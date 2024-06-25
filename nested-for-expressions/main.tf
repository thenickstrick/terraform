locals {
  # map the raw content of the entire sample data file
  raw_content = jsondecode(file("${path.module}/sample.json"))

  # create ref to key to test extracting specific data out of the sample file
  root_node = local.raw_content["zscalerthree.net"]

  # create for-expression to iterate over sample data to extract continent in order to output
  # expected_output = [
  #   # adding cities here is necessary for terrafrom to properly output the contninent values from the root map 
  #   # for this key (continent) in this value (city) in this map (root_node), output this object (continent)
  #   for continent, cities in local.root_node : {
  #     display_name = "${continent}"
  #   }
  # ]

  # flatten the expected output to a single array, making the data easier to iterate across
  expected_output = flatten([
    for continent, cities in local.root_node :
    [
      # nestied for-expression to output the detail in the ctities map
      for city, details in cities : {
        # concatenate the city to the continent to output as one object
        # use replace to clean up the sample data in output
        display_name = "${replace(continent, "continent : ", "")}/${replace(city, "city : ", "")}"
        # create for-expression to iterate across list of details to create an array of address spaces for each city
        # don't include range if empty
        address_space = [for detail in details : detail.range if detail.range != ""]
      }
    ]
  ])
}

# output "raw_content" {
#   value = local.raw_content
# }

# output the data that was extracted
# output "root_node" {
#   value = local.root_node
# }

output "expected_output" {
  value = local.expected_output
}
