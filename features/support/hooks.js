/**
 * Copyright 2012-2013 Amazon.com, Inc. or its affiliates. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License"). You
 * may not use this file except in compliance with the License. A copy of
 * the License is located at
 *
 *     http://aws.amazon.com/apache2.0/
 *
 * or in the "license" file accompanying this file. This file is
 * distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF
 * ANY KIND, either express or implied. See the License for the specific
 * language governing permissions and limitations under the License.
 */

module.exports = function () {

  this.World = require("./world.js").World;

  /* Global error code steps */

  this.Then(/^the error code should be "([^"]*)"$/, function(code, callback) {
    this.assertions(callback, function(assert) {
      assert.equal(this.resp.error.code, code);
    });
  });

  this.Then(/^the error message should be:$/, function(message, callback) {
    this.assertions(callback, function(assert) {
      assert.equal(this.error.message, message);
    });
  });

  this.Then(/^the status code should be (\d+)$/, function(status, callback) {
    this.assertions(callback, function(assert) {
      assert.equal(this.resp.httpResponse.statusCode, parseInt(status));
    });
  });

  this.Then(/^I should get the error:$/, function(table, next) {
    var err = table.hashes()[0]
    this.assertions(next, function(assert) {
      assert.equal(this.error.code, err.code);
      assert.equal(this.error.message, err.message);
    });
  });
};
