
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

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
  macServiceName = "cognitiveservices-FormRecognizer"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_GetCustomModels_567880 = ref object of OpenApiRestCall_567658
proc url_GetCustomModels_567882(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetCustomModels_567881(path: JsonNode; query: JsonNode;
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

proc call*(call_567995: Call_GetCustomModels_567880; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get information about all trained custom models
  ## 
  let valid = call_567995.validator(path, query, header, formData, body)
  let scheme = call_567995.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_567995.url(scheme.get, call_567995.host, call_567995.base,
                         call_567995.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_567995, url, valid)

proc call*(call_568079: Call_GetCustomModels_567880): Recallable =
  ## getCustomModels
  ## Get information about all trained custom models
  result = call_568079.call(nil, nil, nil, nil, nil)

var getCustomModels* = Call_GetCustomModels_567880(name: "getCustomModels",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/custom/models",
    validator: validate_GetCustomModels_567881, base: "", url: url_GetCustomModels_567882,
    schemes: {Scheme.Https})
type
  Call_GetCustomModel_568117 = ref object of OpenApiRestCall_567658
proc url_GetCustomModel_568119(protocol: Scheme; host: string; base: string;
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

proc validate_GetCustomModel_568118(path: JsonNode; query: JsonNode;
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
  var valid_568180 = path.getOrDefault("id")
  valid_568180 = validateParameter(valid_568180, JString, required = true,
                                 default = nil)
  if valid_568180 != nil:
    section.add "id", valid_568180
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568181: Call_GetCustomModel_568117; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get information about a model.
  ## 
  let valid = call_568181.validator(path, query, header, formData, body)
  let scheme = call_568181.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568181.url(scheme.get, call_568181.host, call_568181.base,
                         call_568181.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568181, url, valid)

proc call*(call_568182: Call_GetCustomModel_568117; id: string): Recallable =
  ## getCustomModel
  ## Get information about a model.
  ##   id: string (required)
  ##     : Model identifier.
  var path_568183 = newJObject()
  add(path_568183, "id", newJString(id))
  result = call_568182.call(path_568183, nil, nil, nil, nil)

var getCustomModel* = Call_GetCustomModel_568117(name: "getCustomModel",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/custom/models/{id}",
    validator: validate_GetCustomModel_568118, base: "", url: url_GetCustomModel_568119,
    schemes: {Scheme.Https})
type
  Call_DeleteCustomModel_568186 = ref object of OpenApiRestCall_567658
proc url_DeleteCustomModel_568188(protocol: Scheme; host: string; base: string;
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

proc validate_DeleteCustomModel_568187(path: JsonNode; query: JsonNode;
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
  var valid_568189 = path.getOrDefault("id")
  valid_568189 = validateParameter(valid_568189, JString, required = true,
                                 default = nil)
  if valid_568189 != nil:
    section.add "id", valid_568189
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568190: Call_DeleteCustomModel_568186; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete model artifacts.
  ## 
  let valid = call_568190.validator(path, query, header, formData, body)
  let scheme = call_568190.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568190.url(scheme.get, call_568190.host, call_568190.base,
                         call_568190.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568190, url, valid)

proc call*(call_568191: Call_DeleteCustomModel_568186; id: string): Recallable =
  ## deleteCustomModel
  ## Delete model artifacts.
  ##   id: string (required)
  ##     : The identifier of the model to delete.
  var path_568192 = newJObject()
  add(path_568192, "id", newJString(id))
  result = call_568191.call(path_568192, nil, nil, nil, nil)

var deleteCustomModel* = Call_DeleteCustomModel_568186(name: "deleteCustomModel",
    meth: HttpMethod.HttpDelete, host: "azure.local", route: "/custom/models/{id}",
    validator: validate_DeleteCustomModel_568187, base: "",
    url: url_DeleteCustomModel_568188, schemes: {Scheme.Https})
type
  Call_AnalyzeWithCustomModel_568193 = ref object of OpenApiRestCall_567658
proc url_AnalyzeWithCustomModel_568195(protocol: Scheme; host: string; base: string;
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

proc validate_AnalyzeWithCustomModel_568194(path: JsonNode; query: JsonNode;
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
  var valid_568196 = path.getOrDefault("id")
  valid_568196 = validateParameter(valid_568196, JString, required = true,
                                 default = nil)
  if valid_568196 != nil:
    section.add "id", valid_568196
  result.add "path", section
  ## parameters in `query` object:
  ##   keys: JArray
  ##       : An optional list of known keys to extract the values for.
  section = newJObject()
  var valid_568197 = query.getOrDefault("keys")
  valid_568197 = validateParameter(valid_568197, JArray, required = false,
                                 default = nil)
  if valid_568197 != nil:
    section.add "keys", valid_568197
  result.add "query", section
  section = newJObject()
  result.add "header", section
  ## parameters in `formData` object:
  ##   form_stream: JString (required)
  ##              : A pdf document or image (jpg,png) file to analyze.
  section = newJObject()
  assert formData != nil,
        "formData argument is necessary due to required `form_stream` field"
  var valid_568198 = formData.getOrDefault("form_stream")
  valid_568198 = validateParameter(valid_568198, JString, required = true,
                                 default = nil)
  if valid_568198 != nil:
    section.add "form_stream", valid_568198
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568199: Call_AnalyzeWithCustomModel_568193; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Extract key-value pairs from a given document. The input document must be of one of the supported content types - 'application/pdf', 'image/jpeg' or 'image/png'. A success response is returned in JSON.
  ## 
  let valid = call_568199.validator(path, query, header, formData, body)
  let scheme = call_568199.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568199.url(scheme.get, call_568199.host, call_568199.base,
                         call_568199.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568199, url, valid)

proc call*(call_568200: Call_AnalyzeWithCustomModel_568193; id: string;
          formStream: string; keys: JsonNode = nil): Recallable =
  ## analyzeWithCustomModel
  ## Extract key-value pairs from a given document. The input document must be of one of the supported content types - 'application/pdf', 'image/jpeg' or 'image/png'. A success response is returned in JSON.
  ##   keys: JArray
  ##       : An optional list of known keys to extract the values for.
  ##   id: string (required)
  ##     : Model Identifier to analyze the document with.
  ##   formStream: string (required)
  ##             : A pdf document or image (jpg,png) file to analyze.
  var path_568201 = newJObject()
  var query_568202 = newJObject()
  var formData_568203 = newJObject()
  if keys != nil:
    query_568202.add "keys", keys
  add(path_568201, "id", newJString(id))
  add(formData_568203, "form_stream", newJString(formStream))
  result = call_568200.call(path_568201, query_568202, nil, formData_568203, nil)

var analyzeWithCustomModel* = Call_AnalyzeWithCustomModel_568193(
    name: "analyzeWithCustomModel", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/custom/models/{id}/analyze",
    validator: validate_AnalyzeWithCustomModel_568194, base: "",
    url: url_AnalyzeWithCustomModel_568195, schemes: {Scheme.Https})
type
  Call_GetExtractedKeys_568204 = ref object of OpenApiRestCall_567658
proc url_GetExtractedKeys_568206(protocol: Scheme; host: string; base: string;
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

proc validate_GetExtractedKeys_568205(path: JsonNode; query: JsonNode;
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
  var valid_568207 = path.getOrDefault("id")
  valid_568207 = validateParameter(valid_568207, JString, required = true,
                                 default = nil)
  if valid_568207 != nil:
    section.add "id", valid_568207
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568208: Call_GetExtractedKeys_568204; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve the keys that were
  ##  extracted during the training of the specified model.
  ## 
  let valid = call_568208.validator(path, query, header, formData, body)
  let scheme = call_568208.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568208.url(scheme.get, call_568208.host, call_568208.base,
                         call_568208.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568208, url, valid)

proc call*(call_568209: Call_GetExtractedKeys_568204; id: string): Recallable =
  ## getExtractedKeys
  ## Retrieve the keys that were
  ##  extracted during the training of the specified model.
  ##   id: string (required)
  ##     : Model identifier.
  var path_568210 = newJObject()
  add(path_568210, "id", newJString(id))
  result = call_568209.call(path_568210, nil, nil, nil, nil)

var getExtractedKeys* = Call_GetExtractedKeys_568204(name: "getExtractedKeys",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/custom/models/{id}/keys", validator: validate_GetExtractedKeys_568205,
    base: "", url: url_GetExtractedKeys_568206, schemes: {Scheme.Https})
type
  Call_TrainCustomModel_568211 = ref object of OpenApiRestCall_567658
proc url_TrainCustomModel_568213(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_TrainCustomModel_568212(path: JsonNode; query: JsonNode;
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

proc call*(call_568224: Call_TrainCustomModel_568211; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create and train a custom model. The train request must include a source parameter that is either an externally accessible Azure Storage blob container Uri (preferably a Shared Access Signature Uri) or valid path to a data folder in a locally mounted drive. When local paths are specified, they must follow the Linux/Unix path format and be an absolute path rooted to the input mount configuration
  ##  setting value e.g., if '{Mounts:Input}' configuration setting value is '/input' then a valid source path would be '/input/contosodataset'. All data to be trained is expected to be directly under the source folder. Subfolders are not supported. Models are trained using documents that are of the following content type - 'application/pdf', 'image/jpeg' and 'image/png'."
  ##  Other type of content is ignored.
  ## 
  let valid = call_568224.validator(path, query, header, formData, body)
  let scheme = call_568224.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568224.url(scheme.get, call_568224.host, call_568224.base,
                         call_568224.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568224, url, valid)

proc call*(call_568225: Call_TrainCustomModel_568211; trainRequest: JsonNode): Recallable =
  ## trainCustomModel
  ## Create and train a custom model. The train request must include a source parameter that is either an externally accessible Azure Storage blob container Uri (preferably a Shared Access Signature Uri) or valid path to a data folder in a locally mounted drive. When local paths are specified, they must follow the Linux/Unix path format and be an absolute path rooted to the input mount configuration
  ##  setting value e.g., if '{Mounts:Input}' configuration setting value is '/input' then a valid source path would be '/input/contosodataset'. All data to be trained is expected to be directly under the source folder. Subfolders are not supported. Models are trained using documents that are of the following content type - 'application/pdf', 'image/jpeg' and 'image/png'."
  ##  Other type of content is ignored.
  ##   trainRequest: JObject (required)
  ##               : Request object for training.
  var body_568226 = newJObject()
  if trainRequest != nil:
    body_568226 = trainRequest
  result = call_568225.call(nil, nil, nil, nil, body_568226)

var trainCustomModel* = Call_TrainCustomModel_568211(name: "trainCustomModel",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/custom/train",
    validator: validate_TrainCustomModel_568212, base: "",
    url: url_TrainCustomModel_568213, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
