
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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
  macServiceName = "cognitiveservices-FormRecognizer"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_GetCustomModels_593647 = ref object of OpenApiRestCall_593425
proc url_GetCustomModels_593649(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetCustomModels_593648(path: JsonNode; query: JsonNode;
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

proc call*(call_593762: Call_GetCustomModels_593647; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get information about all trained custom models
  ## 
  let valid = call_593762.validator(path, query, header, formData, body)
  let scheme = call_593762.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593762.url(scheme.get, call_593762.host, call_593762.base,
                         call_593762.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593762, url, valid)

proc call*(call_593846: Call_GetCustomModels_593647): Recallable =
  ## getCustomModels
  ## Get information about all trained custom models
  result = call_593846.call(nil, nil, nil, nil, nil)

var getCustomModels* = Call_GetCustomModels_593647(name: "getCustomModels",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/custom/models",
    validator: validate_GetCustomModels_593648, base: "", url: url_GetCustomModels_593649,
    schemes: {Scheme.Https})
type
  Call_GetCustomModel_593884 = ref object of OpenApiRestCall_593425
proc url_GetCustomModel_593886(protocol: Scheme; host: string; base: string;
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

proc validate_GetCustomModel_593885(path: JsonNode; query: JsonNode;
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
  var valid_593947 = path.getOrDefault("id")
  valid_593947 = validateParameter(valid_593947, JString, required = true,
                                 default = nil)
  if valid_593947 != nil:
    section.add "id", valid_593947
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593948: Call_GetCustomModel_593884; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get information about a model.
  ## 
  let valid = call_593948.validator(path, query, header, formData, body)
  let scheme = call_593948.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593948.url(scheme.get, call_593948.host, call_593948.base,
                         call_593948.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593948, url, valid)

proc call*(call_593949: Call_GetCustomModel_593884; id: string): Recallable =
  ## getCustomModel
  ## Get information about a model.
  ##   id: string (required)
  ##     : Model identifier.
  var path_593950 = newJObject()
  add(path_593950, "id", newJString(id))
  result = call_593949.call(path_593950, nil, nil, nil, nil)

var getCustomModel* = Call_GetCustomModel_593884(name: "getCustomModel",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/custom/models/{id}",
    validator: validate_GetCustomModel_593885, base: "", url: url_GetCustomModel_593886,
    schemes: {Scheme.Https})
type
  Call_DeleteCustomModel_593953 = ref object of OpenApiRestCall_593425
proc url_DeleteCustomModel_593955(protocol: Scheme; host: string; base: string;
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

proc validate_DeleteCustomModel_593954(path: JsonNode; query: JsonNode;
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
  var valid_593956 = path.getOrDefault("id")
  valid_593956 = validateParameter(valid_593956, JString, required = true,
                                 default = nil)
  if valid_593956 != nil:
    section.add "id", valid_593956
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593957: Call_DeleteCustomModel_593953; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete model artifacts.
  ## 
  let valid = call_593957.validator(path, query, header, formData, body)
  let scheme = call_593957.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593957.url(scheme.get, call_593957.host, call_593957.base,
                         call_593957.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593957, url, valid)

proc call*(call_593958: Call_DeleteCustomModel_593953; id: string): Recallable =
  ## deleteCustomModel
  ## Delete model artifacts.
  ##   id: string (required)
  ##     : The identifier of the model to delete.
  var path_593959 = newJObject()
  add(path_593959, "id", newJString(id))
  result = call_593958.call(path_593959, nil, nil, nil, nil)

var deleteCustomModel* = Call_DeleteCustomModel_593953(name: "deleteCustomModel",
    meth: HttpMethod.HttpDelete, host: "azure.local", route: "/custom/models/{id}",
    validator: validate_DeleteCustomModel_593954, base: "",
    url: url_DeleteCustomModel_593955, schemes: {Scheme.Https})
type
  Call_AnalyzeWithCustomModel_593960 = ref object of OpenApiRestCall_593425
proc url_AnalyzeWithCustomModel_593962(protocol: Scheme; host: string; base: string;
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

proc validate_AnalyzeWithCustomModel_593961(path: JsonNode; query: JsonNode;
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
  var valid_593963 = path.getOrDefault("id")
  valid_593963 = validateParameter(valid_593963, JString, required = true,
                                 default = nil)
  if valid_593963 != nil:
    section.add "id", valid_593963
  result.add "path", section
  ## parameters in `query` object:
  ##   keys: JArray
  ##       : An optional list of known keys to extract the values for.
  section = newJObject()
  var valid_593964 = query.getOrDefault("keys")
  valid_593964 = validateParameter(valid_593964, JArray, required = false,
                                 default = nil)
  if valid_593964 != nil:
    section.add "keys", valid_593964
  result.add "query", section
  section = newJObject()
  result.add "header", section
  ## parameters in `formData` object:
  ##   form_stream: JString (required)
  ##              : A pdf document or image (jpg,png) file to analyze.
  section = newJObject()
  assert formData != nil,
        "formData argument is necessary due to required `form_stream` field"
  var valid_593965 = formData.getOrDefault("form_stream")
  valid_593965 = validateParameter(valid_593965, JString, required = true,
                                 default = nil)
  if valid_593965 != nil:
    section.add "form_stream", valid_593965
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593966: Call_AnalyzeWithCustomModel_593960; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Extract key-value pairs from a given document. The input document must be of one of the supported content types - 'application/pdf', 'image/jpeg' or 'image/png'. A success response is returned in JSON.
  ## 
  let valid = call_593966.validator(path, query, header, formData, body)
  let scheme = call_593966.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593966.url(scheme.get, call_593966.host, call_593966.base,
                         call_593966.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593966, url, valid)

proc call*(call_593967: Call_AnalyzeWithCustomModel_593960; id: string;
          formStream: string; keys: JsonNode = nil): Recallable =
  ## analyzeWithCustomModel
  ## Extract key-value pairs from a given document. The input document must be of one of the supported content types - 'application/pdf', 'image/jpeg' or 'image/png'. A success response is returned in JSON.
  ##   keys: JArray
  ##       : An optional list of known keys to extract the values for.
  ##   id: string (required)
  ##     : Model Identifier to analyze the document with.
  ##   formStream: string (required)
  ##             : A pdf document or image (jpg,png) file to analyze.
  var path_593968 = newJObject()
  var query_593969 = newJObject()
  var formData_593970 = newJObject()
  if keys != nil:
    query_593969.add "keys", keys
  add(path_593968, "id", newJString(id))
  add(formData_593970, "form_stream", newJString(formStream))
  result = call_593967.call(path_593968, query_593969, nil, formData_593970, nil)

var analyzeWithCustomModel* = Call_AnalyzeWithCustomModel_593960(
    name: "analyzeWithCustomModel", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/custom/models/{id}/analyze",
    validator: validate_AnalyzeWithCustomModel_593961, base: "",
    url: url_AnalyzeWithCustomModel_593962, schemes: {Scheme.Https})
type
  Call_GetExtractedKeys_593971 = ref object of OpenApiRestCall_593425
proc url_GetExtractedKeys_593973(protocol: Scheme; host: string; base: string;
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

proc validate_GetExtractedKeys_593972(path: JsonNode; query: JsonNode;
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
  var valid_593974 = path.getOrDefault("id")
  valid_593974 = validateParameter(valid_593974, JString, required = true,
                                 default = nil)
  if valid_593974 != nil:
    section.add "id", valid_593974
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593975: Call_GetExtractedKeys_593971; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve the keys that were
  ##  extracted during the training of the specified model.
  ## 
  let valid = call_593975.validator(path, query, header, formData, body)
  let scheme = call_593975.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593975.url(scheme.get, call_593975.host, call_593975.base,
                         call_593975.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593975, url, valid)

proc call*(call_593976: Call_GetExtractedKeys_593971; id: string): Recallable =
  ## getExtractedKeys
  ## Retrieve the keys that were
  ##  extracted during the training of the specified model.
  ##   id: string (required)
  ##     : Model identifier.
  var path_593977 = newJObject()
  add(path_593977, "id", newJString(id))
  result = call_593976.call(path_593977, nil, nil, nil, nil)

var getExtractedKeys* = Call_GetExtractedKeys_593971(name: "getExtractedKeys",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/custom/models/{id}/keys", validator: validate_GetExtractedKeys_593972,
    base: "", url: url_GetExtractedKeys_593973, schemes: {Scheme.Https})
type
  Call_TrainCustomModel_593978 = ref object of OpenApiRestCall_593425
proc url_TrainCustomModel_593980(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_TrainCustomModel_593979(path: JsonNode; query: JsonNode;
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

proc call*(call_593991: Call_TrainCustomModel_593978; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create and train a custom model. The train request must include a source parameter that is either an externally accessible Azure Storage blob container Uri (preferably a Shared Access Signature Uri) or valid path to a data folder in a locally mounted drive. When local paths are specified, they must follow the Linux/Unix path format and be an absolute path rooted to the input mount configuration
  ##  setting value e.g., if '{Mounts:Input}' configuration setting value is '/input' then a valid source path would be '/input/contosodataset'. All data to be trained is expected to be directly under the source folder. Subfolders are not supported. Models are trained using documents that are of the following content type - 'application/pdf', 'image/jpeg' and 'image/png'."
  ##  Other type of content is ignored.
  ## 
  let valid = call_593991.validator(path, query, header, formData, body)
  let scheme = call_593991.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593991.url(scheme.get, call_593991.host, call_593991.base,
                         call_593991.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593991, url, valid)

proc call*(call_593992: Call_TrainCustomModel_593978; trainRequest: JsonNode): Recallable =
  ## trainCustomModel
  ## Create and train a custom model. The train request must include a source parameter that is either an externally accessible Azure Storage blob container Uri (preferably a Shared Access Signature Uri) or valid path to a data folder in a locally mounted drive. When local paths are specified, they must follow the Linux/Unix path format and be an absolute path rooted to the input mount configuration
  ##  setting value e.g., if '{Mounts:Input}' configuration setting value is '/input' then a valid source path would be '/input/contosodataset'. All data to be trained is expected to be directly under the source folder. Subfolders are not supported. Models are trained using documents that are of the following content type - 'application/pdf', 'image/jpeg' and 'image/png'."
  ##  Other type of content is ignored.
  ##   trainRequest: JObject (required)
  ##               : Request object for training.
  var body_593993 = newJObject()
  if trainRequest != nil:
    body_593993 = trainRequest
  result = call_593992.call(nil, nil, nil, nil, body_593993)

var trainCustomModel* = Call_TrainCustomModel_593978(name: "trainCustomModel",
    meth: HttpMethod.HttpPost, host: "azure.local", route: "/custom/train",
    validator: validate_TrainCustomModel_593979, base: "",
    url: url_TrainCustomModel_593980, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
