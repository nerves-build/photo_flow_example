defmodule PhotoFlowExampleWeb.AnalysisControllerTest do
  use PhotoFlowExampleWeb.ConnCase

  alias PhotoFlowExample.Photos

  @create_attrs %{colors: [], histogram: %{}}
  @update_attrs %{colors: [], histogram: %{}}
  @invalid_attrs %{colors: nil, histogram: nil}

  def fixture(:analysis) do
    {:ok, analysis} = Photos.create_analysis(@create_attrs)
    analysis
  end

  describe "index" do
    test "lists all analyses", %{conn: conn} do
      conn = get conn, analysis_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Analyses"
    end
  end

  describe "new analysis" do
    test "renders form", %{conn: conn} do
      conn = get conn, analysis_path(conn, :new)
      assert html_response(conn, 200) =~ "New Analysis"
    end
  end

  describe "create analysis" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, analysis_path(conn, :create), analysis: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == analysis_path(conn, :show, id)

      conn = get conn, analysis_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Analysis"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, analysis_path(conn, :create), analysis: @invalid_attrs
      assert html_response(conn, 200) =~ "New Analysis"
    end
  end

  describe "edit analysis" do
    setup [:create_analysis]

    test "renders form for editing chosen analysis", %{conn: conn, analysis: analysis} do
      conn = get conn, analysis_path(conn, :edit, analysis)
      assert html_response(conn, 200) =~ "Edit Analysis"
    end
  end

  describe "update analysis" do
    setup [:create_analysis]

    test "redirects when data is valid", %{conn: conn, analysis: analysis} do
      conn = put conn, analysis_path(conn, :update, analysis), analysis: @update_attrs
      assert redirected_to(conn) == analysis_path(conn, :show, analysis)

      conn = get conn, analysis_path(conn, :show, analysis)
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, analysis: analysis} do
      conn = put conn, analysis_path(conn, :update, analysis), analysis: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Analysis"
    end
  end

  describe "delete analysis" do
    setup [:create_analysis]

    test "deletes chosen analysis", %{conn: conn, analysis: analysis} do
      conn = delete conn, analysis_path(conn, :delete, analysis)
      assert redirected_to(conn) == analysis_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, analysis_path(conn, :show, analysis)
      end
    end
  end

  defp create_analysis(_) do
    analysis = fixture(:analysis)
    {:ok, analysis: analysis}
  end
end
