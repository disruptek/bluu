
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: Form Recognizer Client
## version: 1.0-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## Extracts information from forms and images into structured data based on a model created by a set of representative training forms.
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
  macServiceName = "cognitiveservices-FormRecognizer"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_GetCustomModels_563778 = ref object of OpenApiRestCall_563556
proc url_GetCustomModels_563780(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetCustomModels_563779(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Get information about all trained custom models
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563893: Call_GetCustomModels_563778; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get information about all trained custom models
  ## 
  let valid = call_563893.validator(path, query, header, formData, body)
  let scheme = call_563893.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563893.url(scheme.get, call_563893.host, call_563893.base,
                         call_563893.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563893, url, valid)

proc call*(call_563977: Call_GetCustomModels_563778): Recallable =
  ## getCustomModels
  ## Get information about all trained custom models
  result = call_563977.call(nil, nil, nil, nil, nil)

var getCustomModels* = Call_GetCustomModels_563778(name: "getCustomModels",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/custom/models",
    validator: validate_GetCustomModels_563779, base: "", url: url_GetCustomModels_563780,
    schemes: {Scheme.Https})
type
  Call_GetCustomModel_564015 = ref object of OpenApiRestCall_563556
proc url_GetCustomModel_564017(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/custom/models/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GetCustomModel_564016(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Get information about a model.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   id: JString (required)
  ##     : Model identifier.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `id` field"
  var valid_564080 = path.getOrDefault("id")
  valid_564080 = validateParameter(valid_564080, JString, required = true,
                                 default = nil)
  if valid_564080 != nil:
    section.add "id", valid_564080
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564081: Call_GetCustomModel_564015; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get information about a model.
  ## 
  let valid = call_564081.validator(path, query, header, formData, body)
  let scheme = call_564081.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564081.url(scheme.get, call_564081.host, call_564081.base,
                         call_564081.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564081, url, valid)

proc call*(call_564082: Call_GetCustomModel_564015; id: string): Recallable =
  ## getCustomModel
  ## Get information about a model.
  ##   id: string (required)
  ##     : Model identifier.
  var path_564083 = newJObject()
  add(path_564083, "id", newJString(id))
  result = call_564082.call(path_564083, nil, nil, nil, nil)

var getCustomModel* = Call_GetCustomModel_564015(name: "getCustomModel",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/custom/models/{id}",
    validator: validate_GetCustomModel_564016, base: "", url: url_GetCustomModel_564017,
    schemes: {Scheme.Https})
type
  Call_DeleteCustomModel_564086 = ref object of OpenApiRestCall_563556
proc url_DeleteCustomModel_564088(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/custom/models/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeleteCustomModel_564087(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Delete model artifacts.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   id: JString (required)
  ##     : The identifier of the model to delete.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `id` field"
  var valid_564089 = path.getOrDefault("id")
  valid_564089 = validateParameter(valid_564089, JString, required = true,
                                 default = nil)
  if valid_564089 != nil:
    section.add "id", valid_564089
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564090: Call_DeleteCustomModel_564086; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete model artifacts.
  ## 
  let valid = call_564090.validator(path, query, header, formData, body)
  let scheme = call_564090.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564090.url(scheme.get, call_564090.host, call_564090.base,
                         call_564090.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564090, url, valid)

proc call*(call_564091: Call_DeleteCustomModel_564086; id: string): Recallable =
  ## deleteCustomModel
  ## Delete model artifacts.
  ##   id: string (required)
  ##     : The identifier of the model to delete.
  var path_564092 = newJObject()
  add(path_564092, "id", newJString(id))
  result = call_564091.call(path_564092, nil, nil, nil, nil)

var deleteCustomModel* = Call_DeleteCustomModel_564086(name: "deleteCustomModel",
    meth: HttpMethod.HttpDelete, host: "azure.local", route: "/custom/models/{id}",
    validator: validate_DeleteCustomModel_564087, base: "",
    url: url_DeleteCustomModel_564088, schemes: {Scheme.Https})
type
  Call_AnalyzeWithCustomModel_564093 = ref object of OpenApiRestCall_563556
proc url_AnalyzeWithCustomModel_564095(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/custom/models/"),
               (kind: VariableSegment, value: "id"),
               (kind: ConstantSegment, value: "/analyze")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyzeWithCustomModel_564094(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Extract key-value pairs from a given document. The input document must be of one of the supported content types - 'application/pdf', 'image/jpeg' or 'image/png'. A success response is returned in JSON.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   id: JString (required)
  ##     : Model Identifier to analyze the document with.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `id` field"
  var valid_564096 = path.getOrDefault("id")
  valid_564096 = validateParameter(valid_564096, JString, required = true,
                                 default = nil)
  if valid_564096 != nil:
    section.add "id", valid_564096
  result.add "path", section
  ## parameters in `query` object:
  ##   keys: JArray
  ##       : An optional list of known keys to extract the values for.
  section = newJObject()
  var valid_564097 = query.getOrDefault("keys")
  valid_564097 = validateParameter(valid_564097, JArray, required = false,
                                 default = nil)
  if valid_564097 != nil:
    section.add "keys", valid_564097
  result.add "query", section
  section = newJObject()
  result.add "header", section
  ## parameters in `formData` object:
  ##   form_stream: JString (required)
  ##              : A pdf document or image (jpg,png) file to analyze.
  section = newJObject()
  assert formData != nil,
        "formData argument is necessary due to required `form_stream` field"
  var valid_564098 = formData.getOrDefault("form_stream")
  valid_564098 = validateParameter(valid_564098, JString, required = true,
                                 default = nil)
  if valid_564098 != nil:
    section.add "form_stream", valid_564098
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564099: Call_AnalyzeWithCustomModel_564093; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Extract key-value pairs from a given document. The input document must be of one of the supported content types - 'application/pdf', 'image/jpeg' or 'image/png'. A success response is returned in JSON.
  ## 
  let valid = call_564099.validator(path, query, header, formData, body)
  let scheme = call_564099.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564099.url(scheme.get, call_564099.host, call_564099.base,
                         call_564099.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564099, url, valid)

proc call*(call_564100: Call_AnalyzeWithCustomModel_564093; id: string;
          formStream: string; keys: JsonNode = nil): Recallable =
  ## analyzeWithCustomModel
  ## Extract key-value pairs from a given document. The input document must be of one of the supported content types - 'application/pdf', 'image/jpeg' or 'image/png'. A success response is returned in JSON.
  ##   id: string (required)
  ##     : Model Identifier to analyze the document with.
  ##   keys: JArray
  ##       : An optional list of known keys to extract the values for.
  ##   formStream: string (required)
  ##             : A pdf document or image (jpg,png) file to analyze.
  var path_564101 = newJObject()
  var query_564102 = newJObject()
  var formData_564103 = newJObject()
  add(path_564101, "id", newJString(id))
  if keys != nil:
    query_564102.add "keys", keys
  add(formData_564103, "form_stream", newJString(formStream))
  result = call_564100.call(path_564101, query_564102, nil, formData_564103, nil)

var analyzeWithCustomModel* = Call_AnalyzeWithCustomModel_564093(
    name: "analyzeWithCustomModel", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/custom/models/{id}/analyze",
    validator: validate_AnalyzeWithCustomModel_564094, base: "",
    url: url_AnalyzeWithCustomModel_564095, schemes: {Scheme.Https})
type
  Call_GetExtractedKeys_564104 = ref object of OpenApiRestCall_563556
proc url_GetExtractedKeys_564106(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/custom/models/"),
               (kind: VariableSegment, value: "id"),
               (kind: ConstantSegment, value: "/keys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GetExtractedKeys_564105(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Retrieve the keys that were
  ##  extracted during the training of the specified model.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   id: JString (required)
  ##     : Model identifier.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `id` field"
  var valid_564107 = path.getOrDefault("id")
  valid_564107 = validateParameter(valid_564107, JString, required = true,
                                 default = nil)
  if valid_564107 != nil:
    section.add "id", valid_564107
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564108: Call_GetExtractedKeys_564104; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve the keys that were
  ##  extracted during the training of the specified model.
  ## 
  let valid = call_564108.validator(path, query, header, formData, body)
  let scheme = call_564108.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564108.url(scheme.get, call_564108.host, call_564108.base,
                         call_564108.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564108, url, valid)

proc call*(call_564109: Call_GetExtractedKeys_564104; id: string): Recallable =
  ## getExtractedKeys
  ## Retrieve the keys that were
  ##  extracted during the training of the specified model.
  ##   id: string (required)
  ##     : Model identifier.
  var path_564110 = newJObject()
  add(path_564110, "id", newJString(id))
  result = call_564109.call(path_564110, nil, nil, nil, nil)

var getExtractedKeys* = Call_GetExtractedKeys_564104(name: "getExtractedKeys",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/custom/models/{id}/keys", validator: validate_GetExtractedKeys_564105,
    base: "", url: url_GetExtractedKeys_564106, schemes: {Scheme.Https})
type
  Call_TrainCustomModel_564111 = ref object of OpenApiRestCall_563556
proc url_TrainCustomModel_564113(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_TrainCustomModel_564112(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Create and train a custom model. The train request must include a source parameter that is either an externally accessible Azure Storage blob container Uri (preferably a Shared Access Signature Uri) or valid path to a data folder in a locally mounted drive. When local paths are specified, they must follow the Linux/Unix path format and be an absolute path rooted to the input mount configuration
  ##  setting value e.g., if '{Mounts:Input}' configuration setting value is '/input' then a valid source path would be '/input/contosodataset'. All data to be trained is expected to be directly under the source folder. Subfolders are not supported. Models are trained using documents that are of the following content type - 'application/pdf', 'image/jpeg' and 'image/png'."
  ##  Other type of content is ignored.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   trainRequest: JObject (required)
  ##               : Request object for training.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564124: Call_TrainCustomModel_564111; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create and train a custom model. The train request must include a source parameter that is either an externally accessible Azure Storage blob container Uri (preferably a Shared Access Signature Uri) or valid path to a data folder in a locally mounted drive. When local paths are specified, they must follow the Linux/Unix path format and be an absolute path rooted to the input mount configuration
  ##  setting value e.g., if '{Mounts:Input}' configuration setting value is '/input' then a valid source path would be '/input/contosodataset'. All data to be trained is expected to be directly under the source folder. Subfolders are not supported. Models are trained using documents that are of the following content type - 'application/pdf', 'image/jpeg' and 'image/png'."
  ##  Other type of content is ignored.
  ## 
  let valid = call_564124.validator(path, query, header, formData, body)
  let scheme = call_564124.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564124.url(scheme.get, call_564124.host, call_564124.base,
                         call_564124.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564124, url, valid)

proc call*(call_564125: Call_TrainCustomModel_564111; trainRequest: JsonNode): Recallable =
  ## trainCustomModel
  ## Create and train a custom model. The train request must include a source parameter that is either an externally accessible Azure Storage blob container Uri (preferably a Shared Access Signature Uri) or valid path to a data folder in a locally mounted drive. When local paths are specified, they must follow the Linux/Unix path format and be an absolute path rooted to the input mount configuration
  ##  setting value e.g., if '{Mounts:Input}' configuration setting value is '/input' then a valid source path would be '/input/contosodataset'. All data to be trained is expected to be directly under the source folder. Subfolders are not supported. Models are trained using documents that are of the following content type - 'application/pdf', 'image/jpeg' and 'image/png'."
  ##  Other type of content is ignored.
  ##   trainRequest: JObject (required)
  ##               : Request object for training.
  var body_564126 = newJObject()
  if trainRequest != nil:
    body_564126 = trainRequest
  result = call_564125.call(nil, nil, nil, nil, body_564126)

var trainCustomModel* = Call_TrainCustomModel_564111(name: "trainCustomModel",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/custom/train",
    validator: validate_TrainCustomModel_564112, base: "",
    url: url_TrainCustomModel_564113, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
