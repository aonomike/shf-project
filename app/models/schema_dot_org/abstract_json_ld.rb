#!/usr/bin/ruby

#--------------------------
#
# @class AbstractJsonLd
#
# @desc Responsibility: - abstract class that can return a json_ld string,
# and respond to :to_json(as_root: true) and :to_json_struct
#
#     methods to convert to json_ld are taken from the schema_dot_org gem
#
#
# @author Ashley Engelund (ashley.engelund@gmail.com  weedySeaDragon @ github)
# @date   2019-02-19
#
# @file abstract_json_ld
#
#--------------------------

module SchemaDotOrg

  class AbstractJsonLd

    UNQUALIFIED_CLASS_NAME_REGEX = /([^:]+)$/

    ROOT_ATTR = { "@context" => "http://schema.org" }.freeze


    def to_json_ld
      "<script type=\"application/ld+json\">\n" + to_json(as_root: true) + "\n</script>"
    end


    def to_json(as_root: true)
      structure = as_root ? ROOT_ATTR.merge(to_json_struct) : to_json_struct
      structure.to_json
    end


    # Use the class name to create the "@type" attribute.
    # If :url is defined, use that to set the "@id" attribute
    # @return a hash structure representing json.
    def to_json_struct


      { "@type" => un_namespaced_classname,
        "@id"   =>   id_value
      }.merge(_to_json_struct).compact
    end


    # ==========================================================


    protected


    # Default is to return as_json
    # But subclasses might want to return a customized Hash of values
    #
    def _to_json_struct
      raise NoMethodError, "subclasses must implement #{__method__}"
    end


    # Subclasses can overwrite this to create their own value for "@id"
    def id_value
      if self.respond_to?(:url)
        self.url
      else
        nil
      end
    end


    # ==========================================================


    private


    # @return the classname without the module namespace.
    def un_namespaced_classname
      self.class.name =~ UNQUALIFIED_CLASS_NAME_REGEX
      Regexp.last_match(1)
    end

  end

end