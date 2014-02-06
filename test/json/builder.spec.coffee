helpers = require('../helpers')
AWS = helpers.AWS

describe 'AWS.JSON.Builder', ->

  timestampFormat = 'iso8601'

  build = (rules, params, options) ->
    options = {} if (!options)
    options.timestampFormat = timestampFormat
    builder = new AWS.JSON.Builder(rules, options)
    builder.build(params)

  describe 'build', ->

    it 'returns an empty document when there are no params', ->
      expect(build({}, {})).toEqual("{}")

    describe 'structures', ->
      rules =
        type: 'structure'
        members:
          Items:
            type: 'structure'
            members:
              A:
                type: 'string'
              B:
                type: 'string'

      it 'translates input', ->
        params = { Items: { A: 'a', B: 'b' } }
        expect(build(rules, params)).toEqual('{"Items":{"A":"a","B":"b"}}')

      it 'ignores null', ->
        expect(build(rules, Items: null)).toEqual('{}')

      it 'ignores undefined', ->
        expect(build(rules, Items: undefined)).toEqual('{}')

    describe 'lists', ->
      rules =
        type: 'structure'
        members:
          Items:
            type: 'list'
            members:
              type: 'string'

      it 'translates input', ->
        params = { Items: ['a','b','c'] }
        expect(build(rules, params)).toEqual('{"Items":["a","b","c"]}')

      it 'ignores null', ->
        expect(build(rules, Items: null)).toEqual('{}')

      it 'ignores undefined', ->
        expect(build(rules, Items: undefined)).toEqual('{}')

    describe 'maps', ->
      rules =
        type: 'structure'
        members:
          Items:
            type: 'map'

      it 'translates maps', ->
        params = { Items: { A: 'a', B: 'b' } }
        expect(build(rules, params)).toEqual('{"Items":{"A":"a","B":"b"}}')

      it 'ignores null', ->
        expect(build(rules, Items: null)).toEqual('{}')

      it 'ignores undefined', ->
        expect(build(rules, Items: undefined)).toEqual('{}')

    it 'translates nested maps', ->
      rules =
        type: 'structure'
        members:
          Items: type: 'map', members: type: 'integer'
      now = new Date()
      now.setMilliseconds(100)
      params = Items: MyKey: "5", MyOtherKey: "10"
      str = '{"Items":{"MyKey":5,"MyOtherKey":10}}'
      expect(build(rules, params)).toEqual(str)

    it 'traslates nested timestamps', ->
      rules =
        type: 'structure'
        members:
          Build:
            type: 'structure'
            members:
              When:
                type: 'timestamp'
      now = new Date()
      now.setMilliseconds(100)
      params =
        Build:
          When: now
      formatted = AWS.util.date.iso8601(now)
      expect(build(rules, params)).toEqual('{"Build":{"When":"'+formatted+'"}}')

    it 'translates integers formatted as strings', ->
      rules =
        type: 'structure'
        members:
          Integer: type: 'integer'
      expect(build(rules, Integer: '20')).toEqual('{"Integer":20}')

    it 'translates floats formatted as strings', ->
      rules =
        type: 'structure'
        members:
          Float: type: 'float'
      expect(build(rules, Float: '20.1')).toEqual('{"Float":20.1}')

    it 'ignores nulls null as null', ->
      rules =
        type: 'structure'
        members:
          Float: type: 'float'
          Other: type: 'string'
      expect(build(rules, Float: null, Other: 'foo')).toEqual('{"Other":"foo"}')
