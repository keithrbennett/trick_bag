module TrickBag
module Xml

  module_function

  # Takes a Nokogiri::XML::NodeSet and builds a hash whose keys are the
  # child nodes' names, and values are their texts.
  def simple_hash_from_node_set(node_set)
    puts "Set: \n\n#{node_set}\n\n"
    node_set.each_with_object({}) do |node, result_hash|
    puts "Node: #{node}\n\n"
      result_hash[node.name] = node.txt
    end
    puts "\n\n"
  end

end
end
