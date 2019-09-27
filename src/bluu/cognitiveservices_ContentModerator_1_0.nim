
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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
  macServiceName = "cognitiveservices-ContentModerator"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ListManagementImageListsCreate_593884 = ref object of OpenApiRestCall_593425
proc url_ListManagementImageListsCreate_593886(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ListManagementImageListsCreate_593885(path: JsonNode;
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
  var valid_593942 = header.getOrDefault("Content-Type")
  valid_593942 = validateParameter(valid_593942, JString, required = true,
                                 default = nil)
  if valid_593942 != nil:
    section.add "Content-Type", valid_593942
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

proc call*(call_593944: Call_ListManagementImageListsCreate_593884; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates an image list.
  ## 
  let valid = call_593944.validator(path, query, header, formData, body)
  let scheme = call_593944.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593944.url(scheme.get, call_593944.host, call_593944.base,
                         call_593944.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593944, url, valid)

proc call*(call_593945: Call_ListManagementImageListsCreate_593884; body: JsonNode): Recallable =
  ## listManagementImageListsCreate
  ## Creates an image list.
  ##   body: JObject (required)
  ##       : Schema of the body.
  var body_593946 = newJObject()
  if body != nil:
    body_593946 = body
  result = call_593945.call(nil, nil, nil, nil, body_593946)

var listManagementImageListsCreate* = Call_ListManagementImageListsCreate_593884(
    name: "listManagementImageListsCreate", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/contentmoderator/lists/v1.0/imagelists",
    validator: validate_ListManagementImageListsCreate_593885, base: "",
    url: url_ListManagementImageListsCreate_593886, schemes: {Scheme.Https})
type
  Call_ListManagementImageListsGetAllImageLists_593647 = ref object of OpenApiRestCall_593425
proc url_ListManagementImageListsGetAllImageLists_593649(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ListManagementImageListsGetAllImageLists_593648(path: JsonNode;
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

proc call*(call_593762: Call_ListManagementImageListsGetAllImageLists_593647;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all the Image Lists.
  ## 
  let valid = call_593762.validator(path, query, header, formData, body)
  let scheme = call_593762.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593762.url(scheme.get, call_593762.host, call_593762.base,
                         call_593762.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593762, url, valid)

proc call*(call_593846: Call_ListManagementImageListsGetAllImageLists_593647): Recallable =
  ## listManagementImageListsGetAllImageLists
  ## Gets all the Image Lists.
  result = call_593846.call(nil, nil, nil, nil, nil)

var listManagementImageListsGetAllImageLists* = Call_ListManagementImageListsGetAllImageLists_593647(
    name: "listManagementImageListsGetAllImageLists", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/contentmoderator/lists/v1.0/imagelists",
    validator: validate_ListManagementImageListsGetAllImageLists_593648, base: "",
    url: url_ListManagementImageListsGetAllImageLists_593649,
    schemes: {Scheme.Https})
type
  Call_ListManagementImageListsUpdate_593970 = ref object of OpenApiRestCall_593425
proc url_ListManagementImageListsUpdate_593972(protocol: Scheme; host: string;
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

proc validate_ListManagementImageListsUpdate_593971(path: JsonNode;
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
  var valid_593973 = path.getOrDefault("listId")
  valid_593973 = validateParameter(valid_593973, JString, required = true,
                                 default = nil)
  if valid_593973 != nil:
    section.add "listId", valid_593973
  result.add "path", section
  section = newJObject()
  result.add "query", section
  ## parameters in `header` object:
  ##   Content-Type: JString (required)
  ##               : The content type.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `Content-Type` field"
  var valid_593974 = header.getOrDefault("Content-Type")
  valid_593974 = validateParameter(valid_593974, JString, required = true,
                                 default = nil)
  if valid_593974 != nil:
    section.add "Content-Type", valid_593974
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

proc call*(call_593976: Call_ListManagementImageListsUpdate_593970; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an image list with list Id equal to list Id passed.
  ## 
  let valid = call_593976.validator(path, query, header, formData, body)
  let scheme = call_593976.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593976.url(scheme.get, call_593976.host, call_593976.base,
                         call_593976.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593976, url, valid)

proc call*(call_593977: Call_ListManagementImageListsUpdate_593970; listId: string;
          body: JsonNode): Recallable =
  ## listManagementImageListsUpdate
  ## Updates an image list with list Id equal to list Id passed.
  ##   listId: string (required)
  ##         : List Id of the image list.
  ##   body: JObject (required)
  ##       : Schema of the body.
  var path_593978 = newJObject()
  var body_593979 = newJObject()
  add(path_593978, "listId", newJString(listId))
  if body != nil:
    body_593979 = body
  result = call_593977.call(path_593978, nil, nil, nil, body_593979)

var listManagementImageListsUpdate* = Call_ListManagementImageListsUpdate_593970(
    name: "listManagementImageListsUpdate", meth: HttpMethod.HttpPut,
    host: "azure.local",
    route: "/contentmoderator/lists/v1.0/imagelists/{listId}",
    validator: validate_ListManagementImageListsUpdate_593971, base: "",
    url: url_ListManagementImageListsUpdate_593972, schemes: {Scheme.Https})
type
  Call_ListManagementImageListsGetDetails_593948 = ref object of OpenApiRestCall_593425
proc url_ListManagementImageListsGetDetails_593950(protocol: Scheme; host: string;
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

proc validate_ListManagementImageListsGetDetails_593949(path: JsonNode;
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
  var valid_593965 = path.getOrDefault("listId")
  valid_593965 = validateParameter(valid_593965, JString, required = true,
                                 default = nil)
  if valid_593965 != nil:
    section.add "listId", valid_593965
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593966: Call_ListManagementImageListsGetDetails_593948;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns the details of the image list with list Id equal to list Id passed.
  ## 
  let valid = call_593966.validator(path, query, header, formData, body)
  let scheme = call_593966.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593966.url(scheme.get, call_593966.host, call_593966.base,
                         call_593966.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593966, url, valid)

proc call*(call_593967: Call_ListManagementImageListsGetDetails_593948;
          listId: string): Recallable =
  ## listManagementImageListsGetDetails
  ## Returns the details of the image list with list Id equal to list Id passed.
  ##   listId: string (required)
  ##         : List Id of the image list.
  var path_593968 = newJObject()
  add(path_593968, "listId", newJString(listId))
  result = call_593967.call(path_593968, nil, nil, nil, nil)

var listManagementImageListsGetDetails* = Call_ListManagementImageListsGetDetails_593948(
    name: "listManagementImageListsGetDetails", meth: HttpMethod.HttpGet,
    host: "azure.local",
    route: "/contentmoderator/lists/v1.0/imagelists/{listId}",
    validator: validate_ListManagementImageListsGetDetails_593949, base: "",
    url: url_ListManagementImageListsGetDetails_593950, schemes: {Scheme.Https})
type
  Call_ListManagementImageListsDelete_593980 = ref object of OpenApiRestCall_593425
proc url_ListManagementImageListsDelete_593982(protocol: Scheme; host: string;
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

proc validate_ListManagementImageListsDelete_593981(path: JsonNode;
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
  var valid_593983 = path.getOrDefault("listId")
  valid_593983 = validateParameter(valid_593983, JString, required = true,
                                 default = nil)
  if valid_593983 != nil:
    section.add "listId", valid_593983
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593984: Call_ListManagementImageListsDelete_593980; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes image list with the list Id equal to list Id passed.
  ## 
  let valid = call_593984.validator(path, query, header, formData, body)
  let scheme = call_593984.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593984.url(scheme.get, call_593984.host, call_593984.base,
                         call_593984.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593984, url, valid)

proc call*(call_593985: Call_ListManagementImageListsDelete_593980; listId: string): Recallable =
  ## listManagementImageListsDelete
  ## Deletes image list with the list Id equal to list Id passed.
  ##   listId: string (required)
  ##         : List Id of the image list.
  var path_593986 = newJObject()
  add(path_593986, "listId", newJString(listId))
  result = call_593985.call(path_593986, nil, nil, nil, nil)

var listManagementImageListsDelete* = Call_ListManagementImageListsDelete_593980(
    name: "listManagementImageListsDelete", meth: HttpMethod.HttpDelete,
    host: "azure.local",
    route: "/contentmoderator/lists/v1.0/imagelists/{listId}",
    validator: validate_ListManagementImageListsDelete_593981, base: "",
    url: url_ListManagementImageListsDelete_593982, schemes: {Scheme.Https})
type
  Call_ListManagementImageListsRefreshIndex_593987 = ref object of OpenApiRestCall_593425
proc url_ListManagementImageListsRefreshIndex_593989(protocol: Scheme;
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

proc validate_ListManagementImageListsRefreshIndex_593988(path: JsonNode;
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
  var valid_593990 = path.getOrDefault("listId")
  valid_593990 = validateParameter(valid_593990, JString, required = true,
                                 default = nil)
  if valid_593990 != nil:
    section.add "listId", valid_593990
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593991: Call_ListManagementImageListsRefreshIndex_593987;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Refreshes the index of the list with list Id equal to list Id passed.
  ## 
  let valid = call_593991.validator(path, query, header, formData, body)
  let scheme = call_593991.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593991.url(scheme.get, call_593991.host, call_593991.base,
                         call_593991.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593991, url, valid)

proc call*(call_593992: Call_ListManagementImageListsRefreshIndex_593987;
          listId: string): Recallable =
  ## listManagementImageListsRefreshIndex
  ## Refreshes the index of the list with list Id equal to list Id passed.
  ##   listId: string (required)
  ##         : List Id of the image list.
  var path_593993 = newJObject()
  add(path_593993, "listId", newJString(listId))
  result = call_593992.call(path_593993, nil, nil, nil, nil)

var listManagementImageListsRefreshIndex* = Call_ListManagementImageListsRefreshIndex_593987(
    name: "listManagementImageListsRefreshIndex", meth: HttpMethod.HttpPost,
    host: "azure.local",
    route: "/contentmoderator/lists/v1.0/imagelists/{listId}/RefreshIndex",
    validator: validate_ListManagementImageListsRefreshIndex_593988, base: "",
    url: url_ListManagementImageListsRefreshIndex_593989, schemes: {Scheme.Https})
type
  Call_ListManagementImageAddImage_594001 = ref object of OpenApiRestCall_593425
proc url_ListManagementImageAddImage_594003(protocol: Scheme; host: string;
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

proc validate_ListManagementImageAddImage_594002(path: JsonNode; query: JsonNode;
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
  var valid_594004 = path.getOrDefault("listId")
  valid_594004 = validateParameter(valid_594004, JString, required = true,
                                 default = nil)
  if valid_594004 != nil:
    section.add "listId", valid_594004
  result.add "path", section
  ## parameters in `query` object:
  ##   tag: JInt
  ##      : Tag for the image.
  ##   label: JString
  ##        : The image label.
  section = newJObject()
  var valid_594005 = query.getOrDefault("tag")
  valid_594005 = validateParameter(valid_594005, JInt, required = false, default = nil)
  if valid_594005 != nil:
    section.add "tag", valid_594005
  var valid_594006 = query.getOrDefault("label")
  valid_594006 = validateParameter(valid_594006, JString, required = false,
                                 default = nil)
  if valid_594006 != nil:
    section.add "label", valid_594006
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594007: Call_ListManagementImageAddImage_594001; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Add an image to the list with list Id equal to list Id passed.
  ## 
  let valid = call_594007.validator(path, query, header, formData, body)
  let scheme = call_594007.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594007.url(scheme.get, call_594007.host, call_594007.base,
                         call_594007.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594007, url, valid)

proc call*(call_594008: Call_ListManagementImageAddImage_594001; listId: string;
          tag: int = 0; label: string = ""): Recallable =
  ## listManagementImageAddImage
  ## Add an image to the list with list Id equal to list Id passed.
  ##   tag: int
  ##      : Tag for the image.
  ##   label: string
  ##        : The image label.
  ##   listId: string (required)
  ##         : List Id of the image list.
  var path_594009 = newJObject()
  var query_594010 = newJObject()
  add(query_594010, "tag", newJInt(tag))
  add(query_594010, "label", newJString(label))
  add(path_594009, "listId", newJString(listId))
  result = call_594008.call(path_594009, query_594010, nil, nil, nil)

var listManagementImageAddImage* = Call_ListManagementImageAddImage_594001(
    name: "listManagementImageAddImage", meth: HttpMethod.HttpPost,
    host: "azure.local",
    route: "/contentmoderator/lists/v1.0/imagelists/{listId}/images",
    validator: validate_ListManagementImageAddImage_594002, base: "",
    url: url_ListManagementImageAddImage_594003, schemes: {Scheme.Https})
type
  Call_ListManagementImageGetAllImageIds_593994 = ref object of OpenApiRestCall_593425
proc url_ListManagementImageGetAllImageIds_593996(protocol: Scheme; host: string;
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

proc validate_ListManagementImageGetAllImageIds_593995(path: JsonNode;
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
  var valid_593997 = path.getOrDefault("listId")
  valid_593997 = validateParameter(valid_593997, JString, required = true,
                                 default = nil)
  if valid_593997 != nil:
    section.add "listId", valid_593997
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593998: Call_ListManagementImageGetAllImageIds_593994;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all image Ids from the list with list Id equal to list Id passed.
  ## 
  let valid = call_593998.validator(path, query, header, formData, body)
  let scheme = call_593998.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593998.url(scheme.get, call_593998.host, call_593998.base,
                         call_593998.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593998, url, valid)

proc call*(call_593999: Call_ListManagementImageGetAllImageIds_593994;
          listId: string): Recallable =
  ## listManagementImageGetAllImageIds
  ## Gets all image Ids from the list with list Id equal to list Id passed.
  ##   listId: string (required)
  ##         : List Id of the image list.
  var path_594000 = newJObject()
  add(path_594000, "listId", newJString(listId))
  result = call_593999.call(path_594000, nil, nil, nil, nil)

var listManagementImageGetAllImageIds* = Call_ListManagementImageGetAllImageIds_593994(
    name: "listManagementImageGetAllImageIds", meth: HttpMethod.HttpGet,
    host: "azure.local",
    route: "/contentmoderator/lists/v1.0/imagelists/{listId}/images",
    validator: validate_ListManagementImageGetAllImageIds_593995, base: "",
    url: url_ListManagementImageGetAllImageIds_593996, schemes: {Scheme.Https})
type
  Call_ListManagementImageDeleteAllImages_594011 = ref object of OpenApiRestCall_593425
proc url_ListManagementImageDeleteAllImages_594013(protocol: Scheme; host: string;
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

proc validate_ListManagementImageDeleteAllImages_594012(path: JsonNode;
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
  var valid_594014 = path.getOrDefault("listId")
  valid_594014 = validateParameter(valid_594014, JString, required = true,
                                 default = nil)
  if valid_594014 != nil:
    section.add "listId", valid_594014
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594015: Call_ListManagementImageDeleteAllImages_594011;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes all images from the list with list Id equal to list Id passed.
  ## 
  let valid = call_594015.validator(path, query, header, formData, body)
  let scheme = call_594015.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594015.url(scheme.get, call_594015.host, call_594015.base,
                         call_594015.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594015, url, valid)

proc call*(call_594016: Call_ListManagementImageDeleteAllImages_594011;
          listId: string): Recallable =
  ## listManagementImageDeleteAllImages
  ## Deletes all images from the list with list Id equal to list Id passed.
  ##   listId: string (required)
  ##         : List Id of the image list.
  var path_594017 = newJObject()
  add(path_594017, "listId", newJString(listId))
  result = call_594016.call(path_594017, nil, nil, nil, nil)

var listManagementImageDeleteAllImages* = Call_ListManagementImageDeleteAllImages_594011(
    name: "listManagementImageDeleteAllImages", meth: HttpMethod.HttpDelete,
    host: "azure.local",
    route: "/contentmoderator/lists/v1.0/imagelists/{listId}/images",
    validator: validate_ListManagementImageDeleteAllImages_594012, base: "",
    url: url_ListManagementImageDeleteAllImages_594013, schemes: {Scheme.Https})
type
  Call_ListManagementImageDeleteImage_594018 = ref object of OpenApiRestCall_593425
proc url_ListManagementImageDeleteImage_594020(protocol: Scheme; host: string;
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

proc validate_ListManagementImageDeleteImage_594019(path: JsonNode;
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
  var valid_594021 = path.getOrDefault("listId")
  valid_594021 = validateParameter(valid_594021, JString, required = true,
                                 default = nil)
  if valid_594021 != nil:
    section.add "listId", valid_594021
  var valid_594022 = path.getOrDefault("ImageId")
  valid_594022 = validateParameter(valid_594022, JString, required = true,
                                 default = nil)
  if valid_594022 != nil:
    section.add "ImageId", valid_594022
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594023: Call_ListManagementImageDeleteImage_594018; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an image from the list with list Id and image Id passed.
  ## 
  let valid = call_594023.validator(path, query, header, formData, body)
  let scheme = call_594023.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594023.url(scheme.get, call_594023.host, call_594023.base,
                         call_594023.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594023, url, valid)

proc call*(call_594024: Call_ListManagementImageDeleteImage_594018; listId: string;
          ImageId: string): Recallable =
  ## listManagementImageDeleteImage
  ## Deletes an image from the list with list Id and image Id passed.
  ##   listId: string (required)
  ##         : List Id of the image list.
  ##   ImageId: string (required)
  ##          : Id of the image.
  var path_594025 = newJObject()
  add(path_594025, "listId", newJString(listId))
  add(path_594025, "ImageId", newJString(ImageId))
  result = call_594024.call(path_594025, nil, nil, nil, nil)

var listManagementImageDeleteImage* = Call_ListManagementImageDeleteImage_594018(
    name: "listManagementImageDeleteImage", meth: HttpMethod.HttpDelete,
    host: "azure.local",
    route: "/contentmoderator/lists/v1.0/imagelists/{listId}/images/{ImageId}",
    validator: validate_ListManagementImageDeleteImage_594019, base: "",
    url: url_ListManagementImageDeleteImage_594020, schemes: {Scheme.Https})
type
  Call_ListManagementTermListsCreate_594031 = ref object of OpenApiRestCall_593425
proc url_ListManagementTermListsCreate_594033(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ListManagementTermListsCreate_594032(path: JsonNode; query: JsonNode;
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
  var valid_594034 = header.getOrDefault("Content-Type")
  valid_594034 = validateParameter(valid_594034, JString, required = true,
                                 default = nil)
  if valid_594034 != nil:
    section.add "Content-Type", valid_594034
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

proc call*(call_594036: Call_ListManagementTermListsCreate_594031; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a Term List
  ## 
  let valid = call_594036.validator(path, query, header, formData, body)
  let scheme = call_594036.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594036.url(scheme.get, call_594036.host, call_594036.base,
                         call_594036.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594036, url, valid)

proc call*(call_594037: Call_ListManagementTermListsCreate_594031; body: JsonNode): Recallable =
  ## listManagementTermListsCreate
  ## Creates a Term List
  ##   body: JObject (required)
  ##       : Schema of the body.
  var body_594038 = newJObject()
  if body != nil:
    body_594038 = body
  result = call_594037.call(nil, nil, nil, nil, body_594038)

var listManagementTermListsCreate* = Call_ListManagementTermListsCreate_594031(
    name: "listManagementTermListsCreate", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/contentmoderator/lists/v1.0/termlists",
    validator: validate_ListManagementTermListsCreate_594032, base: "",
    url: url_ListManagementTermListsCreate_594033, schemes: {Scheme.Https})
type
  Call_ListManagementTermListsGetAllTermLists_594026 = ref object of OpenApiRestCall_593425
proc url_ListManagementTermListsGetAllTermLists_594028(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ListManagementTermListsGetAllTermLists_594027(path: JsonNode;
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

proc call*(call_594029: Call_ListManagementTermListsGetAllTermLists_594026;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## gets all the Term Lists
  ## 
  let valid = call_594029.validator(path, query, header, formData, body)
  let scheme = call_594029.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594029.url(scheme.get, call_594029.host, call_594029.base,
                         call_594029.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594029, url, valid)

proc call*(call_594030: Call_ListManagementTermListsGetAllTermLists_594026): Recallable =
  ## listManagementTermListsGetAllTermLists
  ## gets all the Term Lists
  result = call_594030.call(nil, nil, nil, nil, nil)

var listManagementTermListsGetAllTermLists* = Call_ListManagementTermListsGetAllTermLists_594026(
    name: "listManagementTermListsGetAllTermLists", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/contentmoderator/lists/v1.0/termlists",
    validator: validate_ListManagementTermListsGetAllTermLists_594027, base: "",
    url: url_ListManagementTermListsGetAllTermLists_594028,
    schemes: {Scheme.Https})
type
  Call_ListManagementTermListsUpdate_594046 = ref object of OpenApiRestCall_593425
proc url_ListManagementTermListsUpdate_594048(protocol: Scheme; host: string;
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

proc validate_ListManagementTermListsUpdate_594047(path: JsonNode; query: JsonNode;
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
  var valid_594049 = path.getOrDefault("listId")
  valid_594049 = validateParameter(valid_594049, JString, required = true,
                                 default = nil)
  if valid_594049 != nil:
    section.add "listId", valid_594049
  result.add "path", section
  section = newJObject()
  result.add "query", section
  ## parameters in `header` object:
  ##   Content-Type: JString (required)
  ##               : The content type.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `Content-Type` field"
  var valid_594050 = header.getOrDefault("Content-Type")
  valid_594050 = validateParameter(valid_594050, JString, required = true,
                                 default = nil)
  if valid_594050 != nil:
    section.add "Content-Type", valid_594050
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

proc call*(call_594052: Call_ListManagementTermListsUpdate_594046; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an Term List.
  ## 
  let valid = call_594052.validator(path, query, header, formData, body)
  let scheme = call_594052.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594052.url(scheme.get, call_594052.host, call_594052.base,
                         call_594052.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594052, url, valid)

proc call*(call_594053: Call_ListManagementTermListsUpdate_594046; listId: string;
          body: JsonNode): Recallable =
  ## listManagementTermListsUpdate
  ## Updates an Term List.
  ##   listId: string (required)
  ##         : List Id of the image list.
  ##   body: JObject (required)
  ##       : Schema of the body.
  var path_594054 = newJObject()
  var body_594055 = newJObject()
  add(path_594054, "listId", newJString(listId))
  if body != nil:
    body_594055 = body
  result = call_594053.call(path_594054, nil, nil, nil, body_594055)

var listManagementTermListsUpdate* = Call_ListManagementTermListsUpdate_594046(
    name: "listManagementTermListsUpdate", meth: HttpMethod.HttpPut,
    host: "azure.local", route: "/contentmoderator/lists/v1.0/termlists/{listId}",
    validator: validate_ListManagementTermListsUpdate_594047, base: "",
    url: url_ListManagementTermListsUpdate_594048, schemes: {Scheme.Https})
type
  Call_ListManagementTermListsGetDetails_594039 = ref object of OpenApiRestCall_593425
proc url_ListManagementTermListsGetDetails_594041(protocol: Scheme; host: string;
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

proc validate_ListManagementTermListsGetDetails_594040(path: JsonNode;
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
  var valid_594042 = path.getOrDefault("listId")
  valid_594042 = validateParameter(valid_594042, JString, required = true,
                                 default = nil)
  if valid_594042 != nil:
    section.add "listId", valid_594042
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594043: Call_ListManagementTermListsGetDetails_594039;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns list Id details of the term list with list Id equal to list Id passed.
  ## 
  let valid = call_594043.validator(path, query, header, formData, body)
  let scheme = call_594043.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594043.url(scheme.get, call_594043.host, call_594043.base,
                         call_594043.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594043, url, valid)

proc call*(call_594044: Call_ListManagementTermListsGetDetails_594039;
          listId: string): Recallable =
  ## listManagementTermListsGetDetails
  ## Returns list Id details of the term list with list Id equal to list Id passed.
  ##   listId: string (required)
  ##         : List Id of the image list.
  var path_594045 = newJObject()
  add(path_594045, "listId", newJString(listId))
  result = call_594044.call(path_594045, nil, nil, nil, nil)

var listManagementTermListsGetDetails* = Call_ListManagementTermListsGetDetails_594039(
    name: "listManagementTermListsGetDetails", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/contentmoderator/lists/v1.0/termlists/{listId}",
    validator: validate_ListManagementTermListsGetDetails_594040, base: "",
    url: url_ListManagementTermListsGetDetails_594041, schemes: {Scheme.Https})
type
  Call_ListManagementTermListsDelete_594056 = ref object of OpenApiRestCall_593425
proc url_ListManagementTermListsDelete_594058(protocol: Scheme; host: string;
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

proc validate_ListManagementTermListsDelete_594057(path: JsonNode; query: JsonNode;
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
  var valid_594059 = path.getOrDefault("listId")
  valid_594059 = validateParameter(valid_594059, JString, required = true,
                                 default = nil)
  if valid_594059 != nil:
    section.add "listId", valid_594059
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594060: Call_ListManagementTermListsDelete_594056; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes term list with the list Id equal to list Id passed.
  ## 
  let valid = call_594060.validator(path, query, header, formData, body)
  let scheme = call_594060.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594060.url(scheme.get, call_594060.host, call_594060.base,
                         call_594060.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594060, url, valid)

proc call*(call_594061: Call_ListManagementTermListsDelete_594056; listId: string): Recallable =
  ## listManagementTermListsDelete
  ## Deletes term list with the list Id equal to list Id passed.
  ##   listId: string (required)
  ##         : List Id of the image list.
  var path_594062 = newJObject()
  add(path_594062, "listId", newJString(listId))
  result = call_594061.call(path_594062, nil, nil, nil, nil)

var listManagementTermListsDelete* = Call_ListManagementTermListsDelete_594056(
    name: "listManagementTermListsDelete", meth: HttpMethod.HttpDelete,
    host: "azure.local", route: "/contentmoderator/lists/v1.0/termlists/{listId}",
    validator: validate_ListManagementTermListsDelete_594057, base: "",
    url: url_ListManagementTermListsDelete_594058, schemes: {Scheme.Https})
type
  Call_ListManagementTermListsRefreshIndex_594063 = ref object of OpenApiRestCall_593425
proc url_ListManagementTermListsRefreshIndex_594065(protocol: Scheme; host: string;
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

proc validate_ListManagementTermListsRefreshIndex_594064(path: JsonNode;
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
  var valid_594066 = path.getOrDefault("listId")
  valid_594066 = validateParameter(valid_594066, JString, required = true,
                                 default = nil)
  if valid_594066 != nil:
    section.add "listId", valid_594066
  result.add "path", section
  ## parameters in `query` object:
  ##   language: JString (required)
  ##           : Language of the terms.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `language` field"
  var valid_594067 = query.getOrDefault("language")
  valid_594067 = validateParameter(valid_594067, JString, required = true,
                                 default = nil)
  if valid_594067 != nil:
    section.add "language", valid_594067
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594068: Call_ListManagementTermListsRefreshIndex_594063;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Refreshes the index of the list with list Id equal to list ID passed.
  ## 
  let valid = call_594068.validator(path, query, header, formData, body)
  let scheme = call_594068.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594068.url(scheme.get, call_594068.host, call_594068.base,
                         call_594068.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594068, url, valid)

proc call*(call_594069: Call_ListManagementTermListsRefreshIndex_594063;
          language: string; listId: string): Recallable =
  ## listManagementTermListsRefreshIndex
  ## Refreshes the index of the list with list Id equal to list ID passed.
  ##   language: string (required)
  ##           : Language of the terms.
  ##   listId: string (required)
  ##         : List Id of the image list.
  var path_594070 = newJObject()
  var query_594071 = newJObject()
  add(query_594071, "language", newJString(language))
  add(path_594070, "listId", newJString(listId))
  result = call_594069.call(path_594070, query_594071, nil, nil, nil)

var listManagementTermListsRefreshIndex* = Call_ListManagementTermListsRefreshIndex_594063(
    name: "listManagementTermListsRefreshIndex", meth: HttpMethod.HttpPost,
    host: "azure.local",
    route: "/contentmoderator/lists/v1.0/termlists/{listId}/RefreshIndex",
    validator: validate_ListManagementTermListsRefreshIndex_594064, base: "",
    url: url_ListManagementTermListsRefreshIndex_594065, schemes: {Scheme.Https})
type
  Call_ListManagementTermGetAllTerms_594072 = ref object of OpenApiRestCall_593425
proc url_ListManagementTermGetAllTerms_594074(protocol: Scheme; host: string;
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

proc validate_ListManagementTermGetAllTerms_594073(path: JsonNode; query: JsonNode;
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
  var valid_594075 = path.getOrDefault("listId")
  valid_594075 = validateParameter(valid_594075, JString, required = true,
                                 default = nil)
  if valid_594075 != nil:
    section.add "listId", valid_594075
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
  var valid_594076 = query.getOrDefault("language")
  valid_594076 = validateParameter(valid_594076, JString, required = true,
                                 default = nil)
  if valid_594076 != nil:
    section.add "language", valid_594076
  var valid_594077 = query.getOrDefault("offset")
  valid_594077 = validateParameter(valid_594077, JInt, required = false, default = nil)
  if valid_594077 != nil:
    section.add "offset", valid_594077
  var valid_594078 = query.getOrDefault("limit")
  valid_594078 = validateParameter(valid_594078, JInt, required = false, default = nil)
  if valid_594078 != nil:
    section.add "limit", valid_594078
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594079: Call_ListManagementTermGetAllTerms_594072; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all terms from the list with list Id equal to the list Id passed.
  ## 
  let valid = call_594079.validator(path, query, header, formData, body)
  let scheme = call_594079.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594079.url(scheme.get, call_594079.host, call_594079.base,
                         call_594079.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594079, url, valid)

proc call*(call_594080: Call_ListManagementTermGetAllTerms_594072;
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
  var path_594081 = newJObject()
  var query_594082 = newJObject()
  add(query_594082, "language", newJString(language))
  add(query_594082, "offset", newJInt(offset))
  add(path_594081, "listId", newJString(listId))
  add(query_594082, "limit", newJInt(limit))
  result = call_594080.call(path_594081, query_594082, nil, nil, nil)

var listManagementTermGetAllTerms* = Call_ListManagementTermGetAllTerms_594072(
    name: "listManagementTermGetAllTerms", meth: HttpMethod.HttpGet,
    host: "azure.local",
    route: "/contentmoderator/lists/v1.0/termlists/{listId}/terms",
    validator: validate_ListManagementTermGetAllTerms_594073, base: "",
    url: url_ListManagementTermGetAllTerms_594074, schemes: {Scheme.Https})
type
  Call_ListManagementTermDeleteAllTerms_594083 = ref object of OpenApiRestCall_593425
proc url_ListManagementTermDeleteAllTerms_594085(protocol: Scheme; host: string;
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

proc validate_ListManagementTermDeleteAllTerms_594084(path: JsonNode;
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
  var valid_594086 = path.getOrDefault("listId")
  valid_594086 = validateParameter(valid_594086, JString, required = true,
                                 default = nil)
  if valid_594086 != nil:
    section.add "listId", valid_594086
  result.add "path", section
  ## parameters in `query` object:
  ##   language: JString (required)
  ##           : Language of the terms.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `language` field"
  var valid_594087 = query.getOrDefault("language")
  valid_594087 = validateParameter(valid_594087, JString, required = true,
                                 default = nil)
  if valid_594087 != nil:
    section.add "language", valid_594087
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594088: Call_ListManagementTermDeleteAllTerms_594083;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes all terms from the list with list Id equal to the list Id passed.
  ## 
  let valid = call_594088.validator(path, query, header, formData, body)
  let scheme = call_594088.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594088.url(scheme.get, call_594088.host, call_594088.base,
                         call_594088.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594088, url, valid)

proc call*(call_594089: Call_ListManagementTermDeleteAllTerms_594083;
          language: string; listId: string): Recallable =
  ## listManagementTermDeleteAllTerms
  ## Deletes all terms from the list with list Id equal to the list Id passed.
  ##   language: string (required)
  ##           : Language of the terms.
  ##   listId: string (required)
  ##         : List Id of the image list.
  var path_594090 = newJObject()
  var query_594091 = newJObject()
  add(query_594091, "language", newJString(language))
  add(path_594090, "listId", newJString(listId))
  result = call_594089.call(path_594090, query_594091, nil, nil, nil)

var listManagementTermDeleteAllTerms* = Call_ListManagementTermDeleteAllTerms_594083(
    name: "listManagementTermDeleteAllTerms", meth: HttpMethod.HttpDelete,
    host: "azure.local",
    route: "/contentmoderator/lists/v1.0/termlists/{listId}/terms",
    validator: validate_ListManagementTermDeleteAllTerms_594084, base: "",
    url: url_ListManagementTermDeleteAllTerms_594085, schemes: {Scheme.Https})
type
  Call_ListManagementTermAddTerm_594092 = ref object of OpenApiRestCall_593425
proc url_ListManagementTermAddTerm_594094(protocol: Scheme; host: string;
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

proc validate_ListManagementTermAddTerm_594093(path: JsonNode; query: JsonNode;
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
  var valid_594095 = path.getOrDefault("listId")
  valid_594095 = validateParameter(valid_594095, JString, required = true,
                                 default = nil)
  if valid_594095 != nil:
    section.add "listId", valid_594095
  var valid_594096 = path.getOrDefault("term")
  valid_594096 = validateParameter(valid_594096, JString, required = true,
                                 default = nil)
  if valid_594096 != nil:
    section.add "term", valid_594096
  result.add "path", section
  ## parameters in `query` object:
  ##   language: JString (required)
  ##           : Language of the terms.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `language` field"
  var valid_594097 = query.getOrDefault("language")
  valid_594097 = validateParameter(valid_594097, JString, required = true,
                                 default = nil)
  if valid_594097 != nil:
    section.add "language", valid_594097
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594098: Call_ListManagementTermAddTerm_594092; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Add a term to the term list with list Id equal to list Id passed.
  ## 
  let valid = call_594098.validator(path, query, header, formData, body)
  let scheme = call_594098.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594098.url(scheme.get, call_594098.host, call_594098.base,
                         call_594098.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594098, url, valid)

proc call*(call_594099: Call_ListManagementTermAddTerm_594092; language: string;
          listId: string; term: string): Recallable =
  ## listManagementTermAddTerm
  ## Add a term to the term list with list Id equal to list Id passed.
  ##   language: string (required)
  ##           : Language of the terms.
  ##   listId: string (required)
  ##         : List Id of the image list.
  ##   term: string (required)
  ##       : Term to be deleted
  var path_594100 = newJObject()
  var query_594101 = newJObject()
  add(query_594101, "language", newJString(language))
  add(path_594100, "listId", newJString(listId))
  add(path_594100, "term", newJString(term))
  result = call_594099.call(path_594100, query_594101, nil, nil, nil)

var listManagementTermAddTerm* = Call_ListManagementTermAddTerm_594092(
    name: "listManagementTermAddTerm", meth: HttpMethod.HttpPost,
    host: "azure.local",
    route: "/contentmoderator/lists/v1.0/termlists/{listId}/terms/{term}",
    validator: validate_ListManagementTermAddTerm_594093, base: "",
    url: url_ListManagementTermAddTerm_594094, schemes: {Scheme.Https})
type
  Call_ListManagementTermDeleteTerm_594102 = ref object of OpenApiRestCall_593425
proc url_ListManagementTermDeleteTerm_594104(protocol: Scheme; host: string;
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

proc validate_ListManagementTermDeleteTerm_594103(path: JsonNode; query: JsonNode;
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
  var valid_594105 = path.getOrDefault("listId")
  valid_594105 = validateParameter(valid_594105, JString, required = true,
                                 default = nil)
  if valid_594105 != nil:
    section.add "listId", valid_594105
  var valid_594106 = path.getOrDefault("term")
  valid_594106 = validateParameter(valid_594106, JString, required = true,
                                 default = nil)
  if valid_594106 != nil:
    section.add "term", valid_594106
  result.add "path", section
  ## parameters in `query` object:
  ##   language: JString (required)
  ##           : Language of the terms.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `language` field"
  var valid_594107 = query.getOrDefault("language")
  valid_594107 = validateParameter(valid_594107, JString, required = true,
                                 default = nil)
  if valid_594107 != nil:
    section.add "language", valid_594107
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594108: Call_ListManagementTermDeleteTerm_594102; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a term from the list with list Id equal to the list Id passed.
  ## 
  let valid = call_594108.validator(path, query, header, formData, body)
  let scheme = call_594108.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594108.url(scheme.get, call_594108.host, call_594108.base,
                         call_594108.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594108, url, valid)

proc call*(call_594109: Call_ListManagementTermDeleteTerm_594102; language: string;
          listId: string; term: string): Recallable =
  ## listManagementTermDeleteTerm
  ## Deletes a term from the list with list Id equal to the list Id passed.
  ##   language: string (required)
  ##           : Language of the terms.
  ##   listId: string (required)
  ##         : List Id of the image list.
  ##   term: string (required)
  ##       : Term to be deleted
  var path_594110 = newJObject()
  var query_594111 = newJObject()
  add(query_594111, "language", newJString(language))
  add(path_594110, "listId", newJString(listId))
  add(path_594110, "term", newJString(term))
  result = call_594109.call(path_594110, query_594111, nil, nil, nil)

var listManagementTermDeleteTerm* = Call_ListManagementTermDeleteTerm_594102(
    name: "listManagementTermDeleteTerm", meth: HttpMethod.HttpDelete,
    host: "azure.local",
    route: "/contentmoderator/lists/v1.0/termlists/{listId}/terms/{term}",
    validator: validate_ListManagementTermDeleteTerm_594103, base: "",
    url: url_ListManagementTermDeleteTerm_594104, schemes: {Scheme.Https})
type
  Call_ImageModerationEvaluate_594112 = ref object of OpenApiRestCall_593425
proc url_ImageModerationEvaluate_594114(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ImageModerationEvaluate_594113(path: JsonNode; query: JsonNode;
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
  var valid_594115 = query.getOrDefault("CacheImage")
  valid_594115 = validateParameter(valid_594115, JBool, required = false, default = nil)
  if valid_594115 != nil:
    section.add "CacheImage", valid_594115
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594116: Call_ImageModerationEvaluate_594112; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns probabilities of the image containing racy or adult content.
  ## 
  let valid = call_594116.validator(path, query, header, formData, body)
  let scheme = call_594116.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594116.url(scheme.get, call_594116.host, call_594116.base,
                         call_594116.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594116, url, valid)

proc call*(call_594117: Call_ImageModerationEvaluate_594112;
          CacheImage: bool = false): Recallable =
  ## imageModerationEvaluate
  ## Returns probabilities of the image containing racy or adult content.
  ##   CacheImage: bool
  ##             : Whether to retain the submitted image for future use; defaults to false if omitted.
  var query_594118 = newJObject()
  add(query_594118, "CacheImage", newJBool(CacheImage))
  result = call_594117.call(nil, query_594118, nil, nil, nil)

var imageModerationEvaluate* = Call_ImageModerationEvaluate_594112(
    name: "imageModerationEvaluate", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/contentmoderator/moderate/v1.0/ProcessImage/Evaluate",
    validator: validate_ImageModerationEvaluate_594113, base: "",
    url: url_ImageModerationEvaluate_594114, schemes: {Scheme.Https})
type
  Call_ImageModerationFindFaces_594119 = ref object of OpenApiRestCall_593425
proc url_ImageModerationFindFaces_594121(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ImageModerationFindFaces_594120(path: JsonNode; query: JsonNode;
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
  var valid_594122 = query.getOrDefault("CacheImage")
  valid_594122 = validateParameter(valid_594122, JBool, required = false, default = nil)
  if valid_594122 != nil:
    section.add "CacheImage", valid_594122
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594123: Call_ImageModerationFindFaces_594119; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the list of faces found.
  ## 
  let valid = call_594123.validator(path, query, header, formData, body)
  let scheme = call_594123.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594123.url(scheme.get, call_594123.host, call_594123.base,
                         call_594123.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594123, url, valid)

proc call*(call_594124: Call_ImageModerationFindFaces_594119;
          CacheImage: bool = false): Recallable =
  ## imageModerationFindFaces
  ## Returns the list of faces found.
  ##   CacheImage: bool
  ##             : Whether to retain the submitted image for future use; defaults to false if omitted.
  var query_594125 = newJObject()
  add(query_594125, "CacheImage", newJBool(CacheImage))
  result = call_594124.call(nil, query_594125, nil, nil, nil)

var imageModerationFindFaces* = Call_ImageModerationFindFaces_594119(
    name: "imageModerationFindFaces", meth: HttpMethod.HttpPost,
    host: "azure.local",
    route: "/contentmoderator/moderate/v1.0/ProcessImage/FindFaces",
    validator: validate_ImageModerationFindFaces_594120, base: "",
    url: url_ImageModerationFindFaces_594121, schemes: {Scheme.Https})
type
  Call_ImageModerationMatch_594126 = ref object of OpenApiRestCall_593425
proc url_ImageModerationMatch_594128(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ImageModerationMatch_594127(path: JsonNode; query: JsonNode;
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
  var valid_594129 = query.getOrDefault("CacheImage")
  valid_594129 = validateParameter(valid_594129, JBool, required = false, default = nil)
  if valid_594129 != nil:
    section.add "CacheImage", valid_594129
  var valid_594130 = query.getOrDefault("listId")
  valid_594130 = validateParameter(valid_594130, JString, required = false,
                                 default = nil)
  if valid_594130 != nil:
    section.add "listId", valid_594130
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594131: Call_ImageModerationMatch_594126; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Fuzzily match an image against one of your custom Image Lists. You can create and manage your custom image lists using <a href="/docs/services/578ff44d2703741568569ab9/operations/578ff7b12703741568569abe">this</a> API. 
  ## 
  ## Returns ID and tags of matching image.<br/>
  ## <br/>
  ## Note: Refresh Index must be run on the corresponding Image List before additions and removals are reflected in the response.
  ## 
  let valid = call_594131.validator(path, query, header, formData, body)
  let scheme = call_594131.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594131.url(scheme.get, call_594131.host, call_594131.base,
                         call_594131.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594131, url, valid)

proc call*(call_594132: Call_ImageModerationMatch_594126; CacheImage: bool = false;
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
  var query_594133 = newJObject()
  add(query_594133, "CacheImage", newJBool(CacheImage))
  add(query_594133, "listId", newJString(listId))
  result = call_594132.call(nil, query_594133, nil, nil, nil)

var imageModerationMatch* = Call_ImageModerationMatch_594126(
    name: "imageModerationMatch", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/contentmoderator/moderate/v1.0/ProcessImage/Match",
    validator: validate_ImageModerationMatch_594127, base: "",
    url: url_ImageModerationMatch_594128, schemes: {Scheme.Https})
type
  Call_ImageModerationOCR_594134 = ref object of OpenApiRestCall_593425
proc url_ImageModerationOCR_594136(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ImageModerationOCR_594135(path: JsonNode; query: JsonNode;
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
  var valid_594137 = query.getOrDefault("CacheImage")
  valid_594137 = validateParameter(valid_594137, JBool, required = false, default = nil)
  if valid_594137 != nil:
    section.add "CacheImage", valid_594137
  assert query != nil,
        "query argument is necessary due to required `language` field"
  var valid_594138 = query.getOrDefault("language")
  valid_594138 = validateParameter(valid_594138, JString, required = true,
                                 default = nil)
  if valid_594138 != nil:
    section.add "language", valid_594138
  var valid_594152 = query.getOrDefault("enhanced")
  valid_594152 = validateParameter(valid_594152, JBool, required = false,
                                 default = newJBool(false))
  if valid_594152 != nil:
    section.add "enhanced", valid_594152
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594153: Call_ImageModerationOCR_594134; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns any text found in the image for the language specified. If no language is specified in input then the detection defaults to English.
  ## 
  let valid = call_594153.validator(path, query, header, formData, body)
  let scheme = call_594153.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594153.url(scheme.get, call_594153.host, call_594153.base,
                         call_594153.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594153, url, valid)

proc call*(call_594154: Call_ImageModerationOCR_594134; language: string;
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
  var query_594155 = newJObject()
  add(query_594155, "CacheImage", newJBool(CacheImage))
  add(query_594155, "language", newJString(language))
  add(query_594155, "enhanced", newJBool(enhanced))
  result = call_594154.call(nil, query_594155, nil, nil, nil)

var imageModerationOCR* = Call_ImageModerationOCR_594134(
    name: "imageModerationOCR", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/contentmoderator/moderate/v1.0/ProcessImage/OCR",
    validator: validate_ImageModerationOCR_594135, base: "",
    url: url_ImageModerationOCR_594136, schemes: {Scheme.Https})
type
  Call_TextModerationDetectLanguage_594156 = ref object of OpenApiRestCall_593425
proc url_TextModerationDetectLanguage_594158(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_TextModerationDetectLanguage_594157(path: JsonNode; query: JsonNode;
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
  var valid_594159 = header.getOrDefault("Content-Type")
  valid_594159 = validateParameter(valid_594159, JString, required = true,
                                 default = newJString("text/plain"))
  if valid_594159 != nil:
    section.add "Content-Type", valid_594159
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

proc call*(call_594161: Call_TextModerationDetectLanguage_594156; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This operation will detect the language of given input content. Returns the <a href="http://www-01.sil.org/iso639-3/codes.asp">ISO 639-3 code</a> for the predominant language comprising the submitted text. Over 110 languages supported.
  ## 
  let valid = call_594161.validator(path, query, header, formData, body)
  let scheme = call_594161.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594161.url(scheme.get, call_594161.host, call_594161.base,
                         call_594161.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594161, url, valid)

proc call*(call_594162: Call_TextModerationDetectLanguage_594156;
          TextContent: JsonNode): Recallable =
  ## textModerationDetectLanguage
  ## This operation will detect the language of given input content. Returns the <a href="http://www-01.sil.org/iso639-3/codes.asp">ISO 639-3 code</a> for the predominant language comprising the submitted text. Over 110 languages supported.
  ##   TextContent: JObject (required)
  ##              : Content to screen.
  var body_594163 = newJObject()
  if TextContent != nil:
    body_594163 = TextContent
  result = call_594162.call(nil, nil, nil, nil, body_594163)

var textModerationDetectLanguage* = Call_TextModerationDetectLanguage_594156(
    name: "textModerationDetectLanguage", meth: HttpMethod.HttpPost,
    host: "azure.local",
    route: "/contentmoderator/moderate/v1.0/ProcessText/DetectLanguage",
    validator: validate_TextModerationDetectLanguage_594157, base: "",
    url: url_TextModerationDetectLanguage_594158, schemes: {Scheme.Https})
type
  Call_TextModerationScreenText_594164 = ref object of OpenApiRestCall_593425
proc url_TextModerationScreenText_594166(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_TextModerationScreenText_594165(path: JsonNode; query: JsonNode;
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
  var valid_594167 = query.getOrDefault("language")
  valid_594167 = validateParameter(valid_594167, JString, required = false,
                                 default = nil)
  if valid_594167 != nil:
    section.add "language", valid_594167
  var valid_594168 = query.getOrDefault("autocorrect")
  valid_594168 = validateParameter(valid_594168, JBool, required = false,
                                 default = newJBool(false))
  if valid_594168 != nil:
    section.add "autocorrect", valid_594168
  var valid_594169 = query.getOrDefault("PII")
  valid_594169 = validateParameter(valid_594169, JBool, required = false,
                                 default = newJBool(false))
  if valid_594169 != nil:
    section.add "PII", valid_594169
  var valid_594170 = query.getOrDefault("listId")
  valid_594170 = validateParameter(valid_594170, JString, required = false,
                                 default = nil)
  if valid_594170 != nil:
    section.add "listId", valid_594170
  var valid_594171 = query.getOrDefault("classify")
  valid_594171 = validateParameter(valid_594171, JBool, required = false,
                                 default = newJBool(false))
  if valid_594171 != nil:
    section.add "classify", valid_594171
  result.add "query", section
  ## parameters in `header` object:
  ##   Content-Type: JString (required)
  ##               : The content type.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `Content-Type` field"
  var valid_594172 = header.getOrDefault("Content-Type")
  valid_594172 = validateParameter(valid_594172, JString, required = true,
                                 default = newJString("text/plain"))
  if valid_594172 != nil:
    section.add "Content-Type", valid_594172
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

proc call*(call_594174: Call_TextModerationScreenText_594164; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Detects profanity in more than 100 languages and match against custom and shared blacklists.
  ## 
  let valid = call_594174.validator(path, query, header, formData, body)
  let scheme = call_594174.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594174.url(scheme.get, call_594174.host, call_594174.base,
                         call_594174.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594174, url, valid)

proc call*(call_594175: Call_TextModerationScreenText_594164;
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
  var query_594176 = newJObject()
  var body_594177 = newJObject()
  add(query_594176, "language", newJString(language))
  add(query_594176, "autocorrect", newJBool(autocorrect))
  add(query_594176, "PII", newJBool(PII))
  add(query_594176, "listId", newJString(listId))
  add(query_594176, "classify", newJBool(classify))
  if TextContent != nil:
    body_594177 = TextContent
  result = call_594175.call(nil, query_594176, nil, nil, body_594177)

var textModerationScreenText* = Call_TextModerationScreenText_594164(
    name: "textModerationScreenText", meth: HttpMethod.HttpPost,
    host: "azure.local",
    route: "/contentmoderator/moderate/v1.0/ProcessText/Screen/",
    validator: validate_TextModerationScreenText_594165, base: "",
    url: url_TextModerationScreenText_594166, schemes: {Scheme.Https})
type
  Call_ReviewsCreateJob_594178 = ref object of OpenApiRestCall_593425
proc url_ReviewsCreateJob_594180(protocol: Scheme; host: string; base: string;
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

proc validate_ReviewsCreateJob_594179(path: JsonNode; query: JsonNode;
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
  var valid_594181 = path.getOrDefault("teamName")
  valid_594181 = validateParameter(valid_594181, JString, required = true,
                                 default = nil)
  if valid_594181 != nil:
    section.add "teamName", valid_594181
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
  var valid_594182 = query.getOrDefault("WorkflowName")
  valid_594182 = validateParameter(valid_594182, JString, required = true,
                                 default = nil)
  if valid_594182 != nil:
    section.add "WorkflowName", valid_594182
  var valid_594183 = query.getOrDefault("CallBackEndpoint")
  valid_594183 = validateParameter(valid_594183, JString, required = false,
                                 default = nil)
  if valid_594183 != nil:
    section.add "CallBackEndpoint", valid_594183
  var valid_594184 = query.getOrDefault("ContentType")
  valid_594184 = validateParameter(valid_594184, JString, required = true,
                                 default = newJString("Image"))
  if valid_594184 != nil:
    section.add "ContentType", valid_594184
  var valid_594185 = query.getOrDefault("ContentId")
  valid_594185 = validateParameter(valid_594185, JString, required = true,
                                 default = nil)
  if valid_594185 != nil:
    section.add "ContentId", valid_594185
  result.add "query", section
  ## parameters in `header` object:
  ##   Content-Type: JString (required)
  ##               : The content type.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `Content-Type` field"
  var valid_594186 = header.getOrDefault("Content-Type")
  valid_594186 = validateParameter(valid_594186, JString, required = true,
                                 default = newJString("application/json"))
  if valid_594186 != nil:
    section.add "Content-Type", valid_594186
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

proc call*(call_594188: Call_ReviewsCreateJob_594178; path: JsonNode;
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
  let valid = call_594188.validator(path, query, header, formData, body)
  let scheme = call_594188.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594188.url(scheme.get, call_594188.host, call_594188.base,
                         call_594188.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594188, url, valid)

var reviewsCreateJob* = Call_ReviewsCreateJob_594178(name: "reviewsCreateJob",
    meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/contentmoderator/review/v1.0/teams/{teamName}/jobs",
    validator: validate_ReviewsCreateJob_594179, base: "",
    url: url_ReviewsCreateJob_594180, schemes: {Scheme.Https})
type
  Call_ReviewsGetJobDetails_594193 = ref object of OpenApiRestCall_593425
proc url_ReviewsGetJobDetails_594195(protocol: Scheme; host: string; base: string;
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

proc validate_ReviewsGetJobDetails_594194(path: JsonNode; query: JsonNode;
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
  var valid_594196 = path.getOrDefault("teamName")
  valid_594196 = validateParameter(valid_594196, JString, required = true,
                                 default = nil)
  if valid_594196 != nil:
    section.add "teamName", valid_594196
  var valid_594197 = path.getOrDefault("JobId")
  valid_594197 = validateParameter(valid_594197, JString, required = true,
                                 default = nil)
  if valid_594197 != nil:
    section.add "JobId", valid_594197
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594198: Call_ReviewsGetJobDetails_594193; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the Job Details for a Job Id.
  ## 
  let valid = call_594198.validator(path, query, header, formData, body)
  let scheme = call_594198.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594198.url(scheme.get, call_594198.host, call_594198.base,
                         call_594198.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594198, url, valid)

proc call*(call_594199: Call_ReviewsGetJobDetails_594193; teamName: string;
          JobId: string): Recallable =
  ## reviewsGetJobDetails
  ## Get the Job Details for a Job Id.
  ##   teamName: string (required)
  ##           : Your Team Name.
  ##   JobId: string (required)
  ##        : Id of the job.
  var path_594200 = newJObject()
  add(path_594200, "teamName", newJString(teamName))
  add(path_594200, "JobId", newJString(JobId))
  result = call_594199.call(path_594200, nil, nil, nil, nil)

var reviewsGetJobDetails* = Call_ReviewsGetJobDetails_594193(
    name: "reviewsGetJobDetails", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/contentmoderator/review/v1.0/teams/{teamName}/jobs/{JobId}",
    validator: validate_ReviewsGetJobDetails_594194, base: "",
    url: url_ReviewsGetJobDetails_594195, schemes: {Scheme.Https})
type
  Call_ReviewsCreateReviews_594201 = ref object of OpenApiRestCall_593425
proc url_ReviewsCreateReviews_594203(protocol: Scheme; host: string; base: string;
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

proc validate_ReviewsCreateReviews_594202(path: JsonNode; query: JsonNode;
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
  var valid_594204 = path.getOrDefault("teamName")
  valid_594204 = validateParameter(valid_594204, JString, required = true,
                                 default = nil)
  if valid_594204 != nil:
    section.add "teamName", valid_594204
  result.add "path", section
  ## parameters in `query` object:
  ##   subTeam: JString
  ##          : SubTeam of your team, you want to assign the created review to.
  section = newJObject()
  var valid_594205 = query.getOrDefault("subTeam")
  valid_594205 = validateParameter(valid_594205, JString, required = false,
                                 default = nil)
  if valid_594205 != nil:
    section.add "subTeam", valid_594205
  result.add "query", section
  ## parameters in `header` object:
  ##   UrlContentType: JString (required)
  ##                 : The content type.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `UrlContentType` field"
  var valid_594206 = header.getOrDefault("UrlContentType")
  valid_594206 = validateParameter(valid_594206, JString, required = true,
                                 default = nil)
  if valid_594206 != nil:
    section.add "UrlContentType", valid_594206
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

proc call*(call_594208: Call_ReviewsCreateReviews_594201; path: JsonNode;
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
  let valid = call_594208.validator(path, query, header, formData, body)
  let scheme = call_594208.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594208.url(scheme.get, call_594208.host, call_594208.base,
                         call_594208.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594208, url, valid)

proc call*(call_594209: Call_ReviewsCreateReviews_594201;
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
  var path_594210 = newJObject()
  var query_594211 = newJObject()
  var body_594212 = newJObject()
  if createReviewBody != nil:
    body_594212 = createReviewBody
  add(path_594210, "teamName", newJString(teamName))
  add(query_594211, "subTeam", newJString(subTeam))
  result = call_594209.call(path_594210, query_594211, nil, nil, body_594212)

var reviewsCreateReviews* = Call_ReviewsCreateReviews_594201(
    name: "reviewsCreateReviews", meth: HttpMethod.HttpPost, host: "azure.local",
    route: "/contentmoderator/review/v1.0/teams/{teamName}/reviews",
    validator: validate_ReviewsCreateReviews_594202, base: "",
    url: url_ReviewsCreateReviews_594203, schemes: {Scheme.Https})
type
  Call_ReviewsGetReview_594213 = ref object of OpenApiRestCall_593425
proc url_ReviewsGetReview_594215(protocol: Scheme; host: string; base: string;
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

proc validate_ReviewsGetReview_594214(path: JsonNode; query: JsonNode;
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
  var valid_594216 = path.getOrDefault("reviewId")
  valid_594216 = validateParameter(valid_594216, JString, required = true,
                                 default = nil)
  if valid_594216 != nil:
    section.add "reviewId", valid_594216
  var valid_594217 = path.getOrDefault("teamName")
  valid_594217 = validateParameter(valid_594217, JString, required = true,
                                 default = nil)
  if valid_594217 != nil:
    section.add "teamName", valid_594217
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594218: Call_ReviewsGetReview_594213; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns review details for the review Id passed.
  ## 
  let valid = call_594218.validator(path, query, header, formData, body)
  let scheme = call_594218.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594218.url(scheme.get, call_594218.host, call_594218.base,
                         call_594218.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594218, url, valid)

proc call*(call_594219: Call_ReviewsGetReview_594213; reviewId: string;
          teamName: string): Recallable =
  ## reviewsGetReview
  ## Returns review details for the review Id passed.
  ##   reviewId: string (required)
  ##           : Id of the review.
  ##   teamName: string (required)
  ##           : Your Team Name.
  var path_594220 = newJObject()
  add(path_594220, "reviewId", newJString(reviewId))
  add(path_594220, "teamName", newJString(teamName))
  result = call_594219.call(path_594220, nil, nil, nil, nil)

var reviewsGetReview* = Call_ReviewsGetReview_594213(name: "reviewsGetReview",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/contentmoderator/review/v1.0/teams/{teamName}/reviews/{reviewId}",
    validator: validate_ReviewsGetReview_594214, base: "",
    url: url_ReviewsGetReview_594215, schemes: {Scheme.Https})
type
  Call_ReviewsAddVideoFrame_594233 = ref object of OpenApiRestCall_593425
proc url_ReviewsAddVideoFrame_594235(protocol: Scheme; host: string; base: string;
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

proc validate_ReviewsAddVideoFrame_594234(path: JsonNode; query: JsonNode;
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
  var valid_594236 = path.getOrDefault("reviewId")
  valid_594236 = validateParameter(valid_594236, JString, required = true,
                                 default = nil)
  if valid_594236 != nil:
    section.add "reviewId", valid_594236
  var valid_594237 = path.getOrDefault("teamName")
  valid_594237 = validateParameter(valid_594237, JString, required = true,
                                 default = nil)
  if valid_594237 != nil:
    section.add "teamName", valid_594237
  result.add "path", section
  ## parameters in `query` object:
  ##   timescale: JInt
  ##            : Timescale of the video you are adding frames to.
  section = newJObject()
  var valid_594238 = query.getOrDefault("timescale")
  valid_594238 = validateParameter(valid_594238, JInt, required = false, default = nil)
  if valid_594238 != nil:
    section.add "timescale", valid_594238
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594239: Call_ReviewsAddVideoFrame_594233; path: JsonNode;
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
  let valid = call_594239.validator(path, query, header, formData, body)
  let scheme = call_594239.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594239.url(scheme.get, call_594239.host, call_594239.base,
                         call_594239.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594239, url, valid)

proc call*(call_594240: Call_ReviewsAddVideoFrame_594233; reviewId: string;
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
  var path_594241 = newJObject()
  var query_594242 = newJObject()
  add(query_594242, "timescale", newJInt(timescale))
  add(path_594241, "reviewId", newJString(reviewId))
  add(path_594241, "teamName", newJString(teamName))
  result = call_594240.call(path_594241, query_594242, nil, nil, nil)

var reviewsAddVideoFrame* = Call_ReviewsAddVideoFrame_594233(
    name: "reviewsAddVideoFrame", meth: HttpMethod.HttpPost, host: "azure.local", route: "/contentmoderator/review/v1.0/teams/{teamName}/reviews/{reviewId}/frames",
    validator: validate_ReviewsAddVideoFrame_594234, base: "",
    url: url_ReviewsAddVideoFrame_594235, schemes: {Scheme.Https})
type
  Call_ReviewsGetVideoFrames_594221 = ref object of OpenApiRestCall_593425
proc url_ReviewsGetVideoFrames_594223(protocol: Scheme; host: string; base: string;
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

proc validate_ReviewsGetVideoFrames_594222(path: JsonNode; query: JsonNode;
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
  var valid_594224 = path.getOrDefault("reviewId")
  valid_594224 = validateParameter(valid_594224, JString, required = true,
                                 default = nil)
  if valid_594224 != nil:
    section.add "reviewId", valid_594224
  var valid_594225 = path.getOrDefault("teamName")
  valid_594225 = validateParameter(valid_594225, JString, required = true,
                                 default = nil)
  if valid_594225 != nil:
    section.add "teamName", valid_594225
  result.add "path", section
  ## parameters in `query` object:
  ##   noOfRecords: JInt
  ##              : Number of frames to fetch.
  ##   filter: JString
  ##         : Get frames filtered by tags.
  ##   startSeed: JInt
  ##            : Time stamp of the frame from where you want to start fetching the frames.
  section = newJObject()
  var valid_594226 = query.getOrDefault("noOfRecords")
  valid_594226 = validateParameter(valid_594226, JInt, required = false, default = nil)
  if valid_594226 != nil:
    section.add "noOfRecords", valid_594226
  var valid_594227 = query.getOrDefault("filter")
  valid_594227 = validateParameter(valid_594227, JString, required = false,
                                 default = nil)
  if valid_594227 != nil:
    section.add "filter", valid_594227
  var valid_594228 = query.getOrDefault("startSeed")
  valid_594228 = validateParameter(valid_594228, JInt, required = false, default = nil)
  if valid_594228 != nil:
    section.add "startSeed", valid_594228
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594229: Call_ReviewsGetVideoFrames_594221; path: JsonNode;
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
  let valid = call_594229.validator(path, query, header, formData, body)
  let scheme = call_594229.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594229.url(scheme.get, call_594229.host, call_594229.base,
                         call_594229.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594229, url, valid)

proc call*(call_594230: Call_ReviewsGetVideoFrames_594221; reviewId: string;
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
  var path_594231 = newJObject()
  var query_594232 = newJObject()
  add(query_594232, "noOfRecords", newJInt(noOfRecords))
  add(path_594231, "reviewId", newJString(reviewId))
  add(path_594231, "teamName", newJString(teamName))
  add(query_594232, "filter", newJString(filter))
  add(query_594232, "startSeed", newJInt(startSeed))
  result = call_594230.call(path_594231, query_594232, nil, nil, nil)

var reviewsGetVideoFrames* = Call_ReviewsGetVideoFrames_594221(
    name: "reviewsGetVideoFrames", meth: HttpMethod.HttpGet, host: "azure.local", route: "/contentmoderator/review/v1.0/teams/{teamName}/reviews/{reviewId}/frames",
    validator: validate_ReviewsGetVideoFrames_594222, base: "",
    url: url_ReviewsGetVideoFrames_594223, schemes: {Scheme.Https})
type
  Call_ReviewsPublishVideoReview_594243 = ref object of OpenApiRestCall_593425
proc url_ReviewsPublishVideoReview_594245(protocol: Scheme; host: string;
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

proc validate_ReviewsPublishVideoReview_594244(path: JsonNode; query: JsonNode;
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
  var valid_594246 = path.getOrDefault("reviewId")
  valid_594246 = validateParameter(valid_594246, JString, required = true,
                                 default = nil)
  if valid_594246 != nil:
    section.add "reviewId", valid_594246
  var valid_594247 = path.getOrDefault("teamName")
  valid_594247 = validateParameter(valid_594247, JString, required = true,
                                 default = nil)
  if valid_594247 != nil:
    section.add "teamName", valid_594247
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594248: Call_ReviewsPublishVideoReview_594243; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Publish video review to make it available for review.
  ## 
  let valid = call_594248.validator(path, query, header, formData, body)
  let scheme = call_594248.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594248.url(scheme.get, call_594248.host, call_594248.base,
                         call_594248.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594248, url, valid)

proc call*(call_594249: Call_ReviewsPublishVideoReview_594243; reviewId: string;
          teamName: string): Recallable =
  ## reviewsPublishVideoReview
  ## Publish video review to make it available for review.
  ##   reviewId: string (required)
  ##           : Id of the review.
  ##   teamName: string (required)
  ##           : Your team name.
  var path_594250 = newJObject()
  add(path_594250, "reviewId", newJString(reviewId))
  add(path_594250, "teamName", newJString(teamName))
  result = call_594249.call(path_594250, nil, nil, nil, nil)

var reviewsPublishVideoReview* = Call_ReviewsPublishVideoReview_594243(
    name: "reviewsPublishVideoReview", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/contentmoderator/review/v1.0/teams/{teamName}/reviews/{reviewId}/publish",
    validator: validate_ReviewsPublishVideoReview_594244, base: "",
    url: url_ReviewsPublishVideoReview_594245, schemes: {Scheme.Https})
type
  Call_ReviewsAddVideoTranscript_594251 = ref object of OpenApiRestCall_593425
proc url_ReviewsAddVideoTranscript_594253(protocol: Scheme; host: string;
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

proc validate_ReviewsAddVideoTranscript_594252(path: JsonNode; query: JsonNode;
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
  var valid_594254 = path.getOrDefault("reviewId")
  valid_594254 = validateParameter(valid_594254, JString, required = true,
                                 default = nil)
  if valid_594254 != nil:
    section.add "reviewId", valid_594254
  var valid_594255 = path.getOrDefault("teamName")
  valid_594255 = validateParameter(valid_594255, JString, required = true,
                                 default = nil)
  if valid_594255 != nil:
    section.add "teamName", valid_594255
  result.add "path", section
  section = newJObject()
  result.add "query", section
  ## parameters in `header` object:
  ##   Content-Type: JString (required)
  ##               : The content type.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `Content-Type` field"
  var valid_594256 = header.getOrDefault("Content-Type")
  valid_594256 = validateParameter(valid_594256, JString, required = true,
                                 default = newJString("text/plain"))
  if valid_594256 != nil:
    section.add "Content-Type", valid_594256
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

proc call*(call_594258: Call_ReviewsAddVideoTranscript_594251; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This API adds a transcript file (text version of all the words spoken in a video) to a video review. The file should be a valid WebVTT format.
  ## 
  let valid = call_594258.validator(path, query, header, formData, body)
  let scheme = call_594258.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594258.url(scheme.get, call_594258.host, call_594258.base,
                         call_594258.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594258, url, valid)

proc call*(call_594259: Call_ReviewsAddVideoTranscript_594251; reviewId: string;
          teamName: string; VTTFile: JsonNode): Recallable =
  ## reviewsAddVideoTranscript
  ## This API adds a transcript file (text version of all the words spoken in a video) to a video review. The file should be a valid WebVTT format.
  ##   reviewId: string (required)
  ##           : Id of the review.
  ##   teamName: string (required)
  ##           : Your team name.
  ##   VTTFile: JObject (required)
  ##          : Transcript file of the video.
  var path_594260 = newJObject()
  var body_594261 = newJObject()
  add(path_594260, "reviewId", newJString(reviewId))
  add(path_594260, "teamName", newJString(teamName))
  if VTTFile != nil:
    body_594261 = VTTFile
  result = call_594259.call(path_594260, nil, nil, nil, body_594261)

var reviewsAddVideoTranscript* = Call_ReviewsAddVideoTranscript_594251(
    name: "reviewsAddVideoTranscript", meth: HttpMethod.HttpPut,
    host: "azure.local", route: "/contentmoderator/review/v1.0/teams/{teamName}/reviews/{reviewId}/transcript",
    validator: validate_ReviewsAddVideoTranscript_594252, base: "",
    url: url_ReviewsAddVideoTranscript_594253, schemes: {Scheme.Https})
type
  Call_ReviewsAddVideoTranscriptModerationResult_594262 = ref object of OpenApiRestCall_593425
proc url_ReviewsAddVideoTranscriptModerationResult_594264(protocol: Scheme;
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

proc validate_ReviewsAddVideoTranscriptModerationResult_594263(path: JsonNode;
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
  var valid_594265 = path.getOrDefault("reviewId")
  valid_594265 = validateParameter(valid_594265, JString, required = true,
                                 default = nil)
  if valid_594265 != nil:
    section.add "reviewId", valid_594265
  var valid_594266 = path.getOrDefault("teamName")
  valid_594266 = validateParameter(valid_594266, JString, required = true,
                                 default = nil)
  if valid_594266 != nil:
    section.add "teamName", valid_594266
  result.add "path", section
  section = newJObject()
  result.add "query", section
  ## parameters in `header` object:
  ##   Content-Type: JString (required)
  ##               : The content type.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `Content-Type` field"
  var valid_594267 = header.getOrDefault("Content-Type")
  valid_594267 = validateParameter(valid_594267, JString, required = true,
                                 default = nil)
  if valid_594267 != nil:
    section.add "Content-Type", valid_594267
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

proc call*(call_594269: Call_ReviewsAddVideoTranscriptModerationResult_594262;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## This API adds a transcript screen text result file for a video review. Transcript screen text result file is a result of Screen Text API . In order to generate transcript screen text result file , a transcript file has to be screened for profanity using Screen Text API.
  ## 
  let valid = call_594269.validator(path, query, header, formData, body)
  let scheme = call_594269.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594269.url(scheme.get, call_594269.host, call_594269.base,
                         call_594269.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594269, url, valid)

proc call*(call_594270: Call_ReviewsAddVideoTranscriptModerationResult_594262;
          transcriptModerationBody: JsonNode; reviewId: string; teamName: string): Recallable =
  ## reviewsAddVideoTranscriptModerationResult
  ## This API adds a transcript screen text result file for a video review. Transcript screen text result file is a result of Screen Text API . In order to generate transcript screen text result file , a transcript file has to be screened for profanity using Screen Text API.
  ##   transcriptModerationBody: JArray (required)
  ##                           : Body for add video transcript moderation result API
  ##   reviewId: string (required)
  ##           : Id of the review.
  ##   teamName: string (required)
  ##           : Your team name.
  var path_594271 = newJObject()
  var body_594272 = newJObject()
  if transcriptModerationBody != nil:
    body_594272 = transcriptModerationBody
  add(path_594271, "reviewId", newJString(reviewId))
  add(path_594271, "teamName", newJString(teamName))
  result = call_594270.call(path_594271, nil, nil, nil, body_594272)

var reviewsAddVideoTranscriptModerationResult* = Call_ReviewsAddVideoTranscriptModerationResult_594262(
    name: "reviewsAddVideoTranscriptModerationResult", meth: HttpMethod.HttpPut,
    host: "azure.local", route: "/contentmoderator/review/v1.0/teams/{teamName}/reviews/{reviewId}/transcriptmoderationresult",
    validator: validate_ReviewsAddVideoTranscriptModerationResult_594263,
    base: "", url: url_ReviewsAddVideoTranscriptModerationResult_594264,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
