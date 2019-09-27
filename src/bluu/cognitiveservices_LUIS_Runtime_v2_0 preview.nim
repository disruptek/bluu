
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Language Understanding Intelligent Service (LUIS) Endpoint API for running predictions and extracting user intentions and entities from utterances.
## version: v2.0 preview
## termsOfService: (not provided)
## license: (not provided)
## 
## 
## 
type
  Scheme {.pure.} = enum
    Https = "https", Http = "http", Wss = "wss", Ws = "ws"
  ValidatorSignature = proc (query: JsonNode = nil; body: JsonNode = nil;
                          header: JsonNode = nil; path: JsonNode = nil;
                          formData: JsonNode = nil): JsonNode
  OpenApiRestCall = ref object of RestCall
    validator*: ValidatorSignature
    route*: string
    base*: string
    host*: string
    schemes*: set[Scheme]
    url*: proc (protocol: Scheme; host: string; base: string; route: string;
              path: JsonNode; query: JsonNode): Uri

  OpenApiRestCall_593425 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593425](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593425): Option[Scheme] {.used.} =
  ## select a supported scheme from a set of candidates
  for scheme in Scheme.low ..
      Scheme.high:
    if scheme notin t.schemes:
      continue
    if scheme in [Scheme.Https, Scheme.Wss]:
      when defined(ssl):
        return some(scheme)
      else:
        continue
    return some(scheme)

proc validateParameter(js: JsonNode; kind: JsonNodeKind; required: bool;
                      default: JsonNode = nil): JsonNode =
  ## ensure an input is of the correct json type and yield
  ## a suitable default value when appropriate
  if js ==
      nil:
    if default != nil:
      return validateParameter(default, kind, required = required)
  result = js
  if result ==
      nil:
    assert not required, $kind & " expected; received nil"
    if required:
      result = newJNull()
  else:
    assert js.kind ==
        kind, $kind & " expected; received " &
        $js.kind

type
  KeyVal {.used.} = tuple[key: string, val: string]
  PathTokenKind = enum
    ConstantSegment, VariableSegment
  PathToken = tuple[kind: PathTokenKind, value: string]
