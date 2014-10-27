# coding: UTF-8
require 'test_helper'

class HTMLTOCRenderTest < Redcarpet::TestCase
  def setup
    @renderer = Redcarpet::Render::HTML_TOC
    @markdown = "# A title \n## A __nice__ subtitle\n## Another one \n### A sub-sub-title"
  end

  def test_simple_toc_render
    output = render(@markdown).strip

    assert output.start_with?("<ul>")
    assert output.end_with?("</ul>")

    assert_equal 3, output.scan("<ul>").length
    assert_equal 4, output.scan("<li>").length
  end

  def test_granular_toc_render
    output = render(@markdown, with: { nesting_level: 2 }).strip

    assert output.start_with?("<ul>")
    assert output.end_with?("</ul>")

    assert_equal 3, output.scan("<li>").length
    assert !output.include?("A sub-sub title")
  end

  def test_toc_heading_id
    output = render(@markdown)

    assert_match /a-title/, output
    assert_match /a-nice-subtitle/, output
    assert_match /another-one/, output
    assert_match /a-sub-sub-title/, output
  end

  def test_toc_heading_with_hyphen_and_equal
    output = render("# Hello World\n\n-\n\n=")

    assert_equal 1, output.scan("<li>").length
    assert !output.include?('<a href=\"#\"></a>')
  end

  def test_anchor_generation_with_edge_cases
    # Imported from ActiveSupport::Inflector#parameterize's tests
    titles = {
      "Donald E. Knuth"                     => "donald-e-knuth",
      "Random text with *(bad)* characters" => "random-text-with-bad-characters",
      "Trailing bad characters!@#"          => "trailing-bad-characters",
      "!@#Leading bad characters"           => "leading-bad-characters",
      "Squeeze   separators"                => "squeeze-separators",
      "Test with + sign"                    => "test-with-sign"
    }

    titles.each do |title, anchor|
      assert_match anchor, render("# #{title}")
    end
  end
end
