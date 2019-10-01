
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_567658 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567658](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567658): Option[Scheme] {.used.} =
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
proc queryString(query: JsonNode): string {.used.} =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] {.used.} =
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
  Call_PredictionGetSlotPrediction_568187 = ref object of OpenApiRestCall_567658
proc url_PredictionGetSlotPrediction_568189(protocol: Scheme; host: string;
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

proc validate_PredictionGetSlotPrediction_568188(path: JsonNode; query: JsonNode;
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
  var valid_568199 = path.getOrDefault("appId")
  valid_568199 = validateParameter(valid_568199, JString, required = true,
                                 default = nil)
  if valid_568199 != nil:
    section.add "appId", valid_568199
  var valid_568200 = path.getOrDefault("slotName")
  valid_568200 = validateParameter(valid_568200, JString, required = true,
                                 default = nil)
  if valid_568200 != nil:
    section.add "slotName", valid_568200
  result.add "path", section
  ## parameters in `query` object:
  ##   verbose: JBool
  ##          : Indicates whether to get extra metadata for the entities predictions or not.
  ##   show-all-intents: JBool
  ##                   : Indicates whether to return all the intents in the response or just the top intent.
  ##   log: JBool
  ##      : Indicates whether to log the endpoint query or not.
  section = newJObject()
  var valid_568201 = query.getOrDefault("verbose")
  valid_568201 = validateParameter(valid_568201, JBool, required = false, default = nil)
  if valid_568201 != nil:
    section.add "verbose", valid_568201
  var valid_568202 = query.getOrDefault("show-all-intents")
  valid_568202 = validateParameter(valid_568202, JBool, required = false, default = nil)
  if valid_568202 != nil:
    section.add "show-all-intents", valid_568202
  var valid_568203 = query.getOrDefault("log")
  valid_568203 = validateParameter(valid_568203, JBool, required = false, default = nil)
  if valid_568203 != nil:
    section.add "log", valid_568203
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

proc call*(call_568205: Call_PredictionGetSlotPrediction_568187; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the predictions for an application slot.
  ## 
  let valid = call_568205.validator(path, query, header, formData, body)
  let scheme = call_568205.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568205.url(scheme.get, call_568205.host, call_568205.base,
                         call_568205.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568205, url, valid)

proc call*(call_568206: Call_PredictionGetSlotPrediction_568187; appId: string;
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
  var path_568207 = newJObject()
  var query_568208 = newJObject()
  var body_568209 = newJObject()
  add(query_568208, "verbose", newJBool(verbose))
  add(query_568208, "show-all-intents", newJBool(showAllIntents))
  add(path_568207, "appId", newJString(appId))
  add(query_568208, "log", newJBool(log))
  add(path_568207, "slotName", newJString(slotName))
  if predictionRequest != nil:
    body_568209 = predictionRequest
  result = call_568206.call(path_568207, query_568208, nil, nil, body_568209)

var predictionGetSlotPrediction* = Call_PredictionGetSlotPrediction_568187(
    name: "predictionGetSlotPrediction", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/apps/{appId}/slots/{slotName}/predict",
    validator: validate_PredictionGetSlotPrediction_568188, base: "",
    url: url_PredictionGetSlotPrediction_568189, schemes: {Scheme.Https})
type
  Call_PredictionGetSlotPredictionGET_567880 = ref object of OpenApiRestCall_567658
proc url_PredictionGetSlotPredictionGET_567882(protocol: Scheme; host: string;
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

proc validate_PredictionGetSlotPredictionGET_567881(path: JsonNode;
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
  var valid_568042 = path.getOrDefault("appId")
  valid_568042 = validateParameter(valid_568042, JString, required = true,
                                 default = nil)
  if valid_568042 != nil:
    section.add "appId", valid_568042
  var valid_568043 = path.getOrDefault("slotName")
  valid_568043 = validateParameter(valid_568043, JString, required = true,
                                 default = nil)
  if valid_568043 != nil:
    section.add "slotName", valid_568043
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
  var valid_568044 = query.getOrDefault("verbose")
  valid_568044 = validateParameter(valid_568044, JBool, required = false, default = nil)
  if valid_568044 != nil:
    section.add "verbose", valid_568044
  var valid_568045 = query.getOrDefault("show-all-intents")
  valid_568045 = validateParameter(valid_568045, JBool, required = false, default = nil)
  if valid_568045 != nil:
    section.add "show-all-intents", valid_568045
  assert query != nil, "query argument is necessary due to required `query` field"
  var valid_568046 = query.getOrDefault("query")
  valid_568046 = validateParameter(valid_568046, JString, required = true,
                                 default = nil)
  if valid_568046 != nil:
    section.add "query", valid_568046
  var valid_568047 = query.getOrDefault("log")
  valid_568047 = validateParameter(valid_568047, JBool, required = false, default = nil)
  if valid_568047 != nil:
    section.add "log", valid_568047
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568074: Call_PredictionGetSlotPredictionGET_567880; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the predictions for an application slot.
  ## 
  let valid = call_568074.validator(path, query, header, formData, body)
  let scheme = call_568074.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568074.url(scheme.get, call_568074.host, call_568074.base,
                         call_568074.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568074, url, valid)

proc call*(call_568145: Call_PredictionGetSlotPredictionGET_567880; query: string;
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
  var path_568146 = newJObject()
  var query_568148 = newJObject()
  add(query_568148, "verbose", newJBool(verbose))
  add(query_568148, "show-all-intents", newJBool(showAllIntents))
  add(query_568148, "query", newJString(query))
  add(path_568146, "appId", newJString(appId))
  add(query_568148, "log", newJBool(log))
  add(path_568146, "slotName", newJString(slotName))
  result = call_568145.call(path_568146, query_568148, nil, nil, nil)

var predictionGetSlotPredictionGET* = Call_PredictionGetSlotPredictionGET_567880(
    name: "predictionGetSlotPredictionGET", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/apps/{appId}/slots/{slotName}/predict",
    validator: validate_PredictionGetSlotPredictionGET_567881, base: "",
    url: url_PredictionGetSlotPredictionGET_567882, schemes: {Scheme.Https})
type
  Call_PredictionGetVersionPrediction_568223 = ref object of OpenApiRestCall_567658
proc url_PredictionGetVersionPrediction_568225(protocol: Scheme; host: string;
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

proc validate_PredictionGetVersionPrediction_568224(path: JsonNode;
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
  var valid_568226 = path.getOrDefault("versionId")
  valid_568226 = validateParameter(valid_568226, JString, required = true,
                                 default = nil)
  if valid_568226 != nil:
    section.add "versionId", valid_568226
  var valid_568227 = path.getOrDefault("appId")
  valid_568227 = validateParameter(valid_568227, JString, required = true,
                                 default = nil)
  if valid_568227 != nil:
    section.add "appId", valid_568227
  result.add "path", section
  ## parameters in `query` object:
  ##   verbose: JBool
  ##          : Indicates whether to get extra metadata for the entities predictions or not.
  ##   show-all-intents: JBool
  ##                   : Indicates whether to return all the intents in the response or just the top intent.
  ##   log: JBool
  ##      : Indicates whether to log the endpoint query or not.
  section = newJObject()
  var valid_568228 = query.getOrDefault("verbose")
  valid_568228 = validateParameter(valid_568228, JBool, required = false, default = nil)
  if valid_568228 != nil:
    section.add "verbose", valid_568228
  var valid_568229 = query.getOrDefault("show-all-intents")
  valid_568229 = validateParameter(valid_568229, JBool, required = false, default = nil)
  if valid_568229 != nil:
    section.add "show-all-intents", valid_568229
  var valid_568230 = query.getOrDefault("log")
  valid_568230 = validateParameter(valid_568230, JBool, required = false, default = nil)
  if valid_568230 != nil:
    section.add "log", valid_568230
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

proc call*(call_568232: Call_PredictionGetVersionPrediction_568223; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the predictions for an application version.
  ## 
  let valid = call_568232.validator(path, query, header, formData, body)
  let scheme = call_568232.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568232.url(scheme.get, call_568232.host, call_568232.base,
                         call_568232.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568232, url, valid)

proc call*(call_568233: Call_PredictionGetVersionPrediction_568223;
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
  var path_568234 = newJObject()
  var query_568235 = newJObject()
  var body_568236 = newJObject()
  add(query_568235, "verbose", newJBool(verbose))
  add(path_568234, "versionId", newJString(versionId))
  add(query_568235, "show-all-intents", newJBool(showAllIntents))
  add(path_568234, "appId", newJString(appId))
  add(query_568235, "log", newJBool(log))
  if predictionRequest != nil:
    body_568236 = predictionRequest
  result = call_568233.call(path_568234, query_568235, nil, nil, body_568236)

var predictionGetVersionPrediction* = Call_PredictionGetVersionPrediction_568223(
    name: "predictionGetVersionPrediction", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/predict",
    validator: validate_PredictionGetVersionPrediction_568224, base: "",
    url: url_PredictionGetVersionPrediction_568225, schemes: {Scheme.Https})
type
  Call_PredictionGetVersionPredictionGET_568210 = ref object of OpenApiRestCall_567658
proc url_PredictionGetVersionPredictionGET_568212(protocol: Scheme; host: string;
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

proc validate_PredictionGetVersionPredictionGET_568211(path: JsonNode;
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
  var valid_568213 = path.getOrDefault("versionId")
  valid_568213 = validateParameter(valid_568213, JString, required = true,
                                 default = nil)
  if valid_568213 != nil:
    section.add "versionId", valid_568213
  var valid_568214 = path.getOrDefault("appId")
  valid_568214 = validateParameter(valid_568214, JString, required = true,
                                 default = nil)
  if valid_568214 != nil:
    section.add "appId", valid_568214
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
  var valid_568215 = query.getOrDefault("verbose")
  valid_568215 = validateParameter(valid_568215, JBool, required = false, default = nil)
  if valid_568215 != nil:
    section.add "verbose", valid_568215
  var valid_568216 = query.getOrDefault("show-all-intents")
  valid_568216 = validateParameter(valid_568216, JBool, required = false, default = nil)
  if valid_568216 != nil:
    section.add "show-all-intents", valid_568216
  assert query != nil, "query argument is necessary due to required `query` field"
  var valid_568217 = query.getOrDefault("query")
  valid_568217 = validateParameter(valid_568217, JString, required = true,
                                 default = nil)
  if valid_568217 != nil:
    section.add "query", valid_568217
  var valid_568218 = query.getOrDefault("log")
  valid_568218 = validateParameter(valid_568218, JBool, required = false, default = nil)
  if valid_568218 != nil:
    section.add "log", valid_568218
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568219: Call_PredictionGetVersionPredictionGET_568210;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the predictions for an application version.
  ## 
  let valid = call_568219.validator(path, query, header, formData, body)
  let scheme = call_568219.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568219.url(scheme.get, call_568219.host, call_568219.base,
                         call_568219.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568219, url, valid)

proc call*(call_568220: Call_PredictionGetVersionPredictionGET_568210;
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
  var path_568221 = newJObject()
  var query_568222 = newJObject()
  add(query_568222, "verbose", newJBool(verbose))
  add(path_568221, "versionId", newJString(versionId))
  add(query_568222, "show-all-intents", newJBool(showAllIntents))
  add(query_568222, "query", newJString(query))
  add(path_568221, "appId", newJString(appId))
  add(query_568222, "log", newJBool(log))
  result = call_568220.call(path_568221, query_568222, nil, nil, nil)

var predictionGetVersionPredictionGET* = Call_PredictionGetVersionPredictionGET_568210(
    name: "predictionGetVersionPredictionGET", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/predict",
    validator: validate_PredictionGetVersionPredictionGET_568211, base: "",
    url: url_PredictionGetVersionPredictionGET_568212, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
