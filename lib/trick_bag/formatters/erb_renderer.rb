module TrickBag

# ERB requires a binding from which it gets its values for substituting
# in its generated output. Often the current binding is used,
# but this often exposes far more to the template than it needs, 
# and can potentially expose the running program to security risks.
#
# Please see the unit tests for examples.
#
# This class functions as a bag of values that can be passed to ERB
# for its substitutions. It subclasses OpenStruct, 
# so it can be instantiated with a hash, and arbitrary new
# setter methods can be called to add new values.
#
# In the template, these values can be accessed by their method/attribute names.
#
# The 'keys' method is added as a convenience, so that you can see the
# names of the attributes in the 'bag'.  It is unfortunate the OpenStruct
# doesn't have something like this already...or does it?
#
# A 'render' method is provided that calls ERB and passes the instance's binding, 
# which will contain the attributes.

# Render strategy taken from 
# http://stackoverflow.com/questions/8954706/render-an-erb-template-with-values-from-a-hash
class ErbRenderer < OpenStruct

  def render(template)
    ERB.new(template).result(binding)
  end

  # Useful for seeing what values are stored in the OpenStruct.
  def keys
    @table.keys
  end
end

end
