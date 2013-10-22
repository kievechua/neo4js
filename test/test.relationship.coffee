Q = require 'q'
chai = require 'chai'
chaiAsPromised = require 'chai-as-promised'

chai.should()
chai.use(chaiAsPromised)

require("mocha-as-promised")()

{Neo4js} = require '../src/main'

describe 'Relationship', ->
    neo = new Neo4js()

    testNode = null
    testRelationship = null

    before (done) ->
        Q.all([
            neo.createNode({ name: 'Test relationship 1' })
            neo.createNode({ name: 'Test relationship 2' })
        ])
        .then (result) ->
            testNode = result

            done()

    describe 'neo.createRelationship(fromNodeId, toNodeId, relationship, relationshipProperty)', ->
        describe 'when valid', ->
            it 'should create relationship between nodes', ->
                neo
                .createRelationship(
                    testNode[0]._id,
                    testNode[1]._id,
                    'friend',
                    { since: '10 years ago' }
                )
                .then((relationship) ->
                    testRelationship = relationship

                    relationship.since.should.equal '10 years ago'
                )

    describe 'neo.readRelationship(relationshipId)', ->
        describe 'when valid', ->
            it 'should return details of a relationship', ->
                neo
                .readRelationship(testRelationship._id)
                .then((result) ->
                    result.since.should.equal '10 years ago'
                )

    describe 'neo.updateRelationshipProperty(relationshipId, property, value)', ->
        describe 'when valid', ->
            it 'should update relationship\'s property value', ->
                neo
                .updateRelationshipProperty(testRelationship._id, 'since', '11 years ago')
                .should.eventually.be.true

    describe 'neo.updateRelationshipProperty(relationshipId, {properties})', ->
        describe 'when valid', ->
            it 'should update relationship\'s properties value', ->
                neo
                .updateRelationshipProperty(testRelationship._id, { 'since': '12 years ago', 'sinceAge': 17 })
                .should.eventually.be.true

    describe 'neo.readRelationshipProperty(relationshipId)', ->
        describe 'when valid', ->
            it 'should return properties of a relationship', ->
                neo
                .readRelationshipProperty(testRelationship._id)
                .then((result) ->
                    result.since.should.equal '12 years ago'
                    result.sinceAge.should.equal 17
                )

    describe 'neo.readRelationshipType()', ->
        describe 'when valid', ->
            it 'should return all relationships type', ->
                neo
                .readRelationshipType()
                .should.eventually.include 'friend'

    describe "neo.readTypedRelationship(nodeId, 'all')", ->
        describe 'when valid', ->
            it 'should return all relationship for a node', ->
                # Q.all([
                #     neo.readTypedRelationship(testNode[1]._id, 'all')
                #     neo.readTypedRelationship(testNode[1]._id, 'in')
                #     neo.readTypedRelationship(testNode[1]._id, 'out')
                #     neo.readTypedRelationship(testNode[1]._id, 'all', 'friend')
                #     neo.readTypedRelationship(testNode[1]._id, 'in', 'friend')
                #     neo.readTypedRelationship(testNode[1]._id, 'out', 'friend')
                #     neo.readTypedRelationship(testNode[1]._id, 'all', ['friend', 'lover'])
                # ])
                # .then((result) ->
                #     result[0].should.have.length 1
                #     result[1].should.have.length 1
                #     result[2].should.be.empty
                #     result[3].should.have.length 1
                #     result[4].should.have.length 1
                #     result[5].should.be.empty
                #     result[6].should.have.length 1
                # )

    describe 'deleteRelationshipProperty', ->
        describe 'delete with property', ->
            it 'should pass', ->
                neo
                .deleteRelationshipProperty(testRelationship._id, 'since')
                .should.eventually.be.true

        describe 'delete without property', ->
            it 'should pass', ->
                neo
                .deleteRelationshipProperty(testRelationship._id)
                .should.eventually.be.true

    describe 'deleteRelationship', ->
        it 'should pass', ->
            neo
            .deleteRelationship(testRelationship._id)
            .should.eventually.be.true

    after ->
        Q.all([
            neo.deleteNode(testNode[0]._id)
            neo.deleteNode(testNode[1]._id)
        ])