proc queryString(query: JsonNode): string =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] =
  ## reconstitute a path with constants and variable values taken from json
  var head: string
  if segments.len == 0:
    return some("")
  head = segments[0].value
  case segments[0].kind
  of ConstantSegment:
    discard
  of VariableSegment:
    if head notin input:
      return
    let js = input[head]
    if js.kind notin {JString, JInt, JFloat, JNull, JBool}:
      return
    head = $js
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  macServiceName = "cognitiveservices-LUIS-Runtime"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_PredictionResolve_593956 = ref object of OpenApiRestCall_593425
proc url_PredictionResolve_593958(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "appId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PredictionResolve_593957(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Gets predictions for a given utterance, in the form of intents and entities. The current maximum query size is 500 characters.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appId: JString (required)
  ##        : The LUIS application ID (Guid).
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appId` field"
  var valid_593968 = path.getOrDefault("appId")
  valid_593968 = validateParameter(valid_593968, JString, required = true,
                                 default = nil)
  if valid_593968 != nil:
    section.add "appId", valid_593968
  result.add "path", section
  ## parameters in `query` object:
  ##   verbose: JBool
  ##          : If true, return all intents instead of just the top scoring intent.
  ##   staging: JBool
  ##          : Use the staging endpoint slot.
  ##   log: JBool
  ##      : Log query (default is true)
  ##   spellCheck: JBool
  ##             : Enable spell checking.
  ##   bing-spell-check-subscription-key: JString
  ##                                    : The subscription key to use when enabling bing spell check
  ##   timezoneOffset: JFloat
  ##                 : The timezone offset for the location of the request.
  section = newJObject()
  var valid_593969 = query.getOrDefault("verbose")
  valid_593969 = validateParameter(valid_593969, JBool, required = false, default = nil)
  if valid_593969 != nil:
    section.add "verbose", valid_593969
  var valid_593970 = query.getOrDefault("staging")
  valid_593970 = validateParameter(valid_593970, JBool, required = false, default = nil)
  if valid_593970 != nil:
    section.add "staging", valid_593970
  var valid_593971 = query.getOrDefault("log")
  valid_593971 = validateParameter(valid_593971, JBool, required = false, default = nil)
  if valid_593971 != nil:
    section.add "log", valid_593971
  var valid_593972 = query.getOrDefault("spellCheck")
  valid_593972 = validateParameter(valid_593972, JBool, required = false, default = nil)
  if valid_593972 != nil:
    section.add "spellCheck", valid_593972
  var valid_593973 = query.getOrDefault("bing-spell-check-subscription-key")
  valid_593973 = validateParameter(valid_593973, JString, required = false,
                                 default = nil)
  if valid_593973 != nil:
    section.add "bing-spell-check-subscription-key", valid_593973
  var valid_593974 = query.getOrDefault("timezoneOffset")
  valid_593974 = validateParameter(valid_593974, JFloat, required = false,
                                 default = nil)
  if valid_593974 != nil:
    section.add "timezoneOffset", valid_593974
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   q: JString (required)
  ##    : The utterance to predict.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JString, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_593976: Call_PredictionResolve_593956; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets predictions for a given utterance, in the form of intents and entities. The current maximum query size is 500 characters.
  ## 
  let valid = call_593976.validator(path, query, header, formData, body)
  let scheme = call_593976.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593976.url(scheme.get, call_593976.host, call_593976.base,
                         call_593976.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593976, url, valid)

proc call*(call_593977: Call_PredictionResolve_593956; appId: string; q: JsonNode;
          verbose: bool = false; staging: bool = false; log: bool = false;
          spellCheck: bool = false; bingSpellCheckSubscriptionKey: string = "";
          timezoneOffset: float = 0.0): Recallable =
  ## predictionResolve
  ## Gets predictions for a given utterance, in the form of intents and entities. The current maximum query size is 500 characters.
  ##   verbose: bool
  ##          : If true, return all intents instead of just the top scoring intent.
  ##   appId: string (required)
  ##        : The LUIS application ID (Guid).
  ##   staging: bool
  ##          : Use the staging endpoint slot.
  ##   log: bool
  ##      : Log query (default is true)
  ##   q: JString (required)
  ##    : The utterance to predict.
  ##   spellCheck: bool
  ##             : Enable spell checking.
  ##   bingSpellCheckSubscriptionKey: string
  ##                                : The subscription key to use when enabling bing spell check
  ##   timezoneOffset: float
  ##                 : The timezone offset for the location of the request.
  var path_593978 = newJObject()
  var query_593979 = newJObject()
  var body_593980 = newJObject()
  add(query_593979, "verbose", newJBool(verbose))
  add(path_593978, "appId", newJString(appId))
  add(query_593979, "staging", newJBool(staging))
  add(query_593979, "log", newJBool(log))
  if q != nil:
    body_593980 = q
  add(query_593979, "spellCheck", newJBool(spellCheck))
  add(query_593979, "bing-spell-check-subscription-key",
      newJString(bingSpellCheckSubscriptionKey))
  add(query_593979, "timezoneOffset", newJFloat(timezoneOffset))
  result = call_593977.call(path_593978, query_593979, nil, nil, body_593980)

var predictionResolve* = Call_PredictionResolve_593956(name: "predictionResolve",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/{appId}",
    validator: validate_PredictionResolve_593957, base: "/luis/v2.0/apps",
    url: url_PredictionResolve_593958, schemes: {Scheme.Https})
type
  Call_PredictionResolve2_593647 = ref object of OpenApiRestCall_593425
proc url_PredictionResolve2_593649(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "appId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PredictionResolve2_593648(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Gets predictions for a given utterance, in the form of intents and entities. The current maximum query size is 500 characters.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appId: JString (required)
  ##        : The LUIS application ID (guid).
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appId` field"
  var valid_593809 = path.getOrDefault("appId")
  valid_593809 = validateParameter(valid_593809, JString, required = true,
                                 default = nil)
  if valid_593809 != nil:
    section.add "appId", valid_593809
  result.add "path", section
  ## parameters in `query` object:
  ##   verbose: JBool
  ##          : If true, return all intents instead of just the top scoring intent.
  ##   staging: JBool
  ##          : Use the staging endpoint slot.
  ##   log: JBool
  ##      : Log query (default is true)
  ##   q: JString (required)
  ##    : The utterance to predict.
  ##   spellCheck: JBool
  ##             : Enable spell checking.
  ##   bing-spell-check-subscription-key: JString
  ##                                    : The subscription key to use when enabling bing spell check
  ##   timezoneOffset: JFloat
  ##                 : The timezone offset for the location of the request.
  section = newJObject()
  var valid_593810 = query.getOrDefault("verbose")
  valid_593810 = validateParameter(valid_593810, JBool, required = false, default = nil)
  if valid_593810 != nil:
    section.add "verbose", valid_593810
  var valid_593811 = query.getOrDefault("staging")
  valid_593811 = validateParameter(valid_593811, JBool, required = false, default = nil)
  if valid_593811 != nil:
    section.add "staging", valid_593811
  var valid_593812 = query.getOrDefault("log")
  valid_593812 = validateParameter(valid_593812, JBool, required = false, default = nil)
  if valid_593812 != nil:
    section.add "log", valid_593812
  assert query != nil, "query argument is necessary due to required `q` field"
  var valid_593813 = query.getOrDefault("q")
  valid_593813 = validateParameter(valid_593813, JString, required = true,
                                 default = nil)
  if valid_593813 != nil:
    section.add "q", valid_593813
  var valid_593814 = query.getOrDefault("spellCheck")
  valid_593814 = validateParameter(valid_593814, JBool, required = false, default = nil)
  if valid_593814 != nil:
    section.add "spellCheck", valid_593814
  var valid_593815 = query.getOrDefault("bing-spell-check-subscription-key")
  valid_593815 = validateParameter(valid_593815, JString, required = false,
                                 default = nil)
  if valid_593815 != nil:
    section.add "bing-spell-check-subscription-key", valid_593815
  var valid_593816 = query.getOrDefault("timezoneOffset")
  valid_593816 = validateParameter(valid_593816, JFloat, required = false,
                                 default = nil)
  if valid_593816 != nil:
    section.add "timezoneOffset", valid_593816
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593843: Call_PredictionResolve2_593647; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets predictions for a given utterance, in the form of intents and entities. The current maximum query size is 500 characters.
  ## 
  let valid = call_593843.validator(path, query, header, formData, body)
  let scheme = call_593843.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593843.url(scheme.get, call_593843.host, call_593843.base,
                         call_593843.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593843, url, valid)

proc call*(call_593914: Call_PredictionResolve2_593647; appId: string; q: string;
          verbose: bool = false; staging: bool = false; log: bool = false;
          spellCheck: bool = false; bingSpellCheckSubscriptionKey: string = "";
          timezoneOffset: float = 0.0): Recallable =
  ## predictionResolve2
  ## Gets predictions for a given utterance, in the form of intents and entities. The current maximum query size is 500 characters.
  ##   verbose: bool
  ##          : If true, return all intents instead of just the top scoring intent.
  ##   appId: string (required)
  ##        : The LUIS application ID (guid).
  ##   staging: bool
  ##          : Use the staging endpoint slot.
  ##   log: bool
  ##      : Log query (default is true)
  ##   q: string (required)
  ##    : The utterance to predict.
  ##   spellCheck: bool
  ##             : Enable spell checking.
  ##   bingSpellCheckSubscriptionKey: string
  ##                                : The subscription key to use when enabling bing spell check
  ##   timezoneOffset: float
  ##                 : The timezone offset for the location of the request.
  var path_593915 = newJObject()
  var query_593917 = newJObject()
  add(query_593917, "verbose", newJBool(verbose))
  add(path_593915, "appId", newJString(appId))
  add(query_593917, "staging", newJBool(staging))
  add(query_593917, "log", newJBool(log))
  add(query_593917, "q", newJString(q))
  add(query_593917, "spellCheck", newJBool(spellCheck))
  add(query_593917, "bing-spell-check-subscription-key",
      newJString(bingSpellCheckSubscriptionKey))
  add(query_593917, "timezoneOffset", newJFloat(timezoneOffset))
  result = call_593914.call(path_593915, query_593917, nil, nil, nil)

var predictionResolve2* = Call_PredictionResolve2_593647(
    name: "predictionResolve2", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/{appId}", validator: validate_PredictionResolve2_593648,
    base: "/luis/v2.0/apps", url: url_PredictionResolve2_593649,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
