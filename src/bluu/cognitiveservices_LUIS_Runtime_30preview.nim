
import
  json, options, hashes, uri, rest, os, uri, httpcore

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

  OpenApiRestCall_563556 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563556](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563556): Option[Scheme] {.used.} =
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
    case js.kind
    of JInt, JFloat, JNull, JBool:
      head = $js
    of JString:
      head = js.getStr
    else:
      return
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  macServiceName = "cognitiveservices-LUIS-Runtime"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_PredictionGetSlotPrediction_564087 = ref object of OpenApiRestCall_563556
proc url_PredictionGetSlotPrediction_564089(protocol: Scheme; host: string;
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

proc validate_PredictionGetSlotPrediction_564088(path: JsonNode; query: JsonNode;
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
  var valid_564099 = path.getOrDefault("appId")
  valid_564099 = validateParameter(valid_564099, JString, required = true,
                                 default = nil)
  if valid_564099 != nil:
    section.add "appId", valid_564099
  var valid_564100 = path.getOrDefault("slotName")
  valid_564100 = validateParameter(valid_564100, JString, required = true,
                                 default = nil)
  if valid_564100 != nil:
    section.add "slotName", valid_564100
  result.add "path", section
  ## parameters in `query` object:
  ##   verbose: JBool
  ##          : Indicates whether to get extra metadata for the entities predictions or not.
  ##   log: JBool
  ##      : Indicates whether to log the endpoint query or not.
  ##   show-all-intents: JBool
  ##                   : Indicates whether to return all the intents in the response or just the top intent.
  section = newJObject()
  var valid_564101 = query.getOrDefault("verbose")
  valid_564101 = validateParameter(valid_564101, JBool, required = false, default = nil)
  if valid_564101 != nil:
    section.add "verbose", valid_564101
  var valid_564102 = query.getOrDefault("log")
  valid_564102 = validateParameter(valid_564102, JBool, required = false, default = nil)
  if valid_564102 != nil:
    section.add "log", valid_564102
  var valid_564103 = query.getOrDefault("show-all-intents")
  valid_564103 = validateParameter(valid_564103, JBool, required = false, default = nil)
  if valid_564103 != nil:
    section.add "show-all-intents", valid_564103
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

proc call*(call_564105: Call_PredictionGetSlotPrediction_564087; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the predictions for an application slot.
  ## 
  let valid = call_564105.validator(path, query, header, formData, body)
  let scheme = call_564105.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564105.url(scheme.get, call_564105.host, call_564105.base,
                         call_564105.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564105, url, valid)

proc call*(call_564106: Call_PredictionGetSlotPrediction_564087;
          predictionRequest: JsonNode; appId: string; slotName: string;
          verbose: bool = false; log: bool = false; showAllIntents: bool = false): Recallable =
  ## predictionGetSlotPrediction
  ## Gets the predictions for an application slot.
  ##   verbose: bool
  ##          : Indicates whether to get extra metadata for the entities predictions or not.
  ##   log: bool
  ##      : Indicates whether to log the endpoint query or not.
  ##   predictionRequest: JObject (required)
  ##                    : The prediction request parameters.
  ##   appId: string (required)
  ##        : The application ID.
  ##   slotName: string (required)
  ##           : The application slot name.
  ##   showAllIntents: bool
  ##                 : Indicates whether to return all the intents in the response or just the top intent.
  var path_564107 = newJObject()
  var query_564108 = newJObject()
  var body_564109 = newJObject()
  add(query_564108, "verbose", newJBool(verbose))
  add(query_564108, "log", newJBool(log))
  if predictionRequest != nil:
    body_564109 = predictionRequest
  add(path_564107, "appId", newJString(appId))
  add(path_564107, "slotName", newJString(slotName))
  add(query_564108, "show-all-intents", newJBool(showAllIntents))
  result = call_564106.call(path_564107, query_564108, nil, nil, body_564109)

var predictionGetSlotPrediction* = Call_PredictionGetSlotPrediction_564087(
    name: "predictionGetSlotPrediction", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/apps/{appId}/slots/{slotName}/predict",
    validator: validate_PredictionGetSlotPrediction_564088, base: "",
    url: url_PredictionGetSlotPrediction_564089, schemes: {Scheme.Https})
type
  Call_PredictionGetSlotPredictionGET_563778 = ref object of OpenApiRestCall_563556
proc url_PredictionGetSlotPredictionGET_563780(protocol: Scheme; host: string;
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

proc validate_PredictionGetSlotPredictionGET_563779(path: JsonNode;
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
  var valid_563942 = path.getOrDefault("appId")
  valid_563942 = validateParameter(valid_563942, JString, required = true,
                                 default = nil)
  if valid_563942 != nil:
    section.add "appId", valid_563942
  var valid_563943 = path.getOrDefault("slotName")
  valid_563943 = validateParameter(valid_563943, JString, required = true,
                                 default = nil)
  if valid_563943 != nil:
    section.add "slotName", valid_563943
  result.add "path", section
  ## parameters in `query` object:
  ##   verbose: JBool
  ##          : Indicates whether to get extra metadata for the entities predictions or not.
  ##   log: JBool
  ##      : Indicates whether to log the endpoint query or not.
  ##   query: JString (required)
  ##        : The query to predict.
  ##   show-all-intents: JBool
  ##                   : Indicates whether to return all the intents in the response or just the top intent.
  section = newJObject()
  var valid_563944 = query.getOrDefault("verbose")
  valid_563944 = validateParameter(valid_563944, JBool, required = false, default = nil)
  if valid_563944 != nil:
    section.add "verbose", valid_563944
  var valid_563945 = query.getOrDefault("log")
  valid_563945 = validateParameter(valid_563945, JBool, required = false, default = nil)
  if valid_563945 != nil:
    section.add "log", valid_563945
  assert query != nil, "query argument is necessary due to required `query` field"
  var valid_563946 = query.getOrDefault("query")
  valid_563946 = validateParameter(valid_563946, JString, required = true,
                                 default = nil)
  if valid_563946 != nil:
    section.add "query", valid_563946
  var valid_563947 = query.getOrDefault("show-all-intents")
  valid_563947 = validateParameter(valid_563947, JBool, required = false, default = nil)
  if valid_563947 != nil:
    section.add "show-all-intents", valid_563947
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563974: Call_PredictionGetSlotPredictionGET_563778; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the predictions for an application slot.
  ## 
  let valid = call_563974.validator(path, query, header, formData, body)
  let scheme = call_563974.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563974.url(scheme.get, call_563974.host, call_563974.base,
                         call_563974.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563974, url, valid)

proc call*(call_564045: Call_PredictionGetSlotPredictionGET_563778; appId: string;
          query: string; slotName: string; verbose: bool = false; log: bool = false;
          showAllIntents: bool = false): Recallable =
  ## predictionGetSlotPredictionGET
  ## Gets the predictions for an application slot.
  ##   verbose: bool
  ##          : Indicates whether to get extra metadata for the entities predictions or not.
  ##   log: bool
  ##      : Indicates whether to log the endpoint query or not.
  ##   appId: string (required)
  ##        : The application ID.
  ##   query: string (required)
  ##        : The query to predict.
  ##   slotName: string (required)
  ##           : The application slot name.
  ##   showAllIntents: bool
  ##                 : Indicates whether to return all the intents in the response or just the top intent.
  var path_564046 = newJObject()
  var query_564048 = newJObject()
  add(query_564048, "verbose", newJBool(verbose))
  add(query_564048, "log", newJBool(log))
  add(path_564046, "appId", newJString(appId))
  add(query_564048, "query", newJString(query))
  add(path_564046, "slotName", newJString(slotName))
  add(query_564048, "show-all-intents", newJBool(showAllIntents))
  result = call_564045.call(path_564046, query_564048, nil, nil, nil)

var predictionGetSlotPredictionGET* = Call_PredictionGetSlotPredictionGET_563778(
    name: "predictionGetSlotPredictionGET", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/apps/{appId}/slots/{slotName}/predict",
    validator: validate_PredictionGetSlotPredictionGET_563779, base: "",
    url: url_PredictionGetSlotPredictionGET_563780, schemes: {Scheme.Https})
type
  Call_PredictionGetVersionPrediction_564123 = ref object of OpenApiRestCall_563556
proc url_PredictionGetVersionPrediction_564125(protocol: Scheme; host: string;
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

proc validate_PredictionGetVersionPrediction_564124(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the predictions for an application version.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The application version ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appId` field"
  var valid_564126 = path.getOrDefault("appId")
  valid_564126 = validateParameter(valid_564126, JString, required = true,
                                 default = nil)
  if valid_564126 != nil:
    section.add "appId", valid_564126
  var valid_564127 = path.getOrDefault("versionId")
  valid_564127 = validateParameter(valid_564127, JString, required = true,
                                 default = nil)
  if valid_564127 != nil:
    section.add "versionId", valid_564127
  result.add "path", section
  ## parameters in `query` object:
  ##   verbose: JBool
  ##          : Indicates whether to get extra metadata for the entities predictions or not.
  ##   log: JBool
  ##      : Indicates whether to log the endpoint query or not.
  ##   show-all-intents: JBool
  ##                   : Indicates whether to return all the intents in the response or just the top intent.
  section = newJObject()
  var valid_564128 = query.getOrDefault("verbose")
  valid_564128 = validateParameter(valid_564128, JBool, required = false, default = nil)
  if valid_564128 != nil:
    section.add "verbose", valid_564128
  var valid_564129 = query.getOrDefault("log")
  valid_564129 = validateParameter(valid_564129, JBool, required = false, default = nil)
  if valid_564129 != nil:
    section.add "log", valid_564129
  var valid_564130 = query.getOrDefault("show-all-intents")
  valid_564130 = validateParameter(valid_564130, JBool, required = false, default = nil)
  if valid_564130 != nil:
    section.add "show-all-intents", valid_564130
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

proc call*(call_564132: Call_PredictionGetVersionPrediction_564123; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the predictions for an application version.
  ## 
  let valid = call_564132.validator(path, query, header, formData, body)
  let scheme = call_564132.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564132.url(scheme.get, call_564132.host, call_564132.base,
                         call_564132.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564132, url, valid)

proc call*(call_564133: Call_PredictionGetVersionPrediction_564123;
          predictionRequest: JsonNode; appId: string; versionId: string;
          verbose: bool = false; log: bool = false; showAllIntents: bool = false): Recallable =
  ## predictionGetVersionPrediction
  ## Gets the predictions for an application version.
  ##   verbose: bool
  ##          : Indicates whether to get extra metadata for the entities predictions or not.
  ##   log: bool
  ##      : Indicates whether to log the endpoint query or not.
  ##   predictionRequest: JObject (required)
  ##                    : The prediction request parameters.
  ##   appId: string (required)
  ##        : The application ID.
  ##   versionId: string (required)
  ##            : The application version ID.
  ##   showAllIntents: bool
  ##                 : Indicates whether to return all the intents in the response or just the top intent.
  var path_564134 = newJObject()
  var query_564135 = newJObject()
  var body_564136 = newJObject()
  add(query_564135, "verbose", newJBool(verbose))
  add(query_564135, "log", newJBool(log))
  if predictionRequest != nil:
    body_564136 = predictionRequest
  add(path_564134, "appId", newJString(appId))
  add(path_564134, "versionId", newJString(versionId))
  add(query_564135, "show-all-intents", newJBool(showAllIntents))
  result = call_564133.call(path_564134, query_564135, nil, nil, body_564136)

var predictionGetVersionPrediction* = Call_PredictionGetVersionPrediction_564123(
    name: "predictionGetVersionPrediction", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/predict",
    validator: validate_PredictionGetVersionPrediction_564124, base: "",
    url: url_PredictionGetVersionPrediction_564125, schemes: {Scheme.Https})
type
  Call_PredictionGetVersionPredictionGET_564110 = ref object of OpenApiRestCall_563556
proc url_PredictionGetVersionPredictionGET_564112(protocol: Scheme; host: string;
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

proc validate_PredictionGetVersionPredictionGET_564111(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the predictions for an application version.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   appId: JString (required)
  ##        : The application ID.
  ##   versionId: JString (required)
  ##            : The application version ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `appId` field"
  var valid_564113 = path.getOrDefault("appId")
  valid_564113 = validateParameter(valid_564113, JString, required = true,
                                 default = nil)
  if valid_564113 != nil:
    section.add "appId", valid_564113
  var valid_564114 = path.getOrDefault("versionId")
  valid_564114 = validateParameter(valid_564114, JString, required = true,
                                 default = nil)
  if valid_564114 != nil:
    section.add "versionId", valid_564114
  result.add "path", section
  ## parameters in `query` object:
  ##   verbose: JBool
  ##          : Indicates whether to get extra metadata for the entities predictions or not.
  ##   log: JBool
  ##      : Indicates whether to log the endpoint query or not.
  ##   query: JString (required)
  ##        : The query to predict.
  ##   show-all-intents: JBool
  ##                   : Indicates whether to return all the intents in the response or just the top intent.
  section = newJObject()
  var valid_564115 = query.getOrDefault("verbose")
  valid_564115 = validateParameter(valid_564115, JBool, required = false, default = nil)
  if valid_564115 != nil:
    section.add "verbose", valid_564115
  var valid_564116 = query.getOrDefault("log")
  valid_564116 = validateParameter(valid_564116, JBool, required = false, default = nil)
  if valid_564116 != nil:
    section.add "log", valid_564116
  assert query != nil, "query argument is necessary due to required `query` field"
  var valid_564117 = query.getOrDefault("query")
  valid_564117 = validateParameter(valid_564117, JString, required = true,
                                 default = nil)
  if valid_564117 != nil:
    section.add "query", valid_564117
  var valid_564118 = query.getOrDefault("show-all-intents")
  valid_564118 = validateParameter(valid_564118, JBool, required = false, default = nil)
  if valid_564118 != nil:
    section.add "show-all-intents", valid_564118
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564119: Call_PredictionGetVersionPredictionGET_564110;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the predictions for an application version.
  ## 
  let valid = call_564119.validator(path, query, header, formData, body)
  let scheme = call_564119.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564119.url(scheme.get, call_564119.host, call_564119.base,
                         call_564119.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564119, url, valid)

proc call*(call_564120: Call_PredictionGetVersionPredictionGET_564110;
          appId: string; query: string; versionId: string; verbose: bool = false;
          log: bool = false; showAllIntents: bool = false): Recallable =
  ## predictionGetVersionPredictionGET
  ## Gets the predictions for an application version.
  ##   verbose: bool
  ##          : Indicates whether to get extra metadata for the entities predictions or not.
  ##   log: bool
  ##      : Indicates whether to log the endpoint query or not.
  ##   appId: string (required)
  ##        : The application ID.
  ##   query: string (required)
  ##        : The query to predict.
  ##   versionId: string (required)
  ##            : The application version ID.
  ##   showAllIntents: bool
  ##                 : Indicates whether to return all the intents in the response or just the top intent.
  var path_564121 = newJObject()
  var query_564122 = newJObject()
  add(query_564122, "verbose", newJBool(verbose))
  add(query_564122, "log", newJBool(log))
  add(path_564121, "appId", newJString(appId))
  add(query_564122, "query", newJString(query))
  add(path_564121, "versionId", newJString(versionId))
  add(query_564122, "show-all-intents", newJBool(showAllIntents))
  result = call_564120.call(path_564121, query_564122, nil, nil, nil)

var predictionGetVersionPredictionGET* = Call_PredictionGetVersionPredictionGET_564110(
    name: "predictionGetVersionPredictionGET", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/apps/{appId}/versions/{versionId}/predict",
    validator: validate_PredictionGetVersionPredictionGET_564111, base: "",
    url: url_PredictionGetVersionPredictionGET_564112, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
