// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

import socket from "./socket"

let channel = socket.channel("photo_flow:live", {})
channel.join()
  .receive("ok", resp => { react_to_payload(resp) })
  .receive("error", resp => { console.log("Unable to connect", resp) })

channel.on("refresh", payload => {
  react_to_payload(payload)
});


$("#start_button").click(function(event) {
  channel.push("start_load", {});
  return false;
});

function react_to_payload(pyld) {
  var data = pyld.status;
  var ingested = data.ingested || 0;
  var total = data.total || 0;

  var completed = data.completed || 0;
  var x_rejected = data.x_rejected || 0;
  var in_progress = ingested - (data.completed + data.x_rejected);


  var places_div = d3.select("#places_holder");

  console.log("refresh received", pyld);

  $("input#type_error_field").val(data.x_file_type_error);
  $("input#dup_error_field").val(data.x_duplicate);
  $("input#total_field").val(data.ingested);

  if (pyld.history.length > 0) {
    var secs = (pyld.history[0].time - pyld.history[pyld.history.length - 1].time)/1000;
    $("#elapsed_secs").html("Time: " + secs + " seconds");
  }

  $("#inprogress").css("width", (in_progress/total) * 100 + "%")
  $("#inprogress").html(in_progress)
  $("#inerror").css("width", (x_rejected/total) * 100 + "%")
  $("#inerror").html(x_rejected)
  $("#insuccess").css("width", (completed/total) * 100 + "%")
  $("#insuccess").html(completed)

  setupPlaces(places_div, pyld.places);

  $("#type_error_field").html(data.duplicate);

  lineChart.load({
    json: pyld.history,
    keys: {
      x: "time",
      value: ["ingested", "hash", "persist", "finfo", "exif", "analyze", "geolocate", "geopersist", "completed"],
    },
    order: 'desc',
  });
}

function setupPlaces(holder, places) {
  let anz = holder.selectAll(".place_row").data(places, function(d) { return d.id }).sort(function(x, y){
    return d3.descending(x.id, y.id);
  });

  anz.transition().duration(500).ease("bounce").style('top', function(d,i) { return `${i*54}px`; })

  anz.enter()
    .append('div').attr('class', 'place_row')
    .call((ans_row) => {
      ans_row.style('opacity', 0);
      ans_row.style('top', function(d,i) { return `0px`; });
      ans_row.html(function(a_place, i) {
        return `<div class="badge">${a_place.name}</div>`
      })
    }).transition().duration(100).style('opacity', 1.0)

  anz.exit()
    .transition().duration(500).style('opacity', 0.0)
    .attr('id', function(d,i) { console.log(`on the exit with ${d} ${i}`)})
    .remove()
}

var lineChart = c3.generate({
    bindto: '#timeseries',
    legend: {
        position: "right",
    },
    data: {
      json: [],
      keys: {
        x: "time",
        value: ["ingested", "hash", "persist", "finfo", "exif", "analyze", "geolocate", "geopersist", "completed"],
      },
      order: 'desc'
    },
    axis: {
      x: {
        type: 'timeseries',
        tick: {
          format: '%Y-%m-%d'
        }
      }
    },
    type: "timeseries"
});
