Feature: HLDS RCon
  As a server admin who likes to ban
  I want to be able to control my server remotely
  In order to run an amazingly awesome server

  Background:
    Given an instance of HLDS
  
  Scenario: RCon Login
    When I connect to a server
    And I provide some valid login information
    Then the result should be a successful authentication
    