
Swagger::Docs::Config.register_apis({
                                        "1.0" => {
                                            :controller_base_path => "",
                                            # the extension used for the API
                                            :api_extension_type => :json,
                                            # the output location where your .json files are written to
                                            :api_file_path => "public",
                                            # the URL base path to your API
                                            :base_path => ENV['BASE_PATH'],
                                            # if you want to delete all .json files at each generation
                                            :clean_directory => false,
                                            # add custom attributes to api-docs
                                            :attributes => {
                                                :info => {
                                                    "title" => "Friend Zone app",
                                                    "description" => "This is an API for an Friend Zone app",
                                                    "contact" => "phankiet91@gmail.com"
                                                }
                                            }
                                        }
                                    })

