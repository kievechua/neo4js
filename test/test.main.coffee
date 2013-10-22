Q = require 'q'
chai = require 'chai'
chaiAsPromised = require 'chai-as-promised'

chai.should()
chai.use(chaiAsPromised)

require("mocha-as-promised")()

{Neo4js} = require '../src/main'

describe 'Main', ->
    describe 'create new connection', ->
        describe 'Default config', ->
            neo = new Neo4js()

            it 'should return default Neo4j connection', ->
                neo.url.should.equal 'http://localhost:7474'

        describe 'custom config', ->
            neo = new Neo4js('http://localhost:8484')

            it 'should return default Neo4j connection', ->
                neo.url.should.equal 'http://localhost:8484'

    describe 'create new connection', ->
        neo = new Neo4js()

        it 'should return default Neo4j setting', ->
            neo
            .service()
            .should.eventually.have.contain.keys 'node', 'node_index', 'relationship_index', 'extensions_info'
