class HomePage
  include PageObject

  page_url LoyalFan::App.config.app_url

  div(:warning_message, id: 'flash_bar_danger')
  div(:success_message, id: 'flash_bar_success')

  h1(:main_header, id: 'main_header')
  text_field(:streamer_name_input, id: 'streamer_name_input')
  button(:add_button, id: 'repo-form-submit')
  table(:clips_table, id: 'clips_table')

  def clips_listed_count
    clips_table_element.rows - 1
  end

  def search_channel(streamer_name)
    self.streamer_name_input = streamer_name
    self.add_button
  end
end
