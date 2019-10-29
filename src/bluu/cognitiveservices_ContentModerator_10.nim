
import
  json, options, hashes, uri, rest, os, uri, httpcore

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
  macServiceName = "cognitiveservices-ContentModerator"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ListManagementImageListsCreate_564015 = ref object of OpenApiRestCall_563556
proc url_ListManagementImageListsCreate_564017(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ListManagementImageListsCreate_564016(path: JsonNode;
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
  var valid_564075 = header.getOrDefault("Content-Type")
  valid_564075 = validateParameter(valid_564075, JString, required = true,
                                 default = nil)
  if valid_564075 != nil:
    section.add "Content-Type", valid_564075
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

proc call*(call_564077: Call_ListManagementImageListsCreate_564015; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates an image list.
  ## 
  let valid = call_564077.validator(path, query, header, formData, body)
  let scheme = call_564077.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564077.url(scheme.get, call_564077.host, call_564077.base,
                         call_564077.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564077, url, valid)

proc call*(call_564078: Call_ListManagementImageListsCreate_564015; body: JsonNode): Recallable =
  ## listManagementImageListsCreate
  ## Creates an image list.
  ##   body: JObject (required)
  ##       : Schema of the body.
  var body_564079 = newJObject()
  if body != nil:
    body_564079 = body
  result = call_564078.call(nil, nil, nil, nil, body_564079)

var listManagementImageListsCreate* = Call_ListManagementImageListsCreate_564015(
    name: "listManagementImageListsCreate", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/contentmoderator/lists/v1.0/imagelists",
    validator: validate_ListManagementImageListsCreate_564016, base: "",
    url: url_ListManagementImageListsCreate_564017, schemes: {Scheme.Https})
type
  Call_ListManagementImageListsGetAllImageLists_563778 = ref object of OpenApiRestCall_563556
proc url_ListManagementImageListsGetAllImageLists_563780(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ListManagementImageListsGetAllImageLists_563779(path: JsonNode;
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

proc call*(call_563893: Call_ListManagementImageListsGetAllImageLists_563778;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all the Image Lists.
  ## 
  let valid = call_563893.validator(path, query, header, formData, body)
  let scheme = call_563893.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563893.url(scheme.get, call_563893.host, call_563893.base,
                         call_563893.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563893, url, valid)

proc call*(call_563977: Call_ListManagementImageListsGetAllImageLists_563778): Recallable =
  ## listManagementImageListsGetAllImageLists
  ## Gets all the Image Lists.
  result = call_563977.call(nil, nil, nil, nil, nil)

var listManagementImageListsGetAllImageLists* = Call_ListManagementImageListsGetAllImageLists_563778(
    name: "listManagementImageListsGetAllImageLists", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/contentmoderator/lists/v1.0/imagelists",
    validator: validate_ListManagementImageListsGetAllImageLists_563779, base: "",
    url: url_ListManagementImageListsGetAllImageLists_563780,
    schemes: {Scheme.Https})
type
  Call_ListManagementImageListsUpdate_564103 = ref object of OpenApiRestCall_563556
proc url_ListManagementImageListsUpdate_564105(protocol: Scheme; host: string;
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

proc validate_ListManagementImageListsUpdate_564104(path: JsonNode;
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
  var valid_564106 = path.getOrDefault("listId")
  valid_564106 = validateParameter(valid_564106, JString, required = true,
                                 default = nil)
  if valid_564106 != nil:
    section.add "listId", valid_564106
  result.add "path", section
  section = newJObject()
  result.add "query", section
  ## parameters in `header` object:
  ##   Content-Type: JString (required)
  ##               : The content type.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `Content-Type` field"
  var valid_564107 = header.getOrDefault("Content-Type")
  valid_564107 = validateParameter(valid_564107, JString, required = true,
                                 default = nil)
  if valid_564107 != nil:
    section.add "Content-Type", valid_564107
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

proc call*(call_564109: Call_ListManagementImageListsUpdate_564103; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an image list with list Id equal to list Id passed.
  ## 
  let valid = call_564109.validator(path, query, header, formData, body)
  let scheme = call_564109.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564109.url(scheme.get, call_564109.host, call_564109.base,
                         call_564109.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564109, url, valid)

proc call*(call_564110: Call_ListManagementImageListsUpdate_564103; body: JsonNode;
          listId: string): Recallable =
  ## listManagementImageListsUpdate
  ## Updates an image list with list Id equal to list Id passed.
  ##   body: JObject (required)
  ##       : Schema of the body.
  ##   listId: string (required)
  ##         : List Id of the image list.
  var path_564111 = newJObject()
  var body_564112 = newJObject()
  if body != nil:
    body_564112 = body
  add(path_564111, "listId", newJString(listId))
  result = call_564110.call(path_564111, nil, nil, nil, body_564112)

var listManagementImageListsUpdate* = Call_ListManagementImageListsUpdate_564103(
    name: "listManagementImageListsUpdate", meth: HttpMethod.HttpPut,
    host: "azure.local",
    route: "/contentmoderator/lists/v1.0/imagelists/{listId}",
    validator: validate_ListManagementImageListsUpdate_564104, base: "",
    url: url_ListManagementImageListsUpdate_564105, schemes: {Scheme.Https})
type
  Call_ListManagementImageListsGetDetails_564081 = ref object of OpenApiRestCall_563556
proc url_ListManagementImageListsGetDetails_564083(protocol: Scheme; host: string;
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

proc validate_ListManagementImageListsGetDetails_564082(path: JsonNode;
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
  var valid_564098 = path.getOrDefault("listId")
  valid_564098 = validateParameter(valid_564098, JString, required = true,
                                 default = nil)
  if valid_564098 != nil:
    section.add "listId", valid_564098
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564099: Call_ListManagementImageListsGetDetails_564081;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns the details of the image list with list Id equal to list Id passed.
  ## 
  let valid = call_564099.validator(path, query, header, formData, body)
  let scheme = call_564099.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564099.url(scheme.get, call_564099.host, call_564099.base,
                         call_564099.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564099, url, valid)

proc call*(call_564100: Call_ListManagementImageListsGetDetails_564081;
          listId: string): Recallable =
  ## listManagementImageListsGetDetails
  ## Returns the details of the image list with list Id equal to list Id passed.
  ##   listId: string (required)
  ##         : List Id of the image list.
  var path_564101 = newJObject()
  add(path_564101, "listId", newJString(listId))
  result = call_564100.call(path_564101, nil, nil, nil, nil)

var listManagementImageListsGetDetails* = Call_ListManagementImageListsGetDetails_564081(
    name: "listManagementImageListsGetDetails", meth: HttpMethod.HttpGet,
    host: "azure.local",
    route: "/contentmoderator/lists/v1.0/imagelists/{listId}",
    validator: validate_ListManagementImageListsGetDetails_564082, base: "",
    url: url_ListManagementImageListsGetDetails_564083, schemes: {Scheme.Https})
type
  Call_ListManagementImageListsDelete_564113 = ref object of OpenApiRestCall_563556
proc url_ListManagementImageListsDelete_564115(protocol: Scheme; host: string;
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

proc validate_ListManagementImageListsDelete_564114(path: JsonNode;
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
  var valid_564116 = path.getOrDefault("listId")
  valid_564116 = validateParameter(valid_564116, JString, required = true,
                                 default = nil)
  if valid_564116 != nil:
    section.add "listId", valid_564116
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564117: Call_ListManagementImageListsDelete_564113; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes image list with the list Id equal to list Id passed.
  ## 
  let valid = call_564117.validator(path, query, header, formData, body)
  let scheme = call_564117.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564117.url(scheme.get, call_564117.host, call_564117.base,
                         call_564117.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564117, url, valid)

proc call*(call_564118: Call_ListManagementImageListsDelete_564113; listId: string): Recallable =
  ## listManagementImageListsDelete
  ## Deletes image list with the list Id equal to list Id passed.
  ##   listId: string (required)
  ##         : List Id of the image list.
  var path_564119 = newJObject()
  add(path_564119, "listId", newJString(listId))
  result = call_564118.call(path_564119, nil, nil, nil, nil)

var listManagementImageListsDelete* = Call_ListManagementImageListsDelete_564113(
    name: "listManagementImageListsDelete", meth: HttpMethod.HttpDelete,
    host: "azure.local",
    route: "/contentmoderator/lists/v1.0/imagelists/{listId}",
    validator: validate_ListManagementImageListsDelete_564114, base: "",
    url: url_ListManagementImageListsDelete_564115, schemes: {Scheme.Https})
type
  Call_ListManagementImageListsRefreshIndex_564120 = ref object of OpenApiRestCall_563556
proc url_ListManagementImageListsRefreshIndex_564122(protocol: Scheme;
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

proc validate_ListManagementImageListsRefreshIndex_564121(path: JsonNode;
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
  var valid_564123 = path.getOrDefault("listId")
  valid_564123 = validateParameter(valid_564123, JString, required = true,
                                 default = nil)
  if valid_564123 != nil:
    section.add "listId", valid_564123
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564124: Call_ListManagementImageListsRefreshIndex_564120;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Refreshes the index of the list with list Id equal to list Id passed.
  ## 
  let valid = call_564124.validator(path, query, header, formData, body)
  let scheme = call_564124.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564124.url(scheme.get, call_564124.host, call_564124.base,
                         call_564124.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564124, url, valid)

proc call*(call_564125: Call_ListManagementImageListsRefreshIndex_564120;
          listId: string): Recallable =
  ## listManagementImageListsRefreshIndex
  ## Refreshes the index of the list with list Id equal to list Id passed.
  ##   listId: string (required)
  ##         : List Id of the image list.
  var path_564126 = newJObject()
  add(path_564126, "listId", newJString(listId))
  result = call_564125.call(path_564126, nil, nil, nil, nil)

var listManagementImageListsRefreshIndex* = Call_ListManagementImageListsRefreshIndex_564120(
    name: "listManagementImageListsRefreshIndex", meth: HttpMethod.HttpPost,
    host: "azure.local",
    route: "/contentmoderator/lists/v1.0/imagelists/{listId}/RefreshIndex",
    validator: validate_ListManagementImageListsRefreshIndex_564121, base: "",
    url: url_ListManagementImageListsRefreshIndex_564122, schemes: {Scheme.Https})
type
  Call_ListManagementImageAddImage_564134 = ref object of OpenApiRestCall_563556
proc url_ListManagementImageAddImage_564136(protocol: Scheme; host: string;
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

proc validate_ListManagementImageAddImage_564135(path: JsonNode; query: JsonNode;
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
  var valid_564137 = path.getOrDefault("listId")
  valid_564137 = validateParameter(valid_564137, JString, required = true,
                                 default = nil)
  if valid_564137 != nil:
    section.add "listId", valid_564137
  result.add "path", section
  ## parameters in `query` object:
  ##   tag: JInt
  ##      : Tag for the image.
  ##   label: JString
  ##        : The image label.
  section = newJObject()
  var valid_564138 = query.getOrDefault("tag")
  valid_564138 = validateParameter(valid_564138, JInt, required = false, default = nil)
  if valid_564138 != nil:
    section.add "tag", valid_564138
  var valid_564139 = query.getOrDefault("label")
  valid_564139 = validateParameter(valid_564139, JString, required = false,
                                 default = nil)
  if valid_564139 != nil:
    section.add "label", valid_564139
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564140: Call_ListManagementImageAddImage_564134; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Add an image to the list with list Id equal to list Id passed.
  ## 
  let valid = call_564140.validator(path, query, header, formData, body)
  let scheme = call_564140.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564140.url(scheme.get, call_564140.host, call_564140.base,
                         call_564140.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564140, url, valid)

proc call*(call_564141: Call_ListManagementImageAddImage_564134; listId: string;
          tag: int = 0; label: string = ""): Recallable =
  ## listManagementImageAddImage
  ## Add an image to the list with list Id equal to list Id passed.
  ##   tag: int
  ##      : Tag for the image.
  ##   label: string
  ##        : The image label.
  ##   listId: string (required)
  ##         : List Id of the image list.
  var path_564142 = newJObject()
  var query_564143 = newJObject()
  add(query_564143, "tag", newJInt(tag))
  add(query_564143, "label", newJString(label))
  add(path_564142, "listId", newJString(listId))
  result = call_564141.call(path_564142, query_564143, nil, nil, nil)

var listManagementImageAddImage* = Call_ListManagementImageAddImage_564134(
    name: "listManagementImageAddImage", meth: HttpMethod.HttpPost,
    host: "azure.local",
    route: "/contentmoderator/lists/v1.0/imagelists/{listId}/images",
    validator: validate_ListManagementImageAddImage_564135, base: "",
    url: url_ListManagementImageAddImage_564136, schemes: {Scheme.Https})
type
  Call_ListManagementImageGetAllImageIds_564127 = ref object of OpenApiRestCall_563556
proc url_ListManagementImageGetAllImageIds_564129(protocol: Scheme; host: string;
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

proc validate_ListManagementImageGetAllImageIds_564128(path: JsonNode;
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
  var valid_564130 = path.getOrDefault("listId")
  valid_564130 = validateParameter(valid_564130, JString, required = true,
                                 default = nil)
  if valid_564130 != nil:
    section.add "listId", valid_564130
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564131: Call_ListManagementImageGetAllImageIds_564127;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all image Ids from the list with list Id equal to list Id passed.
  ## 
  let valid = call_564131.validator(path, query, header, formData, body)
  let scheme = call_564131.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564131.url(scheme.get, call_564131.host, call_564131.base,
                         call_564131.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564131, url, valid)

proc call*(call_564132: Call_ListManagementImageGetAllImageIds_564127;
          listId: string): Recallable =
  ## listManagementImageGetAllImageIds
  ## Gets all image Ids from the list with list Id equal to list Id passed.
  ##   listId: string (required)
  ##         : List Id of the image list.
  var path_564133 = newJObject()
  add(path_564133, "listId", newJString(listId))
  result = call_564132.call(path_564133, nil, nil, nil, nil)

var listManagementImageGetAllImageIds* = Call_ListManagementImageGetAllImageIds_564127(
    name: "listManagementImageGetAllImageIds", meth: HttpMethod.HttpGet,
    host: "azure.local",
    route: "/contentmoderator/lists/v1.0/imagelists/{listId}/images",
    validator: validate_ListManagementImageGetAllImageIds_564128, base: "",
    url: url_ListManagementImageGetAllImageIds_564129, schemes: {Scheme.Https})
type
  Call_ListManagementImageDeleteAllImages_564144 = ref object of OpenApiRestCall_563556
proc url_ListManagementImageDeleteAllImages_564146(protocol: Scheme; host: string;
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

proc validate_ListManagementImageDeleteAllImages_564145(path: JsonNode;
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
  var valid_564147 = path.getOrDefault("listId")
  valid_564147 = validateParameter(valid_564147, JString, required = true,
                                 default = nil)
  if valid_564147 != nil:
    section.add "listId", valid_564147
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564148: Call_ListManagementImageDeleteAllImages_564144;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes all images from the list with list Id equal to list Id passed.
  ## 
  let valid = call_564148.validator(path, query, header, formData, body)
  let scheme = call_564148.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564148.url(scheme.get, call_564148.host, call_564148.base,
                         call_564148.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564148, url, valid)

proc call*(call_564149: Call_ListManagementImageDeleteAllImages_564144;
          listId: string): Recallable =
  ## listManagementImageDeleteAllImages
  ## Deletes all images from the list with list Id equal to list Id passed.
  ##   listId: string (required)
  ##         : List Id of the image list.
  var path_564150 = newJObject()
  add(path_564150, "listId", newJString(listId))
  result = call_564149.call(path_564150, nil, nil, nil, nil)

var listManagementImageDeleteAllImages* = Call_ListManagementImageDeleteAllImages_564144(
    name: "listManagementImageDeleteAllImages", meth: HttpMethod.HttpDelete,
    host: "azure.local",
    route: "/contentmoderator/lists/v1.0/imagelists/{listId}/images",
    validator: validate_ListManagementImageDeleteAllImages_564145, base: "",
    url: url_ListManagementImageDeleteAllImages_564146, schemes: {Scheme.Https})
type
  Call_ListManagementImageDeleteImage_564151 = ref object of OpenApiRestCall_563556
proc url_ListManagementImageDeleteImage_564153(protocol: Scheme; host: string;
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

proc validate_ListManagementImageDeleteImage_564152(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an image from the list with list Id and image Id passed.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   ImageId: JString (required)
  ##          : Id of the image.
  ##   listId: JString (required)
  ##         : List Id of the image list.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `ImageId` field"
  var valid_564154 = path.getOrDefault("ImageId")
  valid_564154 = validateParameter(valid_564154, JString, required = true,
                                 default = nil)
  if valid_564154 != nil:
    section.add "ImageId", valid_564154
  var valid_564155 = path.getOrDefault("listId")
  valid_564155 = validateParameter(valid_564155, JString, required = true,
                                 default = nil)
  if valid_564155 != nil:
    section.add "listId", valid_564155
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564156: Call_ListManagementImageDeleteImage_564151; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an image from the list with list Id and image Id passed.
  ## 
  let valid = call_564156.validator(path, query, header, formData, body)
  let scheme = call_564156.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564156.url(scheme.get, call_564156.host, call_564156.base,
                         call_564156.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564156, url, valid)

proc call*(call_564157: Call_ListManagementImageDeleteImage_564151;
          ImageId: string; listId: string): Recallable =
  ## listManagementImageDeleteImage
  ## Deletes an image from the list with list Id and image Id passed.
  ##   ImageId: string (required)
  ##          : Id of the image.
  ##   listId: string (required)
  ##         : List Id of the image list.
  var path_564158 = newJObject()
  add(path_564158, "ImageId", newJString(ImageId))
  add(path_564158, "listId", newJString(listId))
  result = call_564157.call(path_564158, nil, nil, nil, nil)

var listManagementImageDeleteImage* = Call_ListManagementImageDeleteImage_564151(
    name: "listManagementImageDeleteImage", meth: HttpMethod.HttpDelete,
    host: "azure.local",
    route: "/contentmoderator/lists/v1.0/imagelists/{listId}/images/{ImageId}",
    validator: validate_ListManagementImageDeleteImage_564152, base: "",
    url: url_ListManagementImageDeleteImage_564153, schemes: {Scheme.Https})
type
  Call_ListManagementTermListsCreate_564164 = ref object of OpenApiRestCall_563556
proc url_ListManagementTermListsCreate_564166(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ListManagementTermListsCreate_564165(path: JsonNode; query: JsonNode;
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
  var valid_564167 = header.getOrDefault("Content-Type")
  valid_564167 = validateParameter(valid_564167, JString, required = true,
                                 default = nil)
  if valid_564167 != nil:
    section.add "Content-Type", valid_564167
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

proc call*(call_564169: Call_ListManagementTermListsCreate_564164; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a Term List
  ## 
  let valid = call_564169.validator(path, query, header, formData, body)
  let scheme = call_564169.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564169.url(scheme.get, call_564169.host, call_564169.base,
                         call_564169.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564169, url, valid)

proc call*(call_564170: Call_ListManagementTermListsCreate_564164; body: JsonNode): Recallable =
  ## listManagementTermListsCreate
  ## Creates a Term List
  ##   body: JObject (required)
  ##       : Schema of the body.
  var body_564171 = newJObject()
  if body != nil:
    body_564171 = body
  result = call_564170.call(nil, nil, nil, nil, body_564171)

var listManagementTermListsCreate* = Call_ListManagementTermListsCreate_564164(
    name: "listManagementTermListsCreate", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/contentmoderator/lists/v1.0/termlists",
    validator: validate_ListManagementTermListsCreate_564165, base: "",
    url: url_ListManagementTermListsCreate_564166, schemes: {Scheme.Https})
type
  Call_ListManagementTermListsGetAllTermLists_564159 = ref object of OpenApiRestCall_563556
proc url_ListManagementTermListsGetAllTermLists_564161(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ListManagementTermListsGetAllTermLists_564160(path: JsonNode;
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

proc call*(call_564162: Call_ListManagementTermListsGetAllTermLists_564159;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## gets all the Term Lists
  ## 
  let valid = call_564162.validator(path, query, header, formData, body)
  let scheme = call_564162.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564162.url(scheme.get, call_564162.host, call_564162.base,
                         call_564162.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564162, url, valid)

proc call*(call_564163: Call_ListManagementTermListsGetAllTermLists_564159): Recallable =
  ## listManagementTermListsGetAllTermLists
  ## gets all the Term Lists
  result = call_564163.call(nil, nil, nil, nil, nil)

var listManagementTermListsGetAllTermLists* = Call_ListManagementTermListsGetAllTermLists_564159(
    name: "listManagementTermListsGetAllTermLists", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/contentmoderator/lists/v1.0/termlists",
    validator: validate_ListManagementTermListsGetAllTermLists_564160, base: "",
    url: url_ListManagementTermListsGetAllTermLists_564161,
    schemes: {Scheme.Https})
type
  Call_ListManagementTermListsUpdate_564179 = ref object of OpenApiRestCall_563556
proc url_ListManagementTermListsUpdate_564181(protocol: Scheme; host: string;
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

proc validate_ListManagementTermListsUpdate_564180(path: JsonNode; query: JsonNode;
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
  var valid_564182 = path.getOrDefault("listId")
  valid_564182 = validateParameter(valid_564182, JString, required = true,
                                 default = nil)
  if valid_564182 != nil:
    section.add "listId", valid_564182
  result.add "path", section
  section = newJObject()
  result.add "query", section
  ## parameters in `header` object:
  ##   Content-Type: JString (required)
  ##               : The content type.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `Content-Type` field"
  var valid_564183 = header.getOrDefault("Content-Type")
  valid_564183 = validateParameter(valid_564183, JString, required = true,
                                 default = nil)
  if valid_564183 != nil:
    section.add "Content-Type", valid_564183
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

proc call*(call_564185: Call_ListManagementTermListsUpdate_564179; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an Term List.
  ## 
  let valid = call_564185.validator(path, query, header, formData, body)
  let scheme = call_564185.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564185.url(scheme.get, call_564185.host, call_564185.base,
                         call_564185.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564185, url, valid)

proc call*(call_564186: Call_ListManagementTermListsUpdate_564179; body: JsonNode;
          listId: string): Recallable =
  ## listManagementTermListsUpdate
  ## Updates an Term List.
  ##   body: JObject (required)
  ##       : Schema of the body.
  ##   listId: string (required)
  ##         : List Id of the image list.
  var path_564187 = newJObject()
  var body_564188 = newJObject()
  if body != nil:
    body_564188 = body
  add(path_564187, "listId", newJString(listId))
  result = call_564186.call(path_564187, nil, nil, nil, body_564188)

var listManagementTermListsUpdate* = Call_ListManagementTermListsUpdate_564179(
    name: "listManagementTermListsUpdate", meth: HttpMethod.HttpPut,
    host: "azure.local", route: "/contentmoderator/lists/v1.0/termlists/{listId}",
    validator: validate_ListManagementTermListsUpdate_564180, base: "",
    url: url_ListManagementTermListsUpdate_564181, schemes: {Scheme.Https})
type
  Call_ListManagementTermListsGetDetails_564172 = ref object of OpenApiRestCall_563556
proc url_ListManagementTermListsGetDetails_564174(protocol: Scheme; host: string;
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

proc validate_ListManagementTermListsGetDetails_564173(path: JsonNode;
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
  var valid_564175 = path.getOrDefault("listId")
  valid_564175 = validateParameter(valid_564175, JString, required = true,
                                 default = nil)
  if valid_564175 != nil:
    section.add "listId", valid_564175
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564176: Call_ListManagementTermListsGetDetails_564172;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns list Id details of the term list with list Id equal to list Id passed.
  ## 
  let valid = call_564176.validator(path, query, header, formData, body)
  let scheme = call_564176.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564176.url(scheme.get, call_564176.host, call_564176.base,
                         call_564176.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564176, url, valid)

proc call*(call_564177: Call_ListManagementTermListsGetDetails_564172;
          listId: string): Recallable =
  ## listManagementTermListsGetDetails
  ## Returns list Id details of the term list with list Id equal to list Id passed.
  ##   listId: string (required)
  ##         : List Id of the image list.
  var path_564178 = newJObject()
  add(path_564178, "listId", newJString(listId))
  result = call_564177.call(path_564178, nil, nil, nil, nil)

var listManagementTermListsGetDetails* = Call_ListManagementTermListsGetDetails_564172(
    name: "listManagementTermListsGetDetails", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/contentmoderator/lists/v1.0/termlists/{listId}",
    validator: validate_ListManagementTermListsGetDetails_564173, base: "",
    url: url_ListManagementTermListsGetDetails_564174, schemes: {Scheme.Https})
type
  Call_ListManagementTermListsDelete_564189 = ref object of OpenApiRestCall_563556
proc url_ListManagementTermListsDelete_564191(protocol: Scheme; host: string;
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

proc validate_ListManagementTermListsDelete_564190(path: JsonNode; query: JsonNode;
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
  var valid_564192 = path.getOrDefault("listId")
  valid_564192 = validateParameter(valid_564192, JString, required = true,
                                 default = nil)
  if valid_564192 != nil:
    section.add "listId", valid_564192
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564193: Call_ListManagementTermListsDelete_564189; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes term list with the list Id equal to list Id passed.
  ## 
  let valid = call_564193.validator(path, query, header, formData, body)
  let scheme = call_564193.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564193.url(scheme.get, call_564193.host, call_564193.base,
                         call_564193.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564193, url, valid)

proc call*(call_564194: Call_ListManagementTermListsDelete_564189; listId: string): Recallable =
  ## listManagementTermListsDelete
  ## Deletes term list with the list Id equal to list Id passed.
  ##   listId: string (required)
  ##         : List Id of the image list.
  var path_564195 = newJObject()
  add(path_564195, "listId", newJString(listId))
  result = call_564194.call(path_564195, nil, nil, nil, nil)

var listManagementTermListsDelete* = Call_ListManagementTermListsDelete_564189(
    name: "listManagementTermListsDelete", meth: HttpMethod.HttpDelete,
    host: "azure.local", route: "/contentmoderator/lists/v1.0/termlists/{listId}",
    validator: validate_ListManagementTermListsDelete_564190, base: "",
    url: url_ListManagementTermListsDelete_564191, schemes: {Scheme.Https})
type
  Call_ListManagementTermListsRefreshIndex_564196 = ref object of OpenApiRestCall_563556
proc url_ListManagementTermListsRefreshIndex_564198(protocol: Scheme; host: string;
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

proc validate_ListManagementTermListsRefreshIndex_564197(path: JsonNode;
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
  var valid_564199 = path.getOrDefault("listId")
  valid_564199 = validateParameter(valid_564199, JString, required = true,
                                 default = nil)
  if valid_564199 != nil:
    section.add "listId", valid_564199
  result.add "path", section
  ## parameters in `query` object:
  ##   language: JString (required)
  ##           : Language of the terms.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `language` field"
  var valid_564200 = query.getOrDefault("language")
  valid_564200 = validateParameter(valid_564200, JString, required = true,
                                 default = nil)
  if valid_564200 != nil:
    section.add "language", valid_564200
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564201: Call_ListManagementTermListsRefreshIndex_564196;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Refreshes the index of the list with list Id equal to list ID passed.
  ## 
  let valid = call_564201.validator(path, query, header, formData, body)
  let scheme = call_564201.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564201.url(scheme.get, call_564201.host, call_564201.base,
                         call_564201.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564201, url, valid)

proc call*(call_564202: Call_ListManagementTermListsRefreshIndex_564196;
          listId: string; language: string): Recallable =
  ## listManagementTermListsRefreshIndex
  ## Refreshes the index of the list with list Id equal to list ID passed.
  ##   listId: string (required)
  ##         : List Id of the image list.
  ##   language: string (required)
  ##           : Language of the terms.
  var path_564203 = newJObject()
  var query_564204 = newJObject()
  add(path_564203, "listId", newJString(listId))
  add(query_564204, "language", newJString(language))
  result = call_564202.call(path_564203, query_564204, nil, nil, nil)

var listManagementTermListsRefreshIndex* = Call_ListManagementTermListsRefreshIndex_564196(
    name: "listManagementTermListsRefreshIndex", meth: HttpMethod.HttpPost,
    host: "azure.local",
    route: "/contentmoderator/lists/v1.0/termlists/{listId}/RefreshIndex",
    validator: validate_ListManagementTermListsRefreshIndex_564197, base: "",
    url: url_ListManagementTermListsRefreshIndex_564198, schemes: {Scheme.Https})
type
  Call_ListManagementTermGetAllTerms_564205 = ref object of OpenApiRestCall_563556
proc url_ListManagementTermGetAllTerms_564207(protocol: Scheme; host: string;
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

proc validate_ListManagementTermGetAllTerms_564206(path: JsonNode; query: JsonNode;
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
  var valid_564208 = path.getOrDefault("listId")
  valid_564208 = validateParameter(valid_564208, JString, required = true,
                                 default = nil)
  if valid_564208 != nil:
    section.add "listId", valid_564208
  result.add "path", section
  ## parameters in `query` object:
  ##   offset: JInt
  ##         : The pagination start index.
  ##   limit: JInt
  ##        : The max limit.
  ##   language: JString (required)
  ##           : Language of the terms.
  section = newJObject()
  var valid_564209 = query.getOrDefault("offset")
  valid_564209 = validateParameter(valid_564209, JInt, required = false, default = nil)
  if valid_564209 != nil:
    section.add "offset", valid_564209
  var valid_564210 = query.getOrDefault("limit")
  valid_564210 = validateParameter(valid_564210, JInt, required = false, default = nil)
  if valid_564210 != nil:
    section.add "limit", valid_564210
  assert query != nil,
        "query argument is necessary due to required `language` field"
  var valid_564211 = query.getOrDefault("language")
  valid_564211 = validateParameter(valid_564211, JString, required = true,
                                 default = nil)
  if valid_564211 != nil:
    section.add "language", valid_564211
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564212: Call_ListManagementTermGetAllTerms_564205; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all terms from the list with list Id equal to the list Id passed.
  ## 
  let valid = call_564212.validator(path, query, header, formData, body)
  let scheme = call_564212.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564212.url(scheme.get, call_564212.host, call_564212.base,
                         call_564212.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564212, url, valid)

proc call*(call_564213: Call_ListManagementTermGetAllTerms_564205; listId: string;
          language: string; offset: int = 0; limit: int = 0): Recallable =
  ## listManagementTermGetAllTerms
  ## Gets all terms from the list with list Id equal to the list Id passed.
  ##   offset: int
  ##         : The pagination start index.
  ##   limit: int
  ##        : The max limit.
  ##   listId: string (required)
  ##         : List Id of the image list.
  ##   language: string (required)
  ##           : Language of the terms.
  var path_564214 = newJObject()
  var query_564215 = newJObject()
  add(query_564215, "offset", newJInt(offset))
  add(query_564215, "limit", newJInt(limit))
  add(path_564214, "listId", newJString(listId))
  add(query_564215, "language", newJString(language))
  result = call_564213.call(path_564214, query_564215, nil, nil, nil)

var listManagementTermGetAllTerms* = Call_ListManagementTermGetAllTerms_564205(
    name: "listManagementTermGetAllTerms", meth: HttpMethod.HttpGet,
    host: "azure.local",
    route: "/contentmoderator/lists/v1.0/termlists/{listId}/terms",
    validator: validate_ListManagementTermGetAllTerms_564206, base: "",
    url: url_ListManagementTermGetAllTerms_564207, schemes: {Scheme.Https})
type
  Call_ListManagementTermDeleteAllTerms_564216 = ref object of OpenApiRestCall_563556
proc url_ListManagementTermDeleteAllTerms_564218(protocol: Scheme; host: string;
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

proc validate_ListManagementTermDeleteAllTerms_564217(path: JsonNode;
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
  var valid_564219 = path.getOrDefault("listId")
  valid_564219 = validateParameter(valid_564219, JString, required = true,
                                 default = nil)
  if valid_564219 != nil:
    section.add "listId", valid_564219
  result.add "path", section
  ## parameters in `query` object:
  ##   language: JString (required)
  ##           : Language of the terms.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `language` field"
  var valid_564220 = query.getOrDefault("language")
  valid_564220 = validateParameter(valid_564220, JString, required = true,
                                 default = nil)
  if valid_564220 != nil:
    section.add "language", valid_564220
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564221: Call_ListManagementTermDeleteAllTerms_564216;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes all terms from the list with list Id equal to the list Id passed.
  ## 
  let valid = call_564221.validator(path, query, header, formData, body)
  let scheme = call_564221.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564221.url(scheme.get, call_564221.host, call_564221.base,
                         call_564221.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564221, url, valid)

proc call*(call_564222: Call_ListManagementTermDeleteAllTerms_564216;
          listId: string; language: string): Recallable =
  ## listManagementTermDeleteAllTerms
  ## Deletes all terms from the list with list Id equal to the list Id passed.
  ##   listId: string (required)
  ##         : List Id of the image list.
  ##   language: string (required)
  ##           : Language of the terms.
  var path_564223 = newJObject()
  var query_564224 = newJObject()
  add(path_564223, "listId", newJString(listId))
  add(query_564224, "language", newJString(language))
  result = call_564222.call(path_564223, query_564224, nil, nil, nil)

var listManagementTermDeleteAllTerms* = Call_ListManagementTermDeleteAllTerms_564216(
    name: "listManagementTermDeleteAllTerms", meth: HttpMethod.HttpDelete,
    host: "azure.local",
    route: "/contentmoderator/lists/v1.0/termlists/{listId}/terms",
    validator: validate_ListManagementTermDeleteAllTerms_564217, base: "",
    url: url_ListManagementTermDeleteAllTerms_564218, schemes: {Scheme.Https})
type
  Call_ListManagementTermAddTerm_564225 = ref object of OpenApiRestCall_563556
proc url_ListManagementTermAddTerm_564227(protocol: Scheme; host: string;
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

proc validate_ListManagementTermAddTerm_564226(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Add a term to the term list with list Id equal to list Id passed.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   term: JString (required)
  ##       : Term to be deleted
  ##   listId: JString (required)
  ##         : List Id of the image list.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `term` field"
  var valid_564228 = path.getOrDefault("term")
  valid_564228 = validateParameter(valid_564228, JString, required = true,
                                 default = nil)
  if valid_564228 != nil:
    section.add "term", valid_564228
  var valid_564229 = path.getOrDefault("listId")
  valid_564229 = validateParameter(valid_564229, JString, required = true,
                                 default = nil)
  if valid_564229 != nil:
    section.add "listId", valid_564229
  result.add "path", section
  ## parameters in `query` object:
  ##   language: JString (required)
  ##           : Language of the terms.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `language` field"
  var valid_564230 = query.getOrDefault("language")
  valid_564230 = validateParameter(valid_564230, JString, required = true,
                                 default = nil)
  if valid_564230 != nil:
    section.add "language", valid_564230
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564231: Call_ListManagementTermAddTerm_564225; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Add a term to the term list with list Id equal to list Id passed.
  ## 
  let valid = call_564231.validator(path, query, header, formData, body)
  let scheme = call_564231.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564231.url(scheme.get, call_564231.host, call_564231.base,
                         call_564231.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564231, url, valid)

proc call*(call_564232: Call_ListManagementTermAddTerm_564225; term: string;
          listId: string; language: string): Recallable =
  ## listManagementTermAddTerm
  ## Add a term to the term list with list Id equal to list Id passed.
  ##   term: string (required)
  ##       : Term to be deleted
  ##   listId: string (required)
  ##         : List Id of the image list.
  ##   language: string (required)
  ##           : Language of the terms.
  var path_564233 = newJObject()
  var query_564234 = newJObject()
  add(path_564233, "term", newJString(term))
  add(path_564233, "listId", newJString(listId))
  add(query_564234, "language", newJString(language))
  result = call_564232.call(path_564233, query_564234, nil, nil, nil)

var listManagementTermAddTerm* = Call_ListManagementTermAddTerm_564225(
    name: "listManagementTermAddTerm", meth: HttpMethod.HttpPost,
    host: "azure.local",
    route: "/contentmoderator/lists/v1.0/termlists/{listId}/terms/{term}",
    validator: validate_ListManagementTermAddTerm_564226, base: "",
    url: url_ListManagementTermAddTerm_564227, schemes: {Scheme.Https})
type
  Call_ListManagementTermDeleteTerm_564235 = ref object of OpenApiRestCall_563556
proc url_ListManagementTermDeleteTerm_564237(protocol: Scheme; host: string;
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

proc validate_ListManagementTermDeleteTerm_564236(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a term from the list with list Id equal to the list Id passed.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   term: JString (required)
  ##       : Term to be deleted
  ##   listId: JString (required)
  ##         : List Id of the image list.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `term` field"
  var valid_564238 = path.getOrDefault("term")
  valid_564238 = validateParameter(valid_564238, JString, required = true,
                                 default = nil)
  if valid_564238 != nil:
    section.add "term", valid_564238
  var valid_564239 = path.getOrDefault("listId")
  valid_564239 = validateParameter(valid_564239, JString, required = true,
                                 default = nil)
  if valid_564239 != nil:
    section.add "listId", valid_564239
  result.add "path", section
  ## parameters in `query` object:
  ##   language: JString (required)
  ##           : Language of the terms.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `language` field"
  var valid_564240 = query.getOrDefault("language")
  valid_564240 = validateParameter(valid_564240, JString, required = true,
                                 default = nil)
  if valid_564240 != nil:
    section.add "language", valid_564240
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564241: Call_ListManagementTermDeleteTerm_564235; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a term from the list with list Id equal to the list Id passed.
  ## 
  let valid = call_564241.validator(path, query, header, formData, body)
  let scheme = call_564241.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564241.url(scheme.get, call_564241.host, call_564241.base,
                         call_564241.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564241, url, valid)

proc call*(call_564242: Call_ListManagementTermDeleteTerm_564235; term: string;
          listId: string; language: string): Recallable =
  ## listManagementTermDeleteTerm
  ## Deletes a term from the list with list Id equal to the list Id passed.
  ##   term: string (required)
  ##       : Term to be deleted
  ##   listId: string (required)
  ##         : List Id of the image list.
  ##   language: string (required)
  ##           : Language of the terms.
  var path_564243 = newJObject()
  var query_564244 = newJObject()
  add(path_564243, "term", newJString(term))
  add(path_564243, "listId", newJString(listId))
  add(query_564244, "language", newJString(language))
  result = call_564242.call(path_564243, query_564244, nil, nil, nil)

var listManagementTermDeleteTerm* = Call_ListManagementTermDeleteTerm_564235(
    name: "listManagementTermDeleteTerm", meth: HttpMethod.HttpDelete,
    host: "azure.local",
    route: "/contentmoderator/lists/v1.0/termlists/{listId}/terms/{term}",
    validator: validate_ListManagementTermDeleteTerm_564236, base: "",
    url: url_ListManagementTermDeleteTerm_564237, schemes: {Scheme.Https})
type
  Call_ImageModerationEvaluate_564245 = ref object of OpenApiRestCall_563556
proc url_ImageModerationEvaluate_564247(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ImageModerationEvaluate_564246(path: JsonNode; query: JsonNode;
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
  var valid_564248 = query.getOrDefault("CacheImage")
  valid_564248 = validateParameter(valid_564248, JBool, required = false, default = nil)
  if valid_564248 != nil:
    section.add "CacheImage", valid_564248
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564249: Call_ImageModerationEvaluate_564245; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns probabilities of the image containing racy or adult content.
  ## 
  let valid = call_564249.validator(path, query, header, formData, body)
  let scheme = call_564249.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564249.url(scheme.get, call_564249.host, call_564249.base,
                         call_564249.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564249, url, valid)

proc call*(call_564250: Call_ImageModerationEvaluate_564245;
          CacheImage: bool = false): Recallable =
  ## imageModerationEvaluate
  ## Returns probabilities of the image containing racy or adult content.
  ##   CacheImage: bool
  ##             : Whether to retain the submitted image for future use; defaults to false if omitted.
  var query_564251 = newJObject()
  add(query_564251, "CacheImage", newJBool(CacheImage))
  result = call_564250.call(nil, query_564251, nil, nil, nil)

var imageModerationEvaluate* = Call_ImageModerationEvaluate_564245(
    name: "imageModerationEvaluate", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/contentmoderator/moderate/v1.0/ProcessImage/Evaluate",
    validator: validate_ImageModerationEvaluate_564246, base: "",
    url: url_ImageModerationEvaluate_564247, schemes: {Scheme.Https})
type
  Call_ImageModerationFindFaces_564252 = ref object of OpenApiRestCall_563556
proc url_ImageModerationFindFaces_564254(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ImageModerationFindFaces_564253(path: JsonNode; query: JsonNode;
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
  var valid_564255 = query.getOrDefault("CacheImage")
  valid_564255 = validateParameter(valid_564255, JBool, required = false, default = nil)
  if valid_564255 != nil:
    section.add "CacheImage", valid_564255
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564256: Call_ImageModerationFindFaces_564252; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the list of faces found.
  ## 
  let valid = call_564256.validator(path, query, header, formData, body)
  let scheme = call_564256.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564256.url(scheme.get, call_564256.host, call_564256.base,
                         call_564256.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564256, url, valid)

proc call*(call_564257: Call_ImageModerationFindFaces_564252;
          CacheImage: bool = false): Recallable =
  ## imageModerationFindFaces
  ## Returns the list of faces found.
  ##   CacheImage: bool
  ##             : Whether to retain the submitted image for future use; defaults to false if omitted.
  var query_564258 = newJObject()
  add(query_564258, "CacheImage", newJBool(CacheImage))
  result = call_564257.call(nil, query_564258, nil, nil, nil)

var imageModerationFindFaces* = Call_ImageModerationFindFaces_564252(
    name: "imageModerationFindFaces", meth: HttpMethod.HttpPost,
    host: "azure.local",
    route: "/contentmoderator/moderate/v1.0/ProcessImage/FindFaces",
    validator: validate_ImageModerationFindFaces_564253, base: "",
    url: url_ImageModerationFindFaces_564254, schemes: {Scheme.Https})
type
  Call_ImageModerationMatch_564259 = ref object of OpenApiRestCall_563556
proc url_ImageModerationMatch_564261(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ImageModerationMatch_564260(path: JsonNode; query: JsonNode;
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
  ##   listId: JString
  ##         : The list Id.
  ##   CacheImage: JBool
  ##             : Whether to retain the submitted image for future use; defaults to false if omitted.
  section = newJObject()
  var valid_564262 = query.getOrDefault("listId")
  valid_564262 = validateParameter(valid_564262, JString, required = false,
                                 default = nil)
  if valid_564262 != nil:
    section.add "listId", valid_564262
  var valid_564263 = query.getOrDefault("CacheImage")
  valid_564263 = validateParameter(valid_564263, JBool, required = false, default = nil)
  if valid_564263 != nil:
    section.add "CacheImage", valid_564263
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564264: Call_ImageModerationMatch_564259; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Fuzzily match an image against one of your custom Image Lists. You can create and manage your custom image lists using <a href="/docs/services/578ff44d2703741568569ab9/operations/578ff7b12703741568569abe">this</a> API. 
  ## 
  ## Returns ID and tags of matching image.<br/>
  ## <br/>
  ## Note: Refresh Index must be run on the corresponding Image List before additions and removals are reflected in the response.
  ## 
  let valid = call_564264.validator(path, query, header, formData, body)
  let scheme = call_564264.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564264.url(scheme.get, call_564264.host, call_564264.base,
                         call_564264.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564264, url, valid)

proc call*(call_564265: Call_ImageModerationMatch_564259; listId: string = "";
          CacheImage: bool = false): Recallable =
  ## imageModerationMatch
  ## Fuzzily match an image against one of your custom Image Lists. You can create and manage your custom image lists using <a href="/docs/services/578ff44d2703741568569ab9/operations/578ff7b12703741568569abe">this</a> API. 
  ## 
  ## Returns ID and tags of matching image.<br/>
  ## <br/>
  ## Note: Refresh Index must be run on the corresponding Image List before additions and removals are reflected in the response.
  ##   listId: string
  ##         : The list Id.
  ##   CacheImage: bool
  ##             : Whether to retain the submitted image for future use; defaults to false if omitted.
  var query_564266 = newJObject()
  add(query_564266, "listId", newJString(listId))
  add(query_564266, "CacheImage", newJBool(CacheImage))
  result = call_564265.call(nil, query_564266, nil, nil, nil)

var imageModerationMatch* = Call_ImageModerationMatch_564259(
    name: "imageModerationMatch", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/contentmoderator/moderate/v1.0/ProcessImage/Match",
    validator: validate_ImageModerationMatch_564260, base: "",
    url: url_ImageModerationMatch_564261, schemes: {Scheme.Https})
type
  Call_ImageModerationOCR_564267 = ref object of OpenApiRestCall_563556
proc url_ImageModerationOCR_564269(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ImageModerationOCR_564268(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Returns any text found in the image for the language specified. If no language is specified in input then the detection defaults to English.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   enhanced: JBool
  ##           : When set to True, the image goes through additional processing to come with additional candidates.
  ## 
  ## image/tiff is not supported when enhanced is set to true
  ## 
  ## Note: This impacts the response time.
  ##   language: JString (required)
  ##           : Language of the terms.
  ##   CacheImage: JBool
  ##             : Whether to retain the submitted image for future use; defaults to false if omitted.
  section = newJObject()
  var valid_564283 = query.getOrDefault("enhanced")
  valid_564283 = validateParameter(valid_564283, JBool, required = false,
                                 default = newJBool(false))
  if valid_564283 != nil:
    section.add "enhanced", valid_564283
  assert query != nil,
        "query argument is necessary due to required `language` field"
  var valid_564284 = query.getOrDefault("language")
  valid_564284 = validateParameter(valid_564284, JString, required = true,
                                 default = nil)
  if valid_564284 != nil:
    section.add "language", valid_564284
  var valid_564285 = query.getOrDefault("CacheImage")
  valid_564285 = validateParameter(valid_564285, JBool, required = false, default = nil)
  if valid_564285 != nil:
    section.add "CacheImage", valid_564285
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564286: Call_ImageModerationOCR_564267; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns any text found in the image for the language specified. If no language is specified in input then the detection defaults to English.
  ## 
  let valid = call_564286.validator(path, query, header, formData, body)
  let scheme = call_564286.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564286.url(scheme.get, call_564286.host, call_564286.base,
                         call_564286.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564286, url, valid)

proc call*(call_564287: Call_ImageModerationOCR_564267; language: string;
          enhanced: bool = false; CacheImage: bool = false): Recallable =
  ## imageModerationOCR
  ## Returns any text found in the image for the language specified. If no language is specified in input then the detection defaults to English.
  ##   enhanced: bool
  ##           : When set to True, the image goes through additional processing to come with additional candidates.
  ## 
  ## image/tiff is not supported when enhanced is set to true
  ## 
  ## Note: This impacts the response time.
  ##   language: string (required)
  ##           : Language of the terms.
  ##   CacheImage: bool
  ##             : Whether to retain the submitted image for future use; defaults to false if omitted.
  var query_564288 = newJObject()
  add(query_564288, "enhanced", newJBool(enhanced))
  add(query_564288, "language", newJString(language))
  add(query_564288, "CacheImage", newJBool(CacheImage))
  result = call_564287.call(nil, query_564288, nil, nil, nil)

var imageModerationOCR* = Call_ImageModerationOCR_564267(
    name: "imageModerationOCR", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/contentmoderator/moderate/v1.0/ProcessImage/OCR",
    validator: validate_ImageModerationOCR_564268, base: "",
    url: url_ImageModerationOCR_564269, schemes: {Scheme.Https})
type
  Call_TextModerationDetectLanguage_564289 = ref object of OpenApiRestCall_563556
proc url_TextModerationDetectLanguage_564291(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_TextModerationDetectLanguage_564290(path: JsonNode; query: JsonNode;
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
  var valid_564292 = header.getOrDefault("Content-Type")
  valid_564292 = validateParameter(valid_564292, JString, required = true,
                                 default = newJString("text/plain"))
  if valid_564292 != nil:
    section.add "Content-Type", valid_564292
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

proc call*(call_564294: Call_TextModerationDetectLanguage_564289; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This operation will detect the language of given input content. Returns the <a href="http://www-01.sil.org/iso639-3/codes.asp">ISO 639-3 code</a> for the predominant language comprising the submitted text. Over 110 languages supported.
  ## 
  let valid = call_564294.validator(path, query, header, formData, body)
  let scheme = call_564294.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564294.url(scheme.get, call_564294.host, call_564294.base,
                         call_564294.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564294, url, valid)

proc call*(call_564295: Call_TextModerationDetectLanguage_564289;
          TextContent: JsonNode): Recallable =
  ## textModerationDetectLanguage
  ## This operation will detect the language of given input content. Returns the <a href="http://www-01.sil.org/iso639-3/codes.asp">ISO 639-3 code</a> for the predominant language comprising the submitted text. Over 110 languages supported.
  ##   TextContent: JObject (required)
  ##              : Content to screen.
  var body_564296 = newJObject()
  if TextContent != nil:
    body_564296 = TextContent
  result = call_564295.call(nil, nil, nil, nil, body_564296)

var textModerationDetectLanguage* = Call_TextModerationDetectLanguage_564289(
    name: "textModerationDetectLanguage", meth: HttpMethod.HttpPost,
    host: "azure.local",
    route: "/contentmoderator/moderate/v1.0/ProcessText/DetectLanguage",
    validator: validate_TextModerationDetectLanguage_564290, base: "",
    url: url_TextModerationDetectLanguage_564291, schemes: {Scheme.Https})
type
  Call_TextModerationScreenText_564297 = ref object of OpenApiRestCall_563556
proc url_TextModerationScreenText_564299(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_TextModerationScreenText_564298(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Detects profanity in more than 100 languages and match against custom and shared blacklists.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   autocorrect: JBool
  ##              : Autocorrect text.
  ##   PII: JBool
  ##      : Detect personal identifiable information.
  ##   classify: JBool
  ##           : Classify input.
  ##   listId: JString
  ##         : The list Id.
  ##   language: JString
  ##           : Language of the text.
  section = newJObject()
  var valid_564300 = query.getOrDefault("autocorrect")
  valid_564300 = validateParameter(valid_564300, JBool, required = false,
                                 default = newJBool(false))
  if valid_564300 != nil:
    section.add "autocorrect", valid_564300
  var valid_564301 = query.getOrDefault("PII")
  valid_564301 = validateParameter(valid_564301, JBool, required = false,
                                 default = newJBool(false))
  if valid_564301 != nil:
    section.add "PII", valid_564301
  var valid_564302 = query.getOrDefault("classify")
  valid_564302 = validateParameter(valid_564302, JBool, required = false,
                                 default = newJBool(false))
  if valid_564302 != nil:
    section.add "classify", valid_564302
  var valid_564303 = query.getOrDefault("listId")
  valid_564303 = validateParameter(valid_564303, JString, required = false,
                                 default = nil)
  if valid_564303 != nil:
    section.add "listId", valid_564303
  var valid_564304 = query.getOrDefault("language")
  valid_564304 = validateParameter(valid_564304, JString, required = false,
                                 default = nil)
  if valid_564304 != nil:
    section.add "language", valid_564304
  result.add "query", section
  ## parameters in `header` object:
  ##   Content-Type: JString (required)
  ##               : The content type.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `Content-Type` field"
  var valid_564305 = header.getOrDefault("Content-Type")
  valid_564305 = validateParameter(valid_564305, JString, required = true,
                                 default = newJString("text/plain"))
  if valid_564305 != nil:
    section.add "Content-Type", valid_564305
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

proc call*(call_564307: Call_TextModerationScreenText_564297; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Detects profanity in more than 100 languages and match against custom and shared blacklists.
  ## 
  let valid = call_564307.validator(path, query, header, formData, body)
  let scheme = call_564307.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564307.url(scheme.get, call_564307.host, call_564307.base,
                         call_564307.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564307, url, valid)

proc call*(call_564308: Call_TextModerationScreenText_564297;
          TextContent: JsonNode; autocorrect: bool = false; PII: bool = false;
          classify: bool = false; listId: string = ""; language: string = ""): Recallable =
  ## textModerationScreenText
  ## Detects profanity in more than 100 languages and match against custom and shared blacklists.
  ##   autocorrect: bool
  ##              : Autocorrect text.
  ##   PII: bool
  ##      : Detect personal identifiable information.
  ##   TextContent: JObject (required)
  ##              : Content to screen.
  ##   classify: bool
  ##           : Classify input.
  ##   listId: string
  ##         : The list Id.
  ##   language: string
  ##           : Language of the text.
  var query_564309 = newJObject()
  var body_564310 = newJObject()
  add(query_564309, "autocorrect", newJBool(autocorrect))
  add(query_564309, "PII", newJBool(PII))
  if TextContent != nil:
    body_564310 = TextContent
  add(query_564309, "classify", newJBool(classify))
  add(query_564309, "listId", newJString(listId))
  add(query_564309, "language", newJString(language))
  result = call_564308.call(nil, query_564309, nil, nil, body_564310)

var textModerationScreenText* = Call_TextModerationScreenText_564297(
    name: "textModerationScreenText", meth: HttpMethod.HttpPost,
    host: "azure.local",
    route: "/contentmoderator/moderate/v1.0/ProcessText/Screen/",
    validator: validate_TextModerationScreenText_564298, base: "",
    url: url_TextModerationScreenText_564299, schemes: {Scheme.Https})
type
  Call_ReviewsCreateJob_564311 = ref object of OpenApiRestCall_563556
proc url_ReviewsCreateJob_564313(protocol: Scheme; host: string; base: string;
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

proc validate_ReviewsCreateJob_564312(path: JsonNode; query: JsonNode;
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
  var valid_564314 = path.getOrDefault("teamName")
  valid_564314 = validateParameter(valid_564314, JString, required = true,
                                 default = nil)
  if valid_564314 != nil:
    section.add "teamName", valid_564314
  result.add "path", section
  ## parameters in `query` object:
  ##   ContentId: JString (required)
  ##            : Id/Name to identify the content submitted.
  ##   WorkflowName: JString (required)
  ##               : Workflow Name that you want to invoke.
  ##   CallBackEndpoint: JString
  ##                   : Callback endpoint for posting the create job result.
  ##   ContentType: JString (required)
  ##              : Image, Text or Video.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `ContentId` field"
  var valid_564315 = query.getOrDefault("ContentId")
  valid_564315 = validateParameter(valid_564315, JString, required = true,
                                 default = nil)
  if valid_564315 != nil:
    section.add "ContentId", valid_564315
  var valid_564316 = query.getOrDefault("WorkflowName")
  valid_564316 = validateParameter(valid_564316, JString, required = true,
                                 default = nil)
  if valid_564316 != nil:
    section.add "WorkflowName", valid_564316
  var valid_564317 = query.getOrDefault("CallBackEndpoint")
  valid_564317 = validateParameter(valid_564317, JString, required = false,
                                 default = nil)
  if valid_564317 != nil:
    section.add "CallBackEndpoint", valid_564317
  var valid_564318 = query.getOrDefault("ContentType")
  valid_564318 = validateParameter(valid_564318, JString, required = true,
                                 default = newJString("Image"))
  if valid_564318 != nil:
    section.add "ContentType", valid_564318
  result.add "query", section
  ## parameters in `header` object:
  ##   Content-Type: JString (required)
  ##               : The content type.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `Content-Type` field"
  var valid_564319 = header.getOrDefault("Content-Type")
  valid_564319 = validateParameter(valid_564319, JString, required = true,
                                 default = newJString("application/json"))
  if valid_564319 != nil:
    section.add "Content-Type", valid_564319
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

proc call*(call_564321: Call_ReviewsCreateJob_564311; path: JsonNode;
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
  let valid = call_564321.validator(path, query, header, formData, body)
  let scheme = call_564321.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564321.url(scheme.get, call_564321.host, call_564321.base,
                         call_564321.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564321, url, valid)

var reviewsCreateJob* = Call_ReviewsCreateJob_564311(name: "reviewsCreateJob",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/contentmoderator/review/v1.0/teams/{teamName}/jobs",
    validator: validate_ReviewsCreateJob_564312, base: "",
    url: url_ReviewsCreateJob_564313, schemes: {Scheme.Https})
type
  Call_ReviewsGetJobDetails_564326 = ref object of OpenApiRestCall_563556
proc url_ReviewsGetJobDetails_564328(protocol: Scheme; host: string; base: string;
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

proc validate_ReviewsGetJobDetails_564327(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the Job Details for a Job Id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   JobId: JString (required)
  ##        : Id of the job.
  ##   teamName: JString (required)
  ##           : Your Team Name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `JobId` field"
  var valid_564329 = path.getOrDefault("JobId")
  valid_564329 = validateParameter(valid_564329, JString, required = true,
                                 default = nil)
  if valid_564329 != nil:
    section.add "JobId", valid_564329
  var valid_564330 = path.getOrDefault("teamName")
  valid_564330 = validateParameter(valid_564330, JString, required = true,
                                 default = nil)
  if valid_564330 != nil:
    section.add "teamName", valid_564330
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564331: Call_ReviewsGetJobDetails_564326; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the Job Details for a Job Id.
  ## 
  let valid = call_564331.validator(path, query, header, formData, body)
  let scheme = call_564331.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564331.url(scheme.get, call_564331.host, call_564331.base,
                         call_564331.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564331, url, valid)

proc call*(call_564332: Call_ReviewsGetJobDetails_564326; JobId: string;
          teamName: string): Recallable =
  ## reviewsGetJobDetails
  ## Get the Job Details for a Job Id.
  ##   JobId: string (required)
  ##        : Id of the job.
  ##   teamName: string (required)
  ##           : Your Team Name.
  var path_564333 = newJObject()
  add(path_564333, "JobId", newJString(JobId))
  add(path_564333, "teamName", newJString(teamName))
  result = call_564332.call(path_564333, nil, nil, nil, nil)

var reviewsGetJobDetails* = Call_ReviewsGetJobDetails_564326(
    name: "reviewsGetJobDetails", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/contentmoderator/review/v1.0/teams/{teamName}/jobs/{JobId}",
    validator: validate_ReviewsGetJobDetails_564327, base: "",
    url: url_ReviewsGetJobDetails_564328, schemes: {Scheme.Https})
type
  Call_ReviewsCreateReviews_564334 = ref object of OpenApiRestCall_563556
proc url_ReviewsCreateReviews_564336(protocol: Scheme; host: string; base: string;
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

proc validate_ReviewsCreateReviews_564335(path: JsonNode; query: JsonNode;
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
  var valid_564337 = path.getOrDefault("teamName")
  valid_564337 = validateParameter(valid_564337, JString, required = true,
                                 default = nil)
  if valid_564337 != nil:
    section.add "teamName", valid_564337
  result.add "path", section
  ## parameters in `query` object:
  ##   subTeam: JString
  ##          : SubTeam of your team, you want to assign the created review to.
  section = newJObject()
  var valid_564338 = query.getOrDefault("subTeam")
  valid_564338 = validateParameter(valid_564338, JString, required = false,
                                 default = nil)
  if valid_564338 != nil:
    section.add "subTeam", valid_564338
  result.add "query", section
  ## parameters in `header` object:
  ##   UrlContentType: JString (required)
  ##                 : The content type.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `UrlContentType` field"
  var valid_564339 = header.getOrDefault("UrlContentType")
  valid_564339 = validateParameter(valid_564339, JString, required = true,
                                 default = nil)
  if valid_564339 != nil:
    section.add "UrlContentType", valid_564339
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

proc call*(call_564341: Call_ReviewsCreateReviews_564334; path: JsonNode;
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
  let valid = call_564341.validator(path, query, header, formData, body)
  let scheme = call_564341.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564341.url(scheme.get, call_564341.host, call_564341.base,
                         call_564341.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564341, url, valid)

proc call*(call_564342: Call_ReviewsCreateReviews_564334;
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
  var path_564343 = newJObject()
  var query_564344 = newJObject()
  var body_564345 = newJObject()
  if createReviewBody != nil:
    body_564345 = createReviewBody
  add(path_564343, "teamName", newJString(teamName))
  add(query_564344, "subTeam", newJString(subTeam))
  result = call_564342.call(path_564343, query_564344, nil, nil, body_564345)

var reviewsCreateReviews* = Call_ReviewsCreateReviews_564334(
    name: "reviewsCreateReviews", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/contentmoderator/review/v1.0/teams/{teamName}/reviews",
    validator: validate_ReviewsCreateReviews_564335, base: "",
    url: url_ReviewsCreateReviews_564336, schemes: {Scheme.Https})
type
  Call_ReviewsGetReview_564346 = ref object of OpenApiRestCall_563556
proc url_ReviewsGetReview_564348(protocol: Scheme; host: string; base: string;
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

proc validate_ReviewsGetReview_564347(path: JsonNode; query: JsonNode;
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
  var valid_564349 = path.getOrDefault("reviewId")
  valid_564349 = validateParameter(valid_564349, JString, required = true,
                                 default = nil)
  if valid_564349 != nil:
    section.add "reviewId", valid_564349
  var valid_564350 = path.getOrDefault("teamName")
  valid_564350 = validateParameter(valid_564350, JString, required = true,
                                 default = nil)
  if valid_564350 != nil:
    section.add "teamName", valid_564350
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564351: Call_ReviewsGetReview_564346; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns review details for the review Id passed.
  ## 
  let valid = call_564351.validator(path, query, header, formData, body)
  let scheme = call_564351.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564351.url(scheme.get, call_564351.host, call_564351.base,
                         call_564351.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564351, url, valid)

proc call*(call_564352: Call_ReviewsGetReview_564346; reviewId: string;
          teamName: string): Recallable =
  ## reviewsGetReview
  ## Returns review details for the review Id passed.
  ##   reviewId: string (required)
  ##           : Id of the review.
  ##   teamName: string (required)
  ##           : Your Team Name.
  var path_564353 = newJObject()
  add(path_564353, "reviewId", newJString(reviewId))
  add(path_564353, "teamName", newJString(teamName))
  result = call_564352.call(path_564353, nil, nil, nil, nil)

var reviewsGetReview* = Call_ReviewsGetReview_564346(name: "reviewsGetReview",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/contentmoderator/review/v1.0/teams/{teamName}/reviews/{reviewId}",
    validator: validate_ReviewsGetReview_564347, base: "",
    url: url_ReviewsGetReview_564348, schemes: {Scheme.Https})
type
  Call_ReviewsAddVideoFrame_564366 = ref object of OpenApiRestCall_563556
proc url_ReviewsAddVideoFrame_564368(protocol: Scheme; host: string; base: string;
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

proc validate_ReviewsAddVideoFrame_564367(path: JsonNode; query: JsonNode;
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
  var valid_564369 = path.getOrDefault("reviewId")
  valid_564369 = validateParameter(valid_564369, JString, required = true,
                                 default = nil)
  if valid_564369 != nil:
    section.add "reviewId", valid_564369
  var valid_564370 = path.getOrDefault("teamName")
  valid_564370 = validateParameter(valid_564370, JString, required = true,
                                 default = nil)
  if valid_564370 != nil:
    section.add "teamName", valid_564370
  result.add "path", section
  ## parameters in `query` object:
  ##   timescale: JInt
  ##            : Timescale of the video you are adding frames to.
  section = newJObject()
  var valid_564371 = query.getOrDefault("timescale")
  valid_564371 = validateParameter(valid_564371, JInt, required = false, default = nil)
  if valid_564371 != nil:
    section.add "timescale", valid_564371
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564372: Call_ReviewsAddVideoFrame_564366; path: JsonNode;
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
  let valid = call_564372.validator(path, query, header, formData, body)
  let scheme = call_564372.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564372.url(scheme.get, call_564372.host, call_564372.base,
                         call_564372.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564372, url, valid)

proc call*(call_564373: Call_ReviewsAddVideoFrame_564366; reviewId: string;
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
  ##   reviewId: string (required)
  ##           : Id of the review.
  ##   teamName: string (required)
  ##           : Your team name.
  ##   timescale: int
  ##            : Timescale of the video you are adding frames to.
  var path_564374 = newJObject()
  var query_564375 = newJObject()
  add(path_564374, "reviewId", newJString(reviewId))
  add(path_564374, "teamName", newJString(teamName))
  add(query_564375, "timescale", newJInt(timescale))
  result = call_564373.call(path_564374, query_564375, nil, nil, nil)

var reviewsAddVideoFrame* = Call_ReviewsAddVideoFrame_564366(
    name: "reviewsAddVideoFrame", meth: HttpMethod.HttpPost, host: "azure.local", route: "/contentmoderator/review/v1.0/teams/{teamName}/reviews/{reviewId}/frames",
    validator: validate_ReviewsAddVideoFrame_564367, base: "",
    url: url_ReviewsAddVideoFrame_564368, schemes: {Scheme.Https})
type
  Call_ReviewsGetVideoFrames_564354 = ref object of OpenApiRestCall_563556
proc url_ReviewsGetVideoFrames_564356(protocol: Scheme; host: string; base: string;
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

proc validate_ReviewsGetVideoFrames_564355(path: JsonNode; query: JsonNode;
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
  var valid_564357 = path.getOrDefault("reviewId")
  valid_564357 = validateParameter(valid_564357, JString, required = true,
                                 default = nil)
  if valid_564357 != nil:
    section.add "reviewId", valid_564357
  var valid_564358 = path.getOrDefault("teamName")
  valid_564358 = validateParameter(valid_564358, JString, required = true,
                                 default = nil)
  if valid_564358 != nil:
    section.add "teamName", valid_564358
  result.add "path", section
  ## parameters in `query` object:
  ##   filter: JString
  ##         : Get frames filtered by tags.
  ##   noOfRecords: JInt
  ##              : Number of frames to fetch.
  ##   startSeed: JInt
  ##            : Time stamp of the frame from where you want to start fetching the frames.
  section = newJObject()
  var valid_564359 = query.getOrDefault("filter")
  valid_564359 = validateParameter(valid_564359, JString, required = false,
                                 default = nil)
  if valid_564359 != nil:
    section.add "filter", valid_564359
  var valid_564360 = query.getOrDefault("noOfRecords")
  valid_564360 = validateParameter(valid_564360, JInt, required = false, default = nil)
  if valid_564360 != nil:
    section.add "noOfRecords", valid_564360
  var valid_564361 = query.getOrDefault("startSeed")
  valid_564361 = validateParameter(valid_564361, JInt, required = false, default = nil)
  if valid_564361 != nil:
    section.add "startSeed", valid_564361
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564362: Call_ReviewsGetVideoFrames_564354; path: JsonNode;
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
  let valid = call_564362.validator(path, query, header, formData, body)
  let scheme = call_564362.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564362.url(scheme.get, call_564362.host, call_564362.base,
                         call_564362.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564362, url, valid)

proc call*(call_564363: Call_ReviewsGetVideoFrames_564354; reviewId: string;
          teamName: string; filter: string = ""; noOfRecords: int = 0; startSeed: int = 0): Recallable =
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
  ##   reviewId: string (required)
  ##           : Id of the review.
  ##   filter: string
  ##         : Get frames filtered by tags.
  ##   teamName: string (required)
  ##           : Your team name.
  ##   noOfRecords: int
  ##              : Number of frames to fetch.
  ##   startSeed: int
  ##            : Time stamp of the frame from where you want to start fetching the frames.
  var path_564364 = newJObject()
  var query_564365 = newJObject()
  add(path_564364, "reviewId", newJString(reviewId))
  add(query_564365, "filter", newJString(filter))
  add(path_564364, "teamName", newJString(teamName))
  add(query_564365, "noOfRecords", newJInt(noOfRecords))
  add(query_564365, "startSeed", newJInt(startSeed))
  result = call_564363.call(path_564364, query_564365, nil, nil, nil)

var reviewsGetVideoFrames* = Call_ReviewsGetVideoFrames_564354(
    name: "reviewsGetVideoFrames", meth: HttpMethod.HttpGet, host: "azure.local", route: "/contentmoderator/review/v1.0/teams/{teamName}/reviews/{reviewId}/frames",
    validator: validate_ReviewsGetVideoFrames_564355, base: "",
    url: url_ReviewsGetVideoFrames_564356, schemes: {Scheme.Https})
type
  Call_ReviewsPublishVideoReview_564376 = ref object of OpenApiRestCall_563556
proc url_ReviewsPublishVideoReview_564378(protocol: Scheme; host: string;
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

proc validate_ReviewsPublishVideoReview_564377(path: JsonNode; query: JsonNode;
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
  var valid_564379 = path.getOrDefault("reviewId")
  valid_564379 = validateParameter(valid_564379, JString, required = true,
                                 default = nil)
  if valid_564379 != nil:
    section.add "reviewId", valid_564379
  var valid_564380 = path.getOrDefault("teamName")
  valid_564380 = validateParameter(valid_564380, JString, required = true,
                                 default = nil)
  if valid_564380 != nil:
    section.add "teamName", valid_564380
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564381: Call_ReviewsPublishVideoReview_564376; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Publish video review to make it available for review.
  ## 
  let valid = call_564381.validator(path, query, header, formData, body)
  let scheme = call_564381.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564381.url(scheme.get, call_564381.host, call_564381.base,
                         call_564381.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564381, url, valid)

proc call*(call_564382: Call_ReviewsPublishVideoReview_564376; reviewId: string;
          teamName: string): Recallable =
  ## reviewsPublishVideoReview
  ## Publish video review to make it available for review.
  ##   reviewId: string (required)
  ##           : Id of the review.
  ##   teamName: string (required)
  ##           : Your team name.
  var path_564383 = newJObject()
  add(path_564383, "reviewId", newJString(reviewId))
  add(path_564383, "teamName", newJString(teamName))
  result = call_564382.call(path_564383, nil, nil, nil, nil)

var reviewsPublishVideoReview* = Call_ReviewsPublishVideoReview_564376(
    name: "reviewsPublishVideoReview", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/contentmoderator/review/v1.0/teams/{teamName}/reviews/{reviewId}/publish",
    validator: validate_ReviewsPublishVideoReview_564377, base: "",
    url: url_ReviewsPublishVideoReview_564378, schemes: {Scheme.Https})
type
  Call_ReviewsAddVideoTranscript_564384 = ref object of OpenApiRestCall_563556
proc url_ReviewsAddVideoTranscript_564386(protocol: Scheme; host: string;
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

proc validate_ReviewsAddVideoTranscript_564385(path: JsonNode; query: JsonNode;
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
  var valid_564387 = path.getOrDefault("reviewId")
  valid_564387 = validateParameter(valid_564387, JString, required = true,
                                 default = nil)
  if valid_564387 != nil:
    section.add "reviewId", valid_564387
  var valid_564388 = path.getOrDefault("teamName")
  valid_564388 = validateParameter(valid_564388, JString, required = true,
                                 default = nil)
  if valid_564388 != nil:
    section.add "teamName", valid_564388
  result.add "path", section
  section = newJObject()
  result.add "query", section
  ## parameters in `header` object:
  ##   Content-Type: JString (required)
  ##               : The content type.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `Content-Type` field"
  var valid_564389 = header.getOrDefault("Content-Type")
  valid_564389 = validateParameter(valid_564389, JString, required = true,
                                 default = newJString("text/plain"))
  if valid_564389 != nil:
    section.add "Content-Type", valid_564389
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

proc call*(call_564391: Call_ReviewsAddVideoTranscript_564384; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This API adds a transcript file (text version of all the words spoken in a video) to a video review. The file should be a valid WebVTT format.
  ## 
  let valid = call_564391.validator(path, query, header, formData, body)
  let scheme = call_564391.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564391.url(scheme.get, call_564391.host, call_564391.base,
                         call_564391.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564391, url, valid)

proc call*(call_564392: Call_ReviewsAddVideoTranscript_564384; VTTFile: JsonNode;
          reviewId: string; teamName: string): Recallable =
  ## reviewsAddVideoTranscript
  ## This API adds a transcript file (text version of all the words spoken in a video) to a video review. The file should be a valid WebVTT format.
  ##   VTTFile: JObject (required)
  ##          : Transcript file of the video.
  ##   reviewId: string (required)
  ##           : Id of the review.
  ##   teamName: string (required)
  ##           : Your team name.
  var path_564393 = newJObject()
  var body_564394 = newJObject()
  if VTTFile != nil:
    body_564394 = VTTFile
  add(path_564393, "reviewId", newJString(reviewId))
  add(path_564393, "teamName", newJString(teamName))
  result = call_564392.call(path_564393, nil, nil, nil, body_564394)

var reviewsAddVideoTranscript* = Call_ReviewsAddVideoTranscript_564384(
    name: "reviewsAddVideoTranscript", meth: HttpMethod.HttpPut,
    host: "azure.local", route: "/contentmoderator/review/v1.0/teams/{teamName}/reviews/{reviewId}/transcript",
    validator: validate_ReviewsAddVideoTranscript_564385, base: "",
    url: url_ReviewsAddVideoTranscript_564386, schemes: {Scheme.Https})
type
  Call_ReviewsAddVideoTranscriptModerationResult_564395 = ref object of OpenApiRestCall_563556
proc url_ReviewsAddVideoTranscriptModerationResult_564397(protocol: Scheme;
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

proc validate_ReviewsAddVideoTranscriptModerationResult_564396(path: JsonNode;
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
  var valid_564398 = path.getOrDefault("reviewId")
  valid_564398 = validateParameter(valid_564398, JString, required = true,
                                 default = nil)
  if valid_564398 != nil:
    section.add "reviewId", valid_564398
  var valid_564399 = path.getOrDefault("teamName")
  valid_564399 = validateParameter(valid_564399, JString, required = true,
                                 default = nil)
  if valid_564399 != nil:
    section.add "teamName", valid_564399
  result.add "path", section
  section = newJObject()
  result.add "query", section
  ## parameters in `header` object:
  ##   Content-Type: JString (required)
  ##               : The content type.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `Content-Type` field"
  var valid_564400 = header.getOrDefault("Content-Type")
  valid_564400 = validateParameter(valid_564400, JString, required = true,
                                 default = nil)
  if valid_564400 != nil:
    section.add "Content-Type", valid_564400
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

proc call*(call_564402: Call_ReviewsAddVideoTranscriptModerationResult_564395;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## This API adds a transcript screen text result file for a video review. Transcript screen text result file is a result of Screen Text API . In order to generate transcript screen text result file , a transcript file has to be screened for profanity using Screen Text API.
  ## 
  let valid = call_564402.validator(path, query, header, formData, body)
  let scheme = call_564402.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564402.url(scheme.get, call_564402.host, call_564402.base,
                         call_564402.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564402, url, valid)

proc call*(call_564403: Call_ReviewsAddVideoTranscriptModerationResult_564395;
          transcriptModerationBody: JsonNode; reviewId: string; teamName: string): Recallable =
  ## reviewsAddVideoTranscriptModerationResult
  ## This API adds a transcript screen text result file for a video review. Transcript screen text result file is a result of Screen Text API . In order to generate transcript screen text result file , a transcript file has to be screened for profanity using Screen Text API.
  ##   transcriptModerationBody: JArray (required)
  ##                           : Body for add video transcript moderation result API
  ##   reviewId: string (required)
  ##           : Id of the review.
  ##   teamName: string (required)
  ##           : Your team name.
  var path_564404 = newJObject()
  var body_564405 = newJObject()
  if transcriptModerationBody != nil:
    body_564405 = transcriptModerationBody
  add(path_564404, "reviewId", newJString(reviewId))
  add(path_564404, "teamName", newJString(teamName))
  result = call_564403.call(path_564404, nil, nil, nil, body_564405)

var reviewsAddVideoTranscriptModerationResult* = Call_ReviewsAddVideoTranscriptModerationResult_564395(
    name: "reviewsAddVideoTranscriptModerationResult", meth: HttpMethod.HttpPut,
    host: "azure.local", route: "/contentmoderator/review/v1.0/teams/{teamName}/reviews/{reviewId}/transcriptmoderationresult",
    validator: validate_ReviewsAddVideoTranscriptModerationResult_564396,
    base: "", url: url_ReviewsAddVideoTranscriptModerationResult_564397,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
