(function() {
  'use strict';

  var globals = typeof window === 'undefined' ? global : window;
  if (typeof globals.require === 'function') return;

  var modules = {};
  var cache = {};
  var has = ({}).hasOwnProperty;

  var aliases = {};

  var endsWith = function(str, suffix) {
    return str.indexOf(suffix, str.length - suffix.length) !== -1;
  };

  var unalias = function(alias, loaderPath) {
    var start = 0;
    if (loaderPath) {
      if (loaderPath.indexOf('components/' === 0)) {
        start = 'components/'.length;
      }
      if (loaderPath.indexOf('/', start) > 0) {
        loaderPath = loaderPath.substring(start, loaderPath.indexOf('/', start));
      }
    }
    var result = aliases[alias + '/index.js'] || aliases[loaderPath + '/deps/' + alias + '/index.js'];
    if (result) {
      return 'components/' + result.substring(0, result.length - '.js'.length);
    }
    return alias;
  };

  var expand = (function() {
    var reg = /^\.\.?(\/|$)/;
    return function(root, name) {
      var results = [], parts, part;
      parts = (reg.test(name) ? root + '/' + name : name).split('/');
      for (var i = 0, length = parts.length; i < length; i++) {
        part = parts[i];
        if (part === '..') {
          results.pop();
        } else if (part !== '.' && part !== '') {
          results.push(part);
        }
      }
      return results.join('/');
    };
  })();
  var dirname = function(path) {
    return path.split('/').slice(0, -1).join('/');
  };

  var localRequire = function(path) {
    return function(name) {
      var absolute = expand(dirname(path), name);
      return globals.require(absolute, path);
    };
  };

  var initModule = function(name, definition) {
    var module = {id: name, exports: {}};
    cache[name] = module;
    definition(module.exports, localRequire(name), module);
    return module.exports;
  };

  var require = function(name, loaderPath) {
    var path = expand(name, '.');
    if (loaderPath == null) loaderPath = '/';
    path = unalias(name, loaderPath);

    if (has.call(cache, path)) return cache[path].exports;
    if (has.call(modules, path)) return initModule(path, modules[path]);

    var dirIndex = expand(path, './index');
    if (has.call(cache, dirIndex)) return cache[dirIndex].exports;
    if (has.call(modules, dirIndex)) return initModule(dirIndex, modules[dirIndex]);

    throw new Error('Cannot find module "' + name + '" from '+ '"' + loaderPath + '"');
  };

  require.alias = function(from, to) {
    aliases[to] = from;
  };

  require.register = require.define = function(bundle, fn) {
    if (typeof bundle === 'object') {
      for (var key in bundle) {
        if (has.call(bundle, key)) {
          modules[key] = bundle[key];
        }
      }
    } else {
      modules[bundle] = fn;
    }
  };

  require.list = function() {
    var result = [];
    for (var item in modules) {
      if (has.call(modules, item)) {
        result.push(item);
      }
    }
    return result;
  };

  require.brunch = true;
  globals.require = require;
})();
require.register("client", function(exports, require, module) {
module.exports = {
  get: function(url, callbacks) {
    return $.ajax({
      type: 'GET',
      url: url,
      success: (function(_this) {
        return function(response) {
          if (response.success) {
            return callbacks.success(response);
          } else {
            return callbacks.error(response);
          }
        };
      })(this),
      error: (function(_this) {
        return function(response) {
          return callbacks.error(response);
        };
      })(this)
    });
  },
  post: function(url, data, callbacks) {
    return $.ajax({
      type: 'POST',
      url: url,
      data: JSON.stringify(data),
      dataType: "json",
      success: (function(_this) {
        return function(response) {
          if (response.success) {
            return callbacks.success(response);
          } else {
            return callbacks.error(response);
          }
        };
      })(this),
      error: (function(_this) {
        return function(response) {
          return callbacks.error(response);
        };
      })(this)
    });
  }
};
});

;require.register("initialize", function(exports, require, module) {
var button, buttonLabel, client, getPlaceholder, hidePasswordButton, isUpdating, password, showPasswordButton;

require('./spinner');

getPlaceholder = function(password) {
  var i, placeholder, _i, _ref;
  placeholder = [];
  for (i = _i = 1, _ref = password.length; _i <= _ref; i = _i += 1) {
    placeholder.push('*');
  }
  return placeholder.join('');
};

password = $('#password-span');

password.html(getPlaceholder(window.password));

showPasswordButton = $('#show-password');

hidePasswordButton = $('#hide-password');

showPasswordButton.click(function() {
  password.text(window.password);
  showPasswordButton.hide();
  return hidePasswordButton.show();
});

hidePasswordButton.click(function() {
  password.text(getPlaceholder(window.password));
  hidePasswordButton.hide();
  return showPasswordButton.show();
});

button = $('#generate-btn');

buttonLabel = button.html();

isUpdating = false;

button.startLoading = function() {
  button.text('&nbsp;');
  return button.spin('tiny');
};

button.endLoading = function() {
  button.spin();
  return button.html(buttonLabel);
};

client = require('./client');

button.click(function() {
  if (!isUpdating) {
    isUpdating = true;
    button.startLoading();
    return client.post('token', {}, {
      success: function(data) {
        $('#password-span').html(data.account.token);
        button.endLoading();
        return isUpdating = false;
      },
      error: function(err) {
        button.endLoading();
        return isUpdating = false;
      }
    });
  }
});

$('.tab.caldav').click(function() {
  var device;
  $('.tab.caldav.selected').removeClass('selected');
  $('.caldavconf:visible').hide();
  $(this).addClass('selected');
  device = $(this).data('device');
  return $(".caldavconf[data-device='" + device + "']").show();
});

$('.tab.carddav').click(function() {
  var device;
  $('.tab.carddav.selected').removeClass('selected');
  $('.carddavconf:visible').hide();
  $(this).addClass('selected');
  device = $(this).data('device');
  return $(".carddavconf[data-device='" + device + "']").show();
});

$('select#calendar').change(function(ev) {
  var domain;
  $('option#placeholder').remove();
  domain = $('#iosuri').text().split('/')[0];
  return $('#thunderbirduri').text('https://' + domain + '/public/sync/calendars/me/' + this.value);
});
});

;require.register("spinner", function(exports, require, module) {
$.fn.spin = function(opts, color, content) {
  var presets;
  presets = {
    tiny: {
      lines: 8,
      length: 2,
      width: 2,
      radius: 3
    },
    small: {
      lines: 8,
      length: 1,
      width: 2,
      radius: 5
    },
    large: {
      lines: 10,
      length: 8,
      width: 4,
      radius: 8
    }
  };
  if (Spinner) {
    return this.each(function() {
      var $this, spinner;
      $this = $(this);
      $this.html("&nbsp;");
      spinner = $this.data("spinner");
      if (spinner != null) {
        spinner.stop();
        $this.data("spinner", null);
        return $this.html(content);
      } else if (opts !== false) {
        if (typeof opts === "string") {
          if (opts in presets) {
            opts = presets[opts];
          } else {
            opts = {};
          }
          if (color) {
            opts.color = color;
          }
        }
        spinner = new Spinner($.extend({
          color: $this.css("color")
        }, opts));
        spinner.spin(this);
        return $this.data("spinner", spinner);
      }
    });
  } else {
    console.log("Spinner class not available.");
    return null;
  }
};
});

;
//# sourceMappingURL=app.js.map