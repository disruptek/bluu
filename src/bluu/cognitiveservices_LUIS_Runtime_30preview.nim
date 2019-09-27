
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: LUIS Runtime Client
## version: 3.0-preview
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
  Call_PredictionGetSlotPrediction_593954 = ref object of OpenApiRestCall_593425
proc url_PredictionGetSlotPrediction_593956(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "slotName" in path, "`slotName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/slots/"),
               (kind: VariableSegment, value: "slotName"),
               (kind: ConstantSegment, value: "/predict")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PredictionGetSlotPrediction_593955(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the predictions for an application slot.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appId: JString (required)
  ##        : The application ID.
  ##   slotName: JString (required)
  ##           : The application slot name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appId` field"
  var valid_593966 = path.getOrDefault("appId")
  valid_593966 = validateParameter(valid_593966, JString, required = true,
                                 default = nil)
  if valid_593966 != nil:
    section.add "appId", valid_593966
  var valid_593967 = path.getOrDefault("slotName")
  valid_593967 = validateParameter(valid_593967, JString, required = true,
                                 default = nil)
  if valid_593967 != nil:
    section.add "slotName", valid_593967
  result.add "path", section
  ## parameters in `query` object:
  ##   verbose: JBool
  ##          : Indicates whether to get extra metadata for the entities predictions or not.
  ##   show-all-intents: JBool
  ##                   : Indicates whether to return all the intents in the response or just the top intent.
  ##   log: JBool
  ##      : Indicates whether to log the endpoint query or not.
  section = newJObject()
  var valid_593968 = query.getOrDefault("verbose")
  valid_593968 = validateParameter(valid_593968, JBool, required = false, default = nil)
  if valid_593968 != nil:
    section.add "verbose", valid_593968
  var valid_593969 = query.getOrDefault("show-all-intents")
  valid_593969 = validateParameter(valid_593969, JBool, required = false, default = nil)
  if valid_593969 != nil:
    section.add "show-all-intents", valid_593969
  var valid_593970 = query.getOrDefault("log")
  valid_593970 = validateParameter(valid_593970, JBool, required = false, default = nil)
  if valid_593970 != nil:
    section.add "log", valid_593970
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   predictionRequest: JObject (required)
  ##                    : The prediction request parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_593972: Call_PredictionGetSlotPrediction_593954; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the predictions for an application slot.
  ## 
  let valid = call_593972.validator(path, query, header, formData, body)
  let scheme = call_593972.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593972.url(scheme.get, call_593972.host, call_593972.base,
                         call_593972.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593972, url, valid)

proc call*(call_593973: Call_PredictionGetSlotPrediction_593954; appId: string;
          slotName: string; predictionRequest: JsonNode; verbose: bool = false;
          showAllIntents: bool = false; log: bool = false): Recallable =
  ## predictionGetSlotPrediction
  ## Gets the predictions for an application slot.
  ##   verbose: bool
  ##          : Indicates whether to get extra metadata for the entities predictions or not.
  ##   showAllIntents: bool
  ##                 : Indicates whether to return all the intents in the response or just the top intent.
  ##   appId: string (required)
  ##        : The application ID.
  ##   log: bool
  ##      : Indicates whether to log the endpoint query or not.
  ##   slotName: string (required)
  ##           : The application slot name.
  ##   predictionRequest: JObject (required)
  ##                    : The prediction request parameters.
  var path_593974 = newJObject()
  var query_593975 = newJObject()
  var body_593976 = newJObject()
  add(query_593975, "verbose", newJBool(verbose))
  add(query_593975, "show-all-intents", newJBool(showAllIntents))
  add(path_593974, "appId", newJString(appId))
  add(query_593975, "log", newJBool(log))
  add(path_593974, "slotName", newJString(slotName))
  if predictionRequest != nil:
    body_593976 = predictionRequest
  result = call_593973.call(path_593974, query_593975, nil, nil, body_593976)

var predictionGetSlotPrediction* = Call_PredictionGetSlotPrediction_593954(
    name: "predictionGetSlotPrediction", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/apps/{appId}/slots/{slotName}/predict",
    validator: validate_PredictionGetSlotPrediction_593955, base: "",
    url: url_PredictionGetSlotPrediction_593956, schemes: {Scheme.Https})
type
  Call_PredictionGetSlotPredictionGET_593647 = ref object of OpenApiRestCall_593425
proc url_PredictionGetSlotPredictionGET_593649(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "slotName" in path, "`slotName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/slots/"),
               (kind: VariableSegment, value: "slotName"),
               (kind: ConstantSegment, value: "/predict")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PredictionGetSlotPredictionGET_593648(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the predictions for an application slot.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appId: JString (required)
  ##        : The application ID.
  ##   slotName: JString (required)
  ##           : The application slot name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appId` field"
  var valid_593809 = path.getOrDefault("appId")
  valid_593809 = validateParameter(valid_593809, JString, required = true,
                                 default = nil)
  if valid_593809 != nil:
    section.add "appId", valid_593809
  var valid_593810 = path.getOrDefault("slotName")
  valid_593810 = validateParameter(valid_593810, JString, required = true,
                                 default = nil)
  if valid_593810 != nil:
    section.add "slotName", valid_593810
  result.add "path", section
  ## parameters in `query` object:
  ##   verbose: JBool
  ##          : Indicates whether to get extra metadata for the entities predictions or not.
  ##   show-all-intents: JBool
  ##                   : Indicates whether to return all the intents in the response or just the top intent.
  ##   query: JString (required)
  ##        : The query to predict.
  ##   log: JBool
  ##      : Indicates whether to log the endpoint query or not.
  section = newJObject()
  var valid_593811 = query.getOrDefault("verbose")
  valid_593811 = validateParameter(valid_593811, JBool, required = false, default = nil)
  if valid_593811 != nil:
    section.add "verbose", valid_593811
  var valid_593812 = query.getOrDefault("show-all-intents")
  valid_593812 = validateParameter(valid_593812, JBool, required = false, default = nil)
  if valid_593812 != nil:
    section.add "show-all-intents", valid_593812
  assert query != nil, "query argument is necessary due to required `query` field"
  var valid_593813 = query.getOrDefault("query")
  valid_593813 = validateParameter(valid_593813, JString, required = true,
                                 default = nil)
  if valid_593813 != nil:
    section.add "query", valid_593813
  var valid_593814 = query.getOrDefault("log")
  valid_593814 = validateParameter(valid_593814, JBool, required = false, default = nil)
  if valid_593814 != nil:
    section.add "log", valid_593814
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593841: Call_PredictionGetSlotPredictionGET_593647; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the predictions for an application slot.
  ## 
  let valid = call_593841.validator(path, query, header, formData, body)
  let scheme = call_593841.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593841.url(scheme.get, call_593841.host, call_593841.base,
                         call_593841.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593841, url, valid)

proc call*(call_593912: Call_PredictionGetSlotPredictionGET_593647; query: string;
          appId: string; slotName: string; verbose: bool = false;
          showAllIntents: bool = false; log: bool = false): Recallable =
  ## predictionGetSlotPredictionGET
  ## Gets the predictions for an application slot.
  ##   verbose: bool
  ##          : Indicates whether to get extra metadata for the entities predictions or not.
  ##   showAllIntents: bool
  ##                 : Indicates whether to return all the intents in the response or just the top intent.
  ##   query: string (required)
  ##        : The query to predict.
  ##   appId: string (required)
  ##        : The application ID.
  ##   log: bool
  ##      : Indicates whether to log the endpoint query or not.
  ##   slotName: string (required)
  ##           : The application slot name.
  var path_593913 = newJObject()
  var query_593915 = newJObject()
  add(query_593915, "verbose", newJBool(verbose))
  add(query_593915, "show-all-intents", newJBool(showAllIntents))
  add(query_593915, "query", newJString(query))
  add(path_593913, "appId", newJString(appId))
  add(query_593915, "log", newJBool(log))
  add(path_593913, "slotName", newJString(slotName))
  result = call_593912.call(path_593913, query_593915, nil, nil, nil)

var predictionGetSlotPredictionGET* = Call_PredictionGetSlotPredictionGET_593647(
    name: "predictionGetSlotPredictionGET", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/apps/{appId}/slots/{slotName}/predict",
    validator: validate_PredictionGetSlotPredictionGET_593648, base: "",
    url: url_PredictionGetSlotPredictionGET_593649, schemes: {Scheme.Https})
type
  Call_PredictionGetVersionPrediction_593990 = ref object of OpenApiRestCall_593425
proc url_PredictionGetVersionPrediction_593992(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/predict")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PredictionGetVersionPrediction_593991(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the predictions for an application version.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The application version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_593993 = path.getOrDefault("versionId")
  valid_593993 = validateParameter(valid_593993, JString, required = true,
                                 default = nil)
  if valid_593993 != nil:
    section.add "versionId", valid_593993
  var valid_593994 = path.getOrDefault("appId")
  valid_593994 = validateParameter(valid_593994, JString, required = true,
                                 default = nil)
  if valid_593994 != nil:
    section.add "appId", valid_593994
  result.add "path", section
  ## parameters in `query` object:
  ##   verbose: JBool
  ##          : Indicates whether to get extra metadata for the entities predictions or not.
  ##   show-all-intents: JBool
  ##                   : Indicates whether to return all the intents in the response or just the top intent.
  ##   log: JBool
  ##      : Indicates whether to log the endpoint query or not.
  section = newJObject()
  var valid_593995 = query.getOrDefault("verbose")
  valid_593995 = validateParameter(valid_593995, JBool, required = false, default = nil)
  if valid_593995 != nil:
    section.add "verbose", valid_593995
  var valid_593996 = query.getOrDefault("show-all-intents")
  valid_593996 = validateParameter(valid_593996, JBool, required = false, default = nil)
  if valid_593996 != nil:
    section.add "show-all-intents", valid_593996
  var valid_593997 = query.getOrDefault("log")
  valid_593997 = validateParameter(valid_593997, JBool, required = false, default = nil)
  if valid_593997 != nil:
    section.add "log", valid_593997
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   predictionRequest: JObject (required)
  ##                    : The prediction request parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_593999: Call_PredictionGetVersionPrediction_593990; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the predictions for an application version.
  ## 
  let valid = call_593999.validator(path, query, header, formData, body)
  let scheme = call_593999.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593999.url(scheme.get, call_593999.host, call_593999.base,
                         call_593999.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593999, url, valid)

proc call*(call_594000: Call_PredictionGetVersionPrediction_593990;
          versionId: string; appId: string; predictionRequest: JsonNode;
          verbose: bool = false; showAllIntents: bool = false; log: bool = false): Recallable =
  ## predictionGetVersionPrediction
  ## Gets the predictions for an application version.
  ##   verbose: bool
  ##          : Indicates whether to get extra metadata for the entities predictions or not.
  ##   versionId: string (required)
  ##            : The application version ID.
  ##   showAllIntents: bool
  ##                 : Indicates whether to return all the intents in the response or just the top intent.
  ##   appId: string (required)
  ##        : The application ID.
  ##   log: bool
  ##      : Indicates whether to log the endpoint query or not.
  ##   predictionRequest: JObject (required)
  ##                    : The prediction request parameters.
  var path_594001 = newJObject()
  var query_594002 = newJObject()
  var body_594003 = newJObject()
  add(query_594002, "verbose", newJBool(verbose))
  add(path_594001, "versionId", newJString(versionId))
  add(query_594002, "show-all-intents", newJBool(showAllIntents))
  add(path_594001, "appId", newJString(appId))
  add(query_594002, "log", newJBool(log))
  if predictionRequest != nil:
    body_594003 = predictionRequest
  result = call_594000.call(path_594001, query_594002, nil, nil, body_594003)

var predictionGetVersionPrediction* = Call_PredictionGetVersionPrediction_593990(
    name: "predictionGetVersionPrediction", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/predict",
    validator: validate_PredictionGetVersionPrediction_593991, base: "",
    url: url_PredictionGetVersionPrediction_593992, schemes: {Scheme.Https})
type
  Call_PredictionGetVersionPredictionGET_593977 = ref object of OpenApiRestCall_593425
proc url_PredictionGetVersionPredictionGET_593979(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "appId" in path, "`appId` is a required path parameter"
  assert "versionId" in path, "`versionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionId"),
               (kind: ConstantSegment, value: "/predict")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PredictionGetVersionPredictionGET_593978(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the predictions for an application version.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionId: JString (required)
  ##            : The application version ID.
  ##   appId: JString (required)
  ##        : The application ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `versionId` field"
  var valid_593980 = path.getOrDefault("versionId")
  valid_593980 = validateParameter(valid_593980, JString, required = true,
                                 default = nil)
  if valid_593980 != nil:
    section.add "versionId", valid_593980
  var valid_593981 = path.getOrDefault("appId")
  valid_593981 = validateParameter(valid_593981, JString, required = true,
                                 default = nil)
  if valid_593981 != nil:
    section.add "appId", valid_593981
  result.add "path", section
  ## parameters in `query` object:
  ##   verbose: JBool
  ##          : Indicates whether to get extra metadata for the entities predictions or not.
  ##   show-all-intents: JBool
  ##                   : Indicates whether to return all the intents in the response or just the top intent.
  ##   query: JString (required)
  ##        : The query to predict.
  ##   log: JBool
  ##      : Indicates whether to log the endpoint query or not.
  section = newJObject()
  var valid_593982 = query.getOrDefault("verbose")
  valid_593982 = validateParameter(valid_593982, JBool, required = false, default = nil)
  if valid_593982 != nil:
    section.add "verbose", valid_593982
  var valid_593983 = query.getOrDefault("show-all-intents")
  valid_593983 = validateParameter(valid_593983, JBool, required = false, default = nil)
  if valid_593983 != nil:
    section.add "show-all-intents", valid_593983
  assert query != nil, "query argument is necessary due to required `query` field"
  var valid_593984 = query.getOrDefault("query")
  valid_593984 = validateParameter(valid_593984, JString, required = true,
                                 default = nil)
  if valid_593984 != nil:
    section.add "query", valid_593984
  var valid_593985 = query.getOrDefault("log")
  valid_593985 = validateParameter(valid_593985, JBool, required = false, default = nil)
  if valid_593985 != nil:
    section.add "log", valid_593985
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593986: Call_PredictionGetVersionPredictionGET_593977;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the predictions for an application version.
  ## 
  let valid = call_593986.validator(path, query, header, formData, body)
  let scheme = call_593986.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593986.url(scheme.get, call_593986.host, call_593986.base,
                         call_593986.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593986, url, valid)

proc call*(call_593987: Call_PredictionGetVersionPredictionGET_593977;
          versionId: string; query: string; appId: string; verbose: bool = false;
          showAllIntents: bool = false; log: bool = false): Recallable =
  ## predictionGetVersionPredictionGET
  ## Gets the predictions for an application version.
  ##   verbose: bool
  ##          : Indicates whether to get extra metadata for the entities predictions or not.
  ##   versionId: string (required)
  ##            : The application version ID.
  ##   showAllIntents: bool
  ##                 : Indicates whether to return all the intents in the response or just the top intent.
  ##   query: string (required)
  ##        : The query to predict.
  ##   appId: string (required)
  ##        : The application ID.
  ##   log: bool
  ##      : Indicates whether to log the endpoint query or not.
  var path_593988 = newJObject()
  var query_593989 = newJObject()
  add(query_593989, "verbose", newJBool(verbose))
  add(path_593988, "versionId", newJString(versionId))
  add(query_593989, "show-all-intents", newJBool(showAllIntents))
  add(query_593989, "query", newJString(query))
  add(path_593988, "appId", newJString(appId))
  add(query_593989, "log", newJBool(log))
  result = call_593987.call(path_593988, query_593989, nil, nil, nil)

var predictionGetVersionPredictionGET* = Call_PredictionGetVersionPredictionGET_593977(
    name: "predictionGetVersionPredictionGET", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/predict",
    validator: validate_PredictionGetVersionPredictionGET_593978, base: "",
    url: url_PredictionGetVersionPredictionGET_593979, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
