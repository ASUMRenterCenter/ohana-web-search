module Features
  module SessionHelpers

    # search helpers
    def search(options = {})
      keyword = options[:keyword]
      fill_in('keyword', :with => keyword)

      if options[:location].present?
        set_location_filter(options)
      end

      find(:css, '#update-btn').click
    end

    def search_from_home(options = {})
      visit ("/")
      keyword = options[:keyword]
      fill_in('keyword', :with => keyword)
      find(:css, '#find-btn').click
    end

    def search_for_maceo
      visit('/organizations?utf8=✓&keyword=maceo')
    end


    # helpers for filters
    def set_location_filter(options = {})
      set_filter("location",options[:location])
    end

    def set_service_area_filter(options = {})
      set_filter("service-area",options[:service_area])
    end

    def set_kind_filter(options = {})
      set_filter("kind",options[:kind])
    end

    # @param options [Object] the URL parameters object
    # @param name [String] the CSS name of the field
    # @oaram field [Symbol] the field to look up in the options object.
    def set_filter(name,field,custom=true)
      within(".require-loaded") do
        within("##{name}-options") do
          find(".closed").click
          if field.present? && custom == true
            all(".toggle").last.trigger('mousedown')
            fill_in("#{name}-option-input", :with => field)
          elsif custom == false
            find(".toggle-group",:text=>field).trigger('mousedown')
          else
            first("label").click
          end
        end
      end
    end

    # Tests opening and closing the fieldset by clicking the legend.
    # @param name [String] The name of the filter field to test.
    # @param val [String] The value that should be showing in the current toggle.
    # @param count [Number] The amount of toggle that should be showing.
    def test_filter_legend(name,val="All",count=2)
      within("##{name}-options") do
        # test clicking legend functionality
        expect(all(".current-option label").last).to have_content(val)
        find(".closed").trigger("mousedown")
        find(".available-options").should have_css(".toggle-group", :count=>count)
        find(".open").trigger("mousedown")
        expect(all(".current-option label").last).to have_content(val)
      end
    end

    # Tests opening and closing the fieldset by clicking the current toggle.
    # @param name [String] The name of the filter field to test.
    # @param val [String] The value that should be showing in the current toggle.
    # @param count [Number] The amount of toggle that should be showing.
    def test_filter_toggle(name,val="All",count=2)
      within("##{name}-options") do
        # test clicking toggle functionality
        expect(all(".current-option label").last).to have_content(val)
        all(".current-option label").last.trigger("mousedown")
        find(".available-options").should have_css(".toggle-group", :count=>count)
        find(".options label",:text=>val).trigger("mousedown")
        expect(all(".current-option label").last).to have_content(val)
      end
    end

    # Tests opening the filter fieldset, setting a custom value, and closing the fieldset.
    # By clicking on the toggle.
    # @param name [String] The name of the filter field to test.
    # @param val [String] The value that should be showing in the current toggle.
    # @param count [Number] The amount of toggle that should be showing.
    def test_filter_custom_value(name)
      within("##{name}-options") do
        # test adding custom value functionality
        find(".closed").trigger("mousedown")
        find(".available-options").should have_css(".toggle-group", :count=>2)
        all(".available-options label").last.trigger("mousedown")
        fill_in("#{name}-option-input", :with => "Custom Value")
        all(".available-options label").last.trigger("mousedown")
        expect(all(".current-option label").last).to have_content("Custom Value")
      end
    end

    def test_filter_custom_value_no_results(name,field)
      set_filter(name,field)
      find('#update-btn').click

      within("##{name}-options") do
        find(".closed").trigger('mousedown')
        find(".available-options").should have_css(".toggle-group", :count=>2)
        find_field("#{name}-option-input").value.should eq field
      end
    end

    # navigation helpers
    def visit_details
      page.find("#list-view").first(:css, 'a').trigger('click')
    end

    def looks_like_results
      expect(page).to have_content("SanMaceo Example Agency")
      expect(page).to have_content("1 result")
      expect(page).to have_title "1 result"
    end

    def looks_like_puente
      expect(page).to have_content("Puente Resource Center")
      expect(page).to have_content("1 result")
      expect(page).to have_title "1 result"
    end

    def looks_like_no_results
      expect(page).to have_selector(".no-results")
      expect(page).to have_content("your search returned no results.")
      expect(page).to have_selector("#search-summary")
      expect(page).to_not have_selector('#map-canvas')
    end

    def looks_like_location
      find(:css, "#detail-info .description a").should have_content("more")
      find(:css, "#detail-info .description a").click
      find(:css, "#detail-info .description a").should have_content("less")

      expect(page).to have_title "San Maceo Agency | SMC-Connect"

      expect(page).to have_content("Works to control")
      expect(page).to have_content("Profit and nonprofit")
      expect(page).to have_content("Marin County")
      expect(page).to have_content("Walk in")
      expect(page).to have_content("permits and photocopying")
      expect(page).to have_content("Russian")
      expect(page).to have_content("Special parking")
      expect(page).to have_link("Print")
      expect(page).to have_link("Directions")
    end

    def looks_like_market
      find(:css, "#detail-info .description a").should have_content("more")
      find(:css, "#detail-info .description a").click
      find(:css, "#detail-info .description a").should have_content("less")

      expect(page).to have_title "San Maceo Agency | SMC-Connect"

      within ("#detail-info .payments-accepted") do
        page.should_not have_content("Women, Infants, and Children")
        find(:css, ".popup-term", :text=>"WIC").trigger(:mousedown)
        page.should have_content("Women, Infants, and Children")
      end
      expect(page).to have_content("Works to control")
      expect(page).to have_content("Profit and nonprofit")
      expect(page).to have_content("Marin County")
      expect(page).to have_content("Walk in")
      expect(page).to have_content("permits and photocopying")
      expect(page).to have_content("Russian")
      expect(page).to have_content("Special parking")
      expect(page).to have_link("Print")
      expect(page).to have_link("Directions")
    end

    def looks_like_homepage
      expect(page).to have_title "SMC-Connect"
      expect(page).to have_content "About"
      expect(page).to have_content "Contribute"
      expect(page).to have_content "Feedback"
      expect(page).to have_content "I need"
      expect(page).to have_content "reporting"
      expect(page).to have_content "government assistance"
      expect(page).to_not have_title "1 result"
      find("#language-box").should have_content("English")
    end

    def go_to_next_page
      first('.pagination').find_link('>').click
    end

    def go_to_prev_page
      first('.pagination').find_link('<').click
    end

    def go_to_page(page)
      first('.pagination').find_link(page).click
    end

    # webbrowser navigation using browser's JS history API
    def go_back
      page.evaluate_script("window.history.back()")
    end

    def go_forward
      page.evaluate_script("window.history.forward()")
    end

    # helper to (hopefully) wait for page to load
    def delay
      sleep(2)
    end


  end
end