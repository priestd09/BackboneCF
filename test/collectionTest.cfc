
component extends="mxunit.framework.TestCase" {
	public void function newAndSort() {
		assertEquals(col.first(), a, "a should be first");
		assertEquals(col.last(), d, "d should be last");
		col.comparator = function(a, b) {
			if (a.id > b.id) {
				return -1;
			}
			else {
				return 1;
			}
		};
		col.sort();
		assertEquals(col.first(), a, "a should be first");
		assertEquals(col.last(), d, "d should be last");
		col.comparator = function(model) { return model.id; };
		col.sort();
		assertEquals(col.first(), d, "d should be first");
		assertEquals(col.last(), a, "a should be last");
		assertEquals(col.length, 4);
	}

	public void function getAndGetByCid() {
		assertEquals(col.get(0), d);
	    assertEquals(col.get(2), b);
	    assertEquals(col.getByCid(col.first().cid), col.first());
	}

	public void function getWithNonDefaultIds() {
		var col = Backbone.Collection.new();
	    var MongoModel = Backbone.Model.extend({
	      idAttribute: '_id'
	    });
	    var model = MongoModel({_id: 100});
	    col.push(model);
	    assertEquals(col.get(100), model);
	    model.set({_id: 101});
	    assertEquals(col.get(101), model);
	}

	public void function updateIndexWhenIdChanges() {
		var col = Backbone.Collection.new();
		col.add([
		  {id : 0, name : 'one'},
		  {id : 1, name : 'two'}
		]);
		var one = col.get(0);
		assertEquals(one.get('name'), 'one');
		one.set({id : 101});
		assertEquals(col.get(101).get('name'), 'one');
	}
	
	public void function testAt() {
		assertEquals(col.at(3), c);
	}
	
	public void function testPluck() {
		assertEquals(col.pluck('label'), ['a', 'b', 'c', 'd']);
	}
	
	public void function testAdd() {
	    var e = Backbone.Model.new({id: 10, label : 'e'});
	    otherCol.add(e);
	    otherCol.on('add', function() {
			secondAdded = true;
	    });
	    col.on('add', function(model, collection, options){
			added = model.get('label');
			// assertEquals(options.index, 5);//todo: get this fixed
			opts = options;
	    });
	    col.add(e, {amazing: true});
	    assertEquals(added, 'e');
	    assertEquals(col.length, 5);
	    assertTrue(_.isEqual(col.last(), e));
	    assertEquals(otherCol.length, 1);
	    assertTrue(opts.amazing);

	    var Model = Backbone.Model.extend();
	    var f = Model({id: 20, label : 'f'});
	    var g = Model({id: 21, label : 'g'});
	    var h = Model({id: 22, label : 'h'});
	    var NewAtCol = Backbone.Collection.extend();
	    var atCol = NewAtCol([f, g, h]);
	    assertEquals(atCol.length, 3);
	    atCol.add(e, {at: 1});
	    assertEquals(atCol.length, 4);
	    assertTrue(_.isEqual(atCol.at(1), e));
	    assertTrue(_.isEqual(atCol.last(), h));
	}
	
	public void function addMultipleModels() {
		var col = Backbone.Collection.new([{at: 1}, {at: 2}, {at: 9}]);
	    col.add([{at: 3}, {at: 4}, {at: 5}, {at: 6}, {at: 7}, {at: 8}, {at: 9}], {at: 3});
	    for (i = 1; i <= 6; i++) {
			assertEquals(col.at(i).get('at'), i);
	    }	
	}
	
	public void function add_AtShouldHavePreferenceOverComparator() {
		var Col = Backbone.Collection.extend({
			comparator: function(a,b) {
				return a.id > b.id ? -1 : 1;
			}
		});

		var col = Col([{id: 2}, {id: 3}]);
		col.add(Backbone.Model.new({id: 1}), {at: 1});

		assertEquals(col.pluck('id'), [3, 1, 2]);
	}
	
	
	
	
	

	public void function setUp() {
		variables.Backbone  = new backbone.Backbone();
		variables.a         = Backbone.Model.new({id: 3, label: 'a'});
		variables.b         = Backbone.Model.new({id: 2, label: 'b'});
		variables.c         = Backbone.Model.new({id: 1, label: 'c'});
		variables.d         = Backbone.Model.new({id: 0, label: 'd'});
		variables.col       = Backbone.Collection.new([a,b,c,d]);
		variables.otherCol  = Backbone.Collection.new();

		Backbone.sync = function(method, model, options) {
			lastRequest = {
				method: method,
				model: model,
				options: options
			};
		};

		_ = new github.UnderscoreCF.Underscore();
	}

	public void function tearDown() {
		structDelete(variables, "Backbone");
	}	
}