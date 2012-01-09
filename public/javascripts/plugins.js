
// usage: log('inside coolFunc', this, arguments);
// paulirish.com/2009/log-a-lightweight-wrapper-for-consolelog/
window.log = function(){
  log.history = log.history || [];   // store logs to an array for reference
  log.history.push(arguments);
  if(this.console) {
    arguments.callee = arguments.callee.caller;
    var newarr = [].slice.call(arguments);
    (typeof console.log === 'object' ? log.apply.call(console.log, console, newarr) : console.log.apply(console, newarr));
  }
};

// make it safe to use console.log always
(function(b){function c(){}for(var d="assert,count,debug,dir,dirxml,error,exception,group,groupCollapsed,groupEnd,info,log,timeStamp,profile,profileEnd,time,timeEnd,trace,warn".split(","),a;a=d.pop();){b[a]=b[a]||c}})((function(){try
{console.log();return window.console;}catch(err){return window.console={};}})());


// place any jQuery/helper plugins in here, instead of separate, slower script files.



(function($){$.fn.columnize=function(options){var defaults={width:400,columns:false,buildOnce:false,overflow:false,doneFunc:function(){},target:false,ignoreImageLoading:true,columnFloat:"left",lastNeverTallest:false,accuracy:false};var options=$.extend(defaults,options);if(typeof(options.width)=="string"){options.width=parseInt(options.width);if(isNaN(options.width)){options.width=defaults.width;}}
return this.each(function(){var $inBox=options.target?$(options.target):$(this);var maxHeight=$(this).height();var $cache=$('<div></div>');var lastWidth=0;var columnizing=false;var adjustment=0;$cache.append($(this).contents().clone(true));if(!options.ignoreImageLoading&&!options.target){if(!$inBox.data("imageLoaded")){$inBox.data("imageLoaded",true);if($(this).find("img").length>0){var func=function($inBox,$cache){return function(){if(!$inBox.data("firstImageLoaded")){$inBox.data("firstImageLoaded","true");$inBox.empty().append($cache.children().clone(true));$inBox.columnize(options);}}}($(this),$cache);$(this).find("img").one("load",func);$(this).find("img").one("abort",func);return;}}}
$inBox.empty();columnizeIt();if(!options.buildOnce){$(window).resize(function(){if(!options.buildOnce&&$.browser.msie){if($inBox.data("timeout")){clearTimeout($inBox.data("timeout"));}
$inBox.data("timeout",setTimeout(columnizeIt,200));}else if(!options.buildOnce){columnizeIt();}else{}});}
function columnize($putInHere,$pullOutHere,$parentColumn,height){while($parentColumn.height()<height&&$pullOutHere[0].childNodes.length){$putInHere.append($pullOutHere[0].childNodes[0]);}
if($putInHere[0].childNodes.length==0)return;var kids=$putInHere[0].childNodes;var lastKid=kids[kids.length-1];$putInHere[0].removeChild(lastKid);var $item=$(lastKid);if($item[0].nodeType==3){var oText=$item[0].nodeValue;var counter2=options.width/18;if(options.accuracy)
counter2=options.accuracy;var columnText;var latestTextNode=null;while($parentColumn.height()<height&&oText.length){if(oText.indexOf(' ',counter2)!='-1'){columnText=oText.substring(0,oText.indexOf(' ',counter2));}else{columnText=oText;}
latestTextNode=document.createTextNode(columnText);$putInHere.append(latestTextNode);if(oText.length>counter2){oText=oText.substring(oText.indexOf(' ',counter2));}else{oText="";}}
if($parentColumn.height()>=height&&latestTextNode!=null){$putInHere[0].removeChild(latestTextNode);oText=latestTextNode.nodeValue+oText;}
if(oText.length){$item[0].nodeValue=oText;}else{return false;}}
if($pullOutHere.children().length){$pullOutHere.prepend($item);}else{$pullOutHere.append($item);}
return $item[0].nodeType==3;}
function split($putInHere,$pullOutHere,$parentColumn,height){if($pullOutHere.children().length){$cloneMe=$pullOutHere.children(":first");$clone=$cloneMe.clone(true);if($clone.prop("nodeType")==1&&!$clone.hasClass("dontend")){$putInHere.append($clone);if($clone.is("img")&&$parentColumn.height()<height+20){$cloneMe.remove();}else if(!$cloneMe.hasClass("dontsplit")&&$parentColumn.height()<height+20){$cloneMe.remove();}else if($clone.is("img")||$cloneMe.hasClass("dontsplit")){$clone.remove();}else{$clone.empty();if(!columnize($clone,$cloneMe,$parentColumn,height)){if($cloneMe.children().length){split($clone,$cloneMe,$parentColumn,height);}}
if($clone.get(0).childNodes.length==0){$clone.remove();}}}}}
function singleColumnizeIt(){if($inBox.data("columnized")&&$inBox.children().length==1){return;}
$inBox.data("columnized",true);$inBox.data("columnizing",true);$inBox.empty();$inBox.append($("<div class='first last column' style='width:100%; float: "+options.columnFloat+";'></div>"));$col=$inBox.children().eq($inBox.children().length-1);$destroyable=$cache.clone(true);if(options.overflow){targetHeight=options.overflow.height;columnize($col,$destroyable,$col,targetHeight);if(!$destroyable.contents().find(":first-child").hasClass("dontend")){split($col,$destroyable,$col,targetHeight);}
while(checkDontEndColumn($col.children(":last").length&&$col.children(":last").get(0))){var $lastKid=$col.children(":last");$lastKid.remove();$destroyable.prepend($lastKid);}
var html="";var div=document.createElement('DIV');while($destroyable[0].childNodes.length>0){var kid=$destroyable[0].childNodes[0];for(var i=0;i<kid.attributes.length;i++){if(kid.attributes[i].nodeName.indexOf("jQuery")==0){kid.removeAttribute(kid.attributes[i].nodeName);}}
div.innerHTML="";div.appendChild($destroyable[0].childNodes[0]);html+=div.innerHTML;}
var overflow=$(options.overflow.id)[0];overflow.innerHTML=html;}else{$col.append($destroyable);}
$inBox.data("columnizing",false);if(options.overflow){options.overflow.doneFunc();}}
function checkDontEndColumn(dom){if(dom.nodeType!=1)return false;if($(dom).hasClass("dontend"))return true;if(dom.childNodes.length==0)return false;return checkDontEndColumn(dom.childNodes[dom.childNodes.length-1]);}
function columnizeIt(){if(lastWidth==$inBox.width())return;lastWidth=$inBox.width();var numCols=Math.round($inBox.width()/options.width);if(options.columns)numCols=options.columns;if(numCols<=1){return singleColumnizeIt();}
if($inBox.data("columnizing"))return;$inBox.data("columnized",true);$inBox.data("columnizing",true);$inBox.empty();$inBox.append($("<div style='width:"+(Math.floor(100/numCols))+"%; float: "+options.columnFloat+";'></div>"));$col=$inBox.children(":last");$col.append($cache.clone());maxHeight=$col.height();$inBox.empty();var targetHeight=maxHeight/numCols;var firstTime=true;var maxLoops=3;var scrollHorizontally=false;if(options.overflow){maxLoops=1;targetHeight=options.overflow.height;}else if(options.height&&options.width){maxLoops=1;targetHeight=options.height;scrollHorizontally=true;}
for(var loopCount=0;loopCount<maxLoops;loopCount++){$inBox.empty();var $destroyable;try{$destroyable=$cache.clone(true);}catch(e){$destroyable=$cache.clone();}
$destroyable.css("visibility","hidden");for(var i=0;i<numCols;i++){var className=(i==0)?"first column":"column";var className=(i==numCols-1)?("last "+className):className;$inBox.append($("<div class='"+className+"' style='width:"+(Math.floor(100/numCols))+"%; float: "+options.columnFloat+";'></div>"));}
var i=0;while(i<numCols-(options.overflow?0:1)||scrollHorizontally&&$destroyable.contents().length){if($inBox.children().length<=i){$inBox.append($("<div class='"+className+"' style='width:"+(Math.floor(100/numCols))+"%; float: "+options.columnFloat+";'></div>"));}
var $col=$inBox.children().eq(i);columnize($col,$destroyable,$col,targetHeight);if(!$destroyable.contents().find(":first-child").hasClass("dontend")){split($col,$destroyable,$col,targetHeight);}else{}
while(checkDontEndColumn($col.children(":last").length&&$col.children(":last").get(0))){var $lastKid=$col.children(":last");$lastKid.remove();$destroyable.prepend($lastKid);}
i++;}
if(options.overflow&&!scrollHorizontally){var IE6=false;var IE7=(document.all)&&(navigator.appVersion.indexOf("MSIE 7.")!=-1);if(IE6||IE7){var html="";var div=document.createElement('DIV');while($destroyable[0].childNodes.length>0){var kid=$destroyable[0].childNodes[0];for(var i=0;i<kid.attributes.length;i++){if(kid.attributes[i].nodeName.indexOf("jQuery")==0){kid.removeAttribute(kid.attributes[i].nodeName);}}
div.innerHTML="";div.appendChild($destroyable[0].childNodes[0]);html+=div.innerHTML;}
var overflow=$(options.overflow.id)[0];overflow.innerHTML=html;}else{$(options.overflow.id).empty().append($destroyable.contents().clone(true));}}else if(!scrollHorizontally){$col=$inBox.children().eq($inBox.children().length-1);while($destroyable.contents().length)$col.append($destroyable.contents(":first"));var afterH=$col.height();var diff=afterH-targetHeight;var totalH=0;var min=10000000;var max=0;var lastIsMax=false;$inBox.children().each(function($inBox){return function($item){var h=$inBox.children().eq($item).height();lastIsMax=false;totalH+=h;if(h>max){max=h;lastIsMax=true;}
if(h<min)min=h;}}($inBox));var avgH=totalH/numCols;if(options.lastNeverTallest&&lastIsMax){adjustment+=30;if(adjustment<100){targetHeight=targetHeight+30;if(loopCount==maxLoops-1)maxLoops++;}else{debugger;loopCount=maxLoops;}}else if(max-min>30){targetHeight=avgH+30;}else if(Math.abs(avgH-targetHeight)>20){targetHeight=avgH;}else{loopCount=maxLoops;}}else{$inBox.children().each(function(i){$col=$inBox.children().eq(i);$col.width(options.width+"px");if(i==0){$col.addClass("first");}else if(i==$inBox.children().length-1){$col.addClass("last");}else{$col.removeClass("first");$col.removeClass("last");}});$inBox.width($inBox.children().length*options.width+"px");}
$inBox.append($("<br style='clear:both;'>"));}
$inBox.find('.column').find(':first.removeiffirst').remove();$inBox.find('.column').find(':last.removeiflast').remove();$inBox.data("columnizing",false);if(options.overflow){options.overflow.doneFunc();}
options.doneFunc();}});};})(jQuery);

// Underscore.js 1.1.7
// (c) 2011 Jeremy Ashkenas, DocumentCloud Inc.
// Underscore is freely distributable under the MIT license.
// Portions of Underscore are inspired or borrowed from Prototype,
// Oliver Steele's Functional, and John Resig's Micro-Templating.
// For all details and documentation:
// http://documentcloud.github.com/underscore
(function(){var p=this,C=p._,m={},i=Array.prototype,n=Object.prototype,f=i.slice,D=i.unshift,E=n.toString,l=n.hasOwnProperty,s=i.forEach,t=i.map,u=i.reduce,v=i.reduceRight,w=i.filter,x=i.every,y=i.some,o=i.indexOf,z=i.lastIndexOf;n=Array.isArray;var F=Object.keys,q=Function.prototype.bind,b=function(a){return new j(a)};typeof module!=="undefined"&&module.exports?(module.exports=b,b._=b):p._=b;b.VERSION="1.1.7";var h=b.each=b.forEach=function(a,c,b){if(a!=null)if(s&&a.forEach===s)a.forEach(c,b);else if(a.length===
+a.length)for(var e=0,k=a.length;e<k;e++){if(e in a&&c.call(b,a[e],e,a)===m)break}else for(e in a)if(l.call(a,e)&&c.call(b,a[e],e,a)===m)break};b.map=function(a,c,b){var e=[];if(a==null)return e;if(t&&a.map===t)return a.map(c,b);h(a,function(a,g,G){e[e.length]=c.call(b,a,g,G)});return e};b.reduce=b.foldl=b.inject=function(a,c,d,e){var k=d!==void 0;a==null&&(a=[]);if(u&&a.reduce===u)return e&&(c=b.bind(c,e)),k?a.reduce(c,d):a.reduce(c);h(a,function(a,b,f){k?d=c.call(e,d,a,b,f):(d=a,k=!0)});if(!k)throw new TypeError("Reduce of empty array with no initial value");
return d};b.reduceRight=b.foldr=function(a,c,d,e){a==null&&(a=[]);if(v&&a.reduceRight===v)return e&&(c=b.bind(c,e)),d!==void 0?a.reduceRight(c,d):a.reduceRight(c);a=(b.isArray(a)?a.slice():b.toArray(a)).reverse();return b.reduce(a,c,d,e)};b.find=b.detect=function(a,c,b){var e;A(a,function(a,g,f){if(c.call(b,a,g,f))return e=a,!0});return e};b.filter=b.select=function(a,c,b){var e=[];if(a==null)return e;if(w&&a.filter===w)return a.filter(c,b);h(a,function(a,g,f){c.call(b,a,g,f)&&(e[e.length]=a)});return e};
b.reject=function(a,c,b){var e=[];if(a==null)return e;h(a,function(a,g,f){c.call(b,a,g,f)||(e[e.length]=a)});return e};b.every=b.all=function(a,c,b){var e=!0;if(a==null)return e;if(x&&a.every===x)return a.every(c,b);h(a,function(a,g,f){if(!(e=e&&c.call(b,a,g,f)))return m});return e};var A=b.some=b.any=function(a,c,d){c=c||b.identity;var e=!1;if(a==null)return e;if(y&&a.some===y)return a.some(c,d);h(a,function(a,b,f){if(e|=c.call(d,a,b,f))return m});return!!e};b.include=b.contains=function(a,c){var b=
!1;if(a==null)return b;if(o&&a.indexOf===o)return a.indexOf(c)!=-1;A(a,function(a){if(b=a===c)return!0});return b};b.invoke=function(a,c){var d=f.call(arguments,2);return b.map(a,function(a){return(c.call?c||a:a[c]).apply(a,d)})};b.pluck=function(a,c){return b.map(a,function(a){return a[c]})};b.max=function(a,c,d){if(!c&&b.isArray(a))return Math.max.apply(Math,a);var e={computed:-Infinity};h(a,function(a,b,f){b=c?c.call(d,a,b,f):a;b>=e.computed&&(e={value:a,computed:b})});return e.value};b.min=function(a,
c,d){if(!c&&b.isArray(a))return Math.min.apply(Math,a);var e={computed:Infinity};h(a,function(a,b,f){b=c?c.call(d,a,b,f):a;b<e.computed&&(e={value:a,computed:b})});return e.value};b.sortBy=function(a,c,d){return b.pluck(b.map(a,function(a,b,f){return{value:a,criteria:c.call(d,a,b,f)}}).sort(function(a,b){var c=a.criteria,d=b.criteria;return c<d?-1:c>d?1:0}),"value")};b.groupBy=function(a,b){var d={};h(a,function(a,f){var g=b(a,f);(d[g]||(d[g]=[])).push(a)});return d};b.sortedIndex=function(a,c,d){d||
(d=b.identity);for(var e=0,f=a.length;e<f;){var g=e+f>>1;d(a[g])<d(c)?e=g+1:f=g}return e};b.toArray=function(a){if(!a)return[];if(a.toArray)return a.toArray();if(b.isArray(a))return f.call(a);if(b.isArguments(a))return f.call(a);return b.values(a)};b.size=function(a){return b.toArray(a).length};b.first=b.head=function(a,b,d){return b!=null&&!d?f.call(a,0,b):a[0]};b.rest=b.tail=function(a,b,d){return f.call(a,b==null||d?1:b)};b.last=function(a){return a[a.length-1]};b.compact=function(a){return b.filter(a,
function(a){return!!a})};b.flatten=function(a){return b.reduce(a,function(a,d){if(b.isArray(d))return a.concat(b.flatten(d));a[a.length]=d;return a},[])};b.without=function(a){return b.difference(a,f.call(arguments,1))};b.uniq=b.unique=function(a,c){return b.reduce(a,function(a,e,f){if(0==f||(c===!0?b.last(a)!=e:!b.include(a,e)))a[a.length]=e;return a},[])};b.union=function(){return b.uniq(b.flatten(arguments))};b.intersection=b.intersect=function(a){var c=f.call(arguments,1);return b.filter(b.uniq(a),
function(a){return b.every(c,function(c){return b.indexOf(c,a)>=0})})};b.difference=function(a,c){return b.filter(a,function(a){return!b.include(c,a)})};b.zip=function(){for(var a=f.call(arguments),c=b.max(b.pluck(a,"length")),d=Array(c),e=0;e<c;e++)d[e]=b.pluck(a,""+e);return d};b.indexOf=function(a,c,d){if(a==null)return-1;var e;if(d)return d=b.sortedIndex(a,c),a[d]===c?d:-1;if(o&&a.indexOf===o)return a.indexOf(c);d=0;for(e=a.length;d<e;d++)if(a[d]===c)return d;return-1};b.lastIndexOf=function(a,
b){if(a==null)return-1;if(z&&a.lastIndexOf===z)return a.lastIndexOf(b);for(var d=a.length;d--;)if(a[d]===b)return d;return-1};b.range=function(a,b,d){arguments.length<=1&&(b=a||0,a=0);d=arguments[2]||1;for(var e=Math.max(Math.ceil((b-a)/d),0),f=0,g=Array(e);f<e;)g[f++]=a,a+=d;return g};b.bind=function(a,b){if(a.bind===q&&q)return q.apply(a,f.call(arguments,1));var d=f.call(arguments,2);return function(){return a.apply(b,d.concat(f.call(arguments)))}};b.bindAll=function(a){var c=f.call(arguments,1);
c.length==0&&(c=b.functions(a));h(c,function(c){a[c]=b.bind(a[c],a)});return a};b.memoize=function(a,c){var d={};c||(c=b.identity);return function(){var b=c.apply(this,arguments);return l.call(d,b)?d[b]:d[b]=a.apply(this,arguments)}};b.delay=function(a,b){var d=f.call(arguments,2);return setTimeout(function(){return a.apply(a,d)},b)};b.defer=function(a){return b.delay.apply(b,[a,1].concat(f.call(arguments,1)))};var B=function(a,b,d){var e;return function(){var f=this,g=arguments,h=function(){e=null;
a.apply(f,g)};d&&clearTimeout(e);if(d||!e)e=setTimeout(h,b)}};b.throttle=function(a,b){return B(a,b,!1)};b.debounce=function(a,b){return B(a,b,!0)};b.once=function(a){var b=!1,d;return function(){if(b)return d;b=!0;return d=a.apply(this,arguments)}};b.wrap=function(a,b){return function(){var d=[a].concat(f.call(arguments));return b.apply(this,d)}};b.compose=function(){var a=f.call(arguments);return function(){for(var b=f.call(arguments),d=a.length-1;d>=0;d--)b=[a[d].apply(this,b)];return b[0]}};b.after=
function(a,b){return function(){if(--a<1)return b.apply(this,arguments)}};b.keys=F||function(a){if(a!==Object(a))throw new TypeError("Invalid object");var b=[],d;for(d in a)l.call(a,d)&&(b[b.length]=d);return b};b.values=function(a){return b.map(a,b.identity)};b.functions=b.methods=function(a){var c=[],d;for(d in a)b.isFunction(a[d])&&c.push(d);return c.sort()};b.extend=function(a){h(f.call(arguments,1),function(b){for(var d in b)b[d]!==void 0&&(a[d]=b[d])});return a};b.defaults=function(a){h(f.call(arguments,
1),function(b){for(var d in b)a[d]==null&&(a[d]=b[d])});return a};b.clone=function(a){return b.isArray(a)?a.slice():b.extend({},a)};b.tap=function(a,b){b(a);return a};b.isEqual=function(a,c){if(a===c)return!0;var d=typeof a;if(d!=typeof c)return!1;if(a==c)return!0;if(!a&&c||a&&!c)return!1;if(a._chain)a=a._wrapped;if(c._chain)c=c._wrapped;if(a.isEqual)return a.isEqual(c);if(c.isEqual)return c.isEqual(a);if(b.isDate(a)&&b.isDate(c))return a.getTime()===c.getTime();if(b.isNaN(a)&&b.isNaN(c))return!1;
if(b.isRegExp(a)&&b.isRegExp(c))return a.source===c.source&&a.global===c.global&&a.ignoreCase===c.ignoreCase&&a.multiline===c.multiline;if(d!=="object")return!1;if(a.length&&a.length!==c.length)return!1;d=b.keys(a);var e=b.keys(c);if(d.length!=e.length)return!1;for(var f in a)if(!(f in c)||!b.isEqual(a[f],c[f]))return!1;return!0};b.isEmpty=function(a){if(b.isArray(a)||b.isString(a))return a.length===0;for(var c in a)if(l.call(a,c))return!1;return!0};b.isElement=function(a){return!!(a&&a.nodeType==
1)};b.isArray=n||function(a){return E.call(a)==="[object Array]"};b.isObject=function(a){return a===Object(a)};b.isArguments=function(a){return!(!a||!l.call(a,"callee"))};b.isFunction=function(a){return!(!a||!a.constructor||!a.call||!a.apply)};b.isString=function(a){return!!(a===""||a&&a.charCodeAt&&a.substr)};b.isNumber=function(a){return!!(a===0||a&&a.toExponential&&a.toFixed)};b.isNaN=function(a){return a!==a};b.isBoolean=function(a){return a===!0||a===!1};b.isDate=function(a){return!(!a||!a.getTimezoneOffset||
!a.setUTCFullYear)};b.isRegExp=function(a){return!(!a||!a.test||!a.exec||!(a.ignoreCase||a.ignoreCase===!1))};b.isNull=function(a){return a===null};b.isUndefined=function(a){return a===void 0};b.noConflict=function(){p._=C;return this};b.identity=function(a){return a};b.times=function(a,b,d){for(var e=0;e<a;e++)b.call(d,e)};b.mixin=function(a){h(b.functions(a),function(c){H(c,b[c]=a[c])})};var I=0;b.uniqueId=function(a){var b=I++;return a?a+b:b};b.templateSettings={evaluate:/<%([\s\S]+?)%>/g,interpolate:/<%=([\s\S]+?)%>/g};
b.template=function(a,c){var d=b.templateSettings;d="var __p=[],print=function(){__p.push.apply(__p,arguments);};with(obj||{}){__p.push('"+a.replace(/\\/g,"\\\\").replace(/'/g,"\\'").replace(d.interpolate,function(a,b){return"',"+b.replace(/\\'/g,"'")+",'"}).replace(d.evaluate||null,function(a,b){return"');"+b.replace(/\\'/g,"'").replace(/[\r\n\t]/g," ")+"__p.push('"}).replace(/\r/g,"\\r").replace(/\n/g,"\\n").replace(/\t/g,"\\t")+"');}return __p.join('');";d=new Function("obj",d);return c?d(c):d};
var j=function(a){this._wrapped=a};b.prototype=j.prototype;var r=function(a,c){return c?b(a).chain():a},H=function(a,c){j.prototype[a]=function(){var a=f.call(arguments);D.call(a,this._wrapped);return r(c.apply(b,a),this._chain)}};b.mixin(b);h(["pop","push","reverse","shift","sort","splice","unshift"],function(a){var b=i[a];j.prototype[a]=function(){b.apply(this._wrapped,arguments);return r(this._wrapped,this._chain)}});h(["concat","join","slice"],function(a){var b=i[a];j.prototype[a]=function(){return r(b.apply(this._wrapped,
arguments),this._chain)}});j.prototype.chain=function(){this._chain=!0;return this};j.prototype.value=function(){return this._wrapped}})();


/* tipsy */
// tipsy, facebook style tooltips for jquery
// version 1.0.0a
// (c) 2008-2010 jason frame [jason@onehackoranother.com]
// released under the MIT license

(function($) {

    function maybeCall(thing, ctx) {
        return (typeof thing == 'function') ? (thing.call(ctx)) : thing;
    };

    function Tipsy(element, options) {
        this.$element = $(element);
        this.options = options;
        this.enabled = true;
        this.fixTitle();
    };

    Tipsy.prototype = {
        show: function() {
            var title = this.getTitle();
            if (title && this.enabled) {
                var $tip = this.tip();

                $tip.find('.tipsy-inner')[this.options.html ? 'html' : 'text'](title);
                $tip[0].className = 'tipsy'; // reset classname in case of dynamic gravity
                $tip.remove().css({top: 0, left: 0, visibility: 'hidden', display: 'block'}).prependTo(document.body);

                var pos = $.extend({}, this.$element.offset(), {
                    width: this.$element[0].offsetWidth,
                    height: this.$element[0].offsetHeight
                });

                var actualWidth = $tip[0].offsetWidth,
                    actualHeight = $tip[0].offsetHeight,
                    gravity = maybeCall(this.options.gravity, this.$element[0]);

                var tp;
                switch (gravity.charAt(0)) {
                    case 'n':
                        tp = {top: pos.top + pos.height + this.options.offset, left: pos.left + pos.width / 2 - actualWidth / 2};
                        break;
                    case 's':
                        tp = {top: pos.top - actualHeight - this.options.offset, left: pos.left + pos.width / 2 - actualWidth / 2};
                        break;
                    case 'e':
                        tp = {top: pos.top + pos.height / 2 - actualHeight / 2, left: pos.left - actualWidth - this.options.offset};
                        break;
                    case 'w':
                        tp = {top: pos.top + pos.height / 2 - actualHeight / 2, left: pos.left + pos.width + this.options.offset};
                        break;
                }

                if (gravity.length == 2) {
                    if (gravity.charAt(1) == 'w') {
                        tp.left = pos.left + pos.width / 2 - 15;
                    } else {
                        tp.left = pos.left + pos.width / 2 - actualWidth + 15;
                    }
                }

                $tip.css(tp).addClass('tipsy-' + gravity);
                $tip.find('.tipsy-arrow')[0].className = 'tipsy-arrow tipsy-arrow-' + gravity.charAt(0);
                if (this.options.className) {
                    $tip.addClass(maybeCall(this.options.className, this.$element[0]));
                }

                if (this.options.fade) {
                    $tip.stop().css({opacity: 0, display: 'block', visibility: 'visible'}).animate({opacity: this.options.opacity});
                } else {
                    $tip.css({visibility: 'visible', opacity: this.options.opacity});
                }
            }
        },

        hide: function() {
            if (this.options.fade) {
                this.tip().stop().fadeOut(function() { $(this).remove(); });
            } else {
                this.tip().remove();
            }
        },

        fixTitle: function() {
            var $e = this.$element;
            if ($e.attr('title') || typeof($e.attr('original-title')) != 'string') {
                $e.attr('original-title', $e.attr('title') || '').removeAttr('title');
            }
        },

        getTitle: function() {
            var title, $e = this.$element, o = this.options;
            this.fixTitle();
            var title, o = this.options;
            if (typeof o.title == 'string') {
                title = $e.attr(o.title == 'title' ? 'original-title' : o.title);
            } else if (typeof o.title == 'function') {
                title = o.title.call($e[0]);
            }
            title = ('' + title).replace(/(^\s*|\s*$)/, "");
            return title || o.fallback;
        },

        tip: function() {
            if (!this.$tip) {
                this.$tip = $('<div class="tipsy"></div>').html('<div class="tipsy-arrow"></div><div class="tipsy-inner"></div>');
            }
            return this.$tip;
        },

        validate: function() {
            if (!this.$element[0].parentNode) {
                this.hide();
                this.$element = null;
                this.options = null;
            }
        },

        enable: function() { this.enabled = true; },
        disable: function() { this.enabled = false; },
        toggleEnabled: function() { this.enabled = !this.enabled; }
    };

    $.fn.tipsy = function(options) {

        if (options === true) {
            return this.data('tipsy');
        } else if (typeof options == 'string') {
            var tipsy = this.data('tipsy');
            if (tipsy) tipsy[options]();
            return this;
        }

        options = $.extend({}, $.fn.tipsy.defaults, options);

        function get(ele) {
            var tipsy = $.data(ele, 'tipsy');
            if (!tipsy) {
                tipsy = new Tipsy(ele, $.fn.tipsy.elementOptions(ele, options));
                $.data(ele, 'tipsy', tipsy);
            }
            return tipsy;
        }

        function enter() {
            var tipsy = get(this);
            tipsy.hoverState = 'in';
            if (options.delayIn == 0) {
                tipsy.show();
            } else {
                tipsy.fixTitle();
                setTimeout(function() { if (tipsy.hoverState == 'in') tipsy.show(); }, options.delayIn);
            }
        };

        function leave() {
            var tipsy = get(this);
            tipsy.hoverState = 'out';
            if (options.delayOut == 0) {
                tipsy.hide();
            } else {
                setTimeout(function() { if (tipsy.hoverState == 'out') tipsy.hide(); }, options.delayOut);
            }
        };

        if (!options.live) this.each(function() { get(this); });

        if (options.trigger != 'manual') {
            var binder   = options.live ? 'live' : 'bind',
                eventIn  = options.trigger == 'hover' ? 'mouseenter' : 'focus',
                eventOut = options.trigger == 'hover' ? 'mouseleave' : 'blur';
            this[binder](eventIn, enter)[binder](eventOut, leave);
        }

        return this;

    };

    $.fn.tipsy.defaults = {
        className: null,
        delayIn: 0,
        delayOut: 0,
        fade: false,
        fallback: '',
        gravity: 'n',
        html: false,
        live: false,
        offset: 0,
        opacity: 0.8,
        title: 'title',
        trigger: 'hover'
    };

    // Overwrite this method to provide options on a per-element basis.
    // For example, you could store the gravity in a 'tipsy-gravity' attribute:
    // return $.extend({}, options, {gravity: $(ele).attr('tipsy-gravity') || 'n' });
    // (remember - do not modify 'options' in place!)
    $.fn.tipsy.elementOptions = function(ele, options) {
        return $.metadata ? $.extend({}, options, $(ele).metadata()) : options;
    };

    $.fn.tipsy.autoNS = function() {
        return $(this).offset().top > ($(document).scrollTop() + $(window).height() / 2) ? 's' : 'n';
    };

    $.fn.tipsy.autoWE = function() {
        return $(this).offset().left > ($(document).scrollLeft() + $(window).width() / 2) ? 'e' : 'w';
    };

    /**
     * yields a closure of the supplied parameters, producing a function that takes
     * no arguments and is suitable for use as an autogravity function like so:
     *
     * @param margin (int) - distance from the viewable region edge that an
     *        element should be before setting its tooltip's gravity to be away
     *        from that edge.
     * @param prefer (string, e.g. 'n', 'sw', 'w') - the direction to prefer
     *        if there are no viewable region edges effecting the tooltip's
     *        gravity. It will try to vary from this minimally, for example,
     *        if 'sw' is preferred and an element is near the right viewable
     *        region edge, but not the top edge, it will set the gravity for
     *        that element's tooltip to be 'se', preserving the southern
     *        component.
     */
     $.fn.tipsy.autoBounds = function(margin, prefer) {
		return function() {
			var dir = {ns: prefer[0], ew: (prefer.length > 1 ? prefer[1] : false)},
			    boundTop = $(document).scrollTop() + margin,
			    boundLeft = $(document).scrollLeft() + margin,
			    $this = $(this);

			if ($this.offset().top < boundTop) dir.ns = 'n';
			if ($this.offset().left < boundLeft) dir.ew = 'w';
			if ($(window).width() + $(document).scrollLeft() - $this.offset().left < margin) dir.ew = 'e';
			if ($(window).height() + $(document).scrollTop() - $this.offset().top < margin) dir.ns = 's';

			return dir.ns + (dir.ew ? dir.ew : '');
		}
	};

})(jQuery);


/* jquery.sparkline 1.6 - http://omnipotent.net/jquery.sparkline/
** Licensed under the New BSD License - see above site for details */

(function($){var defaults={common:{type:'line',lineColor:'#00f',fillColor:'#cdf',defaultPixelsPerValue:3,width:'auto',height:'auto',composite:false,tagValuesAttribute:'values',tagOptionsPrefix:'spark',enableTagOptions:false},line:{spotColor:'#f80',spotRadius:1.5,minSpotColor:'#f80',maxSpotColor:'#f80',lineWidth:1,normalRangeMin:undefined,normalRangeMax:undefined,normalRangeColor:'#ccc',drawNormalOnTop:false,chartRangeMin:undefined,chartRangeMax:undefined,chartRangeMinX:undefined,chartRangeMaxX:undefined},bar:{barColor:'#00f',negBarColor:'#f44',zeroColor:undefined,nullColor:undefined,zeroAxis:undefined,barWidth:4,barSpacing:1,chartRangeMax:undefined,chartRangeMin:undefined,chartRangeClip:false,colorMap:undefined},tristate:{barWidth:4,barSpacing:1,posBarColor:'#6f6',negBarColor:'#f44',zeroBarColor:'#999',colorMap:{}},discrete:{lineHeight:'auto',thresholdColor:undefined,thresholdValue:0,chartRangeMax:undefined,chartRangeMin:undefined,chartRangeClip:false},bullet:{targetColor:'red',targetWidth:3,performanceColor:'blue',rangeColors:['#D3DAFE','#A8B6FF','#7F94FF'],base:undefined},pie:{sliceColors:['#f00','#0f0','#00f']},box:{raw:false,boxLineColor:'black',boxFillColor:'#cdf',whiskerColor:'black',outlierLineColor:'#333',outlierFillColor:'white',medianColor:'red',showOutliers:true,outlierIQR:1.5,spotRadius:1.5,target:undefined,targetColor:'#4a2',chartRangeMax:undefined,chartRangeMin:undefined}};var VCanvas_base,VCanvas_canvas,VCanvas_vml;$.fn.simpledraw=function(width,height,use_existing){if(use_existing&&this[0].VCanvas){return this[0].VCanvas;}
if(width===undefined){width=$(this).innerWidth();}
if(height===undefined){height=$(this).innerHeight();}
if($.browser.hasCanvas){return new VCanvas_canvas(width,height,this);}else if($.browser.msie){return new VCanvas_vml(width,height,this);}else{return false;}};var pending=[];$.fn.sparkline=function(uservalues,userOptions){return this.each(function(){var options=new $.fn.sparkline.options(this,userOptions);var render=function(){var values,width,height;if(uservalues==='html'||uservalues===undefined){var vals=this.getAttribute(options.get('tagValuesAttribute'));if(vals===undefined||vals===null){vals=$(this).html();}
values=vals.replace(/(^\s*<!--)|(-->\s*$)|\s+/g,'').split(',');}else{values=uservalues;}
width=options.get('width')=='auto'?values.length*options.get('defaultPixelsPerValue'):options.get('width');if(options.get('height')=='auto'){if(!options.get('composite')||!this.VCanvas){var tmp=document.createElement('span');tmp.innerHTML='a';$(this).html(tmp);height=$(tmp).innerHeight();$(tmp).remove();}}else{height=options.get('height');}
$.fn.sparkline[options.get('type')].call(this,values,options,width,height);};if(($(this).html()&&$(this).is(':hidden'))||($.fn.jquery<"1.3.0"&&$(this).parents().is(':hidden'))||!$(this).parents('body').length){pending.push([this,render]);}else{render.call(this);}});};$.fn.sparkline.defaults=defaults;$.sparkline_display_visible=function(){for(var i=pending.length-1;i>=0;i--){var el=pending[i][0];if($(el).is(':visible')&&!$(el).parents().is(':hidden')){pending[i][1].call(el);pending.splice(i,1);}}};var UNSET_OPTION={};var normalizeValue=function(val){switch(val){case'undefined':val=undefined;break;case'null':val=null;break;case'true':val=true;break;case'false':val=false;break;default:var nf=parseFloat(val);if(val==nf){val=nf;}}
return val;};$.fn.sparkline.options=function(tag,userOptions){var extendedOptions;this.userOptions=userOptions=userOptions||{};this.tag=tag;this.tagValCache={};var defaults=$.fn.sparkline.defaults;var base=defaults.common;this.tagOptionsPrefix=userOptions.enableTagOptions&&(userOptions.tagOptionsPrefix||base.tagOptionsPrefix);var tagOptionType=this.getTagSetting('type');if(tagOptionType===UNSET_OPTION){extendedOptions=defaults[userOptions.type||base.type];}else{extendedOptions=defaults[tagOptionType];}
this.mergedOptions=$.extend({},base,extendedOptions,userOptions);};$.fn.sparkline.options.prototype.getTagSetting=function(key){var val,i,prefix=this.tagOptionsPrefix;if(prefix===false||prefix===undefined){return UNSET_OPTION;}
if(this.tagValCache.hasOwnProperty(key)){val=this.tagValCache.key;}else{val=this.tag.getAttribute(prefix+key);if(val===undefined||val===null){val=UNSET_OPTION;}else if(val.substr(0,1)=='['){val=val.substr(1,val.length-2).split(',');for(i=val.length;i--;){val[i]=normalizeValue(val[i].replace(/(^\s*)|(\s*$)/g,''));}}else if(val.substr(0,1)=='{'){var pairs=val.substr(1,val.length-2).split(',');val={};for(i=pairs.length;i--;){var keyval=pairs[i].split(':',2);val[keyval[0].replace(/(^\s*)|(\s*$)/g,'')]=normalizeValue(keyval[1].replace(/(^\s*)|(\s*$)/g,''));}}else{val=normalizeValue(val);}
this.tagValCache.key=val;}
return val;};$.fn.sparkline.options.prototype.get=function(key){var tagOption=this.getTagSetting(key);if(tagOption!==UNSET_OPTION){return tagOption;}
return this.mergedOptions[key];};$.fn.sparkline.line=function(values,options,width,height){var xvalues=[],yvalues=[],yminmax=[];for(var i=0;i<values.length;i++){var val=values[i];var isstr=typeof(values[i])=='string';var isarray=typeof(values[i])=='object'&&values[i]instanceof Array;var sp=isstr&&values[i].split(':');if(isstr&&sp.length==2){xvalues.push(Number(sp[0]));yvalues.push(Number(sp[1]));yminmax.push(Number(sp[1]));}else if(isarray){xvalues.push(val[0]);yvalues.push(val[1]);yminmax.push(val[1]);}else{xvalues.push(i);if(values[i]===null||values[i]=='null'){yvalues.push(null);}else{yvalues.push(Number(val));yminmax.push(Number(val));}}}
if(options.get('xvalues')){xvalues=options.get('xvalues');}
var maxy=Math.max.apply(Math,yminmax);var maxyval=maxy;var miny=Math.min.apply(Math,yminmax);var minyval=miny;var maxx=Math.max.apply(Math,xvalues);var minx=Math.min.apply(Math,xvalues);var normalRangeMin=options.get('normalRangeMin');var normalRangeMax=options.get('normalRangeMax');if(normalRangeMin!==undefined){if(normalRangeMin<miny){miny=normalRangeMin;}
if(normalRangeMax>maxy){maxy=normalRangeMax;}}
if(options.get('chartRangeMin')!==undefined&&(options.get('chartRangeClip')||options.get('chartRangeMin')<miny)){miny=options.get('chartRangeMin');}
if(options.get('chartRangeMax')!==undefined&&(options.get('chartRangeClip')||options.get('chartRangeMax')>maxy)){maxy=options.get('chartRangeMax');}
if(options.get('chartRangeMinX')!==undefined&&(options.get('chartRangeClipX')||options.get('chartRangeMinX')<minx)){minx=options.get('chartRangeMinX');}
if(options.get('chartRangeMaxX')!==undefined&&(options.get('chartRangeClipX')||options.get('chartRangeMaxX')>maxx)){maxx=options.get('chartRangeMaxX');}
var rangex=maxx-minx===0?1:maxx-minx;var rangey=maxy-miny===0?1:maxy-miny;var vl=yvalues.length-1;if(vl<1){this.innerHTML='';return;}
var target=$(this).simpledraw(width,height,options.get('composite'));if(target){var canvas_width=target.pixel_width;var canvas_height=target.pixel_height;var canvas_top=0;var canvas_left=0;var spotRadius=options.get('spotRadius');if(spotRadius&&(canvas_width<(spotRadius*4)||canvas_height<(spotRadius*4))){spotRadius=0;}
if(spotRadius){if(options.get('minSpotColor')||(options.get('spotColor')&&yvalues[vl]==miny)){canvas_height-=Math.ceil(spotRadius);}
if(options.get('maxSpotColor')||(options.get('spotColor')&&yvalues[vl]==maxy)){canvas_height-=Math.ceil(spotRadius);canvas_top+=Math.ceil(spotRadius);}
if(options.get('minSpotColor')||options.get('maxSpotColor')&&(yvalues[0]==miny||yvalues[0]==maxy)){canvas_left+=Math.ceil(spotRadius);canvas_width-=Math.ceil(spotRadius);}
if(options.get('spotColor')||(options.get('minSpotColor')||options.get('maxSpotColor')&&(yvalues[vl]==miny||yvalues[vl]==maxy))){canvas_width-=Math.ceil(spotRadius);}}
canvas_height--;var drawNormalRange=function(){if(normalRangeMin!==undefined){var ytop=canvas_top+Math.round(canvas_height-(canvas_height*((normalRangeMax-miny)/rangey)));var height=Math.round((canvas_height*(normalRangeMax-normalRangeMin))/rangey);target.drawRect(canvas_left,ytop,canvas_width,height,undefined,options.get('normalRangeColor'));}};if(!options.get('drawNormalOnTop')){drawNormalRange();}
var path=[];var paths=[path];var x,y,vlen=yvalues.length;for(i=0;i<vlen;i++){x=xvalues[i];y=yvalues[i];if(y===null){if(i){if(yvalues[i-1]!==null){path=[];paths.push(path);}}}else{if(y<miny){y=miny;}
if(y>maxy){y=maxy;}
if(!path.length){path.push([canvas_left+Math.round((x-minx)*(canvas_width/rangex)),canvas_top+canvas_height]);}
path.push([canvas_left+Math.round((x-minx)*(canvas_width/rangex)),canvas_top+Math.round(canvas_height-(canvas_height*((y-miny)/rangey)))]);}}
var lineshapes=[];var fillshapes=[];var plen=paths.length;for(i=0;i<plen;i++){path=paths[i];if(!path.length){continue;}
if(options.get('fillColor')){path.push([path[path.length-1][0],canvas_top+canvas_height-1]);fillshapes.push(path.slice(0));path.pop();}
if(path.length>2){path[0]=[path[0][0],path[1][1]];}
lineshapes.push(path);}
plen=fillshapes.length;for(i=0;i<plen;i++){target.drawShape(fillshapes[i],undefined,options.get('fillColor'));}
if(options.get('drawNormalOnTop')){drawNormalRange();}
plen=lineshapes.length;for(i=0;i<plen;i++){target.drawShape(lineshapes[i],options.get('lineColor'),undefined,options.get('lineWidth'));}
if(spotRadius&&options.get('spotColor')){target.drawCircle(canvas_left+Math.round(xvalues[xvalues.length-1]*(canvas_width/rangex)),canvas_top+Math.round(canvas_height-(canvas_height*((yvalues[vl]-miny)/rangey))),spotRadius,undefined,options.get('spotColor'));}
if(maxy!=minyval){if(spotRadius&&options.get('minSpotColor')){x=xvalues[$.inArray(minyval,yvalues)];target.drawCircle(canvas_left+Math.round((x-minx)*(canvas_width/rangex)),canvas_top+Math.round(canvas_height-(canvas_height*((minyval-miny)/rangey))),spotRadius,undefined,options.get('minSpotColor'));}
if(spotRadius&&options.get('maxSpotColor')){x=xvalues[$.inArray(maxyval,yvalues)];target.drawCircle(canvas_left+Math.round((x-minx)*(canvas_width/rangex)),canvas_top+Math.round(canvas_height-(canvas_height*((maxyval-miny)/rangey))),spotRadius,undefined,options.get('maxSpotColor'));}}}else{this.innerHTML='';}};$.fn.sparkline.bar=function(values,options,width,height){width=(values.length*options.get('barWidth'))+((values.length-1)*options.get('barSpacing'));var num_values=[];for(var i=0,vlen=values.length;i<vlen;i++){if(values[i]=='null'||values[i]===null){values[i]=null;}else{values[i]=Number(values[i]);num_values.push(Number(values[i]));}}
var max=Math.max.apply(Math,num_values),min=Math.min.apply(Math,num_values);if(options.get('chartRangeMin')!==undefined&&(options.get('chartRangeClip')||options.get('chartRangeMin')<min)){min=options.get('chartRangeMin');}
if(options.get('chartRangeMax')!==undefined&&(options.get('chartRangeClip')||options.get('chartRangeMax')>max)){max=options.get('chartRangeMax');}
var zeroAxis=options.get('zeroAxis');if(zeroAxis===undefined){zeroAxis=min<0;}
var range=max-min===0?1:max-min;var colorMapByIndex,colorMapByValue;if($.isArray(options.get('colorMap'))){colorMapByIndex=options.get('colorMap');colorMapByValue=null;}else{colorMapByIndex=null;colorMapByValue=options.get('colorMap');}
var target=$(this).simpledraw(width,height,options.get('composite'));if(target){var color,canvas_height=target.pixel_height,yzero=min<0&&zeroAxis?canvas_height-Math.round(canvas_height*(Math.abs(min)/range))-1:canvas_height-1;for(i=values.length;i--;){var x=i*(options.get('barWidth')+options.get('barSpacing')),y,val=values[i];if(val===null){if(options.get('nullColor')){color=options.get('nullColor');val=(zeroAxis&&min<0)?0:min;height=1;y=(zeroAxis&&min<0)?yzero:canvas_height-height;}else{continue;}}else{if(val<min){val=min;}
if(val>max){val=max;}
color=(val<0)?options.get('negBarColor'):options.get('barColor');if(zeroAxis&&min<0){height=Math.round(canvas_height*((Math.abs(val)/range)))+1;y=(val<0)?yzero:yzero-height;}else{height=Math.round(canvas_height*((val-min)/range))+1;y=canvas_height-height;}
if(val===0&&options.get('zeroColor')!==undefined){color=options.get('zeroColor');}
if(colorMapByValue&&colorMapByValue[val]){color=colorMapByValue[val];}else if(colorMapByIndex&&colorMapByIndex.length>i){color=colorMapByIndex[i];}
if(color===null){continue;}}
target.drawRect(x,y,options.get('barWidth')-1,height-1,color,color);}}else{this.innerHTML='';}};$.fn.sparkline.tristate=function(values,options,width,height){values=$.map(values,Number);width=(values.length*options.get('barWidth'))+((values.length-1)*options.get('barSpacing'));var colorMapByIndex,colorMapByValue;if($.isArray(options.get('colorMap'))){colorMapByIndex=options.get('colorMap');colorMapByValue=null;}else{colorMapByIndex=null;colorMapByValue=options.get('colorMap');}
var target=$(this).simpledraw(width,height,options.get('composite'));if(target){var canvas_height=target.pixel_height,half_height=Math.round(canvas_height/2);for(var i=values.length;i--;){var x=i*(options.get('barWidth')+options.get('barSpacing')),y,color;if(values[i]<0){y=half_height;height=half_height-1;color=options.get('negBarColor');}else if(values[i]>0){y=0;height=half_height-1;color=options.get('posBarColor');}else{y=half_height-1;height=2;color=options.get('zeroBarColor');}
if(colorMapByValue&&colorMapByValue[values[i]]){color=colorMapByValue[values[i]];}else if(colorMapByIndex&&colorMapByIndex.length>i){color=colorMapByIndex[i];}
if(color===null){continue;}
target.drawRect(x,y,options.get('barWidth')-1,height-1,color,color);}}else{this.innerHTML='';}};$.fn.sparkline.discrete=function(values,options,width,height){values=$.map(values,Number);width=options.get('width')=='auto'?values.length*2:width;var interval=Math.floor(width/values.length);var target=$(this).simpledraw(width,height,options.get('composite'));if(target){var canvas_height=target.pixel_height,line_height=options.get('lineHeight')=='auto'?Math.round(canvas_height*0.3):options.get('lineHeight'),pheight=canvas_height-line_height,min=Math.min.apply(Math,values),max=Math.max.apply(Math,values);if(options.get('chartRangeMin')!==undefined&&(options.get('chartRangeClip')||options.get('chartRangeMin')<min)){min=options.get('chartRangeMin');}
if(options.get('chartRangeMax')!==undefined&&(options.get('chartRangeClip')||options.get('chartRangeMax')>max)){max=options.get('chartRangeMax');}
var range=max-min;for(var i=values.length;i--;){var val=values[i];if(val<min){val=min;}
if(val>max){val=max;}
var x=(i*interval),ytop=Math.round(pheight-pheight*((val-min)/range));target.drawLine(x,ytop,x,ytop+line_height,(options.get('thresholdColor')&&val<options.get('thresholdValue'))?options.get('thresholdColor'):options.get('lineColor'));}}else{this.innerHTML='';}};$.fn.sparkline.bullet=function(values,options,width,height){values=$.map(values,Number);width=options.get('width')=='auto'?'4.0em':width;var target=$(this).simpledraw(width,height,options.get('composite'));if(target&&values.length>1){var canvas_width=target.pixel_width-Math.ceil(options.get('targetWidth')/2),canvas_height=target.pixel_height,min=Math.min.apply(Math,values),max=Math.max.apply(Math,values);if(options.get('base')===undefined){min=min<0?min:0;}else{min=options.get('base');}
var range=max-min;for(var i=2,vlen=values.length;i<vlen;i++){var rangeval=values[i],rangewidth=Math.round(canvas_width*((rangeval-min)/range));target.drawRect(0,0,rangewidth-1,canvas_height-1,options.get('rangeColors')[i-2],options.get('rangeColors')[i-2]);}
var perfval=values[1],perfwidth=Math.round(canvas_width*((perfval-min)/range));target.drawRect(0,Math.round(canvas_height*0.3),perfwidth-1,Math.round(canvas_height*0.4)-1,options.get('performanceColor'),options.get('performanceColor'));var targetval=values[0],x=Math.round(canvas_width*((targetval-min)/range)-(options.get('targetWidth')/2)),targettop=Math.round(canvas_height*0.10),targetheight=canvas_height-(targettop*2);target.drawRect(x,targettop,options.get('targetWidth')-1,targetheight-1,options.get('targetColor'),options.get('targetColor'));}else{this.innerHTML='';}};$.fn.sparkline.pie=function(values,options,width,height){values=$.map(values,Number);width=options.get('width')=='auto'?height:width;var target=$(this).simpledraw(width,height,options.get('composite'));if(target&&values.length>1){var canvas_width=target.pixel_width,canvas_height=target.pixel_height,radius=Math.floor(Math.min(canvas_width,canvas_height)/2),total=0,next=0,circle=2*Math.PI;for(var i=values.length;i--;){total+=values[i];}
if(options.get('offset')){next+=(2*Math.PI)*(options.get('offset')/360);}
var vlen=values.length;for(i=0;i<vlen;i++){var start=next;var end=next;if(total>0){end=next+(circle*(values[i]/total));}
target.drawPieSlice(radius,radius,radius,start,end,undefined,options.get('sliceColors')[i%options.get('sliceColors').length]);next=end;}}};var quartile=function(values,q){if(q==2){var vl2=Math.floor(values.length/2);return values.length%2?values[vl2]:(values[vl2]+values[vl2+1])/2;}else{var vl4=Math.floor(values.length/4);return values.length%2?(values[vl4*q]+values[vl4*q+1])/2:values[vl4*q];}};$.fn.sparkline.box=function(values,options,width,height){values=$.map(values,Number);width=options.get('width')=='auto'?'4.0em':width;var minvalue=options.get('chartRangeMin')===undefined?Math.min.apply(Math,values):options.get('chartRangeMin'),maxvalue=options.get('chartRangeMax')===undefined?Math.max.apply(Math,values):options.get('chartRangeMax'),target=$(this).simpledraw(width,height,options.get('composite')),vlen=values.length,lwhisker,loutlier,q1,q2,q3,rwhisker,routlier;if(target&&values.length>1){var canvas_width=target.pixel_width,canvas_height=target.pixel_height;if(options.get('raw')){if(options.get('showOutliers')&&values.length>5){loutlier=values[0];lwhisker=values[1];q1=values[2];q2=values[3];q3=values[4];rwhisker=values[5];routlier=values[6];}else{lwhisker=values[0];q1=values[1];q2=values[2];q3=values[3];rwhisker=values[4];}}else{values.sort(function(a,b){return a-b;});q1=quartile(values,1);q2=quartile(values,2);q3=quartile(values,3);var iqr=q3-q1;if(options.get('showOutliers')){lwhisker=undefined;rwhisker=undefined;for(var i=0;i<vlen;i++){if(lwhisker===undefined&&values[i]>q1-(iqr*options.get('outlierIQR'))){lwhisker=values[i];}
if(values[i]<q3+(iqr*options.get('outlierIQR'))){rwhisker=values[i];}}
loutlier=values[0];routlier=values[vlen-1];}else{lwhisker=values[0];rwhisker=values[vlen-1];}}
var unitsize=canvas_width/(maxvalue-minvalue+1),canvas_left=0;if(options.get('showOutliers')){canvas_left=Math.ceil(options.get('spotRadius'));canvas_width-=2*Math.ceil(options.get('spotRadius'));unitsize=canvas_width/(maxvalue-minvalue+1);if(loutlier<lwhisker){target.drawCircle((loutlier-minvalue)*unitsize+canvas_left,canvas_height/2,options.get('spotRadius'),options.get('outlierLineColor'),options.get('outlierFillColor'));}
if(routlier>rwhisker){target.drawCircle((routlier-minvalue)*unitsize+canvas_left,canvas_height/2,options.get('spotRadius'),options.get('outlierLineColor'),options.get('outlierFillColor'));}}
target.drawRect(Math.round((q1-minvalue)*unitsize+canvas_left),Math.round(canvas_height*0.1),Math.round((q3-q1)*unitsize),Math.round(canvas_height*0.8),options.get('boxLineColor'),options.get('boxFillColor'));target.drawLine(Math.round((lwhisker-minvalue)*unitsize+canvas_left),Math.round(canvas_height/2),Math.round((q1-minvalue)*unitsize+canvas_left),Math.round(canvas_height/2),options.get('lineColor'));target.drawLine(Math.round((lwhisker-minvalue)*unitsize+canvas_left),Math.round(canvas_height/4),Math.round((lwhisker-minvalue)*unitsize+canvas_left),Math.round(canvas_height-canvas_height/4),options.get('whiskerColor'));target.drawLine(Math.round((rwhisker-minvalue)*unitsize+canvas_left),Math.round(canvas_height/2),Math.round((q3-minvalue)*unitsize+canvas_left),Math.round(canvas_height/2),options.get('lineColor'));target.drawLine(Math.round((rwhisker-minvalue)*unitsize+canvas_left),Math.round(canvas_height/4),Math.round((rwhisker-minvalue)*unitsize+canvas_left),Math.round(canvas_height-canvas_height/4),options.get('whiskerColor'));target.drawLine(Math.round((q2-minvalue)*unitsize+canvas_left),Math.round(canvas_height*0.1),Math.round((q2-minvalue)*unitsize+canvas_left),Math.round(canvas_height*0.9),options.get('medianColor'));if(options.get('target')){var size=Math.ceil(options.get('spotRadius'));target.drawLine(Math.round((options.get('target')-minvalue)*unitsize+canvas_left),Math.round((canvas_height/2)-size),Math.round((options.get('target')-minvalue)*unitsize+canvas_left),Math.round((canvas_height/2)+size),options.get('targetColor'));target.drawLine(Math.round((options.get('target')-minvalue)*unitsize+canvas_left-size),Math.round(canvas_height/2),Math.round((options.get('target')-minvalue)*unitsize+canvas_left+size),Math.round(canvas_height/2),options.get('targetColor'));}}else{this.innerHTML='';}};if($.browser.msie&&!document.namespaces.v){document.namespaces.add('v','urn:schemas-microsoft-com:vml','#default#VML');}
if($.browser.hasCanvas===undefined){var t=document.createElement('canvas');$.browser.hasCanvas=t.getContext!==undefined;}
VCanvas_base=function(width,height,target){};VCanvas_base.prototype={init:function(width,height,target){this.width=width;this.height=height;this.target=target;if(target[0]){target=target[0];}
target.VCanvas=this;},drawShape:function(path,lineColor,fillColor,lineWidth){alert('drawShape not implemented');},drawLine:function(x1,y1,x2,y2,lineColor,lineWidth){return this.drawShape([[x1,y1],[x2,y2]],lineColor,lineWidth);},drawCircle:function(x,y,radius,lineColor,fillColor){alert('drawCircle not implemented');},drawPieSlice:function(x,y,radius,startAngle,endAngle,lineColor,fillColor){alert('drawPieSlice not implemented');},drawRect:function(x,y,width,height,lineColor,fillColor){alert('drawRect not implemented');},getElement:function(){return this.canvas;},_insert:function(el,target){$(target).html(el);}};VCanvas_canvas=function(width,height,target){return this.init(width,height,target);};VCanvas_canvas.prototype=$.extend(new VCanvas_base(),{_super:VCanvas_base.prototype,init:function(width,height,target){this._super.init(width,height,target);this.canvas=document.createElement('canvas');if(target[0]){target=target[0];}
target.VCanvas=this;$(this.canvas).css({display:'inline-block',width:width,height:height,verticalAlign:'top'});this._insert(this.canvas,target);this.pixel_height=$(this.canvas).height();this.pixel_width=$(this.canvas).width();this.canvas.width=this.pixel_width;this.canvas.height=this.pixel_height;$(this.canvas).css({width:this.pixel_width,height:this.pixel_height});},_getContext:function(lineColor,fillColor,lineWidth){var context=this.canvas.getContext('2d');if(lineColor!==undefined){context.strokeStyle=lineColor;}
context.lineWidth=lineWidth===undefined?1:lineWidth;if(fillColor!==undefined){context.fillStyle=fillColor;}
return context;},drawShape:function(path,lineColor,fillColor,lineWidth){var context=this._getContext(lineColor,fillColor,lineWidth);context.beginPath();context.moveTo(path[0][0]+0.5,path[0][1]+0.5);for(var i=1,plen=path.length;i<plen;i++){context.lineTo(path[i][0]+0.5,path[i][1]+0.5);}
if(lineColor!==undefined){context.stroke();}
if(fillColor!==undefined){context.fill();}},drawCircle:function(x,y,radius,lineColor,fillColor){var context=this._getContext(lineColor,fillColor);context.beginPath();context.arc(x,y,radius,0,2*Math.PI,false);if(lineColor!==undefined){context.stroke();}
if(fillColor!==undefined){context.fill();}},drawPieSlice:function(x,y,radius,startAngle,endAngle,lineColor,fillColor){var context=this._getContext(lineColor,fillColor);context.beginPath();context.moveTo(x,y);context.arc(x,y,radius,startAngle,endAngle,false);context.lineTo(x,y);context.closePath();if(lineColor!==undefined){context.stroke();}
if(fillColor){context.fill();}},drawRect:function(x,y,width,height,lineColor,fillColor){return this.drawShape([[x,y],[x+width,y],[x+width,y+height],[x,y+height],[x,y]],lineColor,fillColor);}});VCanvas_vml=function(width,height,target){return this.init(width,height,target);};VCanvas_vml.prototype=$.extend(new VCanvas_base(),{_super:VCanvas_base.prototype,init:function(width,height,target){this._super.init(width,height,target);if(target[0]){target=target[0];}
target.VCanvas=this;this.canvas=document.createElement('span');$(this.canvas).css({display:'inline-block',position:'relative',overflow:'hidden',width:width,height:height,margin:'0px',padding:'0px',verticalAlign:'top'});this._insert(this.canvas,target);this.pixel_height=$(this.canvas).height();this.pixel_width=$(this.canvas).width();this.canvas.width=this.pixel_width;this.canvas.height=this.pixel_height;var groupel='<v:group coordorigin="0 0" coordsize="'+this.pixel_width+' '+this.pixel_height+'"'+' style="position:absolute;top:0;left:0;width:'+this.pixel_width+'px;height='+this.pixel_height+'px;"></v:group>';this.canvas.insertAdjacentHTML('beforeEnd',groupel);this.group=$(this.canvas).children()[0];},drawShape:function(path,lineColor,fillColor,lineWidth){var vpath=[];for(var i=0,plen=path.length;i<plen;i++){vpath[i]=''+(path[i][0])+','+(path[i][1]);}
var initial=vpath.splice(0,1);lineWidth=lineWidth===undefined?1:lineWidth;var stroke=lineColor===undefined?' stroked="false" ':' strokeWeight="'+lineWidth+'" strokeColor="'+lineColor+'" ';var fill=fillColor===undefined?' filled="false"':' fillColor="'+fillColor+'" filled="true" ';var closed=vpath[0]==vpath[vpath.length-1]?'x ':'';var vel='<v:shape coordorigin="0 0" coordsize="'+this.pixel_width+' '+this.pixel_height+'" '+
stroke+
fill+' style="position:absolute;left:0px;top:0px;height:'+this.pixel_height+'px;width:'+this.pixel_width+'px;padding:0px;margin:0px;" '+' path="m '+initial+' l '+vpath.join(', ')+' '+closed+'e">'+' </v:shape>';this.group.insertAdjacentHTML('beforeEnd',vel);},drawCircle:function(x,y,radius,lineColor,fillColor){x-=radius+1;y-=radius+1;var stroke=lineColor===undefined?' stroked="false" ':' strokeWeight="1" strokeColor="'+lineColor+'" ';var fill=fillColor===undefined?' filled="false"':' fillColor="'+fillColor+'" filled="true" ';var vel='<v:oval '+
stroke+
fill+' style="position:absolute;top:'+y+'px; left:'+x+'px; width:'+(radius*2)+'px; height:'+(radius*2)+'px"></v:oval>';this.group.insertAdjacentHTML('beforeEnd',vel);},drawPieSlice:function(x,y,radius,startAngle,endAngle,lineColor,fillColor){if(startAngle==endAngle){return;}
if((endAngle-startAngle)==(2*Math.PI)){startAngle=0.0;endAngle=(2*Math.PI);}
var startx=x+Math.round(Math.cos(startAngle)*radius);var starty=y+Math.round(Math.sin(startAngle)*radius);var endx=x+Math.round(Math.cos(endAngle)*radius);var endy=y+Math.round(Math.sin(endAngle)*radius);if(startx==endx&&starty==endy&&(endAngle-startAngle)<Math.PI){return;}
var vpath=[x-radius,y-radius,x+radius,y+radius,startx,starty,endx,endy];var stroke=lineColor===undefined?' stroked="false" ':' strokeWeight="1" strokeColor="'+lineColor+'" ';var fill=fillColor===undefined?' filled="false"':' fillColor="'+fillColor+'" filled="true" ';var vel='<v:shape coordorigin="0 0" coordsize="'+this.pixel_width+' '+this.pixel_height+'" '+
stroke+
fill+' style="position:absolute;left:0px;top:0px;height:'+this.pixel_height+'px;width:'+this.pixel_width+'px;padding:0px;margin:0px;" '+' path="m '+x+','+y+' wa '+vpath.join(', ')+' x e">'+' </v:shape>';this.group.insertAdjacentHTML('beforeEnd',vel);},drawRect:function(x,y,width,height,lineColor,fillColor){return this.drawShape([[x,y],[x,y+height],[x+width,y+height],[x+width,y],[x,y]],lineColor,fillColor);}});})(jQuery);

/*! Copyright (c) 2010 Brandon Aaron (http://brandonaaron.net)
 * Licensed under the MIT License (LICENSE.txt).
 *
 * Thanks to: http://adomas.org/javascript-mouse-wheel/ for some pointers.
 * Thanks to: Mathias Bank(http://www.mathias-bank.de) for a scope bug fix.
 * Thanks to: Seamus Leahy for adding deltaX and deltaY
 *
 * Version: 3.0.4
 *
 * Requires: 1.2.2+
 */

(function($) {

var types = ['DOMMouseScroll', 'mousewheel'];

$.event.special.mousewheel = {
    setup: function() {
        if ( this.addEventListener ) {
            for ( var i=types.length; i; ) {
                this.addEventListener( types[--i], handler, false );
            }
        } else {
            this.onmousewheel = handler;
        }
    },

    teardown: function() {
        if ( this.removeEventListener ) {
            for ( var i=types.length; i; ) {
                this.removeEventListener( types[--i], handler, false );
            }
        } else {
            this.onmousewheel = null;
        }
    }
};

$.fn.extend({
    mousewheel: function(fn) {
        return fn ? this.bind("mousewheel", fn) : this.trigger("mousewheel");
    },

    unmousewheel: function(fn) {
        return this.unbind("mousewheel", fn);
    }
});


function handler(event) {
    var orgEvent = event || window.event, args = [].slice.call( arguments, 1 ), delta = 0, returnValue = true, deltaX = 0, deltaY = 0;
    event = $.event.fix(orgEvent);
    event.type = "mousewheel";

    // Old school scrollwheel delta
    if ( event.wheelDelta ) { delta = event.wheelDelta/120; }
    if ( event.detail     ) { delta = -event.detail/3; }

    // New school multidimensional scroll (touchpads) deltas
    deltaY = delta;

    // Gecko
    if ( orgEvent.axis !== undefined && orgEvent.axis === orgEvent.HORIZONTAL_AXIS ) {
        deltaY = 0;
        deltaX = -1*delta;
    }

    // Webkit
    if ( orgEvent.wheelDeltaY !== undefined ) { deltaY = orgEvent.wheelDeltaY/120; }
    if ( orgEvent.wheelDeltaX !== undefined ) { deltaX = -1*orgEvent.wheelDeltaX/120; }

    // Add event and delta to the front of the arguments
    args.unshift(event, delta, deltaX, deltaY);

    return $.event.handle.apply(this, args);
}

})(jQuery);

/**
 * jQuery.ScrollTo - Easy element scrolling using jQuery.
 * Copyright (c) 2007-2009 Ariel Flesler - aflesler(at)gmail(dot)com | http://flesler.blogspot.com
 * Dual licensed under MIT and GPL.
 * Date: 5/25/2009
 * @author Ariel Flesler
 * @version 1.4.2
 *
 * http://flesler.blogspot.com/2007/10/jqueryscrollto.html
 */
;(function(d){var k=d.scrollTo=function(a,i,e){d(window).scrollTo(a,i,e)};k.defaults={axis:'xy',duration:parseFloat(d.fn.jquery)>=1.3?0:1};k.window=function(a){return d(window)._scrollable()};d.fn._scrollable=function(){return this.map(function(){var a=this,i=!a.nodeName||d.inArray(a.nodeName.toLowerCase(),['iframe','#document','html','body'])!=-1;if(!i)return a;var e=(a.contentWindow||a).document||a.ownerDocument||a;return d.browser.safari||e.compatMode=='BackCompat'?e.body:e.documentElement})};d.fn.scrollTo=function(n,j,b){if(typeof j=='object'){b=j;j=0}if(typeof b=='function')b={onAfter:b};if(n=='max')n=9e9;b=d.extend({},k.defaults,b);j=j||b.speed||b.duration;b.queue=b.queue&&b.axis.length>1;if(b.queue)j/=2;b.offset=p(b.offset);b.over=p(b.over);return this._scrollable().each(function(){var q=this,r=d(q),f=n,s,g={},u=r.is('html,body');switch(typeof f){case'number':case'string':if(/^([+-]=)?\d+(\.\d+)?(px|%)?$/.test(f)){f=p(f);break}f=d(f,this);case'object':if(f.is||f.style)s=(f=d(f)).offset()}d.each(b.axis.split(''),function(a,i){var e=i=='x'?'Left':'Top',h=e.toLowerCase(),c='scroll'+e,l=q[c],m=k.max(q,i);if(s){g[c]=s[h]+(u?0:l-r.offset()[h]);if(b.margin){g[c]-=parseInt(f.css('margin'+e))||0;g[c]-=parseInt(f.css('border'+e+'Width'))||0}g[c]+=b.offset[h]||0;if(b.over[h])g[c]+=f[i=='x'?'width':'height']()*b.over[h]}else{var o=f[h];g[c]=o.slice&&o.slice(-1)=='%'?parseFloat(o)/100*m:o}if(/^\d+$/.test(g[c]))g[c]=g[c]<=0?0:Math.min(g[c],m);if(!a&&b.queue){if(l!=g[c])t(b.onAfterFirst);delete g[c]}});t(b.onAfter);function t(a){r.animate(g,j,b.easing,a&&function(){a.call(this,n,b)})}}).end()};k.max=function(a,i){var e=i=='x'?'Width':'Height',h='scroll'+e;if(!d(a).is('html,body'))return a[h]-d(a)[e.toLowerCase()]();var c='client'+e,l=a.ownerDocument.documentElement,m=a.ownerDocument.body;return Math.max(l[h],m[h])-Math.min(l[c],m[c])};function p(a){return typeof a=='object'?a:{top:a,left:a}}})(jQuery);

/*
 * jScrollPane - v2.0.0beta11 - 2011-07-04
 * http://jscrollpane.kelvinluck.com/
 *
 * Copyright (c) 2010 Kelvin Luck
 * Dual licensed under the MIT and GPL licenses.
 */
(function(b,a,c){b.fn.jScrollPane=function(e){function d(D,O){var az,Q=this,Y,ak,v,am,T,Z,y,q,aA,aF,av,i,I,h,j,aa,U,aq,X,t,A,ar,af,an,G,l,au,ay,x,aw,aI,f,L,aj=true,P=true,aH=false,k=false,ap=D.clone(false,false).empty(),ac=b.fn.mwheelIntent?"mwheelIntent.jsp":"mousewheel.jsp";aI=D.css("paddingTop")+" "+D.css("paddingRight")+" "+D.css("paddingBottom")+" "+D.css("paddingLeft");f=(parseInt(D.css("paddingLeft"),10)||0)+(parseInt(D.css("paddingRight"),10)||0);function at(aR){var aM,aO,aN,aK,aJ,aQ,aP=false,aL=false;az=aR;if(Y===c){aJ=D.scrollTop();aQ=D.scrollLeft();D.css({overflow:"hidden",padding:0});ak=D.innerWidth()+f;v=D.innerHeight();D.width(ak);Y=b('<div class="jspPane" />').css("padding",aI).append(D.children());am=b('<div class="jspContainer" />').css({width:ak+"px",height:v+"px"}).append(Y).appendTo(D)}else{D.css("width","");aP=az.stickToBottom&&K();aL=az.stickToRight&&B();aK=D.innerWidth()+f!=ak||D.outerHeight()!=v;if(aK){ak=D.innerWidth()+f;v=D.innerHeight();am.css({width:ak+"px",height:v+"px"})}if(!aK&&L==T&&Y.outerHeight()==Z){D.width(ak);return}L=T;Y.css("width","");D.width(ak);am.find(">.jspVerticalBar,>.jspHorizontalBar").remove().end()}Y.css("overflow","auto");if(aR.contentWidth){T=aR.contentWidth}else{T=Y[0].scrollWidth}Z=Y[0].scrollHeight;Y.css("overflow","");y=T/ak;q=Z/v;aA=q>1;aF=y>1;if(!(aF||aA)){D.removeClass("jspScrollable");Y.css({top:0,width:am.width()-f});n();E();R();w();ai()}else{D.addClass("jspScrollable");aM=az.maintainPosition&&(I||aa);if(aM){aO=aD();aN=aB()}aG();z();F();if(aM){N(aL?(T-ak):aO,false);M(aP?(Z-v):aN,false)}J();ag();ao();if(az.enableKeyboardNavigation){S()}if(az.clickOnTrack){p()}C();if(az.hijackInternalLinks){m()}}if(az.autoReinitialise&&!aw){aw=setInterval(function(){at(az)},az.autoReinitialiseDelay)}else{if(!az.autoReinitialise&&aw){clearInterval(aw)}}aJ&&D.scrollTop(0)&&M(aJ,false);aQ&&D.scrollLeft(0)&&N(aQ,false);D.trigger("jsp-initialised",[aF||aA])}function aG(){if(aA){am.append(b('<div class="jspVerticalBar" />').append(b('<div class="jspCap jspCapTop" />'),b('<div class="jspTrack" />').append(b('<div class="jspDrag" />').append(b('<div class="jspDragTop" />'),b('<div class="jspDragBottom" />'))),b('<div class="jspCap jspCapBottom" />')));U=am.find(">.jspVerticalBar");aq=U.find(">.jspTrack");av=aq.find(">.jspDrag");if(az.showArrows){ar=b('<a class="jspArrow jspArrowUp" />').bind("mousedown.jsp",aE(0,-1)).bind("click.jsp",aC);af=b('<a class="jspArrow jspArrowDown" />').bind("mousedown.jsp",aE(0,1)).bind("click.jsp",aC);if(az.arrowScrollOnHover){ar.bind("mouseover.jsp",aE(0,-1,ar));af.bind("mouseover.jsp",aE(0,1,af))}al(aq,az.verticalArrowPositions,ar,af)}t=v;am.find(">.jspVerticalBar>.jspCap:visible,>.jspVerticalBar>.jspArrow").each(function(){t-=b(this).outerHeight()});av.hover(function(){av.addClass("jspHover")},function(){av.removeClass("jspHover")}).bind("mousedown.jsp",function(aJ){b("html").bind("dragstart.jsp selectstart.jsp",aC);av.addClass("jspActive");var s=aJ.pageY-av.position().top;b("html").bind("mousemove.jsp",function(aK){V(aK.pageY-s,false)}).bind("mouseup.jsp mouseleave.jsp",ax);return false});o()}}function o(){aq.height(t+"px");I=0;X=az.verticalGutter+aq.outerWidth();Y.width(ak-X-f);try{if(U.position().left===0){Y.css("margin-left",X+"px")}}catch(s){}}function z(){if(aF){am.append(b('<div class="jspHorizontalBar" />').append(b('<div class="jspCap jspCapLeft" />'),b('<div class="jspTrack" />').append(b('<div class="jspDrag" />').append(b('<div class="jspDragLeft" />'),b('<div class="jspDragRight" />'))),b('<div class="jspCap jspCapRight" />')));an=am.find(">.jspHorizontalBar");G=an.find(">.jspTrack");h=G.find(">.jspDrag");if(az.showArrows){ay=b('<a class="jspArrow jspArrowLeft" />').bind("mousedown.jsp",aE(-1,0)).bind("click.jsp",aC);x=b('<a class="jspArrow jspArrowRight" />').bind("mousedown.jsp",aE(1,0)).bind("click.jsp",aC);
if(az.arrowScrollOnHover){ay.bind("mouseover.jsp",aE(-1,0,ay));x.bind("mouseover.jsp",aE(1,0,x))}al(G,az.horizontalArrowPositions,ay,x)}h.hover(function(){h.addClass("jspHover")},function(){h.removeClass("jspHover")}).bind("mousedown.jsp",function(aJ){b("html").bind("dragstart.jsp selectstart.jsp",aC);h.addClass("jspActive");var s=aJ.pageX-h.position().left;b("html").bind("mousemove.jsp",function(aK){W(aK.pageX-s,false)}).bind("mouseup.jsp mouseleave.jsp",ax);return false});l=am.innerWidth();ah()}}function ah(){am.find(">.jspHorizontalBar>.jspCap:visible,>.jspHorizontalBar>.jspArrow").each(function(){l-=b(this).outerWidth()});G.width(l+"px");aa=0}function F(){if(aF&&aA){var aJ=G.outerHeight(),s=aq.outerWidth();t-=aJ;b(an).find(">.jspCap:visible,>.jspArrow").each(function(){l+=b(this).outerWidth()});l-=s;v-=s;ak-=aJ;G.parent().append(b('<div class="jspCorner" />').css("width",aJ+"px"));o();ah()}if(aF){Y.width((am.outerWidth()-f)+"px")}Z=Y.outerHeight();q=Z/v;if(aF){au=Math.ceil(1/y*l);if(au>az.horizontalDragMaxWidth){au=az.horizontalDragMaxWidth}else{if(au<az.horizontalDragMinWidth){au=az.horizontalDragMinWidth}}h.width(au+"px");j=l-au;ae(aa)}if(aA){A=Math.ceil(1/q*t);if(A>az.verticalDragMaxHeight){A=az.verticalDragMaxHeight}else{if(A<az.verticalDragMinHeight){A=az.verticalDragMinHeight}}av.height(A+"px");i=t-A;ad(I)}}function al(aK,aM,aJ,s){var aO="before",aL="after",aN;if(aM=="os"){aM=/Mac/.test(navigator.platform)?"after":"split"}if(aM==aO){aL=aM}else{if(aM==aL){aO=aM;aN=aJ;aJ=s;s=aN}}aK[aO](aJ)[aL](s)}function aE(aJ,s,aK){return function(){H(aJ,s,this,aK);this.blur();return false}}function H(aM,aL,aP,aO){aP=b(aP).addClass("jspActive");var aN,aK,aJ=true,s=function(){if(aM!==0){Q.scrollByX(aM*az.arrowButtonSpeed)}if(aL!==0){Q.scrollByY(aL*az.arrowButtonSpeed)}aK=setTimeout(s,aJ?az.initialDelay:az.arrowRepeatFreq);aJ=false};s();aN=aO?"mouseout.jsp":"mouseup.jsp";aO=aO||b("html");aO.bind(aN,function(){aP.removeClass("jspActive");aK&&clearTimeout(aK);aK=null;aO.unbind(aN)})}function p(){w();if(aA){aq.bind("mousedown.jsp",function(aO){if(aO.originalTarget===c||aO.originalTarget==aO.currentTarget){var aM=b(this),aP=aM.offset(),aN=aO.pageY-aP.top-I,aK,aJ=true,s=function(){var aS=aM.offset(),aT=aO.pageY-aS.top-A/2,aQ=v*az.scrollPagePercent,aR=i*aQ/(Z-v);if(aN<0){if(I-aR>aT){Q.scrollByY(-aQ)}else{V(aT)}}else{if(aN>0){if(I+aR<aT){Q.scrollByY(aQ)}else{V(aT)}}else{aL();return}}aK=setTimeout(s,aJ?az.initialDelay:az.trackClickRepeatFreq);aJ=false},aL=function(){aK&&clearTimeout(aK);aK=null;b(document).unbind("mouseup.jsp",aL)};s();b(document).bind("mouseup.jsp",aL);return false}})}if(aF){G.bind("mousedown.jsp",function(aO){if(aO.originalTarget===c||aO.originalTarget==aO.currentTarget){var aM=b(this),aP=aM.offset(),aN=aO.pageX-aP.left-aa,aK,aJ=true,s=function(){var aS=aM.offset(),aT=aO.pageX-aS.left-au/2,aQ=ak*az.scrollPagePercent,aR=j*aQ/(T-ak);if(aN<0){if(aa-aR>aT){Q.scrollByX(-aQ)}else{W(aT)}}else{if(aN>0){if(aa+aR<aT){Q.scrollByX(aQ)}else{W(aT)}}else{aL();return}}aK=setTimeout(s,aJ?az.initialDelay:az.trackClickRepeatFreq);aJ=false},aL=function(){aK&&clearTimeout(aK);aK=null;b(document).unbind("mouseup.jsp",aL)};s();b(document).bind("mouseup.jsp",aL);return false}})}}function w(){if(G){G.unbind("mousedown.jsp")}if(aq){aq.unbind("mousedown.jsp")}}function ax(){b("html").unbind("dragstart.jsp selectstart.jsp mousemove.jsp mouseup.jsp mouseleave.jsp");if(av){av.removeClass("jspActive")}if(h){h.removeClass("jspActive")}}function V(s,aJ){if(!aA){return}if(s<0){s=0}else{if(s>i){s=i}}if(aJ===c){aJ=az.animateScroll}if(aJ){Q.animate(av,"top",s,ad)}else{av.css("top",s);ad(s)}}function ad(aJ){if(aJ===c){aJ=av.position().top}am.scrollTop(0);I=aJ;var aM=I===0,aK=I==i,aL=aJ/i,s=-aL*(Z-v);if(aj!=aM||aH!=aK){aj=aM;aH=aK;D.trigger("jsp-arrow-change",[aj,aH,P,k])}u(aM,aK);Y.css("top",s);D.trigger("jsp-scroll-y",[-s,aM,aK]).trigger("scroll")}function W(aJ,s){if(!aF){return}if(aJ<0){aJ=0}else{if(aJ>j){aJ=j}}if(s===c){s=az.animateScroll}if(s){Q.animate(h,"left",aJ,ae)
}else{h.css("left",aJ);ae(aJ)}}function ae(aJ){if(aJ===c){aJ=h.position().left}am.scrollTop(0);aa=aJ;var aM=aa===0,aL=aa==j,aK=aJ/j,s=-aK*(T-ak);if(P!=aM||k!=aL){P=aM;k=aL;D.trigger("jsp-arrow-change",[aj,aH,P,k])}r(aM,aL);Y.css("left",s);D.trigger("jsp-scroll-x",[-s,aM,aL]).trigger("scroll")}function u(aJ,s){if(az.showArrows){ar[aJ?"addClass":"removeClass"]("jspDisabled");af[s?"addClass":"removeClass"]("jspDisabled")}}function r(aJ,s){if(az.showArrows){ay[aJ?"addClass":"removeClass"]("jspDisabled");x[s?"addClass":"removeClass"]("jspDisabled")}}function M(s,aJ){var aK=s/(Z-v);V(aK*i,aJ)}function N(aJ,s){var aK=aJ/(T-ak);W(aK*j,s)}function ab(aW,aR,aK){var aO,aL,aM,s=0,aV=0,aJ,aQ,aP,aT,aS,aU;try{aO=b(aW)}catch(aN){return}aL=aO.outerHeight();aM=aO.outerWidth();am.scrollTop(0);am.scrollLeft(0);while(!aO.is(".jspPane")){s+=aO.position().top;aV+=aO.position().left;aO=aO.offsetParent();if(/^body|html$/i.test(aO[0].nodeName)){return}}aJ=aB();aP=aJ+v;if(s<aJ||aR){aS=s-az.verticalGutter}else{if(s+aL>aP){aS=s-v+aL+az.verticalGutter}}if(aS){M(aS,aK)}aQ=aD();aT=aQ+ak;if(aV<aQ||aR){aU=aV-az.horizontalGutter}else{if(aV+aM>aT){aU=aV-ak+aM+az.horizontalGutter}}if(aU){N(aU,aK)}}function aD(){return -Y.position().left}function aB(){return -Y.position().top}function K(){var s=Z-v;return(s>20)&&(s-aB()<10)}function B(){var s=T-ak;return(s>20)&&(s-aD()<10)}function ag(){am.unbind(ac).bind(ac,function(aM,aN,aL,aJ){var aK=aa,s=I;Q.scrollBy(aL*az.mouseWheelSpeed,-aJ*az.mouseWheelSpeed,false);return aK==aa&&s==I})}function n(){am.unbind(ac)}function aC(){return false}function J(){Y.find(":input,a").unbind("focus.jsp").bind("focus.jsp",function(s){ab(s.target,false)})}function E(){Y.find(":input,a").unbind("focus.jsp")}function S(){var s,aJ,aL=[];aF&&aL.push(an[0]);aA&&aL.push(U[0]);Y.focus(function(){D.focus()});D.attr("tabindex",0).unbind("keydown.jsp keypress.jsp").bind("keydown.jsp",function(aO){if(aO.target!==this&&!(aL.length&&b(aO.target).closest(aL).length)){return}var aN=aa,aM=I;switch(aO.keyCode){case 40:case 38:case 34:case 32:case 33:case 39:case 37:s=aO.keyCode;aK();break;case 35:M(Z-v);s=null;break;case 36:M(0);s=null;break}aJ=aO.keyCode==s&&aN!=aa||aM!=I;return !aJ}).bind("keypress.jsp",function(aM){if(aM.keyCode==s){aK()}return !aJ});if(az.hideFocus){D.css("outline","none");if("hideFocus" in am[0]){D.attr("hideFocus",true)}}else{D.css("outline","");if("hideFocus" in am[0]){D.attr("hideFocus",false)}}function aK(){var aN=aa,aM=I;switch(s){case 40:Q.scrollByY(az.keyboardSpeed,false);break;case 38:Q.scrollByY(-az.keyboardSpeed,false);break;case 34:case 32:Q.scrollByY(v*az.scrollPagePercent,false);break;case 33:Q.scrollByY(-v*az.scrollPagePercent,false);break;case 39:Q.scrollByX(az.keyboardSpeed,false);break;case 37:Q.scrollByX(-az.keyboardSpeed,false);break}aJ=aN!=aa||aM!=I;return aJ}}function R(){D.attr("tabindex","-1").removeAttr("tabindex").unbind("keydown.jsp keypress.jsp")}function C(){if(location.hash&&location.hash.length>1){var aL,aJ,aK=escape(location.hash);try{aL=b(aK)}catch(s){return}if(aL.length&&Y.find(aK)){if(am.scrollTop()===0){aJ=setInterval(function(){if(am.scrollTop()>0){ab(aK,true);b(document).scrollTop(am.position().top);clearInterval(aJ)}},50)}else{ab(aK,true);b(document).scrollTop(am.position().top)}}}}function ai(){b("a.jspHijack").unbind("click.jsp-hijack").removeClass("jspHijack")}function m(){ai();b("a[href^=#]").addClass("jspHijack").bind("click.jsp-hijack",function(){var s=this.href.split("#"),aJ;if(s.length>1){aJ=s[1];if(aJ.length>0&&Y.find("#"+aJ).length>0){ab("#"+aJ,true);return false}}})}function ao(){var aK,aJ,aM,aL,aN,s=false;am.unbind("touchstart.jsp touchmove.jsp touchend.jsp click.jsp-touchclick").bind("touchstart.jsp",function(aO){var aP=aO.originalEvent.touches[0];aK=aD();aJ=aB();aM=aP.pageX;aL=aP.pageY;aN=false;s=true}).bind("touchmove.jsp",function(aR){if(!s){return}var aQ=aR.originalEvent.touches[0],aP=aa,aO=I;Q.scrollTo(aK+aM-aQ.pageX,aJ+aL-aQ.pageY);aN=aN||Math.abs(aM-aQ.pageX)>5||Math.abs(aL-aQ.pageY)>5;
return aP==aa&&aO==I}).bind("touchend.jsp",function(aO){s=false}).bind("click.jsp-touchclick",function(aO){if(aN){aN=false;return false}})}function g(){var s=aB(),aJ=aD();D.removeClass("jspScrollable").unbind(".jsp");D.replaceWith(ap.append(Y.children()));ap.scrollTop(s);ap.scrollLeft(aJ)}b.extend(Q,{reinitialise:function(aJ){aJ=b.extend({},az,aJ);at(aJ)},scrollToElement:function(aK,aJ,s){ab(aK,aJ,s)},scrollTo:function(aK,s,aJ){N(aK,aJ);M(s,aJ)},scrollToX:function(aJ,s){N(aJ,s)},scrollToY:function(s,aJ){M(s,aJ)},scrollToPercentX:function(aJ,s){N(aJ*(T-ak),s)},scrollToPercentY:function(aJ,s){M(aJ*(Z-v),s)},scrollBy:function(aJ,s,aK){Q.scrollByX(aJ,aK);Q.scrollByY(s,aK)},scrollByX:function(s,aK){var aJ=aD()+Math[s<0?"floor":"ceil"](s),aL=aJ/(T-ak);W(aL*j,aK)},scrollByY:function(s,aK){var aJ=aB()+Math[s<0?"floor":"ceil"](s),aL=aJ/(Z-v);V(aL*i,aK)},positionDragX:function(s,aJ){W(s,aJ)},positionDragY:function(aJ,s){V(aJ,s)},animate:function(aJ,aM,s,aL){var aK={};aK[aM]=s;aJ.animate(aK,{duration:az.animateDuration,easing:az.animateEase,queue:false,step:aL})},getContentPositionX:function(){return aD()},getContentPositionY:function(){return aB()},getContentWidth:function(){return T},getContentHeight:function(){return Z},getPercentScrolledX:function(){return aD()/(T-ak)},getPercentScrolledY:function(){return aB()/(Z-v)},getIsScrollableH:function(){return aF},getIsScrollableV:function(){return aA},getContentPane:function(){return Y},scrollToBottom:function(s){V(i,s)},hijackInternalLinks:function(){m()},destroy:function(){g()}});at(O)}e=b.extend({},b.fn.jScrollPane.defaults,e);b.each(["mouseWheelSpeed","arrowButtonSpeed","trackClickSpeed","keyboardSpeed"],function(){e[this]=e[this]||e.speed});return this.each(function(){var f=b(this),g=f.data("jsp");if(g){g.reinitialise(e)}else{g=new d(f,e);f.data("jsp",g)}})};b.fn.jScrollPane.defaults={showArrows:false,maintainPosition:true,stickToBottom:false,stickToRight:false,clickOnTrack:true,autoReinitialise:false,autoReinitialiseDelay:500,verticalDragMinHeight:0,verticalDragMaxHeight:99999,horizontalDragMinWidth:0,horizontalDragMaxWidth:99999,contentWidth:c,animateScroll:false,animateDuration:300,animateEase:"linear",hijackInternalLinks:false,verticalGutter:4,horizontalGutter:4,mouseWheelSpeed:0,arrowButtonSpeed:0,arrowRepeatFreq:50,arrowScrollOnHover:false,trackClickSpeed:0,trackClickRepeatFreq:70,verticalArrowPositions:"split",horizontalArrowPositions:"split",enableKeyboardNavigation:true,hideFocus:false,keyboardSpeed:0,initialDelay:300,speed:30,scrollPagePercent:0.8}})(jQuery,this);

/*! Copyright (c) 2010 Brandon Aaron (http://brandonaaron.net)
 * Licensed under the MIT License (LICENSE.txt).
 *
 * Thanks to: http://adomas.org/javascript-mouse-wheel/ for some pointers.
 * Thanks to: Mathias Bank(http://www.mathias-bank.de) for a scope bug fix.
 * Thanks to: Seamus Leahy for adding deltaX and deltaY
 *
 * Version: 3.0.4
 *
 * Requires: 1.2.2+
 */

(function($) {

var types = ['DOMMouseScroll', 'mousewheel'];

$.event.special.mousewheel = {
    setup: function() {
        if ( this.addEventListener ) {
            for ( var i=types.length; i; ) {
                this.addEventListener( types[--i], handler, false );
            }
        } else {
            this.onmousewheel = handler;
        }
    },

    teardown: function() {
        if ( this.removeEventListener ) {
            for ( var i=types.length; i; ) {
                this.removeEventListener( types[--i], handler, false );
            }
        } else {
            this.onmousewheel = null;
        }
    }
};

$.fn.extend({
    mousewheel: function(fn) {
        return fn ? this.bind("mousewheel", fn) : this.trigger("mousewheel");
    },

    unmousewheel: function(fn) {
        return this.unbind("mousewheel", fn);
    }
});


function handler(event) {
    var orgEvent = event || window.event, args = [].slice.call( arguments, 1 ), delta = 0, returnValue = true, deltaX = 0, deltaY = 0;
    event = $.event.fix(orgEvent);
    event.type = "mousewheel";

    // Old school scrollwheel delta
    if ( event.wheelDelta ) { delta = event.wheelDelta/120; }
    if ( event.detail     ) { delta = -event.detail/3; }

    // New school multidimensional scroll (touchpads) deltas
    deltaY = delta;

    // Gecko
    if ( orgEvent.axis !== undefined && orgEvent.axis === orgEvent.HORIZONTAL_AXIS ) {
        deltaY = 0;
        deltaX = -1*delta;
    }

    // Webkit
    if ( orgEvent.wheelDeltaY !== undefined ) { deltaY = orgEvent.wheelDeltaY/120; }
    if ( orgEvent.wheelDeltaX !== undefined ) { deltaX = -1*orgEvent.wheelDeltaX/120; }

    // Add event and delta to the front of the arguments
    args.unshift(event, delta, deltaX, deltaY);

    return $.event.handle.apply(this, args);
}

})(jQuery);


/*
 * jQuery autoResize (textarea auto-resizer)
 * @copyright James Padolsey http://james.padolsey.com
 * @version 1.04
 */

(function(a){a.fn.autoResize=function(j){var b=a.extend({onResize:function(){},animate:true,animateDuration:150,animateCallback:function(){},extraSpace:20,limit:1000},j);this.filter('textarea').each(function(){var c=a(this).css({resize:'none','overflow-y':'hidden'}),k=c.height(),f=(function(){var l=['height','width','lineHeight','textDecoration','letterSpacing'],h={};a.each(l,function(d,e){h[e]=c.css(e)});return c.clone().removeAttr('id').removeAttr('name').css({position:'absolute',top:0,left:-9999}).css(h).attr('tabIndex','-1').insertBefore(c)})(),i=null,g=function(){f.height(0).val(a(this).val()).scrollTop(10000);var d=Math.max(f.scrollTop(),k)+b.extraSpace,e=a(this).add(f);if(i===d){return}i=d;if(d>=b.limit){a(this).css('overflow-y','');return}b.onResize.call(this);b.animate&&c.css('display')==='block'?e.stop().animate({height:d},b.animateDuration,b.animateCallback):e.height(d)};c.unbind('.dynSiz').bind('keyup.dynSiz',g).bind('keydown.dynSiz',g).bind('change.dynSiz',g)});return this}})(jQuery);


/*
 * jQuery Easing v1.3 - http://gsgd.co.uk/sandbox/jquery/easing/
 *
 * Uses the built in easing capabilities added In jQuery 1.1
 * to offer multiple easing options
 *
 * TERMS OF USE - jQuery Easing
 *
 * Open source under the BSD License.
 *
 * Copyright © 2008 George McGinley Smith
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 * Redistributions of source code must retain the above copyright notice, this list of
 * conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright notice, this list
 * of conditions and the following disclaimer in the documentation and/or other materials
 * provided with the distribution.
 *
 * Neither the name of the author nor the names of contributors may be used to endorse
 * or promote products derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
 *  COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 *  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
 *  GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED
 * AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 *  NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE.
 *
*/

// t: current time, b: begInnIng value, c: change In value, d: duration
jQuery.easing['jswing'] = jQuery.easing['swing'];

jQuery.extend(jQuery.easing, {
    def: 'easeOutQuad',
    swing: function(x, t, b, c, d) {
        //alert(jQuery.easing.default);
        return jQuery.easing[jQuery.easing.def](x, t, b, c, d);
    },
    easeInQuad: function(x, t, b, c, d) {
        return c * (t /= d) * t + b;
    },
    easeOutQuad: function(x, t, b, c, d) {
        return -c * (t /= d) * (t - 2) + b;
    },
    easeInOutQuad: function(x, t, b, c, d) {
        if ((t /= d / 2) < 1) return c / 2 * t * t + b;
        return -c / 2 * ((--t) * (t - 2) - 1) + b;
    },
    easeInCubic: function(x, t, b, c, d) {
        return c * (t /= d) * t * t + b;
    },
    easeOutCubic: function(x, t, b, c, d) {
        return c * ((t = t / d - 1) * t * t + 1) + b;
    },
    easeInOutCubic: function(x, t, b, c, d) {
        if ((t /= d / 2) < 1) return c / 2 * t * t * t + b;
        return c / 2 * ((t -= 2) * t * t + 2) + b;
    },
    easeInQuart: function(x, t, b, c, d) {
        return c * (t /= d) * t * t * t + b;
    },
    easeOutQuart: function(x, t, b, c, d) {
        return -c * ((t = t / d - 1) * t * t * t - 1) + b;
    },
    easeInOutQuart: function(x, t, b, c, d) {
        if ((t /= d / 2) < 1) return c / 2 * t * t * t * t + b;
        return -c / 2 * ((t -= 2) * t * t * t - 2) + b;
    },
    easeInQuint: function(x, t, b, c, d) {
        return c * (t /= d) * t * t * t * t + b;
    },
    easeOutQuint: function(x, t, b, c, d) {
        return c * ((t = t / d - 1) * t * t * t * t + 1) + b;
    },
    easeInOutQuint: function(x, t, b, c, d) {
        if ((t /= d / 2) < 1) return c / 2 * t * t * t * t * t + b;
        return c / 2 * ((t -= 2) * t * t * t * t + 2) + b;
    },
    easeInSine: function(x, t, b, c, d) {
        return -c * Math.cos(t / d * (Math.PI / 2)) + c + b;
    },
    easeOutSine: function(x, t, b, c, d) {
        return c * Math.sin(t / d * (Math.PI / 2)) + b;
    },
    easeInOutSine: function(x, t, b, c, d) {
        return -c / 2 * (Math.cos(Math.PI * t / d) - 1) + b;
    },
    easeInExpo: function(x, t, b, c, d) {
        return (t == 0) ? b : c * Math.pow(2, 10 * (t / d - 1)) + b;
    },
    easeOutExpo: function(x, t, b, c, d) {
        return (t == d) ? b + c : c * (-Math.pow(2, -10 * t / d) + 1) + b;
    },
    easeInOutExpo: function(x, t, b, c, d) {
        if (t == 0) return b;
        if (t == d) return b + c;
        if ((t /= d / 2) < 1) return c / 2 * Math.pow(2, 10 * (t - 1)) + b;
        return c / 2 * (-Math.pow(2, -10 * --t) + 2) + b;
    },
    easeInCirc: function(x, t, b, c, d) {
        return -c * (Math.sqrt(1 - (t /= d) * t) - 1) + b;
    },
    easeOutCirc: function(x, t, b, c, d) {
        return c * Math.sqrt(1 - (t = t / d - 1) * t) + b;
    },
    easeInOutCirc: function(x, t, b, c, d) {
        if ((t /= d / 2) < 1) return -c / 2 * (Math.sqrt(1 - t * t) - 1) + b;
        return c / 2 * (Math.sqrt(1 - (t -= 2) * t) + 1) + b;
    },
    easeInElastic: function(x, t, b, c, d) {
        var s = 1.70158;
        var p = 0;
        var a = c;
        if (t == 0) return b;
        if ((t /= d) == 1) return b + c;
        if (!p) p = d * .3;
        if (a < Math.abs(c)) {
            a = c;
            var s = p / 4;
        } else
        var s = p / (2 * Math.PI) * Math.asin(c / a);
        return -(a * Math.pow(2, 10 * (t -= 1)) * Math.sin((t * d - s) * (2 * Math.PI) / p)) + b;
    },
    easeOutElastic: function(x, t, b, c, d) {
        var s = 1.70158;
        var p = 0;
        var a = c;
        if (t == 0) return b;
        if ((t /= d) == 1) return b + c;
        if (!p) p = d * .3;
        if (a < Math.abs(c)) {
            a = c;
            var s = p / 4;
        } else
        var s = p / (2 * Math.PI) * Math.asin(c / a);
        return a * Math.pow(2, -10 * t) * Math.sin((t * d - s) * (2 * Math.PI) / p) + c + b;
    },
    easeInOutElastic: function(x, t, b, c, d) {
        var s = 1.70158;
        var p = 0;
        var a = c;
        if (t == 0) return b;
        if ((t /= d / 2) == 2) return b + c;
        if (!p) p = d * (.3 * 1.5);
        if (a < Math.abs(c)) {
            a = c;
            var s = p / 4;
        } else
        var s = p / (2 * Math.PI) * Math.asin(c / a);
        if (t < 1) return -.5 * (a * Math.pow(2, 10 * (t -= 1)) * Math.sin((t * d - s) * (2 * Math.PI) / p)) + b;
        return a * Math.pow(2, -10 * (t -= 1)) * Math.sin((t * d - s) * (2 * Math.PI) / p) * .5 + c + b;
    },
    easeInBack: function(x, t, b, c, d, s) {
        if (s == undefined) s = 1.70158;
        return c * (t /= d) * t * ((s + 1) * t - s) + b;
    },
    easeOutBack: function(x, t, b, c, d, s) {
        if (s == undefined) s = 1.70158;
        return c * ((t = t / d - 1) * t * ((s + 1) * t + s) + 1) + b;
    },
    easeInOutBack: function(x, t, b, c, d, s) {
        if (s == undefined) s = 1.70158;
        if ((t /= d / 2) < 1) return c / 2 * (t * t * (((s *= (1.525)) + 1) * t - s)) + b;
        return c / 2 * ((t -= 2) * t * (((s *= (1.525)) + 1) * t + s) + 2) + b;
    },
    easeInBounce: function(x, t, b, c, d) {
        return c - jQuery.easing.easeOutBounce(x, d - t, 0, c, d) + b;
    },
    easeOutBounce: function(x, t, b, c, d) {
        if ((t /= d) < (1 / 2.75)) {
            return c * (7.5625 * t * t) + b;
        } else if (t < (2 / 2.75)) {
            return c * (7.5625 * (t -= (1.5 / 2.75)) * t + .75) + b;
        } else if (t < (2.5 / 2.75)) {
            return c * (7.5625 * (t -= (2.25 / 2.75)) * t + .9375) + b;
        } else {
            return c * (7.5625 * (t -= (2.625 / 2.75)) * t + .984375) + b;
        }
    },
    easeInOutBounce: function(x, t, b, c, d) {
        if (t < d / 2) return jQuery.easing.easeInBounce(x, t * 2, 0, c, d) * .5 + b;
        return jQuery.easing.easeOutBounce(x, t * 2 - d, 0, c, d) * .5 + c * .5 + b;
    }
});

/*
 *
 * TERMS OF USE - EASING EQUATIONS
 *
 * Open source under the BSD License.
 *
 * Copyright © 2001 Robert Penner
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 * Redistributions of source code must retain the above copyright notice, this list of
 * conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright notice, this list
 * of conditions and the following disclaimer in the documentation and/or other materials
 * provided with the distribution.
 *
 * Neither the name of the author nor the names of contributors may be used to endorse
 * or promote products derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
 *  COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 *  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
 *  GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED
 * AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 *  NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 */

/**
 * http://github.com/valums/file-uploader
 *
 * Multiple file upload component with progress-bar, drag-and-drop.
 * © 2010 Andrew Valums ( andrew(at)valums.com )
 *
 * Licensed under GNU GPL 2 or later and GNU LGPL 2 or later, see license.txt.
 */

//
// Helper functions
//
var qq = qq || {};

/**
 * Adds all missing properties from second obj to first obj
 */
qq.extend = function(first, second) {
  for (var prop in second) {
    first[prop] = second[prop];
  }
};

/**
 * Searches for a given element in the array, returns -1 if it is not present.
 * @param {Number} [from] The index at which to begin the search
 */
qq.indexOf = function(arr, elt, from) {
  if (arr.indexOf) return arr.indexOf(elt, from);

  from = from || 0;
  var len = arr.length;

  if (from < 0) from += len;

  for (; from < len; from++) {
    if (from in arr && arr[from] === elt) {
      return from;
    }
  }
  return -1;
};

qq.getUniqueId = (function() {
  var id = 0;
  return function() {
    return id++;
  };
})();

//
// Events
qq.attach = function(element, type, fn) {
  if (element.addEventListener) {
    element.addEventListener(type, fn, false);
  } else if (element.attachEvent) {
    element.attachEvent('on' + type, fn);
  }
};
qq.detach = function(element, type, fn) {
  if (element.removeEventListener) {
    element.removeEventListener(type, fn, false);
  } else if (element.attachEvent) {
    element.detachEvent('on' + type, fn);
  }
};

qq.preventDefault = function(e) {
  if (e.preventDefault) {
    e.preventDefault();
  } else {
    e.returnValue = false;
  }
};

//
// Node manipulations
/**
 * Insert node a before node b.
 */
qq.insertBefore = function(a, b) {
  b.parentNode.insertBefore(a, b);
};
qq.remove = function(element) {
  element.parentNode.removeChild(element);
};

qq.contains = function(parent, descendant) {
  // compareposition returns false in this case
  if (parent == descendant) return true;

  if (parent.contains) {
    return parent.contains(descendant);
  } else {
    return !!(descendant.compareDocumentPosition(parent) & 8);
  }
};

/**
 * Creates and returns element from html string
 * Uses innerHTML to create an element
 */
qq.toElement = (function() {
  var div = document.createElement('div');
  return function(html) {
    div.innerHTML = html;
    var element = div.firstChild;
    div.removeChild(element);
    return element;
  };
})();

//
// Node properties and attributes
/**
 * Sets styles for an element.
 * Fixes opacity in IE6-8.
 */
qq.css = function(element, styles) {
  if (styles.opacity != null) {
    if (typeof element.style.opacity != 'string' && typeof(element.filters) != 'undefined') {
      styles.filter = 'alpha(opacity=' + Math.round(100 * styles.opacity) + ')';
    }
  }
  qq.extend(element.style, styles);
};
qq.hasClass = function(element, name) {
  var re = new RegExp('(^| )' + name + '( |$)');
  return re.test(element.className);
};
qq.addClass = function(element, name) {
  if (!qq.hasClass(element, name)) {
    element.className += ' ' + name;
  }
};
qq.removeClass = function(element, name) {
  var re = new RegExp('(^| )' + name + '( |$)');
  element.className = element.className.replace(re, ' ').replace(/^\s+|\s+$/g, "");
};
qq.setText = function(element, text) {
  element.innerText = text;
  element.textContent = text;
};

//
// Selecting elements
qq.children = function(element) {
  var children = [],
      child = element.firstChild;

  while (child) {
    if (child.nodeType == 1) {
      children.push(child);
    }
    child = child.nextSibling;
  }

  return children;
};

qq.getByClass = function(element, className) {
  if (element.querySelectorAll) {
    return element.querySelectorAll('.' + className);
  }

  var result = [];
  var candidates = element.getElementsByTagName("*");
  var len = candidates.length;

  for (var i = 0; i < len; i++) {
    if (qq.hasClass(candidates[i], className)) {
      result.push(candidates[i]);
    }
  }
  return result;
};

/**
 * obj2url() takes a json-object as argument and generates
 * a querystring. pretty much like jQuery.param()
 *
 * how to use:
 *
 *    `qq.obj2url({a:'b',c:'d'},'http://any.url/upload?otherParam=value');`
 *
 * will result in:
 *
 *    `http://any.url/upload?otherParam=value&a=b&c=d`
 *
 * @param  Object JSON-Object
 * @param  String current querystring-part
 * @return String encoded querystring
 */
qq.obj2url = function(obj, temp, prefixDone) {
  var uristrings = [],
      prefix = '&',
      add = function(nextObj, i) {
      var nextTemp = temp ? (/\[\]$/.test(temp)) // prevent double-encoding
      ? temp : temp + '[' + i + ']' : i;
      if ((nextTemp != 'undefined') && (i != 'undefined')) {
        uristrings.push((typeof nextObj === 'object') ? qq.obj2url(nextObj, nextTemp, true) : (Object.prototype.toString.call(nextObj) === '[object Function]') ? encodeURIComponent(nextTemp) + '=' + encodeURIComponent(nextObj()) : encodeURIComponent(nextTemp) + '=' + encodeURIComponent(nextObj));
      }
      };

  if (!prefixDone && temp) {
    prefix = (/\?/.test(temp)) ? (/\?$/.test(temp)) ? '' : '&' : '?';
    uristrings.push(temp);
    uristrings.push(qq.obj2url(obj));
  } else if ((Object.prototype.toString.call(obj) === '[object Array]') && (typeof obj != 'undefined')) {
    // we wont use a for-in-loop on an array (performance)
    for (var i = 0, len = obj.length; i < len; ++i) {
      add(obj[i], i);
    }
  } else if ((typeof obj != 'undefined') && (obj !== null) && (typeof obj === "object")) {
    // for anything else but a scalar, we will use for-in-loop
    for (var i in obj) {
      add(obj[i], i);
    }
  } else {
    uristrings.push(encodeURIComponent(temp) + '=' + encodeURIComponent(obj));
  }

  return uristrings.join(prefix).replace(/^&/, '').replace(/%20/g, '+');
};

//
//
// Uploader Classes
//
//
var qq = qq || {};

/**
 * Creates upload button, validates upload, but doesn't create file list or dd.
 */
qq.FileUploaderBasic = function(o) {
  this._options = {
    // set to true to see the server response
    debug: false,
    action: '/server/upload',
    params: {},
    button: null,
    multiple: true,
    maxConnections: 3,
    // validation
    allowedExtensions: [],
    sizeLimit: 0,
    minSizeLimit: 0,
    // events
    // return false to cancel submit
    onSubmit: function(id, fileName) {},
    onProgress: function(id, fileName, loaded, total) {},
    onComplete: function(id, fileName, responseJSON) {},
    onCancel: function(id, fileName) {},
    // messages
    messages: {
      typeError: "{file} has invalid extension. Only {extensions} are allowed.",
      sizeError: "{file} is too large, maximum file size is {sizeLimit}.",
      minSizeError: "{file} is too small, minimum file size is {minSizeLimit}.",
      emptyError: "{file} is empty, please select files again without it.",
      onLeave: "The files are being uploaded, if you leave now the upload will be cancelled."
    },
    showMessage: function(message) {
      alert(message);
    }
  };
  qq.extend(this._options, o);

  // number of files being uploaded
  this._filesInProgress = 0;
  this._handler = this._createUploadHandler();

  if (this._options.button) {
    this._button = this._createUploadButton(this._options.button);
  }

  this._preventLeaveInProgress();
};

qq.FileUploaderBasic.prototype = {
  setParams: function(params) {
    this._options.params = params;
  },
  getInProgress: function() {
    return this._filesInProgress;
  },
  _createUploadButton: function(element) {
    var self = this;

    return new qq.UploadButton({
      element: element,
      multiple: this._options.multiple && qq.UploadHandlerXhr.isSupported(),
      onChange: function(input) {
        self._onInputChange(input);
      }
    });
  },
  _createUploadHandler: function() {
    var self = this,
        handlerClass;

    if (qq.UploadHandlerXhr.isSupported()) {
      handlerClass = 'UploadHandlerXhr';
    } else {
      handlerClass = 'UploadHandlerForm';
    }

    var handler = new qq[handlerClass]({
      debug: this._options.debug,
      action: this._options.action,
      maxConnections: this._options.maxConnections,
      onProgress: function(id, fileName, loaded, total) {
        self._onProgress(id, fileName, loaded, total);
        self._options.onProgress(id, fileName, loaded, total);
      },
      onComplete: function(id, fileName, result) {
        self._onComplete(id, fileName, result);
        self._options.onComplete(id, fileName, result);
      },
      onCancel: function(id, fileName) {
        self._onCancel(id, fileName);
        self._options.onCancel(id, fileName);
      }
    });

    return handler;
  },
  _preventLeaveInProgress: function() {
    var self = this;

    qq.attach(window, 'beforeunload', function(e) {
      if (!self._filesInProgress) {
        return;
      }

      var e = e || window.event;
      // for ie, ff
      e.returnValue = self._options.messages.onLeave;
      // for webkit
      return self._options.messages.onLeave;
    });
  },
  _onSubmit: function(id, fileName) {
    this._filesInProgress++;
  },
  _onProgress: function(id, fileName, loaded, total) {},
  _onComplete: function(id, fileName, result) {
    this._filesInProgress--;
    if (result.error) {
      this._options.showMessage(result.error);
    }
  },
  _onCancel: function(id, fileName) {
    this._filesInProgress--;
  },
  _onInputChange: function(input) {
    if (this._handler instanceof qq.UploadHandlerXhr) {
      this._uploadFileList(input.files);
    } else {
      if (this._validateFile(input)) {
        this._uploadFile(input);
      }
    }
    this._button.reset();
  },
  _uploadFileList: function(files) {
    for (var i = 0; i < files.length; i++) {
      if (!this._validateFile(files[i])) {
        return;
      }
    }

    for (var i = 0; i < files.length; i++) {
      this._uploadFile(files[i]);
    }
  },
  _uploadFile: function(fileContainer) {
    var id = this._handler.add(fileContainer);
    var fileName = this._handler.getName(id);

    if (this._options.onSubmit(id, fileName) !== false) {
      this._onSubmit(id, fileName);
      this._handler.upload(id, this._options.params);
    }
  },
  _validateFile: function(file) {
    var name, size;

    if (file.value) {
      // it is a file input
      // get input value and remove path to normalize
      name = file.value.replace(/.*(\/|\\)/, "");
    } else {
      // fix missing properties in Safari
      name = file.fileName != null ? file.fileName : file.name;
      size = file.fileSize != null ? file.fileSize : file.size;
    }

    if (!this._isAllowedExtension(name)) {
      this._error('typeError', name);
      return false;

    } else if (size === 0) {
      this._error('emptyError', name);
      return false;

    } else if (size && this._options.sizeLimit && size > this._options.sizeLimit) {
      this._error('sizeError', name);
      return false;

    } else if (size && size < this._options.minSizeLimit) {
      this._error('minSizeError', name);
      return false;
    }

    return true;
  },
  _error: function(code, fileName) {
    var message = this._options.messages[code];

    function r(name, replacement) {
      message = message.replace(name, replacement);
    }

    r('{file}', this._formatFileName(fileName));
    r('{extensions}', this._options.allowedExtensions.join(', '));
    r('{sizeLimit}', this._formatSize(this._options.sizeLimit));
    r('{minSizeLimit}', this._formatSize(this._options.minSizeLimit));

    this._options.showMessage(message);
  },
  _formatFileName: function(name) {
    if (name.length > 33) {
      name = name.slice(0, 19) + '...' + name.slice(-13);
    }
    return name;
  },
  _isAllowedExtension: function(fileName) {
    var ext = (-1 !== fileName.indexOf('.')) ? fileName.replace(/.*[.]/, '').toLowerCase() : '';
    var allowed = this._options.allowedExtensions;

    if (!allowed.length) {
      return true;
    }

    for (var i = 0; i < allowed.length; i++) {
      if (allowed[i].toLowerCase() == ext) {
        return true;
      }
    }

    return false;
  },
  _formatSize: function(bytes) {
    var i = -1;
    do {
      bytes = bytes / 1024;
      i++;
    } while (bytes > 99);

    return Math.max(bytes, 0.1).toFixed(1) + ['kB', 'MB', 'GB', 'TB', 'PB', 'EB'][i];
  }
};


/**
 * Class that creates upload widget with drag-and-drop and file list
 * @inherits qq.FileUploaderBasic
 */
qq.FileUploader = function(o) {
  // call parent constructor
  qq.FileUploaderBasic.apply(this, arguments);

  // additional options
  qq.extend(this._options, {
    element: null,
    // if set, will be used instead of qq-upload-list in template
    listElement: null,

    template: '<div class="qq-uploader">' + '<div class="qq-upload-drop-area"><span>Drop files here to upload</span></div>' + '<div class="qq-upload-button">Upload a file</div>' + '<ul class="qq-upload-list"></ul>' + '</div>',

    // template for one item in file list
    fileTemplate: '<li>' + '<span class="qq-upload-file"></span>' + '<span class="qq-upload-spinner"></span>' + '<span class="qq-upload-size"></span>' + '<a class="qq-upload-cancel" href="#">Cancel</a>' + '<span class="qq-upload-failed-text">Failed</span>' + '</li>',

    classes: {
      // used to get elements from templates
      button: 'qq-upload-button',
      drop: 'qq-upload-drop-area',
      dropActive: 'qq-upload-drop-area-active',
      list: 'qq-upload-list',

      file: 'qq-upload-file',
      spinner: 'qq-upload-spinner',
      size: 'qq-upload-size',
      cancel: 'qq-upload-cancel',

      // added to list item when upload completes
      // used in css to hide progress spinner
      success: 'qq-upload-success',
      fail: 'qq-upload-fail'
    }
  });
  // overwrite options with user supplied
  qq.extend(this._options, o);

  this._element = this._options.element;
  this._element.innerHTML = this._options.template;
  this._listElement = this._options.listElement || this._find(this._element, 'list');

  this._classes = this._options.classes;

  this._button = this._createUploadButton(this._find(this._element, 'button'));

  this._bindCancelEvent();
  //this._setupDragDrop();
};

// inherit from Basic Uploader
qq.extend(qq.FileUploader.prototype, qq.FileUploaderBasic.prototype);

qq.extend(qq.FileUploader.prototype, {
  /**
   * Gets one of the elements listed in this._options.classes
   **/
  _find: function(parent, type) {
    var element = qq.getByClass(parent, this._options.classes[type])[0];
    if (!element) {
      throw new Error('element not found ' + type);
    }

    return element;
  },
  _setupDragDrop: function() {
    var self = this,
        dropArea = this._find(this._element, 'drop');

    var dz = new qq.UploadDropZone({
      element: dropArea,
      onEnter: function(e) {
        qq.addClass(dropArea, self._classes.dropActive);
        e.stopPropagation();
      },
      onLeave: function(e) {
        e.stopPropagation();
      },
      onLeaveNotDescendants: function(e) {
        qq.removeClass(dropArea, self._classes.dropActive);
      },
      onDrop: function(e) {
        dropArea.style.display = 'none';
        qq.removeClass(dropArea, self._classes.dropActive);
        self._uploadFileList(e.dataTransfer.files);
      }
    });

    dropArea.style.display = 'none';

    qq.attach(document, 'dragenter', function(e) {
      if (!dz._isValidFileDrag(e)) return;

      dropArea.style.display = 'block';
    });
    qq.attach(document, 'dragleave', function(e) {
      if (!dz._isValidFileDrag(e)) return;

      var relatedTarget = document.elementFromPoint(e.clientX, e.clientY);
      // only fire when leaving document out
      if (!relatedTarget || relatedTarget.nodeName == "HTML") {
        dropArea.style.display = 'none';
      }
    });
  },
  _onSubmit: function(id, fileName) {
    qq.FileUploaderBasic.prototype._onSubmit.apply(this, arguments);
    this._addToList(id, fileName);
  },
  _onProgress: function(id, fileName, loaded, total) {
    qq.FileUploaderBasic.prototype._onProgress.apply(this, arguments);

    var item = this._getItemByFileId(id);
    var size = this._find(item, 'size');
    size.style.display = 'inline';

    var text;
    if (loaded != total) {
      text = Math.round(loaded / total * 100) + '% from ' + this._formatSize(total);
    } else {
      text = this._formatSize(total);
    }

    qq.setText(size, text);
  },
  _onComplete: function(id, fileName, result) {
    qq.FileUploaderBasic.prototype._onComplete.apply(this, arguments);

    // mark completed
    var item = this._getItemByFileId(id);
    qq.remove(this._find(item, 'cancel'));
    qq.remove(this._find(item, 'spinner'));

    if (result.success) {
      qq.addClass(item, this._classes.success);
    } else {
      qq.addClass(item, this._classes.fail);
    }
  },
  _addToList: function(id, fileName) {
    var item = qq.toElement(this._options.fileTemplate);
    item.qqFileId = id;

    var fileElement = this._find(item, 'file');
    qq.setText(fileElement, this._formatFileName(fileName));
    this._find(item, 'size').style.display = 'none';

    this._listElement.appendChild(item);
  },
  _getItemByFileId: function(id) {
    var item = this._listElement.firstChild;

    // there can't be txt nodes in dynamically created list
    // and we can  use nextSibling
    while (item) {
      if (item.qqFileId == id) return item;
      item = item.nextSibling;
    }
  },
  /**
   * delegate click event for cancel link
   **/
  _bindCancelEvent: function() {
    var self = this,
        list = this._listElement;

    qq.attach(list, 'click', function(e) {
      e = e || window.event;
      var target = e.target || e.srcElement;

      if (qq.hasClass(target, self._classes.cancel)) {
        qq.preventDefault(e);

        var item = target.parentNode;
        self._handler.cancel(item.qqFileId);
        qq.remove(item);
      }
    });
  }
});

qq.UploadDropZone = function(o) {
  this._options = {
    element: null,
    onEnter: function(e) {},
    onLeave: function(e) {},
    // is not fired when leaving element by hovering descendants
    onLeaveNotDescendants: function(e) {},
    onDrop: function(e) {}
  };
  qq.extend(this._options, o);

  this._element = this._options.element;

  this._disableDropOutside();
  this._attachEvents();
};

qq.UploadDropZone.prototype = {
  _disableDropOutside: function(e) {
    // run only once for all instances
    if (!qq.UploadDropZone.dropOutsideDisabled) {

      qq.attach(document, 'dragover', function(e) {
        if (e.dataTransfer) {
          e.dataTransfer.dropEffect = 'none';
          e.preventDefault();
        }
      });

      qq.UploadDropZone.dropOutsideDisabled = true;
    }
  },
  _attachEvents: function() {
    var self = this;

    qq.attach(self._element, 'dragover', function(e) {
      if (!self._isValidFileDrag(e)) return;

      var effect = e.dataTransfer.effectAllowed;
      if (effect == 'move' || effect == 'linkMove') {
        e.dataTransfer.dropEffect = 'move'; // for FF (only move allowed)
      } else {
        e.dataTransfer.dropEffect = 'copy'; // for Chrome
      }

      e.stopPropagation();
      e.preventDefault();
    });

    qq.attach(self._element, 'dragenter', function(e) {
      if (!self._isValidFileDrag(e)) return;

      self._options.onEnter(e);
    });

    qq.attach(self._element, 'dragleave', function(e) {
      if (!self._isValidFileDrag(e)) return;

      self._options.onLeave(e);

      var relatedTarget = document.elementFromPoint(e.clientX, e.clientY);
      // do not fire when moving a mouse over a descendant
      if (qq.contains(this, relatedTarget)) return;

      self._options.onLeaveNotDescendants(e);
    });

    qq.attach(self._element, 'drop', function(e) {
      if (!self._isValidFileDrag(e)) return;

      e.preventDefault();
      self._options.onDrop(e);
    });
  },
  _isValidFileDrag: function(e) {
    var dt = e.dataTransfer,


        // do not check dt.types.contains in webkit, because it crashes safari 4
        isWebkit = navigator.userAgent.indexOf("AppleWebKit") > -1;

    // dt.effectAllowed is none in Safari 5
    // dt.types.contains check is for firefox
    return dt && dt.effectAllowed != 'none' && (dt.files || (!isWebkit && dt.types.contains && dt.types.contains('Files')));

  }
};

qq.UploadButton = function(o) {
  this._options = {
    element: null,
    // if set to true adds multiple attribute to file input
    multiple: false,
    // name attribute of file input
    name: 'file',
    onChange: function(input) {},
    hoverClass: 'qq-upload-button-hover',
    focusClass: 'qq-upload-button-focus'
  };

  qq.extend(this._options, o);

  this._element = this._options.element;

  // make button suitable container for input
  qq.css(this._element, {
    position: 'relative',
    overflow: 'hidden',
    // Make sure browse button is in the right side
    // in Internet Explorer
    direction: 'ltr'
  });

  this._input = this._createInput();
};

qq.UploadButton.prototype = { /* returns file input element */
  getInput: function() {
    return this._input;
  },
  /* cleans/recreates the file input */
  reset: function() {
    if (this._input.parentNode) {
      qq.remove(this._input);
    }

    qq.removeClass(this._element, this._options.focusClass);
    this._input = this._createInput();
  },
  _createInput: function() {
    var input = document.createElement("input");

    if (this._options.multiple) {
      input.setAttribute("multiple", "multiple");
    }

    input.setAttribute("type", "file");
    input.setAttribute("name", this._options.name);

    qq.css(input, {
      position: 'absolute',
      // in Opera only 'browse' button
      // is clickable and it is located at
      // the right side of the input
      right: 0,
      top: 0,
      fontFamily: 'Arial',
      // 4 persons reported this, the max values that worked for them were 243, 236, 236, 118
      fontSize: '118px',
      margin: 0,
      padding: 0,
      cursor: 'pointer',
      opacity: 0
    });

    this._element.appendChild(input);

    var self = this;
    qq.attach(input, 'change', function() {
      self._options.onChange(input);
    });

    qq.attach(input, 'mouseover', function() {
      qq.addClass(self._element, self._options.hoverClass);
    });
    qq.attach(input, 'mouseout', function() {
      qq.removeClass(self._element, self._options.hoverClass);
    });
    qq.attach(input, 'focus', function() {
      qq.addClass(self._element, self._options.focusClass);
    });
    qq.attach(input, 'blur', function() {
      qq.removeClass(self._element, self._options.focusClass);
    });

    // IE and Opera, unfortunately have 2 tab stops on file input
    // which is unacceptable in our case, disable keyboard access
    if (window.attachEvent) {
      // it is IE or Opera
      input.setAttribute('tabIndex', "-1");
    }

    return input;
  }
};

/**
 * Class for uploading files, uploading itself is handled by child classes
 */
qq.UploadHandlerAbstract = function(o) {
  this._options = {
    debug: false,
    action: '/upload.php',
    // maximum number of concurrent uploads
    maxConnections: 999,
    onProgress: function(id, fileName, loaded, total) {},
    onComplete: function(id, fileName, response) {},
    onCancel: function(id, fileName) {}
  };
  qq.extend(this._options, o);

  this._queue = [];
  // params for files in queue
  this._params = [];
};
qq.UploadHandlerAbstract.prototype = {
  log: function(str) {
    if (this._options.debug && window.console) console.log('[uploader] ' + str);
  },
  /**
   * Adds file or file input to the queue
   * @returns id
   **/
  add: function(file) {},
  /**
   * Sends the file identified by id and additional query params to the server
   */
  upload: function(id, params) {
    var len = this._queue.push(id);

    var copy = {};
    qq.extend(copy, params);
    this._params[id] = copy;

    // if too many active uploads, wait...
    if (len <= this._options.maxConnections) {
      this._upload(id, this._params[id]);
    }
  },
  /**
   * Cancels file upload by id
   */
  cancel: function(id) {
    this._cancel(id);
    this._dequeue(id);
  },
  /**
   * Cancells all uploads
   */
  cancelAll: function() {
    for (var i = 0; i < this._queue.length; i++) {
      this._cancel(this._queue[i]);
    }
    this._queue = [];
  },
  /**
   * Returns name of the file identified by id
   */
  getName: function(id) {},
  /**
   * Returns size of the file identified by id
   */
  getSize: function(id) {},
  /**
   * Returns id of files being uploaded or
   * waiting for their turn
   */
  getQueue: function() {
    return this._queue;
  },
  /**
   * Actual upload method
   */
  _upload: function(id) {},
  /**
   * Actual cancel method
   */
  _cancel: function(id) {},
  /**
   * Removes element from queue, starts upload of next
   */
  _dequeue: function(id) {
    var i = qq.indexOf(this._queue, id);
    this._queue.splice(i, 1);

    var max = this._options.maxConnections;

    if (this._queue.length >= max && i < max) {
      var nextId = this._queue[max - 1];
      this._upload(nextId, this._params[nextId]);
    }
  }
};

/**
 * Class for uploading files using form and iframe
 * @inherits qq.UploadHandlerAbstract
 */
qq.UploadHandlerForm = function(o) {
  qq.UploadHandlerAbstract.apply(this, arguments);

  this._inputs = {};
};
// @inherits qq.UploadHandlerAbstract
qq.extend(qq.UploadHandlerForm.prototype, qq.UploadHandlerAbstract.prototype);

qq.extend(qq.UploadHandlerForm.prototype, {
  add: function(fileInput) {
    fileInput.setAttribute('name', 'qqfile');
    var id = 'qq-upload-handler-iframe' + qq.getUniqueId();

    this._inputs[id] = fileInput;

    // remove file input from DOM
    if (fileInput.parentNode) {
      qq.remove(fileInput);
    }

    return id;
  },
  getName: function(id) {
    // get input value and remove path to normalize
    return this._inputs[id].value.replace(/.*(\/|\\)/, "");
  },
  _cancel: function(id) {
    this._options.onCancel(id, this.getName(id));

    delete this._inputs[id];

    var iframe = document.getElementById(id);
    if (iframe) {
      // to cancel request set src to something else
      // we use src="javascript:false;" because it doesn't
      // trigger ie6 prompt on https
      iframe.setAttribute('src', 'javascript:false;');

      qq.remove(iframe);
    }
  },
  _upload: function(id, params) {
    var input = this._inputs[id];

    if (!input) {
      throw new Error('file with passed id was not added, or already uploaded or cancelled');
    }

    var fileName = this.getName(id);

    var iframe = this._createIframe(id);
    var form = this._createForm(iframe, params);
    form.appendChild(input);

    var self = this;
    this._attachLoadEvent(iframe, function() {
      self.log('iframe loaded');

      var response = self._getIframeContentJSON(iframe);

      self._options.onComplete(id, fileName, response);
      self._dequeue(id);

      delete self._inputs[id];
      // timeout added to fix busy state in FF3.6
      setTimeout(function() {
        qq.remove(iframe);
      }, 1);
    });

    form.submit();
    qq.remove(form);

    return id;
  },
  _attachLoadEvent: function(iframe, callback) {
    qq.attach(iframe, 'load', function() {
      // when we remove iframe from dom
      // the request stops, but in IE load
      // event fires
      if (!iframe.parentNode) {
        return;
      }

      // fixing Opera 10.53
      if (iframe.contentDocument && iframe.contentDocument.body && iframe.contentDocument.body.innerHTML == "false") {
        // In Opera event is fired second time
        // when body.innerHTML changed from false
        // to server response approx. after 1 sec
        // when we upload file with iframe
        return;
      }

      callback();
    });
  },
  /**
   * Returns json object received by iframe from server.
   */
  _getIframeContentJSON: function(iframe) {
    // iframe.contentWindow.document - for IE<7
    var doc = iframe.contentDocument ? iframe.contentDocument : iframe.contentWindow.document,
        response;

    this.log("converting iframe's innerHTML to JSON");
    this.log("innerHTML = " + doc.body.innerHTML);

    try {
      response = eval("(" + doc.body.innerHTML + ")");
    } catch (err) {
      response = {};
    }

    return response;
  },
  /**
   * Creates iframe with unique name
   */
  _createIframe: function(id) {
    // We can't use following code as the name attribute
    // won't be properly registered in IE6, and new window
    // on form submit will open
    // var iframe = document.createElement('iframe');
    // iframe.setAttribute('name', id);
    var iframe = qq.toElement('<iframe src="javascript:false;" name="' + id + '" />');
    // src="javascript:false;" removes ie6 prompt on https
    iframe.setAttribute('id', id);

    iframe.style.display = 'none';
    document.body.appendChild(iframe);

    return iframe;
  },
  /**
   * Creates form, that will be submitted to iframe
   */
  _createForm: function(iframe, params) {
    // We can't use the following code in IE6
    // var form = document.createElement('form');
    // form.setAttribute('method', 'post');
    // form.setAttribute('enctype', 'multipart/form-data');
    // Because in this case file won't be attached to request
    var form = qq.toElement('<form method="post" enctype="multipart/form-data"></form>');

    var queryString = qq.obj2url(params, this._options.action);

    form.setAttribute('action', queryString);
    form.setAttribute('target', iframe.name);
    form.style.display = 'none';
    document.body.appendChild(form);

    return form;
  }
});

/**
 * Class for uploading files using xhr
 * @inherits qq.UploadHandlerAbstract
 */
qq.UploadHandlerXhr = function(o) {
  qq.UploadHandlerAbstract.apply(this, arguments);

  this._files = [];
  this._xhrs = [];

  // current loaded size in bytes for each file
  this._loaded = [];
};

// static method
qq.UploadHandlerXhr.isSupported = function() {
  var input = document.createElement('input');
  input.type = 'file';

  return ('multiple' in input && typeof File != "undefined" && typeof(new XMLHttpRequest()).upload != "undefined");
};

// @inherits qq.UploadHandlerAbstract
qq.extend(qq.UploadHandlerXhr.prototype, qq.UploadHandlerAbstract.prototype)

qq.extend(qq.UploadHandlerXhr.prototype, {
  /**
   * Adds file to the queue
   * Returns id to use with upload, cancel
   **/
  add: function(file) {
    if (!(file instanceof File)) {
      throw new Error('Passed obj in not a File (in qq.UploadHandlerXhr)');
    }

    return this._files.push(file) - 1;
  },
  getName: function(id) {
    var file = this._files[id];
    // fix missing name in Safari 4
    return file.fileName != null ? file.fileName : file.name;
  },
  getSize: function(id) {
    var file = this._files[id];
    return file.fileSize != null ? file.fileSize : file.size;
  },
  /**
   * Returns uploaded bytes for file identified by id
   */
  getLoaded: function(id) {
    return this._loaded[id] || 0;
  },
  /**
   * Sends the file identified by id and additional query params to the server
   * @param {Object} params name-value string pairs
   */
  _upload: function(id, params) {
    var file = this._files[id],
        name = this.getName(id),
        size = this.getSize(id);

    this._loaded[id] = 0;

    var xhr = this._xhrs[id] = new XMLHttpRequest();
    var self = this;

    xhr.upload.onprogress = function(e) {
      if (e.lengthComputable) {
        self._loaded[id] = e.loaded;
        self._options.onProgress(id, name, e.loaded, e.total);
      }
    };

    xhr.onreadystatechange = function() {
      if (xhr.readyState == 4) {
        self._onComplete(id, xhr);
      }
    };

    // build query string
    params = params || {};
    params['qqfile'] = name;
    var queryString = qq.obj2url(params, this._options.action);

    xhr.open("POST", queryString, true);
    xhr.setRequestHeader("X-Requested-With", "XMLHttpRequest");
    xhr.setRequestHeader("X-File-Name", encodeURIComponent(name));
    xhr.setRequestHeader("Content-Type", "application/octet-stream");
    xhr.send(file);
  },
  _onComplete: function(id, xhr) {
    // the request was aborted/cancelled
    if (!this._files[id]) return;

    var name = this.getName(id);
    var size = this.getSize(id);

    this._options.onProgress(id, name, size, size);

    if (xhr.status == 200) {
      this.log("xhr - server response received");
      this.log("responseText = " + xhr.responseText);

      var response;

      try {
        response = eval("(" + xhr.responseText + ")");
      } catch (err) {
        response = {};
      }

      this._options.onComplete(id, name, response);

    } else {
      this._options.onComplete(id, name, {});
    }

    this._files[id] = null;
    this._xhrs[id] = null;
    this._dequeue(id);
  },
  _cancel: function(id) {
    this._options.onCancel(id, this.getName(id));

    this._files[id] = null;

    if (this._xhrs[id]) {
      this._xhrs[id].abort();
      this._xhrs[id] = null;
    }
  }
});

/**
 * obj2url() takes a json-object as argument and generates
 * a querystring. pretty much like jQuery.param()
 *
 * how to use:
 *
 *    `qq.obj2url({a:'b',c:'d'},'http://any.url/upload?otherParam=value');`
 *
 * will result in:
 *
 *    `http://any.url/upload?otherParam=value&a=b&c=d`
 *
 * @param  Object JSON-Object
 * @param  String current querystring-part
 * @return String encoded querystring
 */
qq.obj2url = function(obj, temp, prefixDone) {
  var uristrings = [],
      prefix = '&',
      add = function(nextObj, i) {
      var nextTemp = temp ? (/\[\]$/.test(temp)) // prevent double-encoding
      ? temp : temp + '[' + i + ']' : i;
      if ((nextTemp != 'undefined') && (i != 'undefined')) {
        uristrings.push((typeof nextObj === 'object') ? qq.obj2url(nextObj, nextTemp, true) : (Object.prototype.toString.call(nextObj) === '[object Function]') ? encodeURIComponent(nextTemp) + '=' + encodeURIComponent(nextObj()) : encodeURIComponent(nextTemp) + '=' + encodeURIComponent(nextObj));
      }
      };

  if (!prefixDone && temp) {
    prefix = (/\?/.test(temp)) ? (/\?$/.test(temp)) ? '' : '&' : '?';
    uristrings.push(temp);
    uristrings.push(qq.obj2url(obj));
  } else if ((Object.prototype.toString.call(obj) === '[object Array]') && (typeof obj != 'undefined')) {
    // we wont use a for-in-loop on an array (performance)
    for (var i = 0, len = obj.length; i < len; ++i) {
      add(obj[i], i);
    }
  } else if ((typeof obj != 'undefined') && (obj !== null) && (typeof obj === "object")) {
    // for anything else but a scalar, we will use for-in-loop
    for (var i in obj) {
      add(obj[i], i);
    }
  } else {
    uristrings.push(encodeURIComponent(temp) + '=' + encodeURIComponent(obj));
  }

  return uristrings.join(prefix).replace(/^&/, '').replace(/%20/g, '+');
};

//
//
// Uploader Classes
//
//
var qq = qq || {};

/**
 * Creates upload button, validates upload, but doesn't create file list or dd.
 */
qq.FileUploaderBasic = function(o) {
  this._options = {
    // set to true to see the server response
    debug: false,
    action: '/server/upload',
    params: {},
    button: null,
    multiple: false,
    maxConnections: 3,
    // validation
    allowedExtensions: ['jpg', 'jpeg', 'png', 'gif'],
    sizeLimit: 0,
    minSizeLimit: 0,
    // events
    // return false to cancel submit
    onSubmit: function(id, fileName) {},
    onProgress: function(id, fileName, loaded, total) {},
    onComplete: function(id, fileName, responseJSON) {},
    onCancel: function(id, fileName) {},
    // messages
    messages: {
      typeError: "{file} has invalid extension. Only {extensions} are allowed.",
      sizeError: "{file} is too large, maximum file size is {sizeLimit}.",
      minSizeError: "{file} is too small, minimum file size is {minSizeLimit}.",
      emptyError: "{file} is empty, please select files again without it.",
      onLeave: "The files are being uploaded, if you leave now the upload will be cancelled."
    },
    showMessage: function(message) {
      alert(message);
    }
  };
  qq.extend(this._options, o);

  // number of files being uploaded
  this._filesInProgress = 0;
  this._handler = this._createUploadHandler();

  if (this._options.button) {
    this._button = this._createUploadButton(this._options.button);
  }

  this._preventLeaveInProgress();
};

qq.FileUploaderBasic.prototype = {
  setParams: function(params) {
    this._options.params = params;
  },
  getInProgress: function() {
    return this._filesInProgress;
  },
  _createUploadButton: function(element) {
    var self = this;

    return new qq.UploadButton({
      element: element,
      multiple: this._options.multiple && qq.UploadHandlerXhr.isSupported(),
      onChange: function(input) {
        self._onInputChange(input);
      }
    });
  },
  _createUploadHandler: function() {
    var self = this,
        handlerClass;

    if (qq.UploadHandlerXhr.isSupported()) {
      handlerClass = 'UploadHandlerXhr';
    } else {
      handlerClass = 'UploadHandlerForm';
    }

    var handler = new qq[handlerClass]({
      debug: this._options.debug,
      action: this._options.action,
      maxConnections: this._options.maxConnections,
      onProgress: function(id, fileName, loaded, total) {
        self._onProgress(id, fileName, loaded, total);
        self._options.onProgress(id, fileName, loaded, total);
      },
      onComplete: function(id, fileName, result) {
        self._onComplete(id, fileName, result);
        self._options.onComplete(id, fileName, result);
      },
      onCancel: function(id, fileName) {
        self._onCancel(id, fileName);
        self._options.onCancel(id, fileName);
      }
    });

    return handler;
  },
  _preventLeaveInProgress: function() {
    var self = this;

    qq.attach(window, 'beforeunload', function(e) {
      if (!self._filesInProgress) {
        return;
      }

      var e = e || window.event;
      // for ie, ff
      e.returnValue = self._options.messages.onLeave;
      // for webkit
      return self._options.messages.onLeave;
    });
  },
  _onSubmit: function(id, fileName) {
    this._filesInProgress++;
  },
  _onProgress: function(id, fileName, loaded, total) {},
  _onComplete: function(id, fileName, result) {
    this._filesInProgress--;
    if (result.error) {
      this._options.showMessage(result.error);
    }
  },
  _onCancel: function(id, fileName) {
    this._filesInProgress--;
  },
  _onInputChange: function(input) {
    if (this._handler instanceof qq.UploadHandlerXhr) {
      this._uploadFileList(input.files);
    } else {
      if (this._validateFile(input)) {
        this._uploadFile(input);
      }
    }
    this._button.reset();
  },
  _uploadFileList: function(files) {
    for (var i = 0; i < files.length; i++) {
      if (!this._validateFile(files[i])) {
        return;
      }
    }

    for (var i = 0; i < files.length; i++) {
      this._uploadFile(files[i]);
    }
  },
  _uploadFile: function(fileContainer) {
    var id = this._handler.add(fileContainer);
    var fileName = this._handler.getName(id);

    if (this._options.onSubmit(id, fileName) !== false) {
      this._onSubmit(id, fileName);
      this._handler.upload(id, this._options.params);
    }
  },
  _validateFile: function(file) {
    var name, size;

    if (file.value) {
      // it is a file input
      // get input value and remove path to normalize
      name = file.value.replace(/.*(\/|\\)/, "");
    } else {
      // fix missing properties in Safari
      name = file.fileName != null ? file.fileName : file.name;
      size = file.fileSize != null ? file.fileSize : file.size;
    }

    if (!this._isAllowedExtension(name)) {
      this._error('typeError', name);
      return false;

    } else if (size === 0) {
      this._error('emptyError', name);
      return false;

    } else if (size && this._options.sizeLimit && size > this._options.sizeLimit) {
      this._error('sizeError', name);
      return false;

    } else if (size && size < this._options.minSizeLimit) {
      this._error('minSizeError', name);
      return false;
    }

    return true;
  },
  _error: function(code, fileName) {
    var message = this._options.messages[code];

    function r(name, replacement) {
      message = message.replace(name, replacement);
    }

    r('{file}', this._formatFileName(fileName));
    r('{extensions}', this._options.allowedExtensions.join(', '));
    r('{sizeLimit}', this._formatSize(this._options.sizeLimit));
    r('{minSizeLimit}', this._formatSize(this._options.minSizeLimit));

    this._options.showMessage(message);
  },
  _formatFileName: function(name) {
    if (name.length > 33) {
      name = name.slice(0, 19) + '...' + name.slice(-13);
    }
    return name;
  },
  _isAllowedExtension: function(fileName) {
    var ext = (-1 !== fileName.indexOf('.')) ? fileName.replace(/.*[.]/, '').toLowerCase() : '';
    var allowed = this._options.allowedExtensions;

    if (!allowed.length) {
      return true;
    }

    for (var i = 0; i < allowed.length; i++) {
      if (allowed[i].toLowerCase() == ext) {
        return true;
      }
    }

    return false;
  },
  _formatSize: function(bytes) {
    var i = -1;
    do {
      bytes = bytes / 1024;
      i++;
    } while (bytes > 99);

    return Math.max(bytes, 0.1).toFixed(1) + ['kB', 'MB', 'GB', 'TB', 'PB', 'EB'][i];
  }
};


/**
 * Class that creates upload widget with drag-and-drop and file list
 * @inherits qq.FileUploaderBasic
 */
qq.FileUploader = function(o) {
  // call parent constructor
  qq.FileUploaderBasic.apply(this, arguments);

  // additional options
  qq.extend(this._options, {
    element: null,
    // if set, will be used instead of qq-upload-list in template
    listElement: null,

    template: '<div class="qq-uploader">' + '<div class="qq-upload-drop-area"><span>Drop files here to upload</span></div>' + '<div class="qq-upload-button"> ' + this._options.text + ' </div>' + '<ul class="qq-upload-list"></ul>' + '</div>',

    // template for one item in file list
    fileTemplate: '<li>' + '<span class="qq-upload-file"></span>' + '<span class="qq-upload-spinner"></span>' + '<span class="qq-upload-size"></span>' + '<a class="qq-upload-cancel" href="#">Cancel</a>' + '<span class="qq-upload-failed-text">Failed</span>' + '</li>',

    classes: {
      // used to get elements from templates
      button: 'qq-upload-button',
      drop: 'qq-upload-drop-area',
      dropActive: 'qq-upload-drop-area-active',
      list: 'qq-upload-list',

      file: 'qq-upload-file',
      spinner: 'qq-upload-spinner',
      size: 'qq-upload-size',
      cancel: 'qq-upload-cancel',

      // added to list item when upload completes
      // used in css to hide progress spinner
      success: 'qq-upload-success',
      fail: 'qq-upload-fail'
    }
  });
  // overwrite options with user supplied
  qq.extend(this._options, o);

  this._element = this._options.element;
  this._element.innerHTML = this._options.template;
  this._listElement = this._options.listElement || this._find(this._element, 'list');

  this._classes = this._options.classes;

  this._button = this._createUploadButton(this._find(this._element, 'button'));

  this._bindCancelEvent();
  //this._setupDragDrop();
};

// inherit from Basic Uploader
qq.extend(qq.FileUploader.prototype, qq.FileUploaderBasic.prototype);

qq.extend(qq.FileUploader.prototype, {
  /**
   * Gets one of the elements listed in this._options.classes
   **/
  _find: function(parent, type) {
    var element = qq.getByClass(parent, this._options.classes[type])[0];
    if (!element) {
      throw new Error('element not found ' + type);
    }

    return element;
  },
  _setupDragDrop: function() {
    var self = this,
        dropArea = this._find(this._element, 'drop');

    var dz = new qq.UploadDropZone({
      element: dropArea,
      onEnter: function(e) {
        qq.addClass(dropArea, self._classes.dropActive);
        e.stopPropagation();
      },
      onLeave: function(e) {
        e.stopPropagation();
      },
      onLeaveNotDescendants: function(e) {
        qq.removeClass(dropArea, self._classes.dropActive);
      },
      onDrop: function(e) {
        dropArea.style.display = 'none';
        qq.removeClass(dropArea, self._classes.dropActive);
        self._uploadFileList(e.dataTransfer.files);
      }
    });

    dropArea.style.display = 'none';

    qq.attach(document, 'dragenter', function(e) {
      if (!dz._isValidFileDrag(e)) return;

      dropArea.style.display = 'block';
    });
    qq.attach(document, 'dragleave', function(e) {
      if (!dz._isValidFileDrag(e)) return;

      var relatedTarget = document.elementFromPoint(e.clientX, e.clientY);
      // only fire when leaving document out
      if (!relatedTarget || relatedTarget.nodeName == "HTML") {
        dropArea.style.display = 'none';
      }
    });
  },
  _onSubmit: function(id, fileName) {
    qq.FileUploaderBasic.prototype._onSubmit.apply(this, arguments);
    this._addToList(id, fileName);
  },
  _onProgress: function(id, fileName, loaded, total) {
    qq.FileUploaderBasic.prototype._onProgress.apply(this, arguments);

    var item = this._getItemByFileId(id);
    var size = this._find(item, 'size');
    size.style.display = 'inline';

    var text;
    if (loaded != total) {
      text = Math.round(loaded / total * 100) + '% from ' + this._formatSize(total);
    } else {
      text = this._formatSize(total);
    }

    qq.setText(size, text);
  },
  _onComplete: function(id, fileName, result) {
    qq.FileUploaderBasic.prototype._onComplete.apply(this, arguments);

    // mark completed
    var item = this._getItemByFileId(id);
    qq.remove(this._find(item, 'cancel'));
    qq.remove(this._find(item, 'spinner'));

    if (result.success) {
      qq.addClass(item, this._classes.success);
    } else {
      qq.addClass(item, this._classes.fail);
    }
  },
  _addToList: function(id, fileName) {
    var item = qq.toElement(this._options.fileTemplate);
    item.qqFileId = id;

    var fileElement = this._find(item, 'file');
    qq.setText(fileElement, this._formatFileName(fileName));
    this._find(item, 'size').style.display = 'none';

    this._listElement.appendChild(item);
  },
  _getItemByFileId: function(id) {
    var item = this._listElement.firstChild;

    // there can't be txt nodes in dynamically created list
    // and we can  use nextSibling
    while (item) {
      if (item.qqFileId == id) return item;
      item = item.nextSibling;
    }
  },
  /**
   * delegate click event for cancel link
   **/
  _bindCancelEvent: function() {
    var self = this,
        list = this._listElement;

    qq.attach(list, 'click', function(e) {
      e = e || window.event;
      var target = e.target || e.srcElement;

      if (qq.hasClass(target, self._classes.cancel)) {
        qq.preventDefault(e);

        var item = target.parentNode;
        self._handler.cancel(item.qqFileId);
        qq.remove(item);
      }
    });
  }
});

qq.UploadDropZone = function(o) {
  this._options = {
    element: null,
    onEnter: function(e) {},
    onLeave: function(e) {},
    // is not fired when leaving element by hovering descendants
    onLeaveNotDescendants: function(e) {},
    onDrop: function(e) {}
  };
  qq.extend(this._options, o);

  this._element = this._options.element;

  this._disableDropOutside();
  this._attachEvents();
};

qq.UploadDropZone.prototype = {
  _disableDropOutside: function(e) {
    // run only once for all instances
    if (!qq.UploadDropZone.dropOutsideDisabled) {

      qq.attach(document, 'dragover', function(e) {
        if (e.dataTransfer) {
          e.dataTransfer.dropEffect = 'none';
          e.preventDefault();
        }
      });

      qq.UploadDropZone.dropOutsideDisabled = true;
    }
  },
  _attachEvents: function() {
    var self = this;

    qq.attach(self._element, 'dragover', function(e) {
      if (!self._isValidFileDrag(e)) return;

      var effect = e.dataTransfer.effectAllowed;
      if (effect == 'move' || effect == 'linkMove') {
        e.dataTransfer.dropEffect = 'move'; // for FF (only move allowed)
      } else {
        e.dataTransfer.dropEffect = 'copy'; // for Chrome
      }

      e.stopPropagation();
      e.preventDefault();
    });

    qq.attach(self._element, 'dragenter', function(e) {
      if (!self._isValidFileDrag(e)) return;

      self._options.onEnter(e);
    });

    qq.attach(self._element, 'dragleave', function(e) {
      if (!self._isValidFileDrag(e)) return;

      self._options.onLeave(e);

      var relatedTarget = document.elementFromPoint(e.clientX, e.clientY);
      // do not fire when moving a mouse over a descendant
      if (qq.contains(this, relatedTarget)) return;

      self._options.onLeaveNotDescendants(e);
    });

    qq.attach(self._element, 'drop', function(e) {
      if (!self._isValidFileDrag(e)) return;

      e.preventDefault();
      self._options.onDrop(e);
    });
  },
  _isValidFileDrag: function(e) {
    var dt = e.dataTransfer,


        // do not check dt.types.contains in webkit, because it crashes safari 4
        isWebkit = navigator.userAgent.indexOf("AppleWebKit") > -1;

    // dt.effectAllowed is none in Safari 5
    // dt.types.contains check is for firefox
    return dt && dt.effectAllowed != 'none' && (dt.files || (!isWebkit && dt.types.contains && dt.types.contains('Files')));

  }
};

qq.UploadButton = function(o) {
  this._options = {
    element: null,
    // if set to true adds multiple attribute to file input
    multiple: false,
    // name attribute of file input
    name: 'file',
    onChange: function(input) {},
    hoverClass: 'qq-upload-button-hover',
    focusClass: 'qq-upload-button-focus'
  };

  qq.extend(this._options, o);

  this._element = this._options.element;

  // make button suitable container for input
  qq.css(this._element, {
    position: 'relative',
    overflow: 'hidden',
    // Make sure browse button is in the right side
    // in Internet Explorer
    direction: 'ltr'
  });

  this._input = this._createInput();
};

qq.UploadButton.prototype = { /* returns file input element */
  getInput: function() {
    return this._input;
  },
  /* cleans/recreates the file input */
  reset: function() {
    if (this._input.parentNode) {
      qq.remove(this._input);
    }

    qq.removeClass(this._element, this._options.focusClass);
    this._input = this._createInput();
  },
  _createInput: function() {
    var input = document.createElement("input");

    if (this._options.multiple) {
      input.setAttribute("multiple", "multiple");
    }

    input.setAttribute("type", "file");
    input.setAttribute("name", this._options.name);

    qq.css(input, {
      position: 'absolute',
      // in Opera only 'browse' button
      // is clickable and it is located at
      // the right side of the input
      right: 0,
      top: 0,
      fontFamily: 'Arial',
      // 4 persons reported this, the max values that worked for them were 243, 236, 236, 118
      fontSize: '118px',
      margin: 0,
      padding: 0,
      cursor: 'pointer',
      opacity: 0
    });

    this._element.appendChild(input);

    var self = this;
    qq.attach(input, 'change', function() {
      self._options.onChange(input);
    });

    qq.attach(input, 'mouseover', function() {
      qq.addClass(self._element, self._options.hoverClass);
    });
    qq.attach(input, 'mouseout', function() {
      qq.removeClass(self._element, self._options.hoverClass);
    });
    qq.attach(input, 'focus', function() {
      qq.addClass(self._element, self._options.focusClass);
    });
    qq.attach(input, 'blur', function() {
      qq.removeClass(self._element, self._options.focusClass);
    });

    // IE and Opera, unfortunately have 2 tab stops on file input
    // which is unacceptable in our case, disable keyboard access
    if (window.attachEvent) {
      // it is IE or Opera
      input.setAttribute('tabIndex', "-1");
    }

    return input;
  }
};

/**
 * Class for uploading files, uploading itself is handled by child classes
 */
qq.UploadHandlerAbstract = function(o) {
  this._options = {
    debug: false,
    action: '/upload.php',
    // maximum number of concurrent uploads
    maxConnections: 999,
    onProgress: function(id, fileName, loaded, total) {},
    onComplete: function(id, fileName, response) {},
    onCancel: function(id, fileName) {}
  };
  qq.extend(this._options, o);

  this._queue = [];
  // params for files in queue
  this._params = [];
};
qq.UploadHandlerAbstract.prototype = {
  log: function(str) {
    if (this._options.debug && window.console) console.log('[uploader] ' + str);
  },
  /**
   * Adds file or file input to the queue
   * @returns id
   **/
  add: function(file) {},
  /**
   * Sends the file identified by id and additional query params to the server
   */
  upload: function(id, params) {
    var len = this._queue.push(id);

    var copy = {};
    qq.extend(copy, params);
    this._params[id] = copy;

    // if too many active uploads, wait...
    if (len <= this._options.maxConnections) {
      this._upload(id, this._params[id]);
    }
  },
  /**
   * Cancels file upload by id
   */
  cancel: function(id) {
    this._cancel(id);
    this._dequeue(id);
  },
  /**
   * Cancells all uploads
   */
  cancelAll: function() {
    for (var i = 0; i < this._queue.length; i++) {
      this._cancel(this._queue[i]);
    }
    this._queue = [];
  },
  /**
   * Returns name of the file identified by id
   */
  getName: function(id) {},
  /**
   * Returns size of the file identified by id
   */
  getSize: function(id) {},
  /**
   * Returns id of files being uploaded or
   * waiting for their turn
   */
  getQueue: function() {
    return this._queue;
  },
  /**
   * Actual upload method
   */
  _upload: function(id) {},
  /**
   * Actual cancel method
   */
  _cancel: function(id) {},
  /**
   * Removes element from queue, starts upload of next
   */
  _dequeue: function(id) {
    var i = qq.indexOf(this._queue, id);
    this._queue.splice(i, 1);

    var max = this._options.maxConnections;

    if (this._queue.length >= max && i < max) {
      var nextId = this._queue[max - 1];
      this._upload(nextId, this._params[nextId]);
    }
  }
};

/**
 * Class for uploading files using form and iframe
 * @inherits qq.UploadHandlerAbstract
 */
qq.UploadHandlerForm = function(o) {
  qq.UploadHandlerAbstract.apply(this, arguments);

  this._inputs = {};
};
// @inherits qq.UploadHandlerAbstract
qq.extend(qq.UploadHandlerForm.prototype, qq.UploadHandlerAbstract.prototype);

qq.extend(qq.UploadHandlerForm.prototype, {
  add: function(fileInput) {
    fileInput.setAttribute('name', 'qqfile');
    var id = 'qq-upload-handler-iframe' + qq.getUniqueId();

    this._inputs[id] = fileInput;

    // remove file input from DOM
    if (fileInput.parentNode) {
      qq.remove(fileInput);
    }

    return id;
  },
  getName: function(id) {
    // get input value and remove path to normalize
    return this._inputs[id].value.replace(/.*(\/|\\)/, "");
  },
  _cancel: function(id) {
    this._options.onCancel(id, this.getName(id));

    delete this._inputs[id];

    var iframe = document.getElementById(id);
    if (iframe) {
      // to cancel request set src to something else
      // we use src="javascript:false;" because it doesn't
      // trigger ie6 prompt on https
      iframe.setAttribute('src', 'javascript:false;');

      qq.remove(iframe);
    }
  },
  _upload: function(id, params) {
    var input = this._inputs[id];

    if (!input) {
      throw new Error('file with passed id was not added, or already uploaded or cancelled');
    }

    var fileName = this.getName(id);

    var iframe = this._createIframe(id);
    var form = this._createForm(iframe, params);
    form.appendChild(input);

    var self = this;
    this._attachLoadEvent(iframe, function() {
      self.log('iframe loaded');

      var response = self._getIframeContentJSON(iframe);

      self._options.onComplete(id, fileName, response);
      self._dequeue(id);

      delete self._inputs[id];
      // timeout added to fix busy state in FF3.6
      setTimeout(function() {
        qq.remove(iframe);
      }, 1);
    });

    form.submit();
    qq.remove(form);

    return id;
  },
  _attachLoadEvent: function(iframe, callback) {
    qq.attach(iframe, 'load', function() {
      // when we remove iframe from dom
      // the request stops, but in IE load
      // event fires
      if (!iframe.parentNode) {
        return;
      }

      // fixing Opera 10.53
      if (iframe.contentDocument && iframe.contentDocument.body && iframe.contentDocument.body.innerHTML == "false") {
        // In Opera event is fired second time
        // when body.innerHTML changed from false
        // to server response approx. after 1 sec
        // when we upload file with iframe
        return;
      }

      callback();
    });
  },
  /**
   * Returns json object received by iframe from server.
   */
  _getIframeContentJSON: function(iframe) {
    // iframe.contentWindow.document - for IE<7
    var doc = iframe.contentDocument ? iframe.contentDocument : iframe.contentWindow.document,
        response;

    this.log("converting iframe's innerHTML to JSON");
    this.log("innerHTML = " + doc.body.innerHTML);

    try {
      response = eval("(" + doc.body.innerHTML + ")");
    } catch (err) {
      response = {};
    }

    return response;
  },
  /**
   * Creates iframe with unique name
   */
  _createIframe: function(id) {
    // We can't use following code as the name attribute
    // won't be properly registered in IE6, and new window
    // on form submit will open
    // var iframe = document.createElement('iframe');
    // iframe.setAttribute('name', id);
    var iframe = qq.toElement('<iframe src="javascript:false;" name="' + id + '" />');
    // src="javascript:false;" removes ie6 prompt on https
    iframe.setAttribute('id', id);

    iframe.style.display = 'none';
    document.body.appendChild(iframe);

    return iframe;
  },
  /**
   * Creates form, that will be submitted to iframe
   */
  _createForm: function(iframe, params) {
    // We can't use the following code in IE6
    // var form = document.createElement('form');
    // form.setAttribute('method', 'post');
    // form.setAttribute('enctype', 'multipart/form-data');
    // Because in this case file won't be attached to request
    var form = qq.toElement('<form method="post" enctype="multipart/form-data"></form>');

    var queryString = qq.obj2url(params, this._options.action);

    form.setAttribute('action', queryString);
    form.setAttribute('target', iframe.name);
    form.style.display = 'none';
    document.body.appendChild(form);

    return form;
  }
});

/**
 * Class for uploading files using xhr
 * @inherits qq.UploadHandlerAbstract
 */
qq.UploadHandlerXhr = function(o) {
  qq.UploadHandlerAbstract.apply(this, arguments);

  this._files = [];
  this._xhrs = [];

  // current loaded size in bytes for each file
  this._loaded = [];
};

// static method
qq.UploadHandlerXhr.isSupported = function() {
  var input = document.createElement('input');
  input.type = 'file';

  return ('multiple' in input && typeof File != "undefined" && typeof(new XMLHttpRequest()).upload != "undefined");
};

// @inherits qq.UploadHandlerAbstract
qq.extend(qq.UploadHandlerXhr.prototype, qq.UploadHandlerAbstract.prototype)

qq.extend(qq.UploadHandlerXhr.prototype, {
  /**
   * Adds file to the queue
   * Returns id to use with upload, cancel
   **/
  add: function(file) {
    if (!(file instanceof File)) {
      throw new Error('Passed obj in not a File (in qq.UploadHandlerXhr)');
    }

    return this._files.push(file) - 1;
  },
  getName: function(id) {
    var file = this._files[id];
    // fix missing name in Safari 4
    return file.fileName != null ? file.fileName : file.name;
  },
  getSize: function(id) {
    var file = this._files[id];
    return file.fileSize != null ? file.fileSize : file.size;
  },
  /**
   * Returns uploaded bytes for file identified by id
   */
  getLoaded: function(id) {
    return this._loaded[id] || 0;
  },
  /**
   * Sends the file identified by id and additional query params to the server
   * @param {Object} params name-value string pairs
   */
  _upload: function(id, params) {
    var file = this._files[id],
        name = this.getName(id),
        size = this.getSize(id);

    this._loaded[id] = 0;

    var xhr = this._xhrs[id] = new XMLHttpRequest();
    var self = this;

    xhr.upload.onprogress = function(e) {
      if (e.lengthComputable) {
        self._loaded[id] = e.loaded;
        self._options.onProgress(id, name, e.loaded, e.total);
      }
    };

    xhr.onreadystatechange = function() {
      if (xhr.readyState == 4) {
        self._onComplete(id, xhr);
      }
    };

    // build query string
    params = params || {};
    params['qqfile'] = name;
    var queryString = qq.obj2url(params, this._options.action);

    xhr.open("POST", queryString, true);
    xhr.setRequestHeader("X-Requested-With", "XMLHttpRequest");
    xhr.setRequestHeader("X-File-Name", encodeURIComponent(name));
    xhr.setRequestHeader("Content-Type", "application/octet-stream");
    xhr.send(file);
  },
  _onComplete: function(id, xhr) {
    // the request was aborted/cancelled
    if (!this._files[id]) return;

    var name = this.getName(id);
    var size = this.getSize(id);

    this._options.onProgress(id, name, size, size);

    if (xhr.status == 200) {
      this.log("xhr - server response received");
      this.log("responseText = " + xhr.responseText);

      var response;

      try {
        response = eval("(" + xhr.responseText + ")");
      } catch (err) {
        response = {};
      }

      this._options.onComplete(id, name, response);

    } else {
      this._options.onComplete(id, name, {});
    }

    this._files[id] = null;
    this._xhrs[id] = null;
    this._dequeue(id);
  },
  _cancel: function(id) {
    this._options.onCancel(id, this.getName(id));

    this._files[id] = null;

    if (this._xhrs[id]) {
      this._xhrs[id].abort();
      this._xhrs[id] = null;
    }
  }
});


/* ========================================================
 * bootstrap-tabs.js v1.4.0
 * http://twitter.github.com/bootstrap/javascript.html#tabs
 * ========================================================
 * Copyright 2011 Twitter, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * ======================================================== */


!
function($) {

  "use strict"

  function activate(element, container) {
    container.find('> .active').removeClass('active').find('> .dropdown-menu > .active').removeClass('active')

    element.addClass('active')

    if (element.parent('.dropdown-menu')) {
      element.closest('li.dropdown').addClass('active')
    }
  }

  function tab(e) {
    var $this = $(this),
        $ul = $this.closest('ul:not(.dropdown-menu)'),
        href = $this.attr('href'),
        previous, $href



        if (/^#\w+/.test(href)) {
        e.preventDefault()

        if ($this.parent('li').hasClass('active')) {
          return
        }

        previous = $ul.find('.active a').last()[0]
        $href = $(href)

        activate($this.parent('li'), $ul)
        activate($href, $href.parent())

        $this.trigger({
          type: 'change',
          relatedTarget: previous
        })
        }
  }


/* TABS/PILLS PLUGIN DEFINITION
  * ============================ */

  $.fn.tabs = $.fn.pills = function(selector) {
    return this.each(function() {
      $(this).delegate(selector || '.tabs li > a, .pills > li > a', 'click', tab)
    })
  }

  $(document).ready(function() {
    $('body').tabs('ul[data-tabs] li > a, ul[data-pills] > li > a')
  })

}(window.jQuery || window.ender);




/**
 * SoundManager 2 Demo: "Page as playlist" UI
 * ----------------------------------------------
 * http://schillmania.com/projects/soundmanager2/
 *
 * An example of a Muxtape.com-style UI, where an
 * unordered list of MP3 links becomes a playlist
 *
 * Flash 9 "MovieStar" edition supports MPEG4
 * audio as well.
 *
 * Requires SoundManager 2 Javascript API.
 */

/*jslint white: false, onevar: true, undef: true, nomen: false, eqeqeq: true, plusplus: false, bitwise: true, newcap: true, immed: true */
/*global soundManager, window, document, navigator, setTimeout, attachEvent, Metadata, PP_CONFIG */

var pagePlayer = null;

function PagePlayer() {

  var self = this,
      pl = this,
      sm = soundManager,
       // soundManager instance
      _event, vuDataCanvas = null,
      controlTemplate = null,
      _head = document.getElementsByTagName('head')[0],
      spectrumContainer = null,


      // sniffing for favicon stuff, IE workarounds and touchy-feely devices
      ua = navigator.userAgent,
      supportsFavicon = (ua.match(/(opera|firefox)/i)),
      isTouchDevice = (ua.match(/ipad|ipod|iphone/i)),
      cleanup;

  // configuration options
  // note that if Flash 9 is required, you must set soundManager.flashVersion = 9 in your script before this point.
  this.config = {
    usePeakData: false,
    // [Flash 9 only]: show peak data
    useWaveformData: false,
    // [Flash 9 only]: enable sound spectrum (raw waveform data) - WARNING: CPU-INTENSIVE: may set CPUs on fire.
    useEQData: false,
    // [Flash 9 only]: enable sound EQ (frequency spectrum data) - WARNING: Also CPU-intensive.
    fillGraph: false,
    // [Flash 9 only]: draw full lines instead of only top (peak) spectrum points
    useMovieStar: true,
    // [Flash 9 only]: Support for MPEG4 audio formats
    allowRightClick: true,
    // let users right-click MP3 links ("save as...", etc.) or discourage (can't prevent.)
    useThrottling: true,
    // try to rate-limit potentially-expensive calls (eg. dragging position around)
    autoStart: false,
    // begin playing first sound when page loads
    playNext: false,
    // stop after one sound, or play through list until end
    updatePageTitle: false,
    // change the page title while playing sounds
    emptyTime: '-:--',
    // null/undefined timer values (before data is available)
    useFavIcon: false // try to show peakData in address bar (Firefox + Opera) - may be too CPU heavy
  };

  this.css = { // CSS class names appended to link during various states
    sDefault: 'sm2_link',
    // default state
    sLoading: 'sm2_loading',
    sPlaying: 'sm2_playing',
    sPaused: 'sm2_paused'
  };

  this.sounds = [];
  this.soundsByObject = [];
  this.lastSound = null;
  this.soundCount = 0;
  this.strings = [];
  this.dragActive = false;
  this.dragExec = new Date();
  this.dragTimer = null;
  this.pageTitle = document.title;
  this.lastWPExec = new Date();
  this.lastWLExec = new Date();
  this.vuMeterData = [];
  this.oControls = null;

  this._mergeObjects = function(oMain, oAdd) {
    // non-destructive merge
    var o1 = {},
        o2, i, o; // clone o1
    for (i in oMain) {
      if (oMain.hasOwnProperty(i)) {
        o1[i] = oMain[i];
      }
    }
    o2 = (typeof oAdd === 'undefined' ? {} : oAdd);
    for (o in o2) {
      if (typeof o1[o] === 'undefined') {
        o1[o] = o2[o];
      }
    }
    return o1;
  };

  _event = (function() {

    var old = (window.attachEvent && !window.addEventListener),
        _slice = Array.prototype.slice,
        evt = {
        add: (old ? 'attachEvent' : 'addEventListener'),
        remove: (old ? 'detachEvent' : 'removeEventListener')
        };

    function getArgs(oArgs) {
      var args = _slice.call(oArgs),
          len = args.length;
      if (old) {
        args[1] = 'on' + args[1]; // prefix
        if (len > 3) {
          args.pop(); // no capture
        }
      } else if (len === 3) {
        args.push(false);
      }
      return args;
    }

    function apply(args, sType) {
      var element = args.shift(),
          method = [evt[sType]];
      if (old) {
        element[method](args[0], args[1]);
      } else {
        element[method].apply(element, args);
      }
    }

    function add() {
      apply(getArgs(arguments), 'add');
    }

    function remove() {
      apply(getArgs(arguments), 'remove');
    }

    return {
      'add': add,
      'remove': remove
    };

  }());

  // event + DOM utilities
  this.hasClass = function(o, cStr) {
    return (typeof(o.className) !== 'undefined' ? new RegExp('(^|\\s)' + cStr + '(\\s|$)').test(o.className) : false);
  };

  this.addClass = function(o, cStr) {
    if (!o || !cStr || self.hasClass(o, cStr)) {
      return false; // safety net
    }
    o.className = (o.className ? o.className + ' ' : '') + cStr;
  };

  this.removeClass = function(o, cStr) {
    if (!o || !cStr || !self.hasClass(o, cStr)) {
      return false;
    }
    o.className = o.className.replace(new RegExp('( ' + cStr + ')|(' + cStr + ')', 'g'), '');
  };

  this.select = function(className, oParent) {
    var result = self.getByClassName(className, 'div', oParent || null);
    return (result ? result[0] : null);
  };

  this.getByClassName = (document.querySelectorAll ?
  function(className, tagNames, oParent) { // tagNames: string or ['div', 'p'] etc.
    var pattern = ('.' + className),
        qs;
    if (tagNames) {
      tagNames = tagNames.split(' ');
    }
    qs = (tagNames.length > 1 ? tagNames.join(pattern + ', ') : tagNames[0] + pattern);
    return (oParent ? oParent : document).querySelectorAll(qs);

  } : function(className, tagNames, oParent) {

    var node = (oParent ? oParent : document),
        matches = [],
        i, j, nodes = [];
    if (tagNames) {
      tagNames = tagNames.split(' ');
    }
    if (tagNames instanceof Array) {
      for (i = tagNames.length; i--;) {
        if (!nodes || !nodes[tagNames[i]]) {
          nodes[tagNames[i]] = node.getElementsByTagName(tagNames[i]);
        }
      }
      for (i = tagNames.length; i--;) {
        for (j = nodes[tagNames[i]].length; j--;) {
          if (self.hasClass(nodes[tagNames[i]][j], className)) {
            matches.push(nodes[tagNames[i]][j]);
          }
        }
      }
    } else {
      nodes = node.all || node.getElementsByTagName('*');
      for (i = 0, j = nodes.length; i < j; i++) {
        if (self.hasClass(nodes[i], className)) {
          matches.push(nodes[i]);
        }
      }
    }
    return matches;

  });

  this.isChildOfClass = function(oChild, oClass) {
    if (!oChild || !oClass) {
      return false;
    }
    while (oChild.parentNode && !self.hasClass(oChild, oClass)) {
      oChild = oChild.parentNode;
    }
    return (self.hasClass(oChild, oClass));
  };

  this.getParentByNodeName = function(oChild, sParentNodeName) {
    if (!oChild || !sParentNodeName) {
      return false;
    }
    sParentNodeName = sParentNodeName.toLowerCase();
    while (oChild.parentNode && sParentNodeName !== oChild.parentNode.nodeName.toLowerCase()) {
      oChild = oChild.parentNode;
    }
    return (oChild.parentNode && sParentNodeName === oChild.parentNode.nodeName.toLowerCase() ? oChild.parentNode : null);
  };

  this.getOffX = function(o) {
    // http://www.xs4all.nl/~ppk/js/findpos.html
    var curleft = 0;
    if (o.offsetParent) {
      while (o.offsetParent) {
        curleft += o.offsetLeft;
        o = o.offsetParent;
      }
    } else if (o.x) {
      curleft += o.x;
    }
    return curleft;
  };

  this.getTime = function(nMSec, bAsString) {
    // convert milliseconds to mm:ss, return as object literal or string
    var nSec = Math.floor(nMSec / 1000),
        min = Math.floor(nSec / 60),
        sec = nSec - (min * 60);
    // if (min === 0 && sec === 0) return null; // return 0:00 as null
    return (bAsString ? (min + ':' + (sec < 10 ? '0' + sec : sec)) : {
      'min': min,
      'sec': sec
    });
  };

  this.getSoundByObject = function(o) {
    return (typeof self.soundsByObject[o.id] !== 'undefined' ? self.soundsByObject[o.id] : null);
  };

  this.getPreviousItem = function(o) {
    // given <li> playlist item, find previous <li> and then <a>
    if (o.previousElementSibling) {
      o = o.previousElementSibling;
    } else {
      o = o.previousSibling; // move from original node..
      while (o && o.previousSibling && o.previousSibling.nodeType !== 1) {
        o = o.previousSibling;
      }
    }
    if (o.nodeName.toLowerCase() !== 'li') {
      return null;
    } else {
      return o.getElementsByTagName('a')[0];
    }
  };

  this.playPrevious = function(oSound) {
    if (!oSound) {
      oSound = self.lastSound;
    }
    if (!oSound) {
      return false;
    }
    var previousItem = self.getPreviousItem(oSound._data.oLI);
    if (previousItem) {
      pl.handleClick({
        target: previousItem
      }); // fake a click event - aren't we sneaky. ;)
    }
    return previousItem;
  };

  this.getNextItem = function(o) {
    // given <li> playlist item, find next <li> and then <a>
    if (o.nextElementSibling) {
      o = o.nextElementSibling;
    } else {
      o = o.nextSibling; // move from original node..
      while (o && o.nextSibling && o.nextSibling.nodeType !== 1) {
        o = o.nextSibling;
      }
    }
    if (o.nodeName.toLowerCase() !== 'li') {
      return null;
    } else {
      return o.getElementsByTagName('a')[0];
    }
  };

  this.playNext = function(oSound) {
    if (!oSound) {
      oSound = self.lastSound;
    }
    if (!oSound) {
      return false;
    }
    var nextItem = self.getNextItem(oSound._data.oLI);
    if (nextItem) {
      pl.handleClick({
        target: nextItem
      }); // fake a click event - aren't we sneaky. ;)
    }
    return nextItem;
  };

  this.setPageTitle = function(sTitle) {
    if (!self.config.updatePageTitle) {
      return false;
    }
    try {
      document.title = (sTitle ? sTitle + ' - ' : '') + self.pageTitle;
    } catch (e) {
      // oh well
      self.setPageTitle = function() {
        return false;
      };
    }
  };

  this.events = {

    // handlers for sound events as they're started/stopped/played
    play: function() {
      pl.removeClass(this._data.oLI, this._data.className);
      this._data.className = pl.css.sPlaying;
      pl.addClass(this._data.oLI, this._data.className);
      self.setPageTitle(this._data.originalTitle);
    },

    stop: function() {
      pl.removeClass(this._data.oLI, this._data.className);
      this._data.className = '';
      this._data.oPosition.style.width = '0px';
      self.setPageTitle();
      self.resetPageIcon();
    },

    pause: function() {
      if (pl.dragActive) {
        return false;
      }
      pl.removeClass(this._data.oLI, this._data.className);
      this._data.className = pl.css.sPaused;
      pl.addClass(this._data.oLI, this._data.className);
      self.setPageTitle();
      self.resetPageIcon();
    },

    resume: function() {
      if (pl.dragActive) {
        return false;
      }
      pl.removeClass(this._data.oLI, this._data.className);
      this._data.className = pl.css.sPlaying;
      pl.addClass(this._data.oLI, this._data.className);
    },

    finish: function() {
      pl.removeClass(this._data.oLI, this._data.className);
      this._data.className = '';
      this._data.oPosition.style.width = '0px';
      // play next if applicable
      if (self.config.playNext) {
        pl.playNext(this);
      } else {
        self.setPageTitle();
        self.resetPageIcon();
      }
    },

    whileloading: function() {
      function doWork() {
        this._data.oLoading.style.width = (((this.bytesLoaded / this.bytesTotal) * 100) + '%'); // theoretically, this should work.
        if (!this._data.didRefresh && this._data.metadata) {
          this._data.didRefresh = true;
          this._data.metadata.refresh();
        }
      }
      if (!pl.config.useThrottling) {
        doWork.apply(this);
      } else {
        var d = new Date();
        if (d && d - self.lastWLExec > 30 || this.bytesLoaded === this.bytesTotal) {
          doWork.apply(this);
          self.lastWLExec = d;
        }
      }

    },

    onload: function() {
      if (!this.loaded) {
        var oTemp = this._data.oLI.getElementsByTagName('a')[0],
            oString = oTemp.innerHTML,
            oThis = this;
        oTemp.innerHTML = oString + ' <span style="font-size:0.5em"> | Load failed, d\'oh! ' + (sm.sandbox.noRemote ? ' Possible cause: Flash sandbox is denying remote URL access.' : (sm.sandbox.noLocal ? 'Flash denying local filesystem access' : '404?')) + '</span>';
        setTimeout(function() {
          oTemp.innerHTML = oString;
          // pl.events.finish.apply(oThis); // load next
        }, 5000);
      } else {
        if (this._data.metadata) {
          this._data.metadata.refresh();
        }
      }
    },

    whileplaying: function() {
      var d = null;
      if (pl.dragActive || !pl.config.useThrottling) {
        self.updateTime.apply(this);
        if (sm.flashVersion >= 9) {
          if (pl.config.usePeakData && this.instanceOptions.usePeakData) {
            self.updatePeaks.apply(this);
          }
          if (pl.config.useWaveformData && this.instanceOptions.useWaveformData || pl.config.useEQData && this.instanceOptions.useEQData) {
            self.updateGraph.apply(this);
          }
        }
        if (this._data.metadata) {
          d = new Date();
          if (d && d - self.lastWPExec > 500) {
            this._data.metadata.refreshMetadata(this);
            self.lastWPExec = d;
          }
        }
        this._data.oPosition.style.width = (((this.position / self.getDurationEstimate(this)) * 100) + '%');
      } else {
        d = new Date();
        if (d - self.lastWPExec > 30) {
          self.updateTime.apply(this);
          if (sm.flashVersion >= 9) {
            if (pl.config.usePeakData && this.instanceOptions.usePeakData) {
              self.updatePeaks.apply(this);
            }
            if (pl.config.useWaveformData && this.instanceOptions.useWaveformData || pl.config.useEQData && this.instanceOptions.useEQData) {
              self.updateGraph.apply(this);
            }
          }
          if (this._data.metadata) {
            this._data.metadata.refreshMetadata(this);
          }
          this._data.oPosition.style.width = (((this.position / self.getDurationEstimate(this)) * 100) + '%');
          self.lastWPExec = d;
        }
      }
    }

  }; // events{}
  this.setPageIcon = function(sDataURL) {
    if (!self.config.useFavIcon || !self.config.usePeakData || !sDataURL) {
      return false;
    }
    var link = document.getElementById('sm2-favicon');
    if (link) {
      _head.removeChild(link);
      link = null;
    }
    if (!link) {
      link = document.createElement('link');
      link.id = 'sm2-favicon';
      link.rel = 'shortcut icon';
      link.type = 'image/png';
      link.href = sDataURL;
      document.getElementsByTagName('head')[0].appendChild(link);
    }
  };

  this.resetPageIcon = function() {
    if (!self.config.useFavIcon) {
      return false;
    }
    var link = document.getElementById('favicon');
    if (link) {
      link.href = '/favicon.ico';
    }
  };

  this.updatePeaks = function() {
    var o = this._data.oPeak,
        oSpan = o.getElementsByTagName('span');
    oSpan[0].style.marginTop = (13 - (Math.floor(15 * this.peakData.left)) + 'px');
    oSpan[1].style.marginTop = (13 - (Math.floor(15 * this.peakData.right)) + 'px');
    if (sm.flashVersion > 8 && self.config.useFavIcon && self.config.usePeakData) {
      self.setPageIcon(self.vuMeterData[parseInt(16 * this.peakData.left, 10)][parseInt(16 * this.peakData.right, 10)]);
    }
  };

  this.updateGraph = function() {
    if (pl.config.flashVersion < 9 || (!pl.config.useWaveformData && !pl.config.useEQData)) {
      return false;
    }
    var sbC = this._data.oGraph.getElementsByTagName('div'),
        scale, i, offset;
    if (pl.config.useWaveformData) {
      // raw waveform
      scale = 8; // Y axis (+/- this distance from 0)
      for (i = 255; i--;) {
        sbC[255 - i].style.marginTop = (1 + scale + Math.ceil(this.waveformData.left[i] * -scale)) + 'px';
      }
    } else {
      // eq spectrum
      offset = 9;
      for (i = 255; i--;) {
        sbC[255 - i].style.marginTop = ((offset * 2) - 1 + Math.ceil(this.eqData[i] * -offset)) + 'px';
      }
    }
  };

  this.resetGraph = function() {
    if (!pl.config.useEQData || pl.config.flashVersion < 9) {
      return false;
    }
    var sbC = this._data.oGraph.getElementsByTagName('div'),
        scale = (!pl.config.useEQData ? '9px' : '17px'),
        nHeight = (!pl.config.fillGraph ? '1px' : '32px'),
        i;
    for (i = 255; i--;) {
      sbC[255 - i].style.marginTop = scale; // EQ scale
      sbC[255 - i].style.height = nHeight;
    }
  };

  this.updateTime = function() {
    var str = self.strings.timing.replace('%s1', self.getTime(this.position, true));
    str = str.replace('%s2', self.getTime(self.getDurationEstimate(this), true));
    this._data.oTiming.innerHTML = str;
  };

  this.getTheDamnTarget = function(e) {
    return (e.target || (window.event ? window.event.srcElement : null));
  };

  this.withinStatusBar = function(o) {
    return (self.isChildOfClass(o, 'controls'));
  };

  this.handleClick = function(e) {

    // a sound (or something) was clicked - determine what and handle appropriately
    if (e.button === 2) {
      if (!pl.config.allowRightClick) {
        pl.stopEvent(e);
      }
      return pl.config.allowRightClick; // ignore right-clicks
    }
    var o = self.getTheDamnTarget(e),
        sURL, soundURL, thisSound, oControls, oLI, str;
    if (!o) {
      return true;
    }
    if (self.dragActive) {
      self.stopDrag(); // to be safe
    }
    if (self.withinStatusBar(o)) {
      // self.handleStatusClick(e);
      return false;
    }
    if (o.nodeName.toLowerCase() !== 'a') {
      o = self.getParentByNodeName(o, 'a');
    }
    if (!o) {
      // not a link
      return true;
    }

    // OK, we're dealing with a link
    sURL = o.getAttribute('href');

    if (!o.href || (!sm.canPlayLink(o) && !self.hasClass(o, 'playable')) || self.hasClass(o, 'exclude')) {

      // do nothing, don't return anything.
      return true;

    } else {

      // we have something we're interested in.
      // find and init parent UL, if need be
      self.initUL(self.getParentByNodeName(o, 'ul'));

      // and decorate the link too, if needed
      self.initItem(o);

      soundURL = o.href;
      thisSound = self.getSoundByObject(o);

      if (thisSound) {

        // sound already exists
        self.setPageTitle(thisSound._data.originalTitle);
        if (thisSound === self.lastSound) {
          // ..and was playing (or paused) and isn't in an error state
          if (thisSound.readyState !== 2) {
            if (thisSound.playState !== 1) {
              // not yet playing
              thisSound.play();
            } else {
              thisSound.togglePause();
            }
          } else {
            sm._writeDebug('Warning: sound failed to load (security restrictions, 404 or bad format)', 2);
          }
        } else {
          // ..different sound
          if (self.lastSound) {
            self.stopSound(self.lastSound);
          }
          if (spectrumContainer) {
            thisSound._data.oTimingBox.appendChild(spectrumContainer);
          }
          thisSound.togglePause(); // start playing current
        }

      } else {

        // create sound
        thisSound = sm.createSound({
          id: o.id,
          url: decodeURI(soundURL),
          onplay: self.events.play,
          onstop: self.events.stop,
          onpause: self.events.pause,
          onresume: self.events.resume,
          onfinish: self.events.finish,
          whileloading: self.events.whileloading,
          whileplaying: self.events.whileplaying,
          onmetadata: self.events.metadata,
          onload: self.events.onload
        });

        // append control template
        oControls = self.oControls.cloneNode(true);
        oLI = o.parentNode;
        oLI.appendChild(oControls);
        if (spectrumContainer) {
          oLI.appendChild(spectrumContainer);
        }
        self.soundsByObject[o.id] = thisSound;

        // tack on some custom data
        thisSound._data = {
          oLink: o,
          // DOM reference within SM2 object event handlers
          oLI: oLI,
          oControls: self.select('controls', oLI),
          oStatus: self.select('statusbar', oLI),
          oLoading: self.select('loading', oLI),
          oPosition: self.select('position', oLI),
          oTimingBox: self.select('timing', oLI),
          oTiming: self.select('timing', oLI).getElementsByTagName('div')[0],
          oPeak: self.select('peak', oLI),
          oGraph: self.select('spectrum-box', oLI),
          className: self.css.sPlaying,
          originalTitle: o.innerHTML,
          metadata: null
        };

        if (spectrumContainer) {
          thisSound._data.oTimingBox.appendChild(spectrumContainer);
        }

        // "Metadata"
        if (thisSound._data.oLI.getElementsByTagName('ul').length) {
          thisSound._data.metadata = new Metadata(thisSound);
        }

        // set initial timer stuff (before loading)
        str = self.strings.timing.replace('%s1', self.config.emptyTime);
        str = str.replace('%s2', self.config.emptyTime);
        thisSound._data.oTiming.innerHTML = str;
        self.sounds.push(thisSound);
        if (self.lastSound) {
          self.stopSound(self.lastSound);
        }
        self.resetGraph.apply(thisSound);
        thisSound.play();

      }

      self.lastSound = thisSound; // reference for next call
      return self.stopEvent(e);

    }

  };

  this.handleMouseDown = function(e) {
    // a sound link was clicked
    if (isTouchDevice && e.touches) {
      e = e.touches[0];
    }
    if (e.button === 2) {
      if (!pl.config.allowRightClick) {
        pl.stopEvent(e);
      }
      return pl.config.allowRightClick; // ignore right-clicks
    }
    var o = self.getTheDamnTarget(e);
    if (!o) {
      return true;
    }
    if (!self.withinStatusBar(o)) {
      return true;
    }
    self.dragActive = true;
    self.lastSound.pause();
    self.setPosition(e);
    if (!isTouchDevice) {
      _event.add(document, 'mousemove', self.handleMouseMove);
    } else {
      _event.add(document, 'touchmove', self.handleMouseMove);
    }
    self.addClass(self.lastSound._data.oControls, 'dragging');
    return self.stopEvent(e);
  };

  this.handleMouseMove = function(e) {
    if (isTouchDevice && e.touches) {
      e = e.touches[0];
    }
    // set position accordingly
    if (self.dragActive) {
      if (self.config.useThrottling) {
        // be nice to CPU/externalInterface
        var d = new Date();
        if (d - self.dragExec > 20) {
          self.setPosition(e);
        } else {
          window.clearTimeout(self.dragTimer);
          self.dragTimer = window.setTimeout(function() {
            self.setPosition(e);
          }, 20);
        }
        self.dragExec = d;
      } else {
        // oh the hell with it
        self.setPosition(e);
      }
    } else {
      self.stopDrag();
    }
    e.stopPropagation = true;
    return false;
  };

  this.stopDrag = function(e) {
    if (self.dragActive) {
      self.removeClass(self.lastSound._data.oControls, 'dragging');
      if (!isTouchDevice) {
        _event.remove(document, 'mousemove', self.handleMouseMove);
      } else {
        _event.remove(document, 'touchmove', self.handleMouseMove);
      }
      if (!pl.hasClass(self.lastSound._data.oLI, self.css.sPaused)) {
        self.lastSound.resume();
      }
      self.dragActive = false;
      return self.stopEvent(e);
    }
  };

  this.handleStatusClick = function(e) {
    self.setPosition(e);
    if (!pl.hasClass(self.lastSound._data.oLI, self.css.sPaused)) {
      self.resume();
    }
    return self.stopEvent(e);
  };

  this.stopEvent = function(e) {
    if (typeof e !== 'undefined') {
      if (typeof e.preventDefault !== 'undefined') {
        e.preventDefault();
      } else {
        e.stopPropagation = true;
        e.returnValue = false;
      }
    }
    return false;
  };

  this.setPosition = function(e) {
    // called from slider control
    var oThis = self.getTheDamnTarget(e),
        x, oControl, oSound, nMsecOffset;
    if (!oThis) {
      return true;
    }
    oControl = oThis;
    while (!self.hasClass(oControl, 'controls') && oControl.parentNode) {
      oControl = oControl.parentNode;
    }
    oSound = self.lastSound;
    x = parseInt(e.clientX, 10);
    // play sound at this position
    nMsecOffset = Math.floor((x - self.getOffX(oControl) - 4) / (oControl.offsetWidth) * self.getDurationEstimate(oSound));
    if (!isNaN(nMsecOffset)) {
      nMsecOffset = Math.min(nMsecOffset, oSound.duration);
    }
    if (!isNaN(nMsecOffset)) {
      oSound.setPosition(nMsecOffset);
    }
  };

  this.stopSound = function(oSound) {
    sm._writeDebug('stopping sound: ' + oSound.sID);
    sm.stop(oSound.sID);
    if (!isTouchDevice) { // iOS 4.2+ security blocks onfinish() -> playNext() if we set a .src in-between(?)
      sm.unload(oSound.sID);
    }
  };

  this.getDurationEstimate = function(oSound) {
    if (oSound.instanceOptions.isMovieStar) {
      return (oSound.duration);
    } else {
      return (!oSound._data.metadata || !oSound._data.metadata.data.givenDuration ? (oSound.durationEstimate || 0) : oSound._data.metadata.data.givenDuration);
    }
  };

  this.createVUData = function() {

    var i = 0,
        j = 0,
        canvas = vuDataCanvas.getContext('2d'),
        vuGrad = canvas.createLinearGradient(0, 16, 0, 0),
        bgGrad, outline;

    vuGrad.addColorStop(0, 'rgb(0,192,0)');
    vuGrad.addColorStop(0.30, 'rgb(0,255,0)');
    vuGrad.addColorStop(0.625, 'rgb(255,255,0)');
    vuGrad.addColorStop(0.85, 'rgb(255,0,0)');
    bgGrad = canvas.createLinearGradient(0, 16, 0, 0);
    outline = 'rgba(0,0,0,0.2)';
    bgGrad.addColorStop(0, outline);
    bgGrad.addColorStop(1, 'rgba(0,0,0,0.5)');
    for (i = 0; i < 16; i++) {
      self.vuMeterData[i] = [];
    }
    for (i = 0; i < 16; i++) {
      for (j = 0; j < 16; j++) {
        // reset/erase canvas
        vuDataCanvas.setAttribute('width', 16);
        vuDataCanvas.setAttribute('height', 16);
        // draw new stuffs
        canvas.fillStyle = bgGrad;
        canvas.fillRect(0, 0, 7, 15);
        canvas.fillRect(8, 0, 7, 15);
/*
        // shadow
        canvas.fillStyle = 'rgba(0,0,0,0.1)';
        canvas.fillRect(1,15-i,7,17-(17-i));
        canvas.fillRect(9,15-j,7,17-(17-j));
        */
        canvas.fillStyle = vuGrad;
        canvas.fillRect(0, 15 - i, 7, 16 - (16 - i));
        canvas.fillRect(8, 15 - j, 7, 16 - (16 - j));
        // and now, clear out some bits.
        canvas.clearRect(0, 3, 16, 1);
        canvas.clearRect(0, 7, 16, 1);
        canvas.clearRect(0, 11, 16, 1);
        self.vuMeterData[i][j] = vuDataCanvas.toDataURL('image/png');
        // for debugging VU images
/*
        var o = document.createElement('img');
        o.style.marginRight = '5px';
        o.src = self.vuMeterData[i][j];
        document.documentElement.appendChild(o);
        */
      }
    }

  };

  this.testCanvas = function() {
    // canvas + toDataURL();
    var c = document.createElement('canvas'),
        ctx = null,
        ok;
    if (!c || typeof c.getContext === 'undefined') {
      return null;
    }
    ctx = c.getContext('2d');
    if (!ctx || typeof c.toDataURL !== 'function') {
      return null;
    }
    // just in case..
    try {
      ok = c.toDataURL('image/png');
    } catch (e) {
      // no canvas or no toDataURL()
      return null;
    }
    // assume we're all good.
    return c;
  };

  this.initItem = function(oNode) {
    if (!oNode.id) {
      oNode.id = 'pagePlayerMP3Sound' + (self.soundCount++);
    }
    self.addClass(oNode, self.css.sDefault); // add default CSS decoration
  };

  this.initUL = function(oULNode) {
    // set up graph box stuffs
    if (sm.flashVersion >= 9) {
      self.addClass(oULNode, self.cssBase);
    }
  };

  this.init = function(oConfig) {

    if (oConfig) {
      // allow overriding via arguments object
      sm._writeDebug('pagePlayer.init(): Using custom configuration');
      this.config = this._mergeObjects(oConfig, this.config);
    } else {
      sm._writeDebug('pagePlayer.init(): Using default configuration');
    }

    var i, spectrumBox, sbC, oF, oClone, oTiming;

    // apply externally-defined override, if applicable
    this.cssBase = []; // optional features added to ul.playlist
    // apply some items to SM2
    sm.useFlashBlock = true;

    if (sm.flashVersion >= 9) {

      sm.useMovieStar = this.config.useMovieStar; // enable playing FLV, MP4 etc.
      sm.defaultOptions.usePeakData = this.config.usePeakData;
      sm.defaultOptions.useWaveformData = this.config.useWaveformData;
      sm.defaultOptions.useEQData = this.config.useEQData;

      if (this.config.usePeakData) {
        this.cssBase.push('use-peak');
      }

      if (this.config.useWaveformData || this.config.useEQData) {
        this.cssBase.push('use-spectrum');
      }

      this.cssBase = this.cssBase.join(' ');

      if (this.config.useFavIcon) {
        vuDataCanvas = self.testCanvas();
        if (vuDataCanvas && supportsFavicon) {
          // these browsers support dynamically-updating the favicon
          self.createVUData();
        } else {
          // browser doesn't support doing this
          this.config.useFavIcon = false;
        }
      }

    } else if (this.config.usePeakData || this.config.useWaveformData || this.config.useEQData) {

      sm._writeDebug('Page player: Note: soundManager.flashVersion = 9 is required for peak/waveform/EQ features.');

    }

    controlTemplate = document.createElement('div');
    controlTemplate.className = "prueba clearfix";

    controlTemplate.innerHTML = [

    // control markup inserted dynamically after each page player link
    // if you want to change the UI layout, this is the place to do it.
    '  <div class="controls">', '   <div class="statusbar">', '    <div class="loading"></div>', '    <div class="position"></div>', '   </div>', '  </div>',

    '  <div class="timing">', '   <div id="sm2_timing" class="timing-data">', '    <span class="sm2_position">%s1</span> / <span class="sm2_total">%s2</span>', '   </div>', '  </div>',

    '  <div class="peak">', '   <div class="peak-box"><span class="l"></span><span class="r"></span></div>', '  </div>',

    ' <div class="spectrum-container">', '  <div class="spectrum-box">', '   <div class="spectrum"></div>', '  </div>', ' </div>'

    ].join('\n');

    if (sm.flashVersion >= 9) {

      // create the spectrum box ish
      spectrumContainer = self.select('spectrum-container', controlTemplate);

      // take out of template, too
      spectrumContainer = controlTemplate.removeChild(spectrumContainer);

      spectrumBox = self.select('spectrum-box', spectrumContainer);

      sbC = spectrumBox.getElementsByTagName('div')[0];
      oF = document.createDocumentFragment();
      oClone = null;
      for (i = 256; i--;) {
        oClone = sbC.cloneNode(false);
        oClone.style.left = (i) + 'px';
        oF.appendChild(oClone);
      }
      spectrumBox.removeChild(sbC);
      spectrumBox.appendChild(oF);

    } else {

      // flash 8-only, take out the spectrum container and peak elements
      controlTemplate.removeChild(self.select('spectrum-container', controlTemplate));
      controlTemplate.removeChild(self.select('peak', controlTemplate));

    }

    self.oControls = controlTemplate.cloneNode(true);

    oTiming = self.select('timing-data', controlTemplate);
    self.strings.timing = oTiming.innerHTML;
    oTiming.innerHTML = '';
    oTiming.id = '';

    function doEvents(action) { // action: add / remove
      _event[action](document, 'click', self.handleClick);

      if (!isTouchDevice) {
        _event[action](document, 'mousedown', self.handleMouseDown);
        _event[action](document, 'mouseup', self.stopDrag);
      } else {
        _event[action](document, 'touchstart', self.handleMouseDown);
        _event[action](document, 'touchend', self.stopDrag);
      }

      _event[action](window, 'unload', cleanup);

    }

    cleanup = function() {
      doEvents('remove');
    };

    doEvents('add');

    sm._writeDebug('pagePlayer.init(): Ready', 1);

    if (self.config.autoStart) {
      // grab the first ul.playlist link
      pl.handleClick({
        target: pl.getByClassName('playlist', 'ul')[0].getElementsByTagName('a')[0]
      });
    }

  };

}

soundManager.useFlashBlock = true;

soundManager.onready(function() {
  pagePlayer = new PagePlayer();
  pagePlayer.init(typeof PP_CONFIG !== 'undefined' ? PP_CONFIG : null);
});





/*
 * jQuery UI addresspicker @VERSION
 *
 * Copyright 2010, AUTHORS.txt (http://jqueryui.com/about)
 * Dual licensed under the MIT or GPL Version 2 licenses.
 * http://jquery.org/license
 *
 * http://docs.jquery.com/UI/Progressbar
 *
 * Depends:
 *   jquery.ui.core.js
 *   jquery.ui.widget.js
 *   jquery.ui.autocomplete.js
 */
(function( $, undefined ) {

$.widget( "ui.addresspicker", {
	options: {
		defaultAddress: '',
	  appendAddressString: "",
		mapOptions: {
		  zoom: 5,
		  center: new google.maps.LatLng(46, 2),
		  scrollwheel: false,
		  mapTypeId: google.maps.MapTypeId.ROADMAP
		},
		elements: {
		  map: false,
		  lat: false,
		  lng: false,
		  locality: false,
		  country: false
		},
		geocoder: {},
	  draggableMarker: true
	},

	marker: function() {
		return this.gmarker;
	},

	map: function() {
	  return this.gmap;
	},

  updatePosition: function() {
    this._updatePosition(this.gmarker.getPosition());
  },

  reloadPosition: function() {
    this.gmarker.setVisible(true);
    this.gmarker.setPosition(new google.maps.LatLng(this.lat.val(), this.lng.val()));
    this.gmap.setCenter(this.gmarker.getPosition());
  },

  selected: function() {
    return this.selectedResult;
  },

	_create: function() {
	  this.geocoder = new google.maps.Geocoder();
	  this.element.autocomplete({
			source: $.proxy(this._geocode, this),
			focus:  $.proxy(this._focusAddress, this),
			select: $.proxy(this._selectAddress, this)
		});

		this.lat      = $(this.options.elements.lat);
		this.lng      = $(this.options.elements.lng);
		this.locality = $(this.options.elements.locality);
		this.country  = $(this.options.elements.country);
		if (this.options.elements.map) {
		  this.mapElement = $(this.options.elements.map);
  		this._initMap();
		}
	},

  _initMap: function() {
    if (this.lat && this.lat.val()) {
      this.options.mapOptions.center = new google.maps.LatLng(this.lat.val(), this.lng.val());
    }
    // Map
    this.gmap = new google.maps.Map(this.mapElement[0], this.options.mapOptions);
    // Marker
    var image = new google.maps.MarkerImage('/images/maps_sprite.png', new google.maps.Size(24, 34), new google.maps.Point(0,67), new google.maps.Point(12, 30));
    this.gmarker = new google.maps.Marker({ position: this.options.mapOptions.center, map: this.gmap, icon: image, draggable: this.options.draggableMarker });
    google.maps.event.addListener(this.gmarker, 'dragend', $.proxy(this._markerMoved, this));

    // If we have a location defined, show the marker.
    if (this.options.defaultAddress=='') {
    	this.element.val('');
    	this.gmarker.setVisible(false);
    }	else {
    	this.element.val(this.options.defaultAddress);
    	this.gmarker.setVisible(true);
    }

		// geocoder (geocoder and reverse)
    this.geocoder = new google.maps.Geocoder();

    //Zooms
    // zoomIn
    var zoomInControlDiv = document.createElement('DIV');
    var zoomInControl = new ZoomInControl(zoomInControlDiv, this.gmap);
    zoomInControlDiv.index = 1;
    this.gmap.controls[google.maps.ControlPosition.TOP_LEFT].push(zoomInControlDiv);

    // zoomOut
    var zoomOutControlDiv = document.createElement('DIV');
    var zoomOutControl = new ZoomOutControl(zoomOutControlDiv, this.gmap);
    zoomOutControlDiv.index = 2;
    this.gmap.controls[google.maps.ControlPosition.LEFT].push(zoomOutControlDiv);
  },

  _updatePosition: function(location) {
    if (this.lat) {
      this.lat.val(location.lat());
    }
    if (this.lng) {
      this.lng.val(location.lng());
    }
  },

  _markerMoved: function() {
  	this.element.autocomplete("close");
  	this._reverseGeocode(this.gmarker.getPosition());
    this._updatePosition(this.gmarker.getPosition());
  },

  // Autocomplete source method: fill its suggests with google geocoder results
  _geocode: function(request, response) {
    var address = request.term, self = this,
        options = this.options.geocoder;
    options.address = address + this.options.appendAddressString;
    this.geocoder.geocode(options, function(results, status) {
      if (status == google.maps.GeocoderStatus.OK) {
      	var array = [];
        for (var i = 0; i < Math.min(results.length,3); i++) {
          results[i].label =  results[i].formatted_address;
          array.push(results[i]);
        };
      }
      response(array);
    });
  },

  _reverseGeocode: function(latlng) {
  	var that = this;
  	this.geocoder.geocode({'latLng': latlng}, function(results, status) {
      if (status == google.maps.GeocoderStatus.OK) {
        if (results[1]) {
        	that.element.val(results[1].formatted_address);
        	that.element.trigger('reversegeocode');
        }
      }
    });
  },

  _findInfo: function(result, type) {
    for (var i = 0; i < result.address_components.length; i++) {
      var component = result.address_components[i];
      if (component.types.indexOf(type) !=-1) {
        return component.long_name;
      }
    }
    return false;
  },

  _focusAddress: function(event, ui) {
    var address = ui.item;
    if (!address) {
      return;
    }

    if (this.gmarker) {
      this.gmarker.setPosition(address.geometry.location);
      this.gmarker.setVisible(true);

      this.gmap.fitBounds(address.geometry.viewport);
    }
    this._updatePosition(address.geometry.location);

    if (this.locality) {
      this.locality.val(this._findInfo(address, 'locality'));
    }
    if (this.country) {
      this.country.val(this._findInfo(address, 'country'));
    }
  },

  _selectAddress: function(event, ui) {
    this.selectedResult = ui.item;
    this.element.val(ui.item.formatted_address);
  }
});

$.extend( $.ui.addresspicker, {
	version: "@VERSION"
});

})( jQuery );
