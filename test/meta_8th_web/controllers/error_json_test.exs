defmodule Meta8thWeb.ErrorJSONTest do
  use Meta8thWeb.ConnCase, async: true

  test "renders 404" do
    assert Meta8thWeb.ErrorJSON.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500" do
    assert Meta8thWeb.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
