
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Content Moderator Client
## version: 1.0
## termsOfService: (not provided)
## license: (not provided)
## 
## You use the API to scan your content as it is generated. Content Moderator then processes your content and sends the results along with relevant information either back to your systems or to the built-in review tool. You can use this information to take decisions e.g. take it down, send to human judge, etc.
## 
## When using the API, images need to have a minimum of 128 pixels and a maximum file size of 4MB. 
## Text can be at most 1024 characters long. 
## If the content passed to the text API or the image API exceeds the size limits, the API will return an error code that informs about the issue.
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
  macServiceName = "cognitiveservices-ContentModerator"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ListManagementImageListsCreate_568117 = ref object of OpenApiRestCall_567658
proc url_ListManagementImageListsCreate_568119(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ListManagementImageListsCreate_568118(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates an image list.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  section = newJObject()
  result.add "query", section
  ## parameters in `header` object:
  ##   Content-Type: JString (required)
  ##               : The content type.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `Content-Type` field"
  var valid_568175 = header.getOrDefault("Content-Type")
  valid_568175 = validateParameter(valid_568175, JString, required = true,
                                 default = nil)
  if valid_568175 != nil:
    section.add "Content-Type", valid_568175
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : Schema of the body.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568177: Call_ListManagementImageListsCreate_568117; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates an image list.
  ## 
  let valid = call_568177.validator(path, query, header, formData, body)
  let scheme = call_568177.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568177.url(scheme.get, call_568177.host, call_568177.base,
                         call_568177.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568177, url, valid)

proc call*(call_568178: Call_ListManagementImageListsCreate_568117; body: JsonNode): Recallable =
  ## listManagementImageListsCreate
  ## Creates an image list.
  ##   body: JObject (required)
  ##       : Schema of the body.
  var body_568179 = newJObject()
  if body != nil:
    body_568179 = body
  result = call_568178.call(nil, nil, nil, nil, body_568179)

var listManagementImageListsCreate* = Call_ListManagementImageListsCreate_568117(
    name: "listManagementImageListsCreate", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/contentmoderator/lists/v1.0/imagelists",
    validator: validate_ListManagementImageListsCreate_568118, base: "",
    url: url_ListManagementImageListsCreate_568119, schemes: {Scheme.Https})
type
  Call_ListManagementImageListsGetAllImageLists_567880 = ref object of OpenApiRestCall_567658
proc url_ListManagementImageListsGetAllImageLists_567882(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ListManagementImageListsGetAllImageLists_567881(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the Image Lists.
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

proc call*(call_567995: Call_ListManagementImageListsGetAllImageLists_567880;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all the Image Lists.
  ## 
  let valid = call_567995.validator(path, query, header, formData, body)
  let scheme = call_567995.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_567995.url(scheme.get, call_567995.host, call_567995.base,
                         call_567995.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_567995, url, valid)

proc call*(call_568079: Call_ListManagementImageListsGetAllImageLists_567880): Recallable =
  ## listManagementImageListsGetAllImageLists
  ## Gets all the Image Lists.
  result = call_568079.call(nil, nil, nil, nil, nil)

var listManagementImageListsGetAllImageLists* = Call_ListManagementImageListsGetAllImageLists_567880(
    name: "listManagementImageListsGetAllImageLists", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/contentmoderator/lists/v1.0/imagelists",
    validator: validate_ListManagementImageListsGetAllImageLists_567881, base: "",
    url: url_ListManagementImageListsGetAllImageLists_567882,
    schemes: {Scheme.Https})
type
  Call_ListManagementImageListsUpdate_568203 = ref object of OpenApiRestCall_567658
proc url_ListManagementImageListsUpdate_568205(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "listId" in path, "`listId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/contentmoderator/lists/v1.0/imagelists/"),
               (kind: VariableSegment, value: "listId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ListManagementImageListsUpdate_568204(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an image list with list Id equal to list Id passed.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   listId: JString (required)
  ##         : List Id of the image list.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `listId` field"
  var valid_568206 = path.getOrDefault("listId")
  valid_568206 = validateParameter(valid_568206, JString, required = true,
                                 default = nil)
  if valid_568206 != nil:
    section.add "listId", valid_568206
  result.add "path", section
  section = newJObject()
  result.add "query", section
  ## parameters in `header` object:
  ##   Content-Type: JString (required)
  ##               : The content type.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `Content-Type` field"
  var valid_568207 = header.getOrDefault("Content-Type")
  valid_568207 = validateParameter(valid_568207, JString, required = true,
                                 default = nil)
  if valid_568207 != nil:
    section.add "Content-Type", valid_568207
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : Schema of the body.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568209: Call_ListManagementImageListsUpdate_568203; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an image list with list Id equal to list Id passed.
  ## 
  let valid = call_568209.validator(path, query, header, formData, body)
  let scheme = call_568209.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568209.url(scheme.get, call_568209.host, call_568209.base,
                         call_568209.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568209, url, valid)

proc call*(call_568210: Call_ListManagementImageListsUpdate_568203; listId: string;
          body: JsonNode): Recallable =
  ## listManagementImageListsUpdate
  ## Updates an image list with list Id equal to list Id passed.
  ##   listId: string (required)
  ##         : List Id of the image list.
  ##   body: JObject (required)
  ##       : Schema of the body.
  var path_568211 = newJObject()
  var body_568212 = newJObject()
  add(path_568211, "listId", newJString(listId))
  if body != nil:
    body_568212 = body
  result = call_568210.call(path_568211, nil, nil, nil, body_568212)

var listManagementImageListsUpdate* = Call_ListManagementImageListsUpdate_568203(
    name: "listManagementImageListsUpdate", meth: HttpMethod.HttpPut,
    host: "azure.local",
    route: "/contentmoderator/lists/v1.0/imagelists/{listId}",
    validator: validate_ListManagementImageListsUpdate_568204, base: "",
    url: url_ListManagementImageListsUpdate_568205, schemes: {Scheme.Https})
type
  Call_ListManagementImageListsGetDetails_568181 = ref object of OpenApiRestCall_567658
proc url_ListManagementImageListsGetDetails_568183(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "listId" in path, "`listId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/contentmoderator/lists/v1.0/imagelists/"),
               (kind: VariableSegment, value: "listId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ListManagementImageListsGetDetails_568182(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the details of the image list with list Id equal to list Id passed.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   listId: JString (required)
  ##         : List Id of the image list.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `listId` field"
  var valid_568198 = path.getOrDefault("listId")
  valid_568198 = validateParameter(valid_568198, JString, required = true,
                                 default = nil)
  if valid_568198 != nil:
    section.add "listId", valid_568198
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568199: Call_ListManagementImageListsGetDetails_568181;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns the details of the image list with list Id equal to list Id passed.
  ## 
  let valid = call_568199.validator(path, query, header, formData, body)
  let scheme = call_568199.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568199.url(scheme.get, call_568199.host, call_568199.base,
                         call_568199.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568199, url, valid)

proc call*(call_568200: Call_ListManagementImageListsGetDetails_568181;
          listId: string): Recallable =
  ## listManagementImageListsGetDetails
  ## Returns the details of the image list with list Id equal to list Id passed.
  ##   listId: string (required)
  ##         : List Id of the image list.
  var path_568201 = newJObject()
  add(path_568201, "listId", newJString(listId))
  result = call_568200.call(path_568201, nil, nil, nil, nil)

var listManagementImageListsGetDetails* = Call_ListManagementImageListsGetDetails_568181(
    name: "listManagementImageListsGetDetails", meth: HttpMethod.HttpGet,
    host: "azure.local",
    route: "/contentmoderator/lists/v1.0/imagelists/{listId}",
    validator: validate_ListManagementImageListsGetDetails_568182, base: "",
    url: url_ListManagementImageListsGetDetails_568183, schemes: {Scheme.Https})
type
  Call_ListManagementImageListsDelete_568213 = ref object of OpenApiRestCall_567658
proc url_ListManagementImageListsDelete_568215(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "listId" in path, "`listId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/contentmoderator/lists/v1.0/imagelists/"),
               (kind: VariableSegment, value: "listId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ListManagementImageListsDelete_568214(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes image list with the list Id equal to list Id passed.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   listId: JString (required)
  ##         : List Id of the image list.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `listId` field"
  var valid_568216 = path.getOrDefault("listId")
  valid_568216 = validateParameter(valid_568216, JString, required = true,
                                 default = nil)
  if valid_568216 != nil:
    section.add "listId", valid_568216
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568217: Call_ListManagementImageListsDelete_568213; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes image list with the list Id equal to list Id passed.
  ## 
  let valid = call_568217.validator(path, query, header, formData, body)
  let scheme = call_568217.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568217.url(scheme.get, call_568217.host, call_568217.base,
                         call_568217.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568217, url, valid)

proc call*(call_568218: Call_ListManagementImageListsDelete_568213; listId: string): Recallable =
  ## listManagementImageListsDelete
  ## Deletes image list with the list Id equal to list Id passed.
  ##   listId: string (required)
  ##         : List Id of the image list.
  var path_568219 = newJObject()
  add(path_568219, "listId", newJString(listId))
  result = call_568218.call(path_568219, nil, nil, nil, nil)

var listManagementImageListsDelete* = Call_ListManagementImageListsDelete_568213(
    name: "listManagementImageListsDelete", meth: HttpMethod.HttpDelete,
    host: "azure.local",
    route: "/contentmoderator/lists/v1.0/imagelists/{listId}",
    validator: validate_ListManagementImageListsDelete_568214, base: "",
    url: url_ListManagementImageListsDelete_568215, schemes: {Scheme.Https})
type
  Call_ListManagementImageListsRefreshIndex_568220 = ref object of OpenApiRestCall_567658
proc url_ListManagementImageListsRefreshIndex_568222(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "listId" in path, "`listId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/contentmoderator/lists/v1.0/imagelists/"),
               (kind: VariableSegment, value: "listId"),
               (kind: ConstantSegment, value: "/RefreshIndex")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ListManagementImageListsRefreshIndex_568221(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Refreshes the index of the list with list Id equal to list Id passed.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   listId: JString (required)
  ##         : List Id of the image list.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `listId` field"
  var valid_568223 = path.getOrDefault("listId")
  valid_568223 = validateParameter(valid_568223, JString, required = true,
                                 default = nil)
  if valid_568223 != nil:
    section.add "listId", valid_568223
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568224: Call_ListManagementImageListsRefreshIndex_568220;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Refreshes the index of the list with list Id equal to list Id passed.
  ## 
  let valid = call_568224.validator(path, query, header, formData, body)
  let scheme = call_568224.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568224.url(scheme.get, call_568224.host, call_568224.base,
                         call_568224.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568224, url, valid)

proc call*(call_568225: Call_ListManagementImageListsRefreshIndex_568220;
          listId: string): Recallable =
  ## listManagementImageListsRefreshIndex
  ## Refreshes the index of the list with list Id equal to list Id passed.
  ##   listId: string (required)
  ##         : List Id of the image list.
  var path_568226 = newJObject()
  add(path_568226, "listId", newJString(listId))
  result = call_568225.call(path_568226, nil, nil, nil, nil)

var listManagementImageListsRefreshIndex* = Call_ListManagementImageListsRefreshIndex_568220(
    name: "listManagementImageListsRefreshIndex", meth: HttpMethod.HttpPost,
    host: "azure.local",
    route: "/contentmoderator/lists/v1.0/imagelists/{listId}/RefreshIndex",
    validator: validate_ListManagementImageListsRefreshIndex_568221, base: "",
    url: url_ListManagementImageListsRefreshIndex_568222, schemes: {Scheme.Https})
type
  Call_ListManagementImageAddImage_568234 = ref object of OpenApiRestCall_567658
proc url_ListManagementImageAddImage_568236(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "listId" in path, "`listId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/contentmoderator/lists/v1.0/imagelists/"),
               (kind: VariableSegment, value: "listId"),
               (kind: ConstantSegment, value: "/images")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ListManagementImageAddImage_568235(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Add an image to the list with list Id equal to list Id passed.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   listId: JString (required)
  ##         : List Id of the image list.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `listId` field"
  var valid_568237 = path.getOrDefault("listId")
  valid_568237 = validateParameter(valid_568237, JString, required = true,
                                 default = nil)
  if valid_568237 != nil:
    section.add "listId", valid_568237
  result.add "path", section
  ## parameters in `query` object:
  ##   tag: JInt
  ##      : Tag for the image.
  ##   label: JString
  ##        : The image label.
  section = newJObject()
  var valid_568238 = query.getOrDefault("tag")
  valid_568238 = validateParameter(valid_568238, JInt, required = false, default = nil)
  if valid_568238 != nil:
    section.add "tag", valid_568238
  var valid_568239 = query.getOrDefault("label")
  valid_568239 = validateParameter(valid_568239, JString, required = false,
                                 default = nil)
  if valid_568239 != nil:
    section.add "label", valid_568239
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568240: Call_ListManagementImageAddImage_568234; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Add an image to the list with list Id equal to list Id passed.
  ## 
  let valid = call_568240.validator(path, query, header, formData, body)
  let scheme = call_568240.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568240.url(scheme.get, call_568240.host, call_568240.base,
                         call_568240.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568240, url, valid)

proc call*(call_568241: Call_ListManagementImageAddImage_568234; listId: string;
          tag: int = 0; label: string = ""): Recallable =
  ## listManagementImageAddImage
  ## Add an image to the list with list Id equal to list Id passed.
  ##   tag: int
  ##      : Tag for the image.
  ##   label: string
  ##        : The image label.
  ##   listId: string (required)
  ##         : List Id of the image list.
  var path_568242 = newJObject()
  var query_568243 = newJObject()
  add(query_568243, "tag", newJInt(tag))
  add(query_568243, "label", newJString(label))
  add(path_568242, "listId", newJString(listId))
  result = call_568241.call(path_568242, query_568243, nil, nil, nil)

var listManagementImageAddImage* = Call_ListManagementImageAddImage_568234(
    name: "listManagementImageAddImage", meth: HttpMethod.HttpPost,
    host: "azure.local",
    route: "/contentmoderator/lists/v1.0/imagelists/{listId}/images",
    validator: validate_ListManagementImageAddImage_568235, base: "",
    url: url_ListManagementImageAddImage_568236, schemes: {Scheme.Https})
type
  Call_ListManagementImageGetAllImageIds_568227 = ref object of OpenApiRestCall_567658
proc url_ListManagementImageGetAllImageIds_568229(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "listId" in path, "`listId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/contentmoderator/lists/v1.0/imagelists/"),
               (kind: VariableSegment, value: "listId"),
               (kind: ConstantSegment, value: "/images")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ListManagementImageGetAllImageIds_568228(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all image Ids from the list with list Id equal to list Id passed.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   listId: JString (required)
  ##         : List Id of the image list.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `listId` field"
  var valid_568230 = path.getOrDefault("listId")
  valid_568230 = validateParameter(valid_568230, JString, required = true,
                                 default = nil)
  if valid_568230 != nil:
    section.add "listId", valid_568230
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568231: Call_ListManagementImageGetAllImageIds_568227;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all image Ids from the list with list Id equal to list Id passed.
  ## 
  let valid = call_568231.validator(path, query, header, formData, body)
  let scheme = call_568231.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568231.url(scheme.get, call_568231.host, call_568231.base,
                         call_568231.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568231, url, valid)

proc call*(call_568232: Call_ListManagementImageGetAllImageIds_568227;
          listId: string): Recallable =
  ## listManagementImageGetAllImageIds
  ## Gets all image Ids from the list with list Id equal to list Id passed.
  ##   listId: string (required)
  ##         : List Id of the image list.
  var path_568233 = newJObject()
  add(path_568233, "listId", newJString(listId))
  result = call_568232.call(path_568233, nil, nil, nil, nil)

var listManagementImageGetAllImageIds* = Call_ListManagementImageGetAllImageIds_568227(
    name: "listManagementImageGetAllImageIds", meth: HttpMethod.HttpGet,
    host: "azure.local",
    route: "/contentmoderator/lists/v1.0/imagelists/{listId}/images",
    validator: validate_ListManagementImageGetAllImageIds_568228, base: "",
    url: url_ListManagementImageGetAllImageIds_568229, schemes: {Scheme.Https})
type
  Call_ListManagementImageDeleteAllImages_568244 = ref object of OpenApiRestCall_567658
proc url_ListManagementImageDeleteAllImages_568246(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "listId" in path, "`listId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/contentmoderator/lists/v1.0/imagelists/"),
               (kind: VariableSegment, value: "listId"),
               (kind: ConstantSegment, value: "/images")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ListManagementImageDeleteAllImages_568245(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes all images from the list with list Id equal to list Id passed.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   listId: JString (required)
  ##         : List Id of the image list.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `listId` field"
  var valid_568247 = path.getOrDefault("listId")
  valid_568247 = validateParameter(valid_568247, JString, required = true,
                                 default = nil)
  if valid_568247 != nil:
    section.add "listId", valid_568247
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568248: Call_ListManagementImageDeleteAllImages_568244;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes all images from the list with list Id equal to list Id passed.
  ## 
  let valid = call_568248.validator(path, query, header, formData, body)
  let scheme = call_568248.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568248.url(scheme.get, call_568248.host, call_568248.base,
                         call_568248.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568248, url, valid)

proc call*(call_568249: Call_ListManagementImageDeleteAllImages_568244;
          listId: string): Recallable =
  ## listManagementImageDeleteAllImages
  ## Deletes all images from the list with list Id equal to list Id passed.
  ##   listId: string (required)
  ##         : List Id of the image list.
  var path_568250 = newJObject()
  add(path_568250, "listId", newJString(listId))
  result = call_568249.call(path_568250, nil, nil, nil, nil)

var listManagementImageDeleteAllImages* = Call_ListManagementImageDeleteAllImages_568244(
    name: "listManagementImageDeleteAllImages", meth: HttpMethod.HttpDelete,
    host: "azure.local",
    route: "/contentmoderator/lists/v1.0/imagelists/{listId}/images",
    validator: validate_ListManagementImageDeleteAllImages_568245, base: "",
    url: url_ListManagementImageDeleteAllImages_568246, schemes: {Scheme.Https})
type
  Call_ListManagementImageDeleteImage_568251 = ref object of OpenApiRestCall_567658
proc url_ListManagementImageDeleteImage_568253(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "listId" in path, "`listId` is a required path parameter"
  assert "ImageId" in path, "`ImageId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/contentmoderator/lists/v1.0/imagelists/"),
               (kind: VariableSegment, value: "listId"),
               (kind: ConstantSegment, value: "/images/"),
               (kind: VariableSegment, value: "ImageId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ListManagementImageDeleteImage_568252(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an image from the list with list Id and image Id passed.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   listId: JString (required)
  ##         : List Id of the image list.
  ##   ImageId: JString (required)
  ##          : Id of the image.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `listId` field"
  var valid_568254 = path.getOrDefault("listId")
  valid_568254 = validateParameter(valid_568254, JString, required = true,
                                 default = nil)
  if valid_568254 != nil:
    section.add "listId", valid_568254
  var valid_568255 = path.getOrDefault("ImageId")
  valid_568255 = validateParameter(valid_568255, JString, required = true,
                                 default = nil)
  if valid_568255 != nil:
    section.add "ImageId", valid_568255
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568256: Call_ListManagementImageDeleteImage_568251; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an image from the list with list Id and image Id passed.
  ## 
  let valid = call_568256.validator(path, query, header, formData, body)
  let scheme = call_568256.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568256.url(scheme.get, call_568256.host, call_568256.base,
                         call_568256.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568256, url, valid)

proc call*(call_568257: Call_ListManagementImageDeleteImage_568251; listId: string;
          ImageId: string): Recallable =
  ## listManagementImageDeleteImage
  ## Deletes an image from the list with list Id and image Id passed.
  ##   listId: string (required)
  ##         : List Id of the image list.
  ##   ImageId: string (required)
  ##          : Id of the image.
  var path_568258 = newJObject()
  add(path_568258, "listId", newJString(listId))
  add(path_568258, "ImageId", newJString(ImageId))
  result = call_568257.call(path_568258, nil, nil, nil, nil)

var listManagementImageDeleteImage* = Call_ListManagementImageDeleteImage_568251(
    name: "listManagementImageDeleteImage", meth: HttpMethod.HttpDelete,
    host: "azure.local",
    route: "/contentmoderator/lists/v1.0/imagelists/{listId}/images/{ImageId}",
    validator: validate_ListManagementImageDeleteImage_568252, base: "",
    url: url_ListManagementImageDeleteImage_568253, schemes: {Scheme.Https})
type
  Call_ListManagementTermListsCreate_568264 = ref object of OpenApiRestCall_567658
proc url_ListManagementTermListsCreate_568266(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ListManagementTermListsCreate_568265(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a Term List
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  section = newJObject()
  result.add "query", section
  ## parameters in `header` object:
  ##   Content-Type: JString (required)
  ##               : The content type.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `Content-Type` field"
  var valid_568267 = header.getOrDefault("Content-Type")
  valid_568267 = validateParameter(valid_568267, JString, required = true,
                                 default = nil)
  if valid_568267 != nil:
    section.add "Content-Type", valid_568267
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : Schema of the body.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568269: Call_ListManagementTermListsCreate_568264; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a Term List
  ## 
  let valid = call_568269.validator(path, query, header, formData, body)
  let scheme = call_568269.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568269.url(scheme.get, call_568269.host, call_568269.base,
                         call_568269.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568269, url, valid)

proc call*(call_568270: Call_ListManagementTermListsCreate_568264; body: JsonNode): Recallable =
  ## listManagementTermListsCreate
  ## Creates a Term List
  ##   body: JObject (required)
  ##       : Schema of the body.
  var body_568271 = newJObject()
  if body != nil:
    body_568271 = body
  result = call_568270.call(nil, nil, nil, nil, body_568271)

var listManagementTermListsCreate* = Call_ListManagementTermListsCreate_568264(
    name: "listManagementTermListsCreate", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/contentmoderator/lists/v1.0/termlists",
    validator: validate_ListManagementTermListsCreate_568265, base: "",
    url: url_ListManagementTermListsCreate_568266, schemes: {Scheme.Https})
type
  Call_ListManagementTermListsGetAllTermLists_568259 = ref object of OpenApiRestCall_567658
proc url_ListManagementTermListsGetAllTermLists_568261(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ListManagementTermListsGetAllTermLists_568260(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## gets all the Term Lists
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

proc call*(call_568262: Call_ListManagementTermListsGetAllTermLists_568259;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## gets all the Term Lists
  ## 
  let valid = call_568262.validator(path, query, header, formData, body)
  let scheme = call_568262.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568262.url(scheme.get, call_568262.host, call_568262.base,
                         call_568262.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568262, url, valid)

proc call*(call_568263: Call_ListManagementTermListsGetAllTermLists_568259): Recallable =
  ## listManagementTermListsGetAllTermLists
  ## gets all the Term Lists
  result = call_568263.call(nil, nil, nil, nil, nil)

var listManagementTermListsGetAllTermLists* = Call_ListManagementTermListsGetAllTermLists_568259(
    name: "listManagementTermListsGetAllTermLists", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/contentmoderator/lists/v1.0/termlists",
    validator: validate_ListManagementTermListsGetAllTermLists_568260, base: "",
    url: url_ListManagementTermListsGetAllTermLists_568261,
    schemes: {Scheme.Https})
type
  Call_ListManagementTermListsUpdate_568279 = ref object of OpenApiRestCall_567658
proc url_ListManagementTermListsUpdate_568281(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "listId" in path, "`listId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/contentmoderator/lists/v1.0/termlists/"),
               (kind: VariableSegment, value: "listId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ListManagementTermListsUpdate_568280(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an Term List.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   listId: JString (required)
  ##         : List Id of the image list.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `listId` field"
  var valid_568282 = path.getOrDefault("listId")
  valid_568282 = validateParameter(valid_568282, JString, required = true,
                                 default = nil)
  if valid_568282 != nil:
    section.add "listId", valid_568282
  result.add "path", section
  section = newJObject()
  result.add "query", section
  ## parameters in `header` object:
  ##   Content-Type: JString (required)
  ##               : The content type.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `Content-Type` field"
  var valid_568283 = header.getOrDefault("Content-Type")
  valid_568283 = validateParameter(valid_568283, JString, required = true,
                                 default = nil)
  if valid_568283 != nil:
    section.add "Content-Type", valid_568283
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : Schema of the body.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568285: Call_ListManagementTermListsUpdate_568279; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an Term List.
  ## 
  let valid = call_568285.validator(path, query, header, formData, body)
  let scheme = call_568285.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568285.url(scheme.get, call_568285.host, call_568285.base,
                         call_568285.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568285, url, valid)

proc call*(call_568286: Call_ListManagementTermListsUpdate_568279; listId: string;
          body: JsonNode): Recallable =
  ## listManagementTermListsUpdate
  ## Updates an Term List.
  ##   listId: string (required)
  ##         : List Id of the image list.
  ##   body: JObject (required)
  ##       : Schema of the body.
  var path_568287 = newJObject()
  var body_568288 = newJObject()
  add(path_568287, "listId", newJString(listId))
  if body != nil:
    body_568288 = body
  result = call_568286.call(path_568287, nil, nil, nil, body_568288)

var listManagementTermListsUpdate* = Call_ListManagementTermListsUpdate_568279(
    name: "listManagementTermListsUpdate", meth: HttpMethod.HttpPut,
    host: "azure.local", route: "/contentmoderator/lists/v1.0/termlists/{listId}",
    validator: validate_ListManagementTermListsUpdate_568280, base: "",
    url: url_ListManagementTermListsUpdate_568281, schemes: {Scheme.Https})
type
  Call_ListManagementTermListsGetDetails_568272 = ref object of OpenApiRestCall_567658
proc url_ListManagementTermListsGetDetails_568274(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "listId" in path, "`listId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/contentmoderator/lists/v1.0/termlists/"),
               (kind: VariableSegment, value: "listId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ListManagementTermListsGetDetails_568273(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns list Id details of the term list with list Id equal to list Id passed.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   listId: JString (required)
  ##         : List Id of the image list.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `listId` field"
  var valid_568275 = path.getOrDefault("listId")
  valid_568275 = validateParameter(valid_568275, JString, required = true,
                                 default = nil)
  if valid_568275 != nil:
    section.add "listId", valid_568275
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568276: Call_ListManagementTermListsGetDetails_568272;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns list Id details of the term list with list Id equal to list Id passed.
  ## 
  let valid = call_568276.validator(path, query, header, formData, body)
  let scheme = call_568276.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568276.url(scheme.get, call_568276.host, call_568276.base,
                         call_568276.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568276, url, valid)

proc call*(call_568277: Call_ListManagementTermListsGetDetails_568272;
          listId: string): Recallable =
  ## listManagementTermListsGetDetails
  ## Returns list Id details of the term list with list Id equal to list Id passed.
  ##   listId: string (required)
  ##         : List Id of the image list.
  var path_568278 = newJObject()
  add(path_568278, "listId", newJString(listId))
  result = call_568277.call(path_568278, nil, nil, nil, nil)

var listManagementTermListsGetDetails* = Call_ListManagementTermListsGetDetails_568272(
    name: "listManagementTermListsGetDetails", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/contentmoderator/lists/v1.0/termlists/{listId}",
    validator: validate_ListManagementTermListsGetDetails_568273, base: "",
    url: url_ListManagementTermListsGetDetails_568274, schemes: {Scheme.Https})
type
  Call_ListManagementTermListsDelete_568289 = ref object of OpenApiRestCall_567658
proc url_ListManagementTermListsDelete_568291(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "listId" in path, "`listId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/contentmoderator/lists/v1.0/termlists/"),
               (kind: VariableSegment, value: "listId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ListManagementTermListsDelete_568290(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes term list with the list Id equal to list Id passed.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   listId: JString (required)
  ##         : List Id of the image list.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `listId` field"
  var valid_568292 = path.getOrDefault("listId")
  valid_568292 = validateParameter(valid_568292, JString, required = true,
                                 default = nil)
  if valid_568292 != nil:
    section.add "listId", valid_568292
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568293: Call_ListManagementTermListsDelete_568289; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes term list with the list Id equal to list Id passed.
  ## 
  let valid = call_568293.validator(path, query, header, formData, body)
  let scheme = call_568293.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568293.url(scheme.get, call_568293.host, call_568293.base,
                         call_568293.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568293, url, valid)

proc call*(call_568294: Call_ListManagementTermListsDelete_568289; listId: string): Recallable =
  ## listManagementTermListsDelete
  ## Deletes term list with the list Id equal to list Id passed.
  ##   listId: string (required)
  ##         : List Id of the image list.
  var path_568295 = newJObject()
  add(path_568295, "listId", newJString(listId))
  result = call_568294.call(path_568295, nil, nil, nil, nil)

var listManagementTermListsDelete* = Call_ListManagementTermListsDelete_568289(
    name: "listManagementTermListsDelete", meth: HttpMethod.HttpDelete,
    host: "azure.local", route: "/contentmoderator/lists/v1.0/termlists/{listId}",
    validator: validate_ListManagementTermListsDelete_568290, base: "",
    url: url_ListManagementTermListsDelete_568291, schemes: {Scheme.Https})
type
  Call_ListManagementTermListsRefreshIndex_568296 = ref object of OpenApiRestCall_567658
proc url_ListManagementTermListsRefreshIndex_568298(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "listId" in path, "`listId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/contentmoderator/lists/v1.0/termlists/"),
               (kind: VariableSegment, value: "listId"),
               (kind: ConstantSegment, value: "/RefreshIndex")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ListManagementTermListsRefreshIndex_568297(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Refreshes the index of the list with list Id equal to list ID passed.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   listId: JString (required)
  ##         : List Id of the image list.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `listId` field"
  var valid_568299 = path.getOrDefault("listId")
  valid_568299 = validateParameter(valid_568299, JString, required = true,
                                 default = nil)
  if valid_568299 != nil:
    section.add "listId", valid_568299
  result.add "path", section
  ## parameters in `query` object:
  ##   language: JString (required)
  ##           : Language of the terms.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `language` field"
  var valid_568300 = query.getOrDefault("language")
  valid_568300 = validateParameter(valid_568300, JString, required = true,
                                 default = nil)
  if valid_568300 != nil:
    section.add "language", valid_568300
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568301: Call_ListManagementTermListsRefreshIndex_568296;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Refreshes the index of the list with list Id equal to list ID passed.
  ## 
  let valid = call_568301.validator(path, query, header, formData, body)
  let scheme = call_568301.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568301.url(scheme.get, call_568301.host, call_568301.base,
                         call_568301.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568301, url, valid)

proc call*(call_568302: Call_ListManagementTermListsRefreshIndex_568296;
          language: string; listId: string): Recallable =
  ## listManagementTermListsRefreshIndex
  ## Refreshes the index of the list with list Id equal to list ID passed.
  ##   language: string (required)
  ##           : Language of the terms.
  ##   listId: string (required)
  ##         : List Id of the image list.
  var path_568303 = newJObject()
  var query_568304 = newJObject()
  add(query_568304, "language", newJString(language))
  add(path_568303, "listId", newJString(listId))
  result = call_568302.call(path_568303, query_568304, nil, nil, nil)

var listManagementTermListsRefreshIndex* = Call_ListManagementTermListsRefreshIndex_568296(
    name: "listManagementTermListsRefreshIndex", meth: HttpMethod.HttpPost,
    host: "azure.local",
    route: "/contentmoderator/lists/v1.0/termlists/{listId}/RefreshIndex",
    validator: validate_ListManagementTermListsRefreshIndex_568297, base: "",
    url: url_ListManagementTermListsRefreshIndex_568298, schemes: {Scheme.Https})
type
  Call_ListManagementTermGetAllTerms_568305 = ref object of OpenApiRestCall_567658
proc url_ListManagementTermGetAllTerms_568307(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "listId" in path, "`listId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/contentmoderator/lists/v1.0/termlists/"),
               (kind: VariableSegment, value: "listId"),
               (kind: ConstantSegment, value: "/terms")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ListManagementTermGetAllTerms_568306(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all terms from the list with list Id equal to the list Id passed.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   listId: JString (required)
  ##         : List Id of the image list.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `listId` field"
  var valid_568308 = path.getOrDefault("listId")
  valid_568308 = validateParameter(valid_568308, JString, required = true,
                                 default = nil)
  if valid_568308 != nil:
    section.add "listId", valid_568308
  result.add "path", section
  ## parameters in `query` object:
  ##   language: JString (required)
  ##           : Language of the terms.
  ##   offset: JInt
  ##         : The pagination start index.
  ##   limit: JInt
  ##        : The max limit.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `language` field"
  var valid_568309 = query.getOrDefault("language")
  valid_568309 = validateParameter(valid_568309, JString, required = true,
                                 default = nil)
  if valid_568309 != nil:
    section.add "language", valid_568309
  var valid_568310 = query.getOrDefault("offset")
  valid_568310 = validateParameter(valid_568310, JInt, required = false, default = nil)
  if valid_568310 != nil:
    section.add "offset", valid_568310
  var valid_568311 = query.getOrDefault("limit")
  valid_568311 = validateParameter(valid_568311, JInt, required = false, default = nil)
  if valid_568311 != nil:
    section.add "limit", valid_568311
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568312: Call_ListManagementTermGetAllTerms_568305; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all terms from the list with list Id equal to the list Id passed.
  ## 
  let valid = call_568312.validator(path, query, header, formData, body)
  let scheme = call_568312.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568312.url(scheme.get, call_568312.host, call_568312.base,
                         call_568312.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568312, url, valid)

proc call*(call_568313: Call_ListManagementTermGetAllTerms_568305;
          language: string; listId: string; offset: int = 0; limit: int = 0): Recallable =
  ## listManagementTermGetAllTerms
  ## Gets all terms from the list with list Id equal to the list Id passed.
  ##   language: string (required)
  ##           : Language of the terms.
  ##   offset: int
  ##         : The pagination start index.
  ##   listId: string (required)
  ##         : List Id of the image list.
  ##   limit: int
  ##        : The max limit.
  var path_568314 = newJObject()
  var query_568315 = newJObject()
  add(query_568315, "language", newJString(language))
  add(query_568315, "offset", newJInt(offset))
  add(path_568314, "listId", newJString(listId))
  add(query_568315, "limit", newJInt(limit))
  result = call_568313.call(path_568314, query_568315, nil, nil, nil)

var listManagementTermGetAllTerms* = Call_ListManagementTermGetAllTerms_568305(
    name: "listManagementTermGetAllTerms", meth: HttpMethod.HttpGet,
    host: "azure.local",
    route: "/contentmoderator/lists/v1.0/termlists/{listId}/terms",
    validator: validate_ListManagementTermGetAllTerms_568306, base: "",
    url: url_ListManagementTermGetAllTerms_568307, schemes: {Scheme.Https})
type
  Call_ListManagementTermDeleteAllTerms_568316 = ref object of OpenApiRestCall_567658
proc url_ListManagementTermDeleteAllTerms_568318(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "listId" in path, "`listId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/contentmoderator/lists/v1.0/termlists/"),
               (kind: VariableSegment, value: "listId"),
               (kind: ConstantSegment, value: "/terms")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ListManagementTermDeleteAllTerms_568317(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes all terms from the list with list Id equal to the list Id passed.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   listId: JString (required)
  ##         : List Id of the image list.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `listId` field"
  var valid_568319 = path.getOrDefault("listId")
  valid_568319 = validateParameter(valid_568319, JString, required = true,
                                 default = nil)
  if valid_568319 != nil:
    section.add "listId", valid_568319
  result.add "path", section
  ## parameters in `query` object:
  ##   language: JString (required)
  ##           : Language of the terms.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `language` field"
  var valid_568320 = query.getOrDefault("language")
  valid_568320 = validateParameter(valid_568320, JString, required = true,
                                 default = nil)
  if valid_568320 != nil:
    section.add "language", valid_568320
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568321: Call_ListManagementTermDeleteAllTerms_568316;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes all terms from the list with list Id equal to the list Id passed.
  ## 
  let valid = call_568321.validator(path, query, header, formData, body)
  let scheme = call_568321.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568321.url(scheme.get, call_568321.host, call_568321.base,
                         call_568321.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568321, url, valid)

proc call*(call_568322: Call_ListManagementTermDeleteAllTerms_568316;
          language: string; listId: string): Recallable =
  ## listManagementTermDeleteAllTerms
  ## Deletes all terms from the list with list Id equal to the list Id passed.
  ##   language: string (required)
  ##           : Language of the terms.
  ##   listId: string (required)
  ##         : List Id of the image list.
  var path_568323 = newJObject()
  var query_568324 = newJObject()
  add(query_568324, "language", newJString(language))
  add(path_568323, "listId", newJString(listId))
  result = call_568322.call(path_568323, query_568324, nil, nil, nil)

var listManagementTermDeleteAllTerms* = Call_ListManagementTermDeleteAllTerms_568316(
    name: "listManagementTermDeleteAllTerms", meth: HttpMethod.HttpDelete,
    host: "azure.local",
    route: "/contentmoderator/lists/v1.0/termlists/{listId}/terms",
    validator: validate_ListManagementTermDeleteAllTerms_568317, base: "",
    url: url_ListManagementTermDeleteAllTerms_568318, schemes: {Scheme.Https})
type
  Call_ListManagementTermAddTerm_568325 = ref object of OpenApiRestCall_567658
proc url_ListManagementTermAddTerm_568327(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "listId" in path, "`listId` is a required path parameter"
  assert "term" in path, "`term` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/contentmoderator/lists/v1.0/termlists/"),
               (kind: VariableSegment, value: "listId"),
               (kind: ConstantSegment, value: "/terms/"),
               (kind: VariableSegment, value: "term")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ListManagementTermAddTerm_568326(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Add a term to the term list with list Id equal to list Id passed.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   listId: JString (required)
  ##         : List Id of the image list.
  ##   term: JString (required)
  ##       : Term to be deleted
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `listId` field"
  var valid_568328 = path.getOrDefault("listId")
  valid_568328 = validateParameter(valid_568328, JString, required = true,
                                 default = nil)
  if valid_568328 != nil:
    section.add "listId", valid_568328
  var valid_568329 = path.getOrDefault("term")
  valid_568329 = validateParameter(valid_568329, JString, required = true,
                                 default = nil)
  if valid_568329 != nil:
    section.add "term", valid_568329
  result.add "path", section
  ## parameters in `query` object:
  ##   language: JString (required)
  ##           : Language of the terms.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `language` field"
  var valid_568330 = query.getOrDefault("language")
  valid_568330 = validateParameter(valid_568330, JString, required = true,
                                 default = nil)
  if valid_568330 != nil:
    section.add "language", valid_568330
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568331: Call_ListManagementTermAddTerm_568325; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Add a term to the term list with list Id equal to list Id passed.
  ## 
  let valid = call_568331.validator(path, query, header, formData, body)
  let scheme = call_568331.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568331.url(scheme.get, call_568331.host, call_568331.base,
                         call_568331.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568331, url, valid)

proc call*(call_568332: Call_ListManagementTermAddTerm_568325; language: string;
          listId: string; term: string): Recallable =
  ## listManagementTermAddTerm
  ## Add a term to the term list with list Id equal to list Id passed.
  ##   language: string (required)
  ##           : Language of the terms.
  ##   listId: string (required)
  ##         : List Id of the image list.
  ##   term: string (required)
  ##       : Term to be deleted
  var path_568333 = newJObject()
  var query_568334 = newJObject()
  add(query_568334, "language", newJString(language))
  add(path_568333, "listId", newJString(listId))
  add(path_568333, "term", newJString(term))
  result = call_568332.call(path_568333, query_568334, nil, nil, nil)

var listManagementTermAddTerm* = Call_ListManagementTermAddTerm_568325(
    name: "listManagementTermAddTerm", meth: HttpMethod.HttpPost,
    host: "azure.local",
    route: "/contentmoderator/lists/v1.0/termlists/{listId}/terms/{term}",
    validator: validate_ListManagementTermAddTerm_568326, base: "",
    url: url_ListManagementTermAddTerm_568327, schemes: {Scheme.Https})
type
  Call_ListManagementTermDeleteTerm_568335 = ref object of OpenApiRestCall_567658
proc url_ListManagementTermDeleteTerm_568337(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "listId" in path, "`listId` is a required path parameter"
  assert "term" in path, "`term` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/contentmoderator/lists/v1.0/termlists/"),
               (kind: VariableSegment, value: "listId"),
               (kind: ConstantSegment, value: "/terms/"),
               (kind: VariableSegment, value: "term")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ListManagementTermDeleteTerm_568336(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a term from the list with list Id equal to the list Id passed.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   listId: JString (required)
  ##         : List Id of the image list.
  ##   term: JString (required)
  ##       : Term to be deleted
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `listId` field"
  var valid_568338 = path.getOrDefault("listId")
  valid_568338 = validateParameter(valid_568338, JString, required = true,
                                 default = nil)
  if valid_568338 != nil:
    section.add "listId", valid_568338
  var valid_568339 = path.getOrDefault("term")
  valid_568339 = validateParameter(valid_568339, JString, required = true,
                                 default = nil)
  if valid_568339 != nil:
    section.add "term", valid_568339
  result.add "path", section
  ## parameters in `query` object:
  ##   language: JString (required)
  ##           : Language of the terms.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `language` field"
  var valid_568340 = query.getOrDefault("language")
  valid_568340 = validateParameter(valid_568340, JString, required = true,
                                 default = nil)
  if valid_568340 != nil:
    section.add "language", valid_568340
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568341: Call_ListManagementTermDeleteTerm_568335; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a term from the list with list Id equal to the list Id passed.
  ## 
  let valid = call_568341.validator(path, query, header, formData, body)
  let scheme = call_568341.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568341.url(scheme.get, call_568341.host, call_568341.base,
                         call_568341.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568341, url, valid)

proc call*(call_568342: Call_ListManagementTermDeleteTerm_568335; language: string;
          listId: string; term: string): Recallable =
  ## listManagementTermDeleteTerm
  ## Deletes a term from the list with list Id equal to the list Id passed.
  ##   language: string (required)
  ##           : Language of the terms.
  ##   listId: string (required)
  ##         : List Id of the image list.
  ##   term: string (required)
  ##       : Term to be deleted
  var path_568343 = newJObject()
  var query_568344 = newJObject()
  add(query_568344, "language", newJString(language))
  add(path_568343, "listId", newJString(listId))
  add(path_568343, "term", newJString(term))
  result = call_568342.call(path_568343, query_568344, nil, nil, nil)

var listManagementTermDeleteTerm* = Call_ListManagementTermDeleteTerm_568335(
    name: "listManagementTermDeleteTerm", meth: HttpMethod.HttpDelete,
    host: "azure.local",
    route: "/contentmoderator/lists/v1.0/termlists/{listId}/terms/{term}",
    validator: validate_ListManagementTermDeleteTerm_568336, base: "",
    url: url_ListManagementTermDeleteTerm_568337, schemes: {Scheme.Https})
type
  Call_ImageModerationEvaluate_568345 = ref object of OpenApiRestCall_567658
proc url_ImageModerationEvaluate_568347(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ImageModerationEvaluate_568346(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns probabilities of the image containing racy or adult content.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   CacheImage: JBool
  ##             : Whether to retain the submitted image for future use; defaults to false if omitted.
  section = newJObject()
  var valid_568348 = query.getOrDefault("CacheImage")
  valid_568348 = validateParameter(valid_568348, JBool, required = false, default = nil)
  if valid_568348 != nil:
    section.add "CacheImage", valid_568348
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568349: Call_ImageModerationEvaluate_568345; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns probabilities of the image containing racy or adult content.
  ## 
  let valid = call_568349.validator(path, query, header, formData, body)
  let scheme = call_568349.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568349.url(scheme.get, call_568349.host, call_568349.base,
                         call_568349.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568349, url, valid)

proc call*(call_568350: Call_ImageModerationEvaluate_568345;
          CacheImage: bool = false): Recallable =
  ## imageModerationEvaluate
  ## Returns probabilities of the image containing racy or adult content.
  ##   CacheImage: bool
  ##             : Whether to retain the submitted image for future use; defaults to false if omitted.
  var query_568351 = newJObject()
  add(query_568351, "CacheImage", newJBool(CacheImage))
  result = call_568350.call(nil, query_568351, nil, nil, nil)

var imageModerationEvaluate* = Call_ImageModerationEvaluate_568345(
    name: "imageModerationEvaluate", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/contentmoderator/moderate/v1.0/ProcessImage/Evaluate",
    validator: validate_ImageModerationEvaluate_568346, base: "",
    url: url_ImageModerationEvaluate_568347, schemes: {Scheme.Https})
type
  Call_ImageModerationFindFaces_568352 = ref object of OpenApiRestCall_567658
proc url_ImageModerationFindFaces_568354(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ImageModerationFindFaces_568353(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the list of faces found.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   CacheImage: JBool
  ##             : Whether to retain the submitted image for future use; defaults to false if omitted.
  section = newJObject()
  var valid_568355 = query.getOrDefault("CacheImage")
  valid_568355 = validateParameter(valid_568355, JBool, required = false, default = nil)
  if valid_568355 != nil:
    section.add "CacheImage", valid_568355
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568356: Call_ImageModerationFindFaces_568352; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the list of faces found.
  ## 
  let valid = call_568356.validator(path, query, header, formData, body)
  let scheme = call_568356.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568356.url(scheme.get, call_568356.host, call_568356.base,
                         call_568356.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568356, url, valid)

proc call*(call_568357: Call_ImageModerationFindFaces_568352;
          CacheImage: bool = false): Recallable =
  ## imageModerationFindFaces
  ## Returns the list of faces found.
  ##   CacheImage: bool
  ##             : Whether to retain the submitted image for future use; defaults to false if omitted.
  var query_568358 = newJObject()
  add(query_568358, "CacheImage", newJBool(CacheImage))
  result = call_568357.call(nil, query_568358, nil, nil, nil)

var imageModerationFindFaces* = Call_ImageModerationFindFaces_568352(
    name: "imageModerationFindFaces", meth: HttpMethod.HttpPost,
    host: "azure.local",
    route: "/contentmoderator/moderate/v1.0/ProcessImage/FindFaces",
    validator: validate_ImageModerationFindFaces_568353, base: "",
    url: url_ImageModerationFindFaces_568354, schemes: {Scheme.Https})
type
  Call_ImageModerationMatch_568359 = ref object of OpenApiRestCall_567658
proc url_ImageModerationMatch_568361(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ImageModerationMatch_568360(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Fuzzily match an image against one of your custom Image Lists. You can create and manage your custom image lists using <a href="/docs/services/578ff44d2703741568569ab9/operations/578ff7b12703741568569abe">this</a> API. 
  ## 
  ## Returns ID and tags of matching image.<br/>
  ## <br/>
  ## Note: Refresh Index must be run on the corresponding Image List before additions and removals are reflected in the response.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   CacheImage: JBool
  ##             : Whether to retain the submitted image for future use; defaults to false if omitted.
  ##   listId: JString
  ##         : The list Id.
  section = newJObject()
  var valid_568362 = query.getOrDefault("CacheImage")
  valid_568362 = validateParameter(valid_568362, JBool, required = false, default = nil)
  if valid_568362 != nil:
    section.add "CacheImage", valid_568362
  var valid_568363 = query.getOrDefault("listId")
  valid_568363 = validateParameter(valid_568363, JString, required = false,
                                 default = nil)
  if valid_568363 != nil:
    section.add "listId", valid_568363
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568364: Call_ImageModerationMatch_568359; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Fuzzily match an image against one of your custom Image Lists. You can create and manage your custom image lists using <a href="/docs/services/578ff44d2703741568569ab9/operations/578ff7b12703741568569abe">this</a> API. 
  ## 
  ## Returns ID and tags of matching image.<br/>
  ## <br/>
  ## Note: Refresh Index must be run on the corresponding Image List before additions and removals are reflected in the response.
  ## 
  let valid = call_568364.validator(path, query, header, formData, body)
  let scheme = call_568364.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568364.url(scheme.get, call_568364.host, call_568364.base,
                         call_568364.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568364, url, valid)

proc call*(call_568365: Call_ImageModerationMatch_568359; CacheImage: bool = false;
          listId: string = ""): Recallable =
  ## imageModerationMatch
  ## Fuzzily match an image against one of your custom Image Lists. You can create and manage your custom image lists using <a href="/docs/services/578ff44d2703741568569ab9/operations/578ff7b12703741568569abe">this</a> API. 
  ## 
  ## Returns ID and tags of matching image.<br/>
  ## <br/>
  ## Note: Refresh Index must be run on the corresponding Image List before additions and removals are reflected in the response.
  ##   CacheImage: bool
  ##             : Whether to retain the submitted image for future use; defaults to false if omitted.
  ##   listId: string
  ##         : The list Id.
  var query_568366 = newJObject()
  add(query_568366, "CacheImage", newJBool(CacheImage))
  add(query_568366, "listId", newJString(listId))
  result = call_568365.call(nil, query_568366, nil, nil, nil)

var imageModerationMatch* = Call_ImageModerationMatch_568359(
    name: "imageModerationMatch", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/contentmoderator/moderate/v1.0/ProcessImage/Match",
    validator: validate_ImageModerationMatch_568360, base: "",
    url: url_ImageModerationMatch_568361, schemes: {Scheme.Https})
type
  Call_ImageModerationOCR_568367 = ref object of OpenApiRestCall_567658
proc url_ImageModerationOCR_568369(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ImageModerationOCR_568368(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Returns any text found in the image for the language specified. If no language is specified in input then the detection defaults to English.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   CacheImage: JBool
  ##             : Whether to retain the submitted image for future use; defaults to false if omitted.
  ##   language: JString (required)
  ##           : Language of the terms.
  ##   enhanced: JBool
  ##           : When set to True, the image goes through additional processing to come with additional candidates.
  ## 
  ## image/tiff is not supported when enhanced is set to true
  ## 
  ## Note: This impacts the response time.
  section = newJObject()
  var valid_568370 = query.getOrDefault("CacheImage")
  valid_568370 = validateParameter(valid_568370, JBool, required = false, default = nil)
  if valid_568370 != nil:
    section.add "CacheImage", valid_568370
  assert query != nil,
        "query argument is necessary due to required `language` field"
  var valid_568371 = query.getOrDefault("language")
  valid_568371 = validateParameter(valid_568371, JString, required = true,
                                 default = nil)
  if valid_568371 != nil:
    section.add "language", valid_568371
  var valid_568385 = query.getOrDefault("enhanced")
  valid_568385 = validateParameter(valid_568385, JBool, required = false,
                                 default = newJBool(false))
  if valid_568385 != nil:
    section.add "enhanced", valid_568385
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568386: Call_ImageModerationOCR_568367; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns any text found in the image for the language specified. If no language is specified in input then the detection defaults to English.
  ## 
  let valid = call_568386.validator(path, query, header, formData, body)
  let scheme = call_568386.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568386.url(scheme.get, call_568386.host, call_568386.base,
                         call_568386.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568386, url, valid)

proc call*(call_568387: Call_ImageModerationOCR_568367; language: string;
          CacheImage: bool = false; enhanced: bool = false): Recallable =
  ## imageModerationOCR
  ## Returns any text found in the image for the language specified. If no language is specified in input then the detection defaults to English.
  ##   CacheImage: bool
  ##             : Whether to retain the submitted image for future use; defaults to false if omitted.
  ##   language: string (required)
  ##           : Language of the terms.
  ##   enhanced: bool
  ##           : When set to True, the image goes through additional processing to come with additional candidates.
  ## 
  ## image/tiff is not supported when enhanced is set to true
  ## 
  ## Note: This impacts the response time.
  var query_568388 = newJObject()
  add(query_568388, "CacheImage", newJBool(CacheImage))
  add(query_568388, "language", newJString(language))
  add(query_568388, "enhanced", newJBool(enhanced))
  result = call_568387.call(nil, query_568388, nil, nil, nil)

var imageModerationOCR* = Call_ImageModerationOCR_568367(
    name: "imageModerationOCR", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/contentmoderator/moderate/v1.0/ProcessImage/OCR",
    validator: validate_ImageModerationOCR_568368, base: "",
    url: url_ImageModerationOCR_568369, schemes: {Scheme.Https})
type
  Call_TextModerationDetectLanguage_568389 = ref object of OpenApiRestCall_567658
proc url_TextModerationDetectLanguage_568391(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_TextModerationDetectLanguage_568390(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This operation will detect the language of given input content. Returns the <a href="http://www-01.sil.org/iso639-3/codes.asp">ISO 639-3 code</a> for the predominant language comprising the submitted text. Over 110 languages supported.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  section = newJObject()
  result.add "query", section
  ## parameters in `header` object:
  ##   Content-Type: JString (required)
  ##               : The content type.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `Content-Type` field"
  var valid_568392 = header.getOrDefault("Content-Type")
  valid_568392 = validateParameter(valid_568392, JString, required = true,
                                 default = newJString("text/plain"))
  if valid_568392 != nil:
    section.add "Content-Type", valid_568392
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   Text Content: JObject (required)
  ##               : Content to screen.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568394: Call_TextModerationDetectLanguage_568389; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This operation will detect the language of given input content. Returns the <a href="http://www-01.sil.org/iso639-3/codes.asp">ISO 639-3 code</a> for the predominant language comprising the submitted text. Over 110 languages supported.
  ## 
  let valid = call_568394.validator(path, query, header, formData, body)
  let scheme = call_568394.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568394.url(scheme.get, call_568394.host, call_568394.base,
                         call_568394.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568394, url, valid)

proc call*(call_568395: Call_TextModerationDetectLanguage_568389;
          TextContent: JsonNode): Recallable =
  ## textModerationDetectLanguage
  ## This operation will detect the language of given input content. Returns the <a href="http://www-01.sil.org/iso639-3/codes.asp">ISO 639-3 code</a> for the predominant language comprising the submitted text. Over 110 languages supported.
  ##   TextContent: JObject (required)
  ##              : Content to screen.
  var body_568396 = newJObject()
  if TextContent != nil:
    body_568396 = TextContent
  result = call_568395.call(nil, nil, nil, nil, body_568396)

var textModerationDetectLanguage* = Call_TextModerationDetectLanguage_568389(
    name: "textModerationDetectLanguage", meth: HttpMethod.HttpPost,
    host: "azure.local",
    route: "/contentmoderator/moderate/v1.0/ProcessText/DetectLanguage",
    validator: validate_TextModerationDetectLanguage_568390, base: "",
    url: url_TextModerationDetectLanguage_568391, schemes: {Scheme.Https})
type
  Call_TextModerationScreenText_568397 = ref object of OpenApiRestCall_567658
proc url_TextModerationScreenText_568399(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_TextModerationScreenText_568398(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Detects profanity in more than 100 languages and match against custom and shared blacklists.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   language: JString
  ##           : Language of the text.
  ##   autocorrect: JBool
  ##              : Autocorrect text.
  ##   PII: JBool
  ##      : Detect personal identifiable information.
  ##   listId: JString
  ##         : The list Id.
  ##   classify: JBool
  ##           : Classify input.
  section = newJObject()
  var valid_568400 = query.getOrDefault("language")
  valid_568400 = validateParameter(valid_568400, JString, required = false,
                                 default = nil)
  if valid_568400 != nil:
    section.add "language", valid_568400
  var valid_568401 = query.getOrDefault("autocorrect")
  valid_568401 = validateParameter(valid_568401, JBool, required = false,
                                 default = newJBool(false))
  if valid_568401 != nil:
    section.add "autocorrect", valid_568401
  var valid_568402 = query.getOrDefault("PII")
  valid_568402 = validateParameter(valid_568402, JBool, required = false,
                                 default = newJBool(false))
  if valid_568402 != nil:
    section.add "PII", valid_568402
  var valid_568403 = query.getOrDefault("listId")
  valid_568403 = validateParameter(valid_568403, JString, required = false,
                                 default = nil)
  if valid_568403 != nil:
    section.add "listId", valid_568403
  var valid_568404 = query.getOrDefault("classify")
  valid_568404 = validateParameter(valid_568404, JBool, required = false,
                                 default = newJBool(false))
  if valid_568404 != nil:
    section.add "classify", valid_568404
  result.add "query", section
  ## parameters in `header` object:
  ##   Content-Type: JString (required)
  ##               : The content type.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `Content-Type` field"
  var valid_568405 = header.getOrDefault("Content-Type")
  valid_568405 = validateParameter(valid_568405, JString, required = true,
                                 default = newJString("text/plain"))
  if valid_568405 != nil:
    section.add "Content-Type", valid_568405
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   Text Content: JObject (required)
  ##               : Content to screen.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568407: Call_TextModerationScreenText_568397; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Detects profanity in more than 100 languages and match against custom and shared blacklists.
  ## 
  let valid = call_568407.validator(path, query, header, formData, body)
  let scheme = call_568407.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568407.url(scheme.get, call_568407.host, call_568407.base,
                         call_568407.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568407, url, valid)

proc call*(call_568408: Call_TextModerationScreenText_568397;
          TextContent: JsonNode; language: string = ""; autocorrect: bool = false;
          PII: bool = false; listId: string = ""; classify: bool = false): Recallable =
  ## textModerationScreenText
  ## Detects profanity in more than 100 languages and match against custom and shared blacklists.
  ##   language: string
  ##           : Language of the text.
  ##   autocorrect: bool
  ##              : Autocorrect text.
  ##   PII: bool
  ##      : Detect personal identifiable information.
  ##   listId: string
  ##         : The list Id.
  ##   classify: bool
  ##           : Classify input.
  ##   TextContent: JObject (required)
  ##              : Content to screen.
  var query_568409 = newJObject()
  var body_568410 = newJObject()
  add(query_568409, "language", newJString(language))
  add(query_568409, "autocorrect", newJBool(autocorrect))
  add(query_568409, "PII", newJBool(PII))
  add(query_568409, "listId", newJString(listId))
  add(query_568409, "classify", newJBool(classify))
  if TextContent != nil:
    body_568410 = TextContent
  result = call_568408.call(nil, query_568409, nil, nil, body_568410)

var textModerationScreenText* = Call_TextModerationScreenText_568397(
    name: "textModerationScreenText", meth: HttpMethod.HttpPost,
    host: "azure.local",
    route: "/contentmoderator/moderate/v1.0/ProcessText/Screen/",
    validator: validate_TextModerationScreenText_568398, base: "",
    url: url_TextModerationScreenText_568399, schemes: {Scheme.Https})
type
  Call_ReviewsCreateJob_568411 = ref object of OpenApiRestCall_567658
proc url_ReviewsCreateJob_568413(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "teamName" in path, "`teamName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/contentmoderator/review/v1.0/teams/"),
               (kind: VariableSegment, value: "teamName"),
               (kind: ConstantSegment, value: "/jobs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReviewsCreateJob_568412(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## A job Id will be returned for the content posted on this endpoint. 
  ## 
  ## Once the content is evaluated against the Workflow provided the review will be created or ignored based on the workflow expression.
  ## 
  ## <h3>CallBack Schemas </h3>
  ## 
  ## <p>
  ## <h4>Job Completion CallBack Sample</h4><br/>
  ## 
  ## {<br/>
  ##   "JobId": "<Job Id>,<br/>
  ##   "ReviewId": "<Review Id, if the Job resulted in a Review to be created>",<br/>
  ##   "WorkFlowId": "default",<br/>
  ##   "Status": "<This will be one of Complete, InProgress, Error>",<br/>
  ##   "ContentType": "Image",<br/>
  ##   "ContentId": "<This is the ContentId that was specified on input>",<br/>
  ##   "CallBackType": "Job",<br/>
  ##   "Metadata": {<br/>
  ##     "adultscore": "0.xxx",<br/>
  ##     "a": "False",<br/>
  ##     "racyscore": "0.xxx",<br/>
  ##     "r": "True"<br/>
  ##   }<br/>
  ## }<br/>
  ## 
  ## </p>
  ## <p>
  ## <h4>Review Completion CallBack Sample</h4><br/>
  ## 
  ## {
  ##   "ReviewId": "<Review Id>",<br/>
  ##   "ModifiedOn": "2016-10-11T22:36:32.9934851Z",<br/>
  ##   "ModifiedBy": "<Name of the Reviewer>",<br/>
  ##   "CallBackType": "Review",<br/>
  ##   "ContentId": "<The ContentId that was specified input>",<br/>
  ##   "Metadata": {<br/>
  ##     "adultscore": "0.xxx",
  ##     "a": "False",<br/>
  ##     "racyscore": "0.xxx",<br/>
  ##     "r": "True"<br/>
  ##   },<br/>
  ##   "ReviewerResultTags": {<br/>
  ##     "a": "False",<br/>
  ##     "r": "True"<br/>
  ##   }<br/>
  ## }<br/>
  ## 
  ## </p>.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   teamName: JString (required)
  ##           : Your team name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `teamName` field"
  var valid_568414 = path.getOrDefault("teamName")
  valid_568414 = validateParameter(valid_568414, JString, required = true,
                                 default = nil)
  if valid_568414 != nil:
    section.add "teamName", valid_568414
  result.add "path", section
  ## parameters in `query` object:
  ##   WorkflowName: JString (required)
  ##               : Workflow Name that you want to invoke.
  ##   CallBackEndpoint: JString
  ##                   : Callback endpoint for posting the create job result.
  ##   ContentType: JString (required)
  ##              : Image, Text or Video.
  ##   ContentId: JString (required)
  ##            : Id/Name to identify the content submitted.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `WorkflowName` field"
  var valid_568415 = query.getOrDefault("WorkflowName")
  valid_568415 = validateParameter(valid_568415, JString, required = true,
                                 default = nil)
  if valid_568415 != nil:
    section.add "WorkflowName", valid_568415
  var valid_568416 = query.getOrDefault("CallBackEndpoint")
  valid_568416 = validateParameter(valid_568416, JString, required = false,
                                 default = nil)
  if valid_568416 != nil:
    section.add "CallBackEndpoint", valid_568416
  var valid_568417 = query.getOrDefault("ContentType")
  valid_568417 = validateParameter(valid_568417, JString, required = true,
                                 default = newJString("Image"))
  if valid_568417 != nil:
    section.add "ContentType", valid_568417
  var valid_568418 = query.getOrDefault("ContentId")
  valid_568418 = validateParameter(valid_568418, JString, required = true,
                                 default = nil)
  if valid_568418 != nil:
    section.add "ContentId", valid_568418
  result.add "query", section
  ## parameters in `header` object:
  ##   Content-Type: JString (required)
  ##               : The content type.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `Content-Type` field"
  var valid_568419 = header.getOrDefault("Content-Type")
  valid_568419 = validateParameter(valid_568419, JString, required = true,
                                 default = newJString("application/json"))
  if valid_568419 != nil:
    section.add "Content-Type", valid_568419
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   Content: JObject (required)
  ##          : Content to evaluate.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568421: Call_ReviewsCreateJob_568411; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## A job Id will be returned for the content posted on this endpoint. 
  ## 
  ## Once the content is evaluated against the Workflow provided the review will be created or ignored based on the workflow expression.
  ## 
  ## <h3>CallBack Schemas </h3>
  ## 
  ## <p>
  ## <h4>Job Completion CallBack Sample</h4><br/>
  ## 
  ## {<br/>
  ##   "JobId": "<Job Id>,<br/>
  ##   "ReviewId": "<Review Id, if the Job resulted in a Review to be created>",<br/>
  ##   "WorkFlowId": "default",<br/>
  ##   "Status": "<This will be one of Complete, InProgress, Error>",<br/>
  ##   "ContentType": "Image",<br/>
  ##   "ContentId": "<This is the ContentId that was specified on input>",<br/>
  ##   "CallBackType": "Job",<br/>
  ##   "Metadata": {<br/>
  ##     "adultscore": "0.xxx",<br/>
  ##     "a": "False",<br/>
  ##     "racyscore": "0.xxx",<br/>
  ##     "r": "True"<br/>
  ##   }<br/>
  ## }<br/>
  ## 
  ## </p>
  ## <p>
  ## <h4>Review Completion CallBack Sample</h4><br/>
  ## 
  ## {
  ##   "ReviewId": "<Review Id>",<br/>
  ##   "ModifiedOn": "2016-10-11T22:36:32.9934851Z",<br/>
  ##   "ModifiedBy": "<Name of the Reviewer>",<br/>
  ##   "CallBackType": "Review",<br/>
  ##   "ContentId": "<The ContentId that was specified input>",<br/>
  ##   "Metadata": {<br/>
  ##     "adultscore": "0.xxx",
  ##     "a": "False",<br/>
  ##     "racyscore": "0.xxx",<br/>
  ##     "r": "True"<br/>
  ##   },<br/>
  ##   "ReviewerResultTags": {<br/>
  ##     "a": "False",<br/>
  ##     "r": "True"<br/>
  ##   }<br/>
  ## }<br/>
  ## 
  ## </p>.
  ## 
  let valid = call_568421.validator(path, query, header, formData, body)
  let scheme = call_568421.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568421.url(scheme.get, call_568421.host, call_568421.base,
                         call_568421.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568421, url, valid)

var reviewsCreateJob* = Call_ReviewsCreateJob_568411(name: "reviewsCreateJob",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/contentmoderator/review/v1.0/teams/{teamName}/jobs",
    validator: validate_ReviewsCreateJob_568412, base: "",
    url: url_ReviewsCreateJob_568413, schemes: {Scheme.Https})
type
  Call_ReviewsGetJobDetails_568426 = ref object of OpenApiRestCall_567658
proc url_ReviewsGetJobDetails_568428(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "teamName" in path, "`teamName` is a required path parameter"
  assert "JobId" in path, "`JobId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/contentmoderator/review/v1.0/teams/"),
               (kind: VariableSegment, value: "teamName"),
               (kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "JobId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReviewsGetJobDetails_568427(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the Job Details for a Job Id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   teamName: JString (required)
  ##           : Your Team Name.
  ##   JobId: JString (required)
  ##        : Id of the job.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `teamName` field"
  var valid_568429 = path.getOrDefault("teamName")
  valid_568429 = validateParameter(valid_568429, JString, required = true,
                                 default = nil)
  if valid_568429 != nil:
    section.add "teamName", valid_568429
  var valid_568430 = path.getOrDefault("JobId")
  valid_568430 = validateParameter(valid_568430, JString, required = true,
                                 default = nil)
  if valid_568430 != nil:
    section.add "JobId", valid_568430
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568431: Call_ReviewsGetJobDetails_568426; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the Job Details for a Job Id.
  ## 
  let valid = call_568431.validator(path, query, header, formData, body)
  let scheme = call_568431.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568431.url(scheme.get, call_568431.host, call_568431.base,
                         call_568431.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568431, url, valid)

proc call*(call_568432: Call_ReviewsGetJobDetails_568426; teamName: string;
          JobId: string): Recallable =
  ## reviewsGetJobDetails
  ## Get the Job Details for a Job Id.
  ##   teamName: string (required)
  ##           : Your Team Name.
  ##   JobId: string (required)
  ##        : Id of the job.
  var path_568433 = newJObject()
  add(path_568433, "teamName", newJString(teamName))
  add(path_568433, "JobId", newJString(JobId))
  result = call_568432.call(path_568433, nil, nil, nil, nil)

var reviewsGetJobDetails* = Call_ReviewsGetJobDetails_568426(
    name: "reviewsGetJobDetails", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/contentmoderator/review/v1.0/teams/{teamName}/jobs/{JobId}",
    validator: validate_ReviewsGetJobDetails_568427, base: "",
    url: url_ReviewsGetJobDetails_568428, schemes: {Scheme.Https})
type
  Call_ReviewsCreateReviews_568434 = ref object of OpenApiRestCall_567658
proc url_ReviewsCreateReviews_568436(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "teamName" in path, "`teamName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/contentmoderator/review/v1.0/teams/"),
               (kind: VariableSegment, value: "teamName"),
               (kind: ConstantSegment, value: "/reviews")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReviewsCreateReviews_568435(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The reviews created would show up for Reviewers on your team. As Reviewers complete reviewing, results of the Review would be POSTED (i.e. HTTP POST) on the specified CallBackEndpoint.
  ## 
  ## <h3>CallBack Schemas </h3>
  ## <h4>Review Completion CallBack Sample</h4>
  ## <p>
  ## {<br/>
  ##   "ReviewId": "<Review Id>",<br/>
  ##   "ModifiedOn": "2016-10-11T22:36:32.9934851Z",<br/>
  ##   "ModifiedBy": "<Name of the Reviewer>",<br/>
  ##   "CallBackType": "Review",<br/>
  ##   "ContentId": "<The ContentId that was specified input>",<br/>
  ##   "Metadata": {<br/>
  ##     "adultscore": "0.xxx",<br/>
  ##     "a": "False",<br/>
  ##     "racyscore": "0.xxx",<br/>
  ##     "r": "True"<br/>
  ##   },<br/>
  ##   "ReviewerResultTags": {<br/>
  ##     "a": "False",<br/>
  ##     "r": "True"<br/>
  ##   }<br/>
  ## }<br/>
  ## 
  ## </p>.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   teamName: JString (required)
  ##           : Your team name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `teamName` field"
  var valid_568437 = path.getOrDefault("teamName")
  valid_568437 = validateParameter(valid_568437, JString, required = true,
                                 default = nil)
  if valid_568437 != nil:
    section.add "teamName", valid_568437
  result.add "path", section
  ## parameters in `query` object:
  ##   subTeam: JString
  ##          : SubTeam of your team, you want to assign the created review to.
  section = newJObject()
  var valid_568438 = query.getOrDefault("subTeam")
  valid_568438 = validateParameter(valid_568438, JString, required = false,
                                 default = nil)
  if valid_568438 != nil:
    section.add "subTeam", valid_568438
  result.add "query", section
  ## parameters in `header` object:
  ##   UrlContentType: JString (required)
  ##                 : The content type.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `UrlContentType` field"
  var valid_568439 = header.getOrDefault("UrlContentType")
  valid_568439 = validateParameter(valid_568439, JString, required = true,
                                 default = nil)
  if valid_568439 != nil:
    section.add "UrlContentType", valid_568439
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   createReviewBody: JArray (required)
  ##                   : Body for create reviews API
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JArray, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568441: Call_ReviewsCreateReviews_568434; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The reviews created would show up for Reviewers on your team. As Reviewers complete reviewing, results of the Review would be POSTED (i.e. HTTP POST) on the specified CallBackEndpoint.
  ## 
  ## <h3>CallBack Schemas </h3>
  ## <h4>Review Completion CallBack Sample</h4>
  ## <p>
  ## {<br/>
  ##   "ReviewId": "<Review Id>",<br/>
  ##   "ModifiedOn": "2016-10-11T22:36:32.9934851Z",<br/>
  ##   "ModifiedBy": "<Name of the Reviewer>",<br/>
  ##   "CallBackType": "Review",<br/>
  ##   "ContentId": "<The ContentId that was specified input>",<br/>
  ##   "Metadata": {<br/>
  ##     "adultscore": "0.xxx",<br/>
  ##     "a": "False",<br/>
  ##     "racyscore": "0.xxx",<br/>
  ##     "r": "True"<br/>
  ##   },<br/>
  ##   "ReviewerResultTags": {<br/>
  ##     "a": "False",<br/>
  ##     "r": "True"<br/>
  ##   }<br/>
  ## }<br/>
  ## 
  ## </p>.
  ## 
  let valid = call_568441.validator(path, query, header, formData, body)
  let scheme = call_568441.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568441.url(scheme.get, call_568441.host, call_568441.base,
                         call_568441.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568441, url, valid)

proc call*(call_568442: Call_ReviewsCreateReviews_568434;
          createReviewBody: JsonNode; teamName: string; subTeam: string = ""): Recallable =
  ## reviewsCreateReviews
  ## The reviews created would show up for Reviewers on your team. As Reviewers complete reviewing, results of the Review would be POSTED (i.e. HTTP POST) on the specified CallBackEndpoint.
  ## 
  ## <h3>CallBack Schemas </h3>
  ## <h4>Review Completion CallBack Sample</h4>
  ## <p>
  ## {<br/>
  ##   "ReviewId": "<Review Id>",<br/>
  ##   "ModifiedOn": "2016-10-11T22:36:32.9934851Z",<br/>
  ##   "ModifiedBy": "<Name of the Reviewer>",<br/>
  ##   "CallBackType": "Review",<br/>
  ##   "ContentId": "<The ContentId that was specified input>",<br/>
  ##   "Metadata": {<br/>
  ##     "adultscore": "0.xxx",<br/>
  ##     "a": "False",<br/>
  ##     "racyscore": "0.xxx",<br/>
  ##     "r": "True"<br/>
  ##   },<br/>
  ##   "ReviewerResultTags": {<br/>
  ##     "a": "False",<br/>
  ##     "r": "True"<br/>
  ##   }<br/>
  ## }<br/>
  ## 
  ## </p>.
  ##   createReviewBody: JArray (required)
  ##                   : Body for create reviews API
  ##   teamName: string (required)
  ##           : Your team name.
  ##   subTeam: string
  ##          : SubTeam of your team, you want to assign the created review to.
  var path_568443 = newJObject()
  var query_568444 = newJObject()
  var body_568445 = newJObject()
  if createReviewBody != nil:
    body_568445 = createReviewBody
  add(path_568443, "teamName", newJString(teamName))
  add(query_568444, "subTeam", newJString(subTeam))
  result = call_568442.call(path_568443, query_568444, nil, nil, body_568445)

var reviewsCreateReviews* = Call_ReviewsCreateReviews_568434(
    name: "reviewsCreateReviews", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/contentmoderator/review/v1.0/teams/{teamName}/reviews",
    validator: validate_ReviewsCreateReviews_568435, base: "",
    url: url_ReviewsCreateReviews_568436, schemes: {Scheme.Https})
type
  Call_ReviewsGetReview_568446 = ref object of OpenApiRestCall_567658
proc url_ReviewsGetReview_568448(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "teamName" in path, "`teamName` is a required path parameter"
  assert "reviewId" in path, "`reviewId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/contentmoderator/review/v1.0/teams/"),
               (kind: VariableSegment, value: "teamName"),
               (kind: ConstantSegment, value: "/reviews/"),
               (kind: VariableSegment, value: "reviewId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReviewsGetReview_568447(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Returns review details for the review Id passed.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   reviewId: JString (required)
  ##           : Id of the review.
  ##   teamName: JString (required)
  ##           : Your Team Name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `reviewId` field"
  var valid_568449 = path.getOrDefault("reviewId")
  valid_568449 = validateParameter(valid_568449, JString, required = true,
                                 default = nil)
  if valid_568449 != nil:
    section.add "reviewId", valid_568449
  var valid_568450 = path.getOrDefault("teamName")
  valid_568450 = validateParameter(valid_568450, JString, required = true,
                                 default = nil)
  if valid_568450 != nil:
    section.add "teamName", valid_568450
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568451: Call_ReviewsGetReview_568446; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns review details for the review Id passed.
  ## 
  let valid = call_568451.validator(path, query, header, formData, body)
  let scheme = call_568451.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568451.url(scheme.get, call_568451.host, call_568451.base,
                         call_568451.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568451, url, valid)

proc call*(call_568452: Call_ReviewsGetReview_568446; reviewId: string;
          teamName: string): Recallable =
  ## reviewsGetReview
  ## Returns review details for the review Id passed.
  ##   reviewId: string (required)
  ##           : Id of the review.
  ##   teamName: string (required)
  ##           : Your Team Name.
  var path_568453 = newJObject()
  add(path_568453, "reviewId", newJString(reviewId))
  add(path_568453, "teamName", newJString(teamName))
  result = call_568452.call(path_568453, nil, nil, nil, nil)

var reviewsGetReview* = Call_ReviewsGetReview_568446(name: "reviewsGetReview",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/contentmoderator/review/v1.0/teams/{teamName}/reviews/{reviewId}",
    validator: validate_ReviewsGetReview_568447, base: "",
    url: url_ReviewsGetReview_568448, schemes: {Scheme.Https})
type
  Call_ReviewsAddVideoFrame_568466 = ref object of OpenApiRestCall_567658
proc url_ReviewsAddVideoFrame_568468(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "teamName" in path, "`teamName` is a required path parameter"
  assert "reviewId" in path, "`reviewId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/contentmoderator/review/v1.0/teams/"),
               (kind: VariableSegment, value: "teamName"),
               (kind: ConstantSegment, value: "/reviews/"),
               (kind: VariableSegment, value: "reviewId"),
               (kind: ConstantSegment, value: "/frames")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReviewsAddVideoFrame_568467(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The reviews created would show up for Reviewers on your team. As Reviewers complete reviewing, results of the Review would be POSTED (i.e. HTTP POST) on the specified CallBackEndpoint.
  ## 
  ## <h3>CallBack Schemas </h3>
  ## <h4>Review Completion CallBack Sample</h4>
  ## <p>
  ## {<br/>
  ##   "ReviewId": "<Review Id>",<br/>
  ##   "ModifiedOn": "2016-10-11T22:36:32.9934851Z",<br/>
  ##   "ModifiedBy": "<Name of the Reviewer>",<br/>
  ##   "CallBackType": "Review",<br/>
  ##   "ContentId": "<The ContentId that was specified input>",<br/>
  ##   "Metadata": {<br/>
  ##     "adultscore": "0.xxx",<br/>
  ##     "a": "False",<br/>
  ##     "racyscore": "0.xxx",<br/>
  ##     "r": "True"<br/>
  ##   },<br/>
  ##   "ReviewerResultTags": {<br/>
  ##     "a": "False",<br/>
  ##     "r": "True"<br/>
  ##   }<br/>
  ## }<br/>
  ## 
  ## </p>.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   reviewId: JString (required)
  ##           : Id of the review.
  ##   teamName: JString (required)
  ##           : Your team name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `reviewId` field"
  var valid_568469 = path.getOrDefault("reviewId")
  valid_568469 = validateParameter(valid_568469, JString, required = true,
                                 default = nil)
  if valid_568469 != nil:
    section.add "reviewId", valid_568469
  var valid_568470 = path.getOrDefault("teamName")
  valid_568470 = validateParameter(valid_568470, JString, required = true,
                                 default = nil)
  if valid_568470 != nil:
    section.add "teamName", valid_568470
  result.add "path", section
  ## parameters in `query` object:
  ##   timescale: JInt
  ##            : Timescale of the video you are adding frames to.
  section = newJObject()
  var valid_568471 = query.getOrDefault("timescale")
  valid_568471 = validateParameter(valid_568471, JInt, required = false, default = nil)
  if valid_568471 != nil:
    section.add "timescale", valid_568471
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568472: Call_ReviewsAddVideoFrame_568466; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The reviews created would show up for Reviewers on your team. As Reviewers complete reviewing, results of the Review would be POSTED (i.e. HTTP POST) on the specified CallBackEndpoint.
  ## 
  ## <h3>CallBack Schemas </h3>
  ## <h4>Review Completion CallBack Sample</h4>
  ## <p>
  ## {<br/>
  ##   "ReviewId": "<Review Id>",<br/>
  ##   "ModifiedOn": "2016-10-11T22:36:32.9934851Z",<br/>
  ##   "ModifiedBy": "<Name of the Reviewer>",<br/>
  ##   "CallBackType": "Review",<br/>
  ##   "ContentId": "<The ContentId that was specified input>",<br/>
  ##   "Metadata": {<br/>
  ##     "adultscore": "0.xxx",<br/>
  ##     "a": "False",<br/>
  ##     "racyscore": "0.xxx",<br/>
  ##     "r": "True"<br/>
  ##   },<br/>
  ##   "ReviewerResultTags": {<br/>
  ##     "a": "False",<br/>
  ##     "r": "True"<br/>
  ##   }<br/>
  ## }<br/>
  ## 
  ## </p>.
  ## 
  let valid = call_568472.validator(path, query, header, formData, body)
  let scheme = call_568472.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568472.url(scheme.get, call_568472.host, call_568472.base,
                         call_568472.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568472, url, valid)

proc call*(call_568473: Call_ReviewsAddVideoFrame_568466; reviewId: string;
          teamName: string; timescale: int = 0): Recallable =
  ## reviewsAddVideoFrame
  ## The reviews created would show up for Reviewers on your team. As Reviewers complete reviewing, results of the Review would be POSTED (i.e. HTTP POST) on the specified CallBackEndpoint.
  ## 
  ## <h3>CallBack Schemas </h3>
  ## <h4>Review Completion CallBack Sample</h4>
  ## <p>
  ## {<br/>
  ##   "ReviewId": "<Review Id>",<br/>
  ##   "ModifiedOn": "2016-10-11T22:36:32.9934851Z",<br/>
  ##   "ModifiedBy": "<Name of the Reviewer>",<br/>
  ##   "CallBackType": "Review",<br/>
  ##   "ContentId": "<The ContentId that was specified input>",<br/>
  ##   "Metadata": {<br/>
  ##     "adultscore": "0.xxx",<br/>
  ##     "a": "False",<br/>
  ##     "racyscore": "0.xxx",<br/>
  ##     "r": "True"<br/>
  ##   },<br/>
  ##   "ReviewerResultTags": {<br/>
  ##     "a": "False",<br/>
  ##     "r": "True"<br/>
  ##   }<br/>
  ## }<br/>
  ## 
  ## </p>.
  ##   timescale: int
  ##            : Timescale of the video you are adding frames to.
  ##   reviewId: string (required)
  ##           : Id of the review.
  ##   teamName: string (required)
  ##           : Your team name.
  var path_568474 = newJObject()
  var query_568475 = newJObject()
  add(query_568475, "timescale", newJInt(timescale))
  add(path_568474, "reviewId", newJString(reviewId))
  add(path_568474, "teamName", newJString(teamName))
  result = call_568473.call(path_568474, query_568475, nil, nil, nil)

var reviewsAddVideoFrame* = Call_ReviewsAddVideoFrame_568466(
    name: "reviewsAddVideoFrame", meth: HttpMethod.HttpPost, host: "azure.local", route: "/contentmoderator/review/v1.0/teams/{teamName}/reviews/{reviewId}/frames",
    validator: validate_ReviewsAddVideoFrame_568467, base: "",
    url: url_ReviewsAddVideoFrame_568468, schemes: {Scheme.Https})
type
  Call_ReviewsGetVideoFrames_568454 = ref object of OpenApiRestCall_567658
proc url_ReviewsGetVideoFrames_568456(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "teamName" in path, "`teamName` is a required path parameter"
  assert "reviewId" in path, "`reviewId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/contentmoderator/review/v1.0/teams/"),
               (kind: VariableSegment, value: "teamName"),
               (kind: ConstantSegment, value: "/reviews/"),
               (kind: VariableSegment, value: "reviewId"),
               (kind: ConstantSegment, value: "/frames")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReviewsGetVideoFrames_568455(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The reviews created would show up for Reviewers on your team. As Reviewers complete reviewing, results of the Review would be POSTED (i.e. HTTP POST) on the specified CallBackEndpoint.
  ## 
  ## <h3>CallBack Schemas </h3>
  ## <h4>Review Completion CallBack Sample</h4>
  ## <p>
  ## {<br/>
  ##   "ReviewId": "<Review Id>",<br/>
  ##   "ModifiedOn": "2016-10-11T22:36:32.9934851Z",<br/>
  ##   "ModifiedBy": "<Name of the Reviewer>",<br/>
  ##   "CallBackType": "Review",<br/>
  ##   "ContentId": "<The ContentId that was specified input>",<br/>
  ##   "Metadata": {<br/>
  ##     "adultscore": "0.xxx",<br/>
  ##     "a": "False",<br/>
  ##     "racyscore": "0.xxx",<br/>
  ##     "r": "True"<br/>
  ##   },<br/>
  ##   "ReviewerResultTags": {<br/>
  ##     "a": "False",<br/>
  ##     "r": "True"<br/>
  ##   }<br/>
  ## }<br/>
  ## 
  ## </p>.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   reviewId: JString (required)
  ##           : Id of the review.
  ##   teamName: JString (required)
  ##           : Your team name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `reviewId` field"
  var valid_568457 = path.getOrDefault("reviewId")
  valid_568457 = validateParameter(valid_568457, JString, required = true,
                                 default = nil)
  if valid_568457 != nil:
    section.add "reviewId", valid_568457
  var valid_568458 = path.getOrDefault("teamName")
  valid_568458 = validateParameter(valid_568458, JString, required = true,
                                 default = nil)
  if valid_568458 != nil:
    section.add "teamName", valid_568458
  result.add "path", section
  ## parameters in `query` object:
  ##   noOfRecords: JInt
  ##              : Number of frames to fetch.
  ##   filter: JString
  ##         : Get frames filtered by tags.
  ##   startSeed: JInt
  ##            : Time stamp of the frame from where you want to start fetching the frames.
  section = newJObject()
  var valid_568459 = query.getOrDefault("noOfRecords")
  valid_568459 = validateParameter(valid_568459, JInt, required = false, default = nil)
  if valid_568459 != nil:
    section.add "noOfRecords", valid_568459
  var valid_568460 = query.getOrDefault("filter")
  valid_568460 = validateParameter(valid_568460, JString, required = false,
                                 default = nil)
  if valid_568460 != nil:
    section.add "filter", valid_568460
  var valid_568461 = query.getOrDefault("startSeed")
  valid_568461 = validateParameter(valid_568461, JInt, required = false, default = nil)
  if valid_568461 != nil:
    section.add "startSeed", valid_568461
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568462: Call_ReviewsGetVideoFrames_568454; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The reviews created would show up for Reviewers on your team. As Reviewers complete reviewing, results of the Review would be POSTED (i.e. HTTP POST) on the specified CallBackEndpoint.
  ## 
  ## <h3>CallBack Schemas </h3>
  ## <h4>Review Completion CallBack Sample</h4>
  ## <p>
  ## {<br/>
  ##   "ReviewId": "<Review Id>",<br/>
  ##   "ModifiedOn": "2016-10-11T22:36:32.9934851Z",<br/>
  ##   "ModifiedBy": "<Name of the Reviewer>",<br/>
  ##   "CallBackType": "Review",<br/>
  ##   "ContentId": "<The ContentId that was specified input>",<br/>
  ##   "Metadata": {<br/>
  ##     "adultscore": "0.xxx",<br/>
  ##     "a": "False",<br/>
  ##     "racyscore": "0.xxx",<br/>
  ##     "r": "True"<br/>
  ##   },<br/>
  ##   "ReviewerResultTags": {<br/>
  ##     "a": "False",<br/>
  ##     "r": "True"<br/>
  ##   }<br/>
  ## }<br/>
  ## 
  ## </p>.
  ## 
  let valid = call_568462.validator(path, query, header, formData, body)
  let scheme = call_568462.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568462.url(scheme.get, call_568462.host, call_568462.base,
                         call_568462.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568462, url, valid)

proc call*(call_568463: Call_ReviewsGetVideoFrames_568454; reviewId: string;
          teamName: string; noOfRecords: int = 0; filter: string = ""; startSeed: int = 0): Recallable =
  ## reviewsGetVideoFrames
  ## The reviews created would show up for Reviewers on your team. As Reviewers complete reviewing, results of the Review would be POSTED (i.e. HTTP POST) on the specified CallBackEndpoint.
  ## 
  ## <h3>CallBack Schemas </h3>
  ## <h4>Review Completion CallBack Sample</h4>
  ## <p>
  ## {<br/>
  ##   "ReviewId": "<Review Id>",<br/>
  ##   "ModifiedOn": "2016-10-11T22:36:32.9934851Z",<br/>
  ##   "ModifiedBy": "<Name of the Reviewer>",<br/>
  ##   "CallBackType": "Review",<br/>
  ##   "ContentId": "<The ContentId that was specified input>",<br/>
  ##   "Metadata": {<br/>
  ##     "adultscore": "0.xxx",<br/>
  ##     "a": "False",<br/>
  ##     "racyscore": "0.xxx",<br/>
  ##     "r": "True"<br/>
  ##   },<br/>
  ##   "ReviewerResultTags": {<br/>
  ##     "a": "False",<br/>
  ##     "r": "True"<br/>
  ##   }<br/>
  ## }<br/>
  ## 
  ## </p>.
  ##   noOfRecords: int
  ##              : Number of frames to fetch.
  ##   reviewId: string (required)
  ##           : Id of the review.
  ##   teamName: string (required)
  ##           : Your team name.
  ##   filter: string
  ##         : Get frames filtered by tags.
  ##   startSeed: int
  ##            : Time stamp of the frame from where you want to start fetching the frames.
  var path_568464 = newJObject()
  var query_568465 = newJObject()
  add(query_568465, "noOfRecords", newJInt(noOfRecords))
  add(path_568464, "reviewId", newJString(reviewId))
  add(path_568464, "teamName", newJString(teamName))
  add(query_568465, "filter", newJString(filter))
  add(query_568465, "startSeed", newJInt(startSeed))
  result = call_568463.call(path_568464, query_568465, nil, nil, nil)

var reviewsGetVideoFrames* = Call_ReviewsGetVideoFrames_568454(
    name: "reviewsGetVideoFrames", meth: HttpMethod.HttpGet, host: "azure.local", route: "/contentmoderator/review/v1.0/teams/{teamName}/reviews/{reviewId}/frames",
    validator: validate_ReviewsGetVideoFrames_568455, base: "",
    url: url_ReviewsGetVideoFrames_568456, schemes: {Scheme.Https})
type
  Call_ReviewsPublishVideoReview_568476 = ref object of OpenApiRestCall_567658
proc url_ReviewsPublishVideoReview_568478(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "teamName" in path, "`teamName` is a required path parameter"
  assert "reviewId" in path, "`reviewId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/contentmoderator/review/v1.0/teams/"),
               (kind: VariableSegment, value: "teamName"),
               (kind: ConstantSegment, value: "/reviews/"),
               (kind: VariableSegment, value: "reviewId"),
               (kind: ConstantSegment, value: "/publish")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReviewsPublishVideoReview_568477(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Publish video review to make it available for review.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   reviewId: JString (required)
  ##           : Id of the review.
  ##   teamName: JString (required)
  ##           : Your team name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `reviewId` field"
  var valid_568479 = path.getOrDefault("reviewId")
  valid_568479 = validateParameter(valid_568479, JString, required = true,
                                 default = nil)
  if valid_568479 != nil:
    section.add "reviewId", valid_568479
  var valid_568480 = path.getOrDefault("teamName")
  valid_568480 = validateParameter(valid_568480, JString, required = true,
                                 default = nil)
  if valid_568480 != nil:
    section.add "teamName", valid_568480
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568481: Call_ReviewsPublishVideoReview_568476; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Publish video review to make it available for review.
  ## 
  let valid = call_568481.validator(path, query, header, formData, body)
  let scheme = call_568481.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568481.url(scheme.get, call_568481.host, call_568481.base,
                         call_568481.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568481, url, valid)

proc call*(call_568482: Call_ReviewsPublishVideoReview_568476; reviewId: string;
          teamName: string): Recallable =
  ## reviewsPublishVideoReview
  ## Publish video review to make it available for review.
  ##   reviewId: string (required)
  ##           : Id of the review.
  ##   teamName: string (required)
  ##           : Your team name.
  var path_568483 = newJObject()
  add(path_568483, "reviewId", newJString(reviewId))
  add(path_568483, "teamName", newJString(teamName))
  result = call_568482.call(path_568483, nil, nil, nil, nil)

var reviewsPublishVideoReview* = Call_ReviewsPublishVideoReview_568476(
    name: "reviewsPublishVideoReview", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/contentmoderator/review/v1.0/teams/{teamName}/reviews/{reviewId}/publish",
    validator: validate_ReviewsPublishVideoReview_568477, base: "",
    url: url_ReviewsPublishVideoReview_568478, schemes: {Scheme.Https})
type
  Call_ReviewsAddVideoTranscript_568484 = ref object of OpenApiRestCall_567658
proc url_ReviewsAddVideoTranscript_568486(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "teamName" in path, "`teamName` is a required path parameter"
  assert "reviewId" in path, "`reviewId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/contentmoderator/review/v1.0/teams/"),
               (kind: VariableSegment, value: "teamName"),
               (kind: ConstantSegment, value: "/reviews/"),
               (kind: VariableSegment, value: "reviewId"),
               (kind: ConstantSegment, value: "/transcript")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReviewsAddVideoTranscript_568485(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This API adds a transcript file (text version of all the words spoken in a video) to a video review. The file should be a valid WebVTT format.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   reviewId: JString (required)
  ##           : Id of the review.
  ##   teamName: JString (required)
  ##           : Your team name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `reviewId` field"
  var valid_568487 = path.getOrDefault("reviewId")
  valid_568487 = validateParameter(valid_568487, JString, required = true,
                                 default = nil)
  if valid_568487 != nil:
    section.add "reviewId", valid_568487
  var valid_568488 = path.getOrDefault("teamName")
  valid_568488 = validateParameter(valid_568488, JString, required = true,
                                 default = nil)
  if valid_568488 != nil:
    section.add "teamName", valid_568488
  result.add "path", section
  section = newJObject()
  result.add "query", section
  ## parameters in `header` object:
  ##   Content-Type: JString (required)
  ##               : The content type.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `Content-Type` field"
  var valid_568489 = header.getOrDefault("Content-Type")
  valid_568489 = validateParameter(valid_568489, JString, required = true,
                                 default = newJString("text/plain"))
  if valid_568489 != nil:
    section.add "Content-Type", valid_568489
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   VTT file: JObject (required)
  ##           : Transcript file of the video.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568491: Call_ReviewsAddVideoTranscript_568484; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This API adds a transcript file (text version of all the words spoken in a video) to a video review. The file should be a valid WebVTT format.
  ## 
  let valid = call_568491.validator(path, query, header, formData, body)
  let scheme = call_568491.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568491.url(scheme.get, call_568491.host, call_568491.base,
                         call_568491.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568491, url, valid)

proc call*(call_568492: Call_ReviewsAddVideoTranscript_568484; reviewId: string;
          teamName: string; VTTFile: JsonNode): Recallable =
  ## reviewsAddVideoTranscript
  ## This API adds a transcript file (text version of all the words spoken in a video) to a video review. The file should be a valid WebVTT format.
  ##   reviewId: string (required)
  ##           : Id of the review.
  ##   teamName: string (required)
  ##           : Your team name.
  ##   VTTFile: JObject (required)
  ##          : Transcript file of the video.
  var path_568493 = newJObject()
  var body_568494 = newJObject()
  add(path_568493, "reviewId", newJString(reviewId))
  add(path_568493, "teamName", newJString(teamName))
  if VTTFile != nil:
    body_568494 = VTTFile
  result = call_568492.call(path_568493, nil, nil, nil, body_568494)

var reviewsAddVideoTranscript* = Call_ReviewsAddVideoTranscript_568484(
    name: "reviewsAddVideoTranscript", meth: HttpMethod.HttpPut,
    host: "azure.local", route: "/contentmoderator/review/v1.0/teams/{teamName}/reviews/{reviewId}/transcript",
    validator: validate_ReviewsAddVideoTranscript_568485, base: "",
    url: url_ReviewsAddVideoTranscript_568486, schemes: {Scheme.Https})
type
  Call_ReviewsAddVideoTranscriptModerationResult_568495 = ref object of OpenApiRestCall_567658
proc url_ReviewsAddVideoTranscriptModerationResult_568497(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "teamName" in path, "`teamName` is a required path parameter"
  assert "reviewId" in path, "`reviewId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/contentmoderator/review/v1.0/teams/"),
               (kind: VariableSegment, value: "teamName"),
               (kind: ConstantSegment, value: "/reviews/"),
               (kind: VariableSegment, value: "reviewId"),
               (kind: ConstantSegment, value: "/transcriptmoderationresult")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReviewsAddVideoTranscriptModerationResult_568496(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This API adds a transcript screen text result file for a video review. Transcript screen text result file is a result of Screen Text API . In order to generate transcript screen text result file , a transcript file has to be screened for profanity using Screen Text API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   reviewId: JString (required)
  ##           : Id of the review.
  ##   teamName: JString (required)
  ##           : Your team name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `reviewId` field"
  var valid_568498 = path.getOrDefault("reviewId")
  valid_568498 = validateParameter(valid_568498, JString, required = true,
                                 default = nil)
  if valid_568498 != nil:
    section.add "reviewId", valid_568498
  var valid_568499 = path.getOrDefault("teamName")
  valid_568499 = validateParameter(valid_568499, JString, required = true,
                                 default = nil)
  if valid_568499 != nil:
    section.add "teamName", valid_568499
  result.add "path", section
  section = newJObject()
  result.add "query", section
  ## parameters in `header` object:
  ##   Content-Type: JString (required)
  ##               : The content type.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `Content-Type` field"
  var valid_568500 = header.getOrDefault("Content-Type")
  valid_568500 = validateParameter(valid_568500, JString, required = true,
                                 default = nil)
  if valid_568500 != nil:
    section.add "Content-Type", valid_568500
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   transcriptModerationBody: JArray (required)
  ##                           : Body for add video transcript moderation result API
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JArray, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568502: Call_ReviewsAddVideoTranscriptModerationResult_568495;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## This API adds a transcript screen text result file for a video review. Transcript screen text result file is a result of Screen Text API . In order to generate transcript screen text result file , a transcript file has to be screened for profanity using Screen Text API.
  ## 
  let valid = call_568502.validator(path, query, header, formData, body)
  let scheme = call_568502.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568502.url(scheme.get, call_568502.host, call_568502.base,
                         call_568502.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568502, url, valid)

proc call*(call_568503: Call_ReviewsAddVideoTranscriptModerationResult_568495;
          transcriptModerationBody: JsonNode; reviewId: string; teamName: string): Recallable =
  ## reviewsAddVideoTranscriptModerationResult
  ## This API adds a transcript screen text result file for a video review. Transcript screen text result file is a result of Screen Text API . In order to generate transcript screen text result file , a transcript file has to be screened for profanity using Screen Text API.
  ##   transcriptModerationBody: JArray (required)
  ##                           : Body for add video transcript moderation result API
  ##   reviewId: string (required)
  ##           : Id of the review.
  ##   teamName: string (required)
  ##           : Your team name.
  var path_568504 = newJObject()
  var body_568505 = newJObject()
  if transcriptModerationBody != nil:
    body_568505 = transcriptModerationBody
  add(path_568504, "reviewId", newJString(reviewId))
  add(path_568504, "teamName", newJString(teamName))
  result = call_568503.call(path_568504, nil, nil, nil, body_568505)

var reviewsAddVideoTranscriptModerationResult* = Call_ReviewsAddVideoTranscriptModerationResult_568495(
    name: "reviewsAddVideoTranscriptModerationResult", meth: HttpMethod.HttpPut,
    host: "azure.local", route: "/contentmoderator/review/v1.0/teams/{teamName}/reviews/{reviewId}/transcriptmoderationresult",
    validator: validate_ReviewsAddVideoTranscriptModerationResult_568496,
    base: "", url: url_ReviewsAddVideoTranscriptModerationResult_568497,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
