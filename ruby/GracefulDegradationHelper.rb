
module GracefulDegradationHelper

  def gracefully(&block)

    begin

      capture &block

    rescue => e

      Rails.logger.warn e

      unless Rails.env.production?

        <<-EOS.html_safe
<pre>Error occurred, see html for backtrace</pre>
<!--
#{e.message}

#{e.backtrace.join("\n")}
-->
        EOS
      end # unless

    end # begin/rescue/end

  end # def

end # module

