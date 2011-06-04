##
# ExtJS::Helpers::Component
#
module ExtJS::Helpers
  module Component
    ##
    # add class-var @@extjs_on_ready
    def self.included(helper)

    end

    def extjs_component(*params)
      options = params.extract_options!
      options[:controller] = self
      ExtJS::Component.new(options)
    end

    ##
    # Adds a script or ExtJS::Component instance to on_ready queue.  The queue is emptied and rendered to
    # <script></script> via #extjs_render
    #
    def extjs_onready(*params)
      @onready_queue = [] if @onready_queue.nil?
      params.each do |cmp|
        @onready_queue << cmp
      end
    end

    def extjs_add_partial(*params,options={:before_onready=>true})
     if options[:before_onready]
      @before_onready_queue = [] if @before_onready_queue.nil?
      params.each do |cmp|
         @before_onready_queue << cmp
      end
      else
        @after_onready_queue = [] if @after_onready_queue.nil?
              params.each do |cmp|
                 @after_onready_queue << cmp
              end

      end


    end

    ##
    # Empties the on_ready queue.  Renders within <script></script> tags
    #
    def extjs_render
      @onready_queue = [] if @onready_queue.nil?
      before_html = @before_onready_queue ? @before_onready_queue.join(' ') : ""
      after_html = @after_onready_queue ? @after_onready_queue.join(' ') : ""

      "#{before_html}<script>\nExt.onReady(function() {\n\t#{@onready_queue.collect {|cmp| (cmp.kind_of?(ExtJS::Component)) ? cmp.render : cmp}.join("\n\t")}\n });\n</script>#{after_html}"
    end

    def extjs_add_viewport(*params)

         @onready_queue = [] if @onready_queue.nil?
         params.each do |cmp|
           @onready_queue.insert(0,cmp)

       end
    end
   
  end
end
