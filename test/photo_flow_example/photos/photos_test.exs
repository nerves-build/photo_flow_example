defmodule PhotoFlowExample.PhotosTest do
  use PhotoFlowExample.DataCase

  alias PhotoFlowExample.Photos

  describe "analyses" do
    alias PhotoFlowExample.Photos.Analysis

    @valid_attrs %{colors: [], histogram: %{}}
    @update_attrs %{colors: [], histogram: %{}}
    @invalid_attrs %{colors: nil, histogram: nil}

    def analysis_fixture(attrs \\ %{}) do
      {:ok, analysis} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Photos.create_analysis()

      analysis
    end

    test "list_analyses/0 returns all analyses" do
      analysis = analysis_fixture()
      assert Photos.list_analyses() == [analysis]
    end

    test "get_analysis!/1 returns the analysis with given id" do
      analysis = analysis_fixture()
      assert Photos.get_analysis!(analysis.id) == analysis
    end

    test "create_analysis/1 with valid data creates a analysis" do
      assert {:ok, %Analysis{} = analysis} = Photos.create_analysis(@valid_attrs)
      assert analysis.colors == []
      assert analysis.histogram == %{}
    end

    test "create_analysis/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Photos.create_analysis(@invalid_attrs)
    end

    test "update_analysis/2 with valid data updates the analysis" do
      analysis = analysis_fixture()
      assert {:ok, analysis} = Photos.update_analysis(analysis, @update_attrs)
      assert %Analysis{} = analysis
      assert analysis.colors == []
      assert analysis.histogram == %{}
    end

    test "update_analysis/2 with invalid data returns error changeset" do
      analysis = analysis_fixture()
      assert {:error, %Ecto.Changeset{}} = Photos.update_analysis(analysis, @invalid_attrs)
      assert analysis == Photos.get_analysis!(analysis.id)
    end

    test "delete_analysis/1 deletes the analysis" do
      analysis = analysis_fixture()
      assert {:ok, %Analysis{}} = Photos.delete_analysis(analysis)
      assert_raise Ecto.NoResultsError, fn -> Photos.get_analysis!(analysis.id) end
    end

    test "change_analysis/1 returns a analysis changeset" do
      analysis = analysis_fixture()
      assert %Ecto.Changeset{} = Photos.change_analysis(analysis)
    end
  end
end
