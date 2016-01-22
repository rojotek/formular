require "test_helper"
require "formular/frontend/bootstrap3"

class Bootstrap3Test < Minitest::Spec
  let (:model) { Comment.new(nil, nil, [Reply.new]) }
  let (:builder) { Formular::Bootstrap3::Builder.new(model: model) }

  describe "#input" do
    # with label.
    it { builder.input(:id, label: "Id").must_eq %{
<div class="form-group">
<label for="form_id">Id</label>
<input name="id" type="text" id="form_id" class="form-control" value="" />
</div>} }

    # no options.
    it { builder.input(:id).must_eq %{
<div class="form-group">
<input name="id" type="text" id="form_id" class="form-control" value="" />
</div>} }

    describe "with errors" do
      let (:model) { Comment.new(nil, nil, [Reply.new], nil, nil, {id: ["wrong!"]}) }

      it { builder.input(:id).must_eq %{
<div class="form-group has-error">
<input name="id" type="text" id="form_id" class="form-control" value="" />
<span class="help-block">[\"wrong!\"]</span>
</div>} }
      it { builder.input(:id, label: "Id").must_eq %{
<div class="form-group has-error">
<label for="form_id">Id</label>
<input name="id" type="text" id="form_id" class="form-control" value="" />
<span class="help-block">[\"wrong!\"]</span>
</div>
} }
    end
  end

  describe "#textarea" do
    it { builder.textarea(:public, rows: 3).must_eq %{<textarea name="public" rows="3" id="form_public" class="form-control"></textarea>} }
  end

# <div class="checkbox">
#   <label>
#     <input type="checkbox" value="">
#     Option one is this and that&mdash;be sure to include why it's great
#   </label>
# </div>

  describe "#checkbox" do
    describe "stacked (default)" do
      it { builder.checkbox(:public, label: "Public?").must_eq %{
<div class="checkbox">
<label >
<input type="hidden" value="0" name="public" />
<input name="public" type="checkbox" id="form_public_1" value="1" />
Public?
</label>
</div>
}
      }

      # TODO: more classes
      # <div class="checkbox disabled">
      #   <label>
      #     <input type="checkbox" value="" disabled>
      #     Option two is disabled
      #   </label>
      # </div>
    end



    # describe "unchecked" do
    #   it { builder.checkbox(:public, label: "Public?").must_equal %{<input type="hidden" value="0" name="public" /><input name="public" type="checkbox" id="form_public_1" value="1" /><label for="form_public_1">Public?</label>} }
    #   it { builder.checkbox(:public).must_equal %{<input type="hidden" value="0" name="public" /><input name="public" type="checkbox" id="form_public_1" value="1" />} }
    # end

    describe "with errors" do

    end

    describe "inline" do
      it { builder.checkbox(:public, label: "Public?", inline: true).must_eq %{
<label class="checkbox-inline">
<input type="hidden" value="0" name="public" />
<input name="public" type="checkbox" id="form_public_1" value="1" />
Public?
</label>
}
      }

      # TODO: more classes
      # <div class="checkbox disabled">
      #   <label>
      #     <input type="checkbox" value="" disabled>
      #     Option two is disabled
      #   </label>
      # </div>
    end
  end



  describe "#radio" do
    describe "stacked (default)" do
      it { builder.radio(:public, label: "Public?", value: 1).must_eq %{
<div class="radio">
<label >
<input name="public" type="radio" value="1" id="form_public_1" />
Public?
</label>
</div>
}
      }
    end
  end


  describe "collection type: :checkbox" do
    it do
      # TODO: allow merging :class!
      builder.collection(:public, [[:One, 1],[:Two, 2],[:Three, 3]], type: :checkbox, checked: [2,3], label: "One!").must_eq %{
<div class="form-group">
<label >One!</label>
<div class="checkbox"><label ><input name="public[]" type="checkbox" value="1" id="form_public_1" />One</label></div>
<div class="checkbox"><label ><input name="public[]" type="checkbox" value="2" checked="true" id="form_public_2" />Two</label></div>
<div class="checkbox">
<label ><input type="hidden" value="0" name="public[]" />
<input name="public[]" type="checkbox" value="3" checked="true" id="form_public_3" />Three</label>
</div>
</div>
}
    end

    describe "with errors" do
      let (:model) { Comment.new(nil, nil, [], nil, nil, {public: ["wrong!"]}) }

      it do
        builder.collection(:public, [[:One, 1],[:Two, 2],[:Three, 3]], type: :checkbox, checked: [2,3], label: "One!").must_eq %{
<label >One!</label>
<input name="public[]" type="checkbox" value="1" id="form_public_1" /><label for="form_public_1">One</label>
<input name="public[]" type="checkbox" value="2" checked="true" id="form_public_2" /><label for="form_public_2">Two</label>
<input type="hidden" value="0" name="public[]" />
<input name="public[]" type="checkbox" value="3" checked="true" id="form_public_3" /><label for="form_public_3">Three</label>
<small class="error">["wrong!"]</small>
}
      end
    end

    it "inline: true" do
      # TODO: allow merging :class!
      builder.collection(:public, [[:One, 1],[:Two, 2],[:Three, 3]], type: :checkbox, checked: [2,3], label: "One!", inline: true).must_eq %{
<div class="form-group">
<label >One!</label><div ><label class="checkbox-inline"><input name="public[]" type="checkbox" value="1" id="form_public_1" />One</label><label class="checkbox-inline"><input name="public[]" type="checkbox" value="2" checked="true" id="form_public_2" />Two</label><label class="checkbox-inline"><input type="hidden" value="0" name="public[]" /><input name="public[]" type="checkbox" value="3" checked="true" id="form_public_3" />Three</label></div></div>
}
    end
  end

  describe "collection type: :radio" do
    it do
      # TODO: allow merging :class!
      builder.collection(:public, [[:One, 1],[:Two, 2],[:Three, 3]], type: :radio, checked: [2,3], label: "One!").must_eq %{
<div class="form-group">
<label >One!</label>
<div class="radio"><label ><input name="public" type="radio" value="1" id="form_public_1" />One</label></div>
<div class="radio"><label ><input name="public" type="radio" value="2" checked="true" id="form_public_2" />Two</label></div>
<div class="radio"><label ><input name="public" type="radio" value="3" checked="true" id="form_public_3" />Three</label></div>
</div>
}
    end
  end
end
