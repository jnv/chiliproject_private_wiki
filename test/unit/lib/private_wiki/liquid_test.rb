# -*- encoding : utf-8 -*-
require File.expand_path('../../../../test_helper', __FILE__)
require File.expand_path('test/unit/lib/chili_project/liquid_test', Rails.root)

# Regressions testing
# Unlike Redmine, ChiliProject luckily checks page visibility before inclusion
# TODO test caching
class PrivateWiki::LiquidTest < ChiliProject::LiquidTest

  fixtures :all

  context "PrivateWiki include tag" do
    context "include tag" do
      setup do
        @project = Project.find(1)
        @user = User.find(2)
        @wiki = @project.wiki
        @included_page = WikiPage.generate!(:wiki => @wiki, :title => 'Included_Page', :content => WikiContent.new(:text => 'first page [[Second_Page]]'))
        @included_page.update_attribute(:private, true)

        @project2 = Project.generate!.reload
        @cross_project_page = WikiPage.generate!(:wiki => @project2.wiki, :title => 'Included_Page2', :content => WikiContent.new(:text => 'second page'))
        @cross_project_page.update_attribute(:private, true)

        User.current = @user
      end

      context "without permission" do

        should "not show the included page's content" do
          text = "{% include 'Included Page' %}"
          formatted = textilizable(text)

          assert !formatted.include?('first page')
        end

        should "not show the cross-project page's content" do
          text = "{% include '#{@project2.identifier}:Included Page2' %}"
          formatted = textilizable(text)

          assert !formatted.include?('second page')
        end
      end


      context "with permission in current project" do
        setup do
          Role.find(1).add_permission! :view_private_wiki_pages
        end

        should "show the included page's content" do
          text = "{% include 'Included Page' %}"
          formatted = textilizable(text)

          assert formatted.include?('first page')
        end

        should "not show the cross-project page's content" do
          text = "{% include '#{@project2.identifier}:Included Page2' %}"
          formatted = textilizable(text)

          assert !formatted.include?('second page')
        end
      end

      context "with permission in other project" do
        setup do
          @role = Role.find(3)
          User.add_to_project(@user, @project2, @role)
          @role.add_permission! :view_private_wiki_pages
        end

        should "show the included page's content" do
          text = "{% include 'Included Page' %}"
          formatted = textilizable(text)

          assert !formatted.include?('first page')
        end

        should "not show the cross-project page's content" do
          text = "{% include '#{@project2.identifier}:Included Page2' %}"
          formatted = textilizable(text)

          assert formatted.include?('second page')
        end
      end

    end

  end

end