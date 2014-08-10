xml.instruct!
xml.feed "xmlns" => "http://www.w3.org/2005/Atom" do
  xml.title "RetirementPlan.io Blog"
  xml.link "href" => posts_feed_url,  :rel => :self,      :type => 'application/atom+xml'
  xml.link "href" => posts_url,       :rel => :alternate, :type => 'text/html'
  xml.id posts_url
  xml.updated Post.last_post_date.xmlschema
  xml.author { xml.name "Brandon Parsons" }


  Post.feed.each do |post|
    xml.entry do
      xml.title post.title#, :type => :text
      xml.link "href" => "#{ENV['PRODUCTION_URL']}#{post.path}", "rel" => "alternate"#, :type => 'text/html'
      xml.published post.date.xmlschema
      xml.updated post.updated_at.xmlschema

      if post.author.present?
        xml.author do
          xml.name post.author
          # xml.email post.email if post.email.present?
        end
      end

      xml.id post.path
      # xml.content post_content_html(post), "type" => "html"
      xml.content "type" => "html", 'xml:base' => post.path do
        xml.cdata! post.html
      end
    end
  end

end
