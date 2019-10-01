
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Azure Data Lake Storage
## version: 2018-06-17
## termsOfService: (not provided)
## license: (not provided)
## 
## Azure Data Lake Storage provides storage for Hadoop and other big data workloads.
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
  macServiceName = "storage-DataLakeStorage"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_FilesystemList_567880 = ref object of OpenApiRestCall_567658
proc url_FilesystemList_567882(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_FilesystemList_567881(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## List filesystems and their properties in given account.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : An optional operation timeout value in seconds. The period begins when the request is received by the service. If the timeout value elapses before the operation completes, the operation fails.
  ##   continuation: JString
  ##               : The number of filesystems returned with each invocation is limited. If the number of filesystems to be returned exceeds this limit, a continuation token is returned in the response header x-ms-continuation. When a continuation token is  returned in the response, it must be specified in a subsequent invocation of the list operation to continue listing the filesystems.
  ##   resource: JString (required)
  ##           : The value must be "account" for all account operations.
  ##   maxResults: JInt
  ##             : An optional value that specifies the maximum number of items to return. If omitted or greater than 5,000, the response will include up to 5,000 items.
  ##   prefix: JString
  ##         : Filters results to filesystems within the specified prefix.
  section = newJObject()
  var valid_568041 = query.getOrDefault("timeout")
  valid_568041 = validateParameter(valid_568041, JInt, required = false, default = nil)
  if valid_568041 != nil:
    section.add "timeout", valid_568041
  var valid_568042 = query.getOrDefault("continuation")
  valid_568042 = validateParameter(valid_568042, JString, required = false,
                                 default = nil)
  if valid_568042 != nil:
    section.add "continuation", valid_568042
  assert query != nil,
        "query argument is necessary due to required `resource` field"
  var valid_568056 = query.getOrDefault("resource")
  valid_568056 = validateParameter(valid_568056, JString, required = true,
                                 default = newJString("account"))
  if valid_568056 != nil:
    section.add "resource", valid_568056
  var valid_568057 = query.getOrDefault("maxResults")
  valid_568057 = validateParameter(valid_568057, JInt, required = false, default = nil)
  if valid_568057 != nil:
    section.add "maxResults", valid_568057
  var valid_568058 = query.getOrDefault("prefix")
  valid_568058 = validateParameter(valid_568058, JString, required = false,
                                 default = nil)
  if valid_568058 != nil:
    section.add "prefix", valid_568058
  result.add "query", section
  ## parameters in `header` object:
  ##   x-ms-client-request-id: JString
  ##                         : A UUID recorded in the analytics logs for troubleshooting and correlation.
  ##   x-ms-date: JString
  ##            : Specifies the Coordinated Universal Time (UTC) for the request.  This is required when using shared key authorization.
  ##   x-ms-version: JString
  ##               : Specifies the version of the REST protocol used for processing the request. This is required when using shared key authorization.
  section = newJObject()
  var valid_568059 = header.getOrDefault("x-ms-client-request-id")
  valid_568059 = validateParameter(valid_568059, JString, required = false,
                                 default = nil)
  if valid_568059 != nil:
    section.add "x-ms-client-request-id", valid_568059
  var valid_568060 = header.getOrDefault("x-ms-date")
  valid_568060 = validateParameter(valid_568060, JString, required = false,
                                 default = nil)
  if valid_568060 != nil:
    section.add "x-ms-date", valid_568060
  var valid_568061 = header.getOrDefault("x-ms-version")
  valid_568061 = validateParameter(valid_568061, JString, required = false,
                                 default = nil)
  if valid_568061 != nil:
    section.add "x-ms-version", valid_568061
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568084: Call_FilesystemList_567880; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List filesystems and their properties in given account.
  ## 
  let valid = call_568084.validator(path, query, header, formData, body)
  let scheme = call_568084.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568084.url(scheme.get, call_568084.host, call_568084.base,
                         call_568084.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568084, url, valid)

proc call*(call_568155: Call_FilesystemList_567880; timeout: int = 0;
          continuation: string = ""; resource: string = "account"; maxResults: int = 0;
          prefix: string = ""): Recallable =
  ## filesystemList
  ## List filesystems and their properties in given account.
  ##   timeout: int
  ##          : An optional operation timeout value in seconds. The period begins when the request is received by the service. If the timeout value elapses before the operation completes, the operation fails.
  ##   continuation: string
  ##               : The number of filesystems returned with each invocation is limited. If the number of filesystems to be returned exceeds this limit, a continuation token is returned in the response header x-ms-continuation. When a continuation token is  returned in the response, it must be specified in a subsequent invocation of the list operation to continue listing the filesystems.
  ##   resource: string (required)
  ##           : The value must be "account" for all account operations.
  ##   maxResults: int
  ##             : An optional value that specifies the maximum number of items to return. If omitted or greater than 5,000, the response will include up to 5,000 items.
  ##   prefix: string
  ##         : Filters results to filesystems within the specified prefix.
  var query_568156 = newJObject()
  add(query_568156, "timeout", newJInt(timeout))
  add(query_568156, "continuation", newJString(continuation))
  add(query_568156, "resource", newJString(resource))
  add(query_568156, "maxResults", newJInt(maxResults))
  add(query_568156, "prefix", newJString(prefix))
  result = call_568155.call(nil, query_568156, nil, nil, nil)

var filesystemList* = Call_FilesystemList_567880(name: "filesystemList",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/",
    validator: validate_FilesystemList_567881, base: "", url: url_FilesystemList_567882,
    schemes: {Scheme.Https})
type
  Call_FilesystemCreate_568227 = ref object of OpenApiRestCall_567658
proc url_FilesystemCreate_568229(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "filesystem" in path, "`filesystem` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "filesystem")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FilesystemCreate_568228(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Create a filesystem rooted at the specified location. If the filesystem already exists, the operation fails.  This operation does not support conditional HTTP requests.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   filesystem: JString (required)
  ##             : The filesystem identifier.  The value must start and end with a letter or number and must contain only letters, numbers, and the dash (-) character.  Consecutive dashes are not permitted.  All letters must be lowercase.  The value must have between 3 and 63 characters.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `filesystem` field"
  var valid_568230 = path.getOrDefault("filesystem")
  valid_568230 = validateParameter(valid_568230, JString, required = true,
                                 default = nil)
  if valid_568230 != nil:
    section.add "filesystem", valid_568230
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : An optional operation timeout value in seconds. The period begins when the request is received by the service. If the timeout value elapses before the operation completes, the operation fails.
  ##   resource: JString (required)
  ##           : The value must be "filesystem" for all filesystem operations.
  section = newJObject()
  var valid_568231 = query.getOrDefault("timeout")
  valid_568231 = validateParameter(valid_568231, JInt, required = false, default = nil)
  if valid_568231 != nil:
    section.add "timeout", valid_568231
  assert query != nil,
        "query argument is necessary due to required `resource` field"
  var valid_568232 = query.getOrDefault("resource")
  valid_568232 = validateParameter(valid_568232, JString, required = true,
                                 default = newJString("filesystem"))
  if valid_568232 != nil:
    section.add "resource", valid_568232
  result.add "query", section
  ## parameters in `header` object:
  ##   x-ms-properties: JString
  ##                  : User-defined properties to be stored with the filesystem, in the format of a comma-separated list of name and value pairs "n1=v1, n2=v2, ...", where each value is base64 encoded.
  ##   x-ms-client-request-id: JString
  ##                         : A UUID recorded in the analytics logs for troubleshooting and correlation.
  ##   x-ms-date: JString
  ##            : Specifies the Coordinated Universal Time (UTC) for the request.  This is required when using shared key authorization.
  ##   x-ms-version: JString
  ##               : Specifies the version of the REST protocol used for processing the request. This is required when using shared key authorization.
  section = newJObject()
  var valid_568233 = header.getOrDefault("x-ms-properties")
  valid_568233 = validateParameter(valid_568233, JString, required = false,
                                 default = nil)
  if valid_568233 != nil:
    section.add "x-ms-properties", valid_568233
  var valid_568234 = header.getOrDefault("x-ms-client-request-id")
  valid_568234 = validateParameter(valid_568234, JString, required = false,
                                 default = nil)
  if valid_568234 != nil:
    section.add "x-ms-client-request-id", valid_568234
  var valid_568235 = header.getOrDefault("x-ms-date")
  valid_568235 = validateParameter(valid_568235, JString, required = false,
                                 default = nil)
  if valid_568235 != nil:
    section.add "x-ms-date", valid_568235
  var valid_568236 = header.getOrDefault("x-ms-version")
  valid_568236 = validateParameter(valid_568236, JString, required = false,
                                 default = nil)
  if valid_568236 != nil:
    section.add "x-ms-version", valid_568236
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568237: Call_FilesystemCreate_568227; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a filesystem rooted at the specified location. If the filesystem already exists, the operation fails.  This operation does not support conditional HTTP requests.
  ## 
  let valid = call_568237.validator(path, query, header, formData, body)
  let scheme = call_568237.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568237.url(scheme.get, call_568237.host, call_568237.base,
                         call_568237.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568237, url, valid)

proc call*(call_568238: Call_FilesystemCreate_568227; filesystem: string;
          timeout: int = 0; resource: string = "filesystem"): Recallable =
  ## filesystemCreate
  ## Create a filesystem rooted at the specified location. If the filesystem already exists, the operation fails.  This operation does not support conditional HTTP requests.
  ##   timeout: int
  ##          : An optional operation timeout value in seconds. The period begins when the request is received by the service. If the timeout value elapses before the operation completes, the operation fails.
  ##   resource: string (required)
  ##           : The value must be "filesystem" for all filesystem operations.
  ##   filesystem: string (required)
  ##             : The filesystem identifier.  The value must start and end with a letter or number and must contain only letters, numbers, and the dash (-) character.  Consecutive dashes are not permitted.  All letters must be lowercase.  The value must have between 3 and 63 characters.
  var path_568239 = newJObject()
  var query_568240 = newJObject()
  add(query_568240, "timeout", newJInt(timeout))
  add(query_568240, "resource", newJString(resource))
  add(path_568239, "filesystem", newJString(filesystem))
  result = call_568238.call(path_568239, query_568240, nil, nil, nil)

var filesystemCreate* = Call_FilesystemCreate_568227(name: "filesystemCreate",
    meth: HttpMethod.HttpPut, host: "azure.local", route: "/{filesystem}",
    validator: validate_FilesystemCreate_568228, base: "",
    url: url_FilesystemCreate_568229, schemes: {Scheme.Https})
type
  Call_FilesystemGetProperties_568256 = ref object of OpenApiRestCall_567658
proc url_FilesystemGetProperties_568258(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "filesystem" in path, "`filesystem` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "filesystem")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FilesystemGetProperties_568257(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## All system and user-defined filesystem properties are specified in the response headers.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   filesystem: JString (required)
  ##             : The filesystem identifier.  The value must start and end with a letter or number and must contain only letters, numbers, and the dash (-) character.  Consecutive dashes are not permitted.  All letters must be lowercase.  The value must have between 3 and 63 characters.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `filesystem` field"
  var valid_568259 = path.getOrDefault("filesystem")
  valid_568259 = validateParameter(valid_568259, JString, required = true,
                                 default = nil)
  if valid_568259 != nil:
    section.add "filesystem", valid_568259
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : An optional operation timeout value in seconds. The period begins when the request is received by the service. If the timeout value elapses before the operation completes, the operation fails.
  ##   resource: JString (required)
  ##           : The value must be "filesystem" for all filesystem operations.
  section = newJObject()
  var valid_568260 = query.getOrDefault("timeout")
  valid_568260 = validateParameter(valid_568260, JInt, required = false, default = nil)
  if valid_568260 != nil:
    section.add "timeout", valid_568260
  assert query != nil,
        "query argument is necessary due to required `resource` field"
  var valid_568261 = query.getOrDefault("resource")
  valid_568261 = validateParameter(valid_568261, JString, required = true,
                                 default = newJString("filesystem"))
  if valid_568261 != nil:
    section.add "resource", valid_568261
  result.add "query", section
  ## parameters in `header` object:
  ##   x-ms-client-request-id: JString
  ##                         : A UUID recorded in the analytics logs for troubleshooting and correlation.
  ##   x-ms-date: JString
  ##            : Specifies the Coordinated Universal Time (UTC) for the request.  This is required when using shared key authorization.
  ##   x-ms-version: JString
  ##               : Specifies the version of the REST protocol used for processing the request. This is required when using shared key authorization.
  section = newJObject()
  var valid_568262 = header.getOrDefault("x-ms-client-request-id")
  valid_568262 = validateParameter(valid_568262, JString, required = false,
                                 default = nil)
  if valid_568262 != nil:
    section.add "x-ms-client-request-id", valid_568262
  var valid_568263 = header.getOrDefault("x-ms-date")
  valid_568263 = validateParameter(valid_568263, JString, required = false,
                                 default = nil)
  if valid_568263 != nil:
    section.add "x-ms-date", valid_568263
  var valid_568264 = header.getOrDefault("x-ms-version")
  valid_568264 = validateParameter(valid_568264, JString, required = false,
                                 default = nil)
  if valid_568264 != nil:
    section.add "x-ms-version", valid_568264
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568265: Call_FilesystemGetProperties_568256; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## All system and user-defined filesystem properties are specified in the response headers.
  ## 
  let valid = call_568265.validator(path, query, header, formData, body)
  let scheme = call_568265.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568265.url(scheme.get, call_568265.host, call_568265.base,
                         call_568265.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568265, url, valid)

proc call*(call_568266: Call_FilesystemGetProperties_568256; filesystem: string;
          timeout: int = 0; resource: string = "filesystem"): Recallable =
  ## filesystemGetProperties
  ## All system and user-defined filesystem properties are specified in the response headers.
  ##   timeout: int
  ##          : An optional operation timeout value in seconds. The period begins when the request is received by the service. If the timeout value elapses before the operation completes, the operation fails.
  ##   resource: string (required)
  ##           : The value must be "filesystem" for all filesystem operations.
  ##   filesystem: string (required)
  ##             : The filesystem identifier.  The value must start and end with a letter or number and must contain only letters, numbers, and the dash (-) character.  Consecutive dashes are not permitted.  All letters must be lowercase.  The value must have between 3 and 63 characters.
  var path_568267 = newJObject()
  var query_568268 = newJObject()
  add(query_568268, "timeout", newJInt(timeout))
  add(query_568268, "resource", newJString(resource))
  add(path_568267, "filesystem", newJString(filesystem))
  result = call_568266.call(path_568267, query_568268, nil, nil, nil)

var filesystemGetProperties* = Call_FilesystemGetProperties_568256(
    name: "filesystemGetProperties", meth: HttpMethod.HttpHead, host: "azure.local",
    route: "/{filesystem}", validator: validate_FilesystemGetProperties_568257,
    base: "", url: url_FilesystemGetProperties_568258, schemes: {Scheme.Https})
type
  Call_PathList_568196 = ref object of OpenApiRestCall_567658
proc url_PathList_568198(protocol: Scheme; host: string; base: string; route: string;
                        path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "filesystem" in path, "`filesystem` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "filesystem")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PathList_568197(path: JsonNode; query: JsonNode; header: JsonNode;
                             formData: JsonNode; body: JsonNode): JsonNode =
  ## List filesystem paths and their properties.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   filesystem: JString (required)
  ##             : The filesystem identifier.  The value must start and end with a letter or number and must contain only letters, numbers, and the dash (-) character.  Consecutive dashes are not permitted.  All letters must be lowercase.  The value must have between 3 and 63 characters.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `filesystem` field"
  var valid_568213 = path.getOrDefault("filesystem")
  valid_568213 = validateParameter(valid_568213, JString, required = true,
                                 default = nil)
  if valid_568213 != nil:
    section.add "filesystem", valid_568213
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : An optional operation timeout value in seconds. The period begins when the request is received by the service. If the timeout value elapses before the operation completes, the operation fails.
  ##   continuation: JString
  ##               : The number of paths returned with each invocation is limited. If the number of paths to be returned exceeds this limit, a continuation token is returned in the response header x-ms-continuation. When a continuation token is  returned in the response, it must be specified in a subsequent invocation of the list operation to continue listing the paths.
  ##   resource: JString (required)
  ##           : The value must be "filesystem" for all filesystem operations.
  ##   directory: JString
  ##            : Filters results to paths within the specified directory. An error occurs if the directory does not exist.
  ##   maxResults: JInt
  ##             : An optional value that specifies the maximum number of items to return. If omitted or greater than 5,000, the response will include up to 5,000 items.
  ##   recursive: JBool (required)
  ##            : If "true", all paths are listed; otherwise, only paths at the root of the filesystem are listed.  If "directory" is specified, the list will only include paths that share the same root.
  section = newJObject()
  var valid_568214 = query.getOrDefault("timeout")
  valid_568214 = validateParameter(valid_568214, JInt, required = false, default = nil)
  if valid_568214 != nil:
    section.add "timeout", valid_568214
  var valid_568215 = query.getOrDefault("continuation")
  valid_568215 = validateParameter(valid_568215, JString, required = false,
                                 default = nil)
  if valid_568215 != nil:
    section.add "continuation", valid_568215
  assert query != nil,
        "query argument is necessary due to required `resource` field"
  var valid_568216 = query.getOrDefault("resource")
  valid_568216 = validateParameter(valid_568216, JString, required = true,
                                 default = newJString("filesystem"))
  if valid_568216 != nil:
    section.add "resource", valid_568216
  var valid_568217 = query.getOrDefault("directory")
  valid_568217 = validateParameter(valid_568217, JString, required = false,
                                 default = nil)
  if valid_568217 != nil:
    section.add "directory", valid_568217
  var valid_568218 = query.getOrDefault("maxResults")
  valid_568218 = validateParameter(valid_568218, JInt, required = false, default = nil)
  if valid_568218 != nil:
    section.add "maxResults", valid_568218
  var valid_568219 = query.getOrDefault("recursive")
  valid_568219 = validateParameter(valid_568219, JBool, required = true, default = nil)
  if valid_568219 != nil:
    section.add "recursive", valid_568219
  result.add "query", section
  ## parameters in `header` object:
  ##   x-ms-client-request-id: JString
  ##                         : A UUID recorded in the analytics logs for troubleshooting and correlation.
  ##   x-ms-date: JString
  ##            : Specifies the Coordinated Universal Time (UTC) for the request.  This is required when using shared key authorization.
  ##   x-ms-version: JString
  ##               : Specifies the version of the REST protocol used for processing the request. This is required when using shared key authorization.
  section = newJObject()
  var valid_568220 = header.getOrDefault("x-ms-client-request-id")
  valid_568220 = validateParameter(valid_568220, JString, required = false,
                                 default = nil)
  if valid_568220 != nil:
    section.add "x-ms-client-request-id", valid_568220
  var valid_568221 = header.getOrDefault("x-ms-date")
  valid_568221 = validateParameter(valid_568221, JString, required = false,
                                 default = nil)
  if valid_568221 != nil:
    section.add "x-ms-date", valid_568221
  var valid_568222 = header.getOrDefault("x-ms-version")
  valid_568222 = validateParameter(valid_568222, JString, required = false,
                                 default = nil)
  if valid_568222 != nil:
    section.add "x-ms-version", valid_568222
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568223: Call_PathList_568196; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List filesystem paths and their properties.
  ## 
  let valid = call_568223.validator(path, query, header, formData, body)
  let scheme = call_568223.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568223.url(scheme.get, call_568223.host, call_568223.base,
                         call_568223.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568223, url, valid)

proc call*(call_568224: Call_PathList_568196; filesystem: string; recursive: bool;
          timeout: int = 0; continuation: string = ""; resource: string = "filesystem";
          directory: string = ""; maxResults: int = 0): Recallable =
  ## pathList
  ## List filesystem paths and their properties.
  ##   timeout: int
  ##          : An optional operation timeout value in seconds. The period begins when the request is received by the service. If the timeout value elapses before the operation completes, the operation fails.
  ##   continuation: string
  ##               : The number of paths returned with each invocation is limited. If the number of paths to be returned exceeds this limit, a continuation token is returned in the response header x-ms-continuation. When a continuation token is  returned in the response, it must be specified in a subsequent invocation of the list operation to continue listing the paths.
  ##   resource: string (required)
  ##           : The value must be "filesystem" for all filesystem operations.
  ##   directory: string
  ##            : Filters results to paths within the specified directory. An error occurs if the directory does not exist.
  ##   maxResults: int
  ##             : An optional value that specifies the maximum number of items to return. If omitted or greater than 5,000, the response will include up to 5,000 items.
  ##   filesystem: string (required)
  ##             : The filesystem identifier.  The value must start and end with a letter or number and must contain only letters, numbers, and the dash (-) character.  Consecutive dashes are not permitted.  All letters must be lowercase.  The value must have between 3 and 63 characters.
  ##   recursive: bool (required)
  ##            : If "true", all paths are listed; otherwise, only paths at the root of the filesystem are listed.  If "directory" is specified, the list will only include paths that share the same root.
  var path_568225 = newJObject()
  var query_568226 = newJObject()
  add(query_568226, "timeout", newJInt(timeout))
  add(query_568226, "continuation", newJString(continuation))
  add(query_568226, "resource", newJString(resource))
  add(query_568226, "directory", newJString(directory))
  add(query_568226, "maxResults", newJInt(maxResults))
  add(path_568225, "filesystem", newJString(filesystem))
  add(query_568226, "recursive", newJBool(recursive))
  result = call_568224.call(path_568225, query_568226, nil, nil, nil)

var pathList* = Call_PathList_568196(name: "pathList", meth: HttpMethod.HttpGet,
                                  host: "azure.local", route: "/{filesystem}",
                                  validator: validate_PathList_568197, base: "",
                                  url: url_PathList_568198,
                                  schemes: {Scheme.Https})
type
  Call_FilesystemSetProperties_568269 = ref object of OpenApiRestCall_567658
proc url_FilesystemSetProperties_568271(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "filesystem" in path, "`filesystem` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "filesystem")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FilesystemSetProperties_568270(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Set properties for the filesystem.  This operation supports conditional HTTP requests.  For more information, see [Specifying Conditional Headers for Blob Service Operations](https://docs.microsoft.com/en-us/rest/api/storageservices/specifying-conditional-headers-for-blob-service-operations).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   filesystem: JString (required)
  ##             : The filesystem identifier.  The value must start and end with a letter or number and must contain only letters, numbers, and the dash (-) character.  Consecutive dashes are not permitted.  All letters must be lowercase.  The value must have between 3 and 63 characters.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `filesystem` field"
  var valid_568272 = path.getOrDefault("filesystem")
  valid_568272 = validateParameter(valid_568272, JString, required = true,
                                 default = nil)
  if valid_568272 != nil:
    section.add "filesystem", valid_568272
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : An optional operation timeout value in seconds. The period begins when the request is received by the service. If the timeout value elapses before the operation completes, the operation fails.
  ##   resource: JString (required)
  ##           : The value must be "filesystem" for all filesystem operations.
  section = newJObject()
  var valid_568273 = query.getOrDefault("timeout")
  valid_568273 = validateParameter(valid_568273, JInt, required = false, default = nil)
  if valid_568273 != nil:
    section.add "timeout", valid_568273
  assert query != nil,
        "query argument is necessary due to required `resource` field"
  var valid_568274 = query.getOrDefault("resource")
  valid_568274 = validateParameter(valid_568274, JString, required = true,
                                 default = newJString("filesystem"))
  if valid_568274 != nil:
    section.add "resource", valid_568274
  result.add "query", section
  ## parameters in `header` object:
  ##   x-ms-properties: JString
  ##                  : Optional. User-defined properties to be stored with the filesystem, in the format of a comma-separated list of name and value pairs "n1=v1, n2=v2, ...", where each value is base64 encoded.  If the filesystem exists, any properties not included in the list will be removed.  All properties are removed if the header is omitted.  To merge new and existing properties, first get all existing properties and the current E-Tag, then make a conditional request with the E-Tag and include values for all properties.
  ##   If-Unmodified-Since: JString
  ##                      : Optional. A date and time value. Specify this header to perform the operation only if the resource has not been modified since the specified date and time.
  ##   x-ms-client-request-id: JString
  ##                         : A UUID recorded in the analytics logs for troubleshooting and correlation.
  ##   x-ms-date: JString
  ##            : Specifies the Coordinated Universal Time (UTC) for the request.  This is required when using shared key authorization.
  ##   If-Modified-Since: JString
  ##                    : Optional. A date and time value. Specify this header to perform the operation only if the resource has been modified since the specified date and time.
  ##   x-ms-version: JString
  ##               : Specifies the version of the REST protocol used for processing the request. This is required when using shared key authorization.
  section = newJObject()
  var valid_568275 = header.getOrDefault("x-ms-properties")
  valid_568275 = validateParameter(valid_568275, JString, required = false,
                                 default = nil)
  if valid_568275 != nil:
    section.add "x-ms-properties", valid_568275
  var valid_568276 = header.getOrDefault("If-Unmodified-Since")
  valid_568276 = validateParameter(valid_568276, JString, required = false,
                                 default = nil)
  if valid_568276 != nil:
    section.add "If-Unmodified-Since", valid_568276
  var valid_568277 = header.getOrDefault("x-ms-client-request-id")
  valid_568277 = validateParameter(valid_568277, JString, required = false,
                                 default = nil)
  if valid_568277 != nil:
    section.add "x-ms-client-request-id", valid_568277
  var valid_568278 = header.getOrDefault("x-ms-date")
  valid_568278 = validateParameter(valid_568278, JString, required = false,
                                 default = nil)
  if valid_568278 != nil:
    section.add "x-ms-date", valid_568278
  var valid_568279 = header.getOrDefault("If-Modified-Since")
  valid_568279 = validateParameter(valid_568279, JString, required = false,
                                 default = nil)
  if valid_568279 != nil:
    section.add "If-Modified-Since", valid_568279
  var valid_568280 = header.getOrDefault("x-ms-version")
  valid_568280 = validateParameter(valid_568280, JString, required = false,
                                 default = nil)
  if valid_568280 != nil:
    section.add "x-ms-version", valid_568280
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568281: Call_FilesystemSetProperties_568269; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Set properties for the filesystem.  This operation supports conditional HTTP requests.  For more information, see [Specifying Conditional Headers for Blob Service Operations](https://docs.microsoft.com/en-us/rest/api/storageservices/specifying-conditional-headers-for-blob-service-operations).
  ## 
  let valid = call_568281.validator(path, query, header, formData, body)
  let scheme = call_568281.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568281.url(scheme.get, call_568281.host, call_568281.base,
                         call_568281.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568281, url, valid)

proc call*(call_568282: Call_FilesystemSetProperties_568269; filesystem: string;
          timeout: int = 0; resource: string = "filesystem"): Recallable =
  ## filesystemSetProperties
  ## Set properties for the filesystem.  This operation supports conditional HTTP requests.  For more information, see [Specifying Conditional Headers for Blob Service Operations](https://docs.microsoft.com/en-us/rest/api/storageservices/specifying-conditional-headers-for-blob-service-operations).
  ##   timeout: int
  ##          : An optional operation timeout value in seconds. The period begins when the request is received by the service. If the timeout value elapses before the operation completes, the operation fails.
  ##   resource: string (required)
  ##           : The value must be "filesystem" for all filesystem operations.
  ##   filesystem: string (required)
  ##             : The filesystem identifier.  The value must start and end with a letter or number and must contain only letters, numbers, and the dash (-) character.  Consecutive dashes are not permitted.  All letters must be lowercase.  The value must have between 3 and 63 characters.
  var path_568283 = newJObject()
  var query_568284 = newJObject()
  add(query_568284, "timeout", newJInt(timeout))
  add(query_568284, "resource", newJString(resource))
  add(path_568283, "filesystem", newJString(filesystem))
  result = call_568282.call(path_568283, query_568284, nil, nil, nil)

var filesystemSetProperties* = Call_FilesystemSetProperties_568269(
    name: "filesystemSetProperties", meth: HttpMethod.HttpPatch,
    host: "azure.local", route: "/{filesystem}",
    validator: validate_FilesystemSetProperties_568270, base: "",
    url: url_FilesystemSetProperties_568271, schemes: {Scheme.Https})
type
  Call_FilesystemDelete_568241 = ref object of OpenApiRestCall_567658
proc url_FilesystemDelete_568243(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "filesystem" in path, "`filesystem` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "filesystem")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FilesystemDelete_568242(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Marks the filesystem for deletion.  When a filesystem is deleted, a filesystem with the same identifier cannot be created for at least 30 seconds. While the filesystem is being deleted, attempts to create a filesystem with the same identifier will fail with status code 409 (Conflict), with the service returning additional error information indicating that the filesystem is being deleted. All other operations, including operations on any files or directories within the filesystem, will fail with status code 404 (Not Found) while the filesystem is being deleted. This operation supports conditional HTTP requests.  For more information, see [Specifying Conditional Headers for Blob Service Operations](https://docs.microsoft.com/en-us/rest/api/storageservices/specifying-conditional-headers-for-blob-service-operations).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   filesystem: JString (required)
  ##             : The filesystem identifier.  The value must start and end with a letter or number and must contain only letters, numbers, and the dash (-) character.  Consecutive dashes are not permitted.  All letters must be lowercase.  The value must have between 3 and 63 characters.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `filesystem` field"
  var valid_568244 = path.getOrDefault("filesystem")
  valid_568244 = validateParameter(valid_568244, JString, required = true,
                                 default = nil)
  if valid_568244 != nil:
    section.add "filesystem", valid_568244
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : An optional operation timeout value in seconds. The period begins when the request is received by the service. If the timeout value elapses before the operation completes, the operation fails.
  ##   resource: JString (required)
  ##           : The value must be "filesystem" for all filesystem operations.
  section = newJObject()
  var valid_568245 = query.getOrDefault("timeout")
  valid_568245 = validateParameter(valid_568245, JInt, required = false, default = nil)
  if valid_568245 != nil:
    section.add "timeout", valid_568245
  assert query != nil,
        "query argument is necessary due to required `resource` field"
  var valid_568246 = query.getOrDefault("resource")
  valid_568246 = validateParameter(valid_568246, JString, required = true,
                                 default = newJString("filesystem"))
  if valid_568246 != nil:
    section.add "resource", valid_568246
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Unmodified-Since: JString
  ##                      : Optional. A date and time value. Specify this header to perform the operation only if the resource has not been modified since the specified date and time.
  ##   x-ms-client-request-id: JString
  ##                         : A UUID recorded in the analytics logs for troubleshooting and correlation.
  ##   x-ms-date: JString
  ##            : Specifies the Coordinated Universal Time (UTC) for the request.  This is required when using shared key authorization.
  ##   If-Modified-Since: JString
  ##                    : Optional. A date and time value. Specify this header to perform the operation only if the resource has been modified since the specified date and time.
  ##   x-ms-version: JString
  ##               : Specifies the version of the REST protocol used for processing the request. This is required when using shared key authorization.
  section = newJObject()
  var valid_568247 = header.getOrDefault("If-Unmodified-Since")
  valid_568247 = validateParameter(valid_568247, JString, required = false,
                                 default = nil)
  if valid_568247 != nil:
    section.add "If-Unmodified-Since", valid_568247
  var valid_568248 = header.getOrDefault("x-ms-client-request-id")
  valid_568248 = validateParameter(valid_568248, JString, required = false,
                                 default = nil)
  if valid_568248 != nil:
    section.add "x-ms-client-request-id", valid_568248
  var valid_568249 = header.getOrDefault("x-ms-date")
  valid_568249 = validateParameter(valid_568249, JString, required = false,
                                 default = nil)
  if valid_568249 != nil:
    section.add "x-ms-date", valid_568249
  var valid_568250 = header.getOrDefault("If-Modified-Since")
  valid_568250 = validateParameter(valid_568250, JString, required = false,
                                 default = nil)
  if valid_568250 != nil:
    section.add "If-Modified-Since", valid_568250
  var valid_568251 = header.getOrDefault("x-ms-version")
  valid_568251 = validateParameter(valid_568251, JString, required = false,
                                 default = nil)
  if valid_568251 != nil:
    section.add "x-ms-version", valid_568251
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568252: Call_FilesystemDelete_568241; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Marks the filesystem for deletion.  When a filesystem is deleted, a filesystem with the same identifier cannot be created for at least 30 seconds. While the filesystem is being deleted, attempts to create a filesystem with the same identifier will fail with status code 409 (Conflict), with the service returning additional error information indicating that the filesystem is being deleted. All other operations, including operations on any files or directories within the filesystem, will fail with status code 404 (Not Found) while the filesystem is being deleted. This operation supports conditional HTTP requests.  For more information, see [Specifying Conditional Headers for Blob Service Operations](https://docs.microsoft.com/en-us/rest/api/storageservices/specifying-conditional-headers-for-blob-service-operations).
  ## 
  let valid = call_568252.validator(path, query, header, formData, body)
  let scheme = call_568252.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568252.url(scheme.get, call_568252.host, call_568252.base,
                         call_568252.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568252, url, valid)

proc call*(call_568253: Call_FilesystemDelete_568241; filesystem: string;
          timeout: int = 0; resource: string = "filesystem"): Recallable =
  ## filesystemDelete
  ## Marks the filesystem for deletion.  When a filesystem is deleted, a filesystem with the same identifier cannot be created for at least 30 seconds. While the filesystem is being deleted, attempts to create a filesystem with the same identifier will fail with status code 409 (Conflict), with the service returning additional error information indicating that the filesystem is being deleted. All other operations, including operations on any files or directories within the filesystem, will fail with status code 404 (Not Found) while the filesystem is being deleted. This operation supports conditional HTTP requests.  For more information, see [Specifying Conditional Headers for Blob Service Operations](https://docs.microsoft.com/en-us/rest/api/storageservices/specifying-conditional-headers-for-blob-service-operations).
  ##   timeout: int
  ##          : An optional operation timeout value in seconds. The period begins when the request is received by the service. If the timeout value elapses before the operation completes, the operation fails.
  ##   resource: string (required)
  ##           : The value must be "filesystem" for all filesystem operations.
  ##   filesystem: string (required)
  ##             : The filesystem identifier.  The value must start and end with a letter or number and must contain only letters, numbers, and the dash (-) character.  Consecutive dashes are not permitted.  All letters must be lowercase.  The value must have between 3 and 63 characters.
  var path_568254 = newJObject()
  var query_568255 = newJObject()
  add(query_568255, "timeout", newJInt(timeout))
  add(query_568255, "resource", newJString(resource))
  add(path_568254, "filesystem", newJString(filesystem))
  result = call_568253.call(path_568254, query_568255, nil, nil, nil)

var filesystemDelete* = Call_FilesystemDelete_568241(name: "filesystemDelete",
    meth: HttpMethod.HttpDelete, host: "azure.local", route: "/{filesystem}",
    validator: validate_FilesystemDelete_568242, base: "",
    url: url_FilesystemDelete_568243, schemes: {Scheme.Https})
type
  Call_PathCreate_568303 = ref object of OpenApiRestCall_567658
proc url_PathCreate_568305(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "filesystem" in path, "`filesystem` is a required path parameter"
  assert "path" in path, "`path` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "filesystem"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "path")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PathCreate_568304(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or rename a file or directory.    By default, the destination is overwritten and if the destination already exists and has a lease the lease is broken.  This operation supports conditional HTTP requests.  For more information, see [Specifying Conditional Headers for Blob Service Operations](https://docs.microsoft.com/en-us/rest/api/storageservices/specifying-conditional-headers-for-blob-service-operations).  To fail if the destination already exists, use a conditional request with If-None-Match: "*".
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   path: JString (required)
  ##       : The file or directory path.
  ##   filesystem: JString (required)
  ##             : The filesystem identifier.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `path` field"
  var valid_568306 = path.getOrDefault("path")
  valid_568306 = validateParameter(valid_568306, JString, required = true,
                                 default = nil)
  if valid_568306 != nil:
    section.add "path", valid_568306
  var valid_568307 = path.getOrDefault("filesystem")
  valid_568307 = validateParameter(valid_568307, JString, required = true,
                                 default = nil)
  if valid_568307 != nil:
    section.add "filesystem", valid_568307
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : An optional operation timeout value in seconds. The period begins when the request is received by the service. If the timeout value elapses before the operation completes, the operation fails.
  ##   continuation: JString
  ##               : Optional.  When renaming a directory, the number of paths that are renamed with each invocation is limited.  If the number of paths to be renamed exceeds this limit, a continuation token is returned in this response header.  When a continuation token is returned in the response, it must be specified in a subsequent invocation of the rename operation to continue renaming the directory.
  ##   resource: JString
  ##           : Required only for Create File and Create Directory. The value must be "file" or "directory".
  ##   mode: JString
  ##       : Optional. Valid only when namespace is enabled. This parameter determines the behavior of the rename operation. The value must be "legacy" or "posix", and the default value will be "posix". 
  section = newJObject()
  var valid_568308 = query.getOrDefault("timeout")
  valid_568308 = validateParameter(valid_568308, JInt, required = false, default = nil)
  if valid_568308 != nil:
    section.add "timeout", valid_568308
  var valid_568309 = query.getOrDefault("continuation")
  valid_568309 = validateParameter(valid_568309, JString, required = false,
                                 default = nil)
  if valid_568309 != nil:
    section.add "continuation", valid_568309
  var valid_568310 = query.getOrDefault("resource")
  valid_568310 = validateParameter(valid_568310, JString, required = false,
                                 default = newJString("directory"))
  if valid_568310 != nil:
    section.add "resource", valid_568310
  var valid_568311 = query.getOrDefault("mode")
  valid_568311 = validateParameter(valid_568311, JString, required = false,
                                 default = newJString("legacy"))
  if valid_568311 != nil:
    section.add "mode", valid_568311
  result.add "query", section
  ## parameters in `header` object:
  ##   Content-Disposition: JString
  ##                      : Optional.  The service stores this value and includes it in the "Content-Disposition" response header for "Read File" operations.
  ##   x-ms-permissions: JString
  ##                   : Optional and only valid if Hierarchical Namespace is enabled for the account. Sets POSIX access permissions for the file owner, the file owning group, and others. Each class may be granted read, write, or execute permission.  The sticky bit is also supported.  Both symbolic (rwxrw-rw-) and 4-digit octal notation (e.g. 0766) are supported.
  ##   x-ms-source-lease-id: JString
  ##                       : Optional for rename operations.  A lease ID for the source path.  The source path must have an active lease and the lease ID must match.
  ##   If-Match: JString
  ##           : Optional.  An ETag value. Specify this header to perform the operation only if the resource's ETag matches the value specified. The ETag must be specified in quotes.
  ##   x-ms-source-if-unmodified-since: JString
  ##                                  : Optional. A date and time value. Specify this header to perform the rename operation only if the source has not been modified since the specified date and time.
  ##   x-ms-properties: JString
  ##                  : Optional.  User-defined properties to be stored with the file or directory, in the format of a comma-separated list of name and value pairs "n1=v1, n2=v2, ...", where each value is base64 encoded.
  ##   Cache-Control: JString
  ##                : Optional.  The service stores this value and includes it in the "Cache-Control" response header for "Read File" operations for "Read File" operations.
  ##   Content-Language: JString
  ##                   : Optional.  Specifies the natural language used by the intended audience for the file.
  ##   x-ms-source-if-match: JString
  ##                       : Optional.  An ETag value. Specify this header to perform the rename operation only if the source's ETag matches the value specified. The ETag must be specified in quotes.
  ##   x-ms-content-language: JString
  ##                        : Optional.  The service stores this value and includes it in the "Content-Language" response header for "Read File" operations.
  ##   If-Unmodified-Since: JString
  ##                      : Optional. A date and time value. Specify this header to perform the operation only if the resource has not been modified since the specified date and time.
  ##   x-ms-lease-id: JString
  ##                : Optional.  A lease ID for the path specified in the URI.  The path to be overwritten must have an active lease and the lease ID must match.
  ##   x-ms-content-encoding: JString
  ##                        : Optional.  The service stores this value and includes it in the "Content-Encoding" response header for "Read File" operations.
  ##   x-ms-cache-control: JString
  ##                     : Optional.  The service stores this value and includes it in the "Cache-Control" response header for "Read File" operations.
  ##   x-ms-client-request-id: JString
  ##                         : A UUID recorded in the analytics logs for troubleshooting and correlation.
  ##   x-ms-source-if-none-match: JString
  ##                            : Optional.  An ETag value or the special wildcard ("*") value. Specify this header to perform the rename operation only if the source's ETag does not match the value specified. The ETag must be specified in quotes.
  ##   x-ms-date: JString
  ##            : Specifies the Coordinated Universal Time (UTC) for the request.  This is required when using shared key authorization.
  ##   x-ms-proposed-lease-id: JString
  ##                         : Optional for create operations.  Required when "x-ms-lease-action" is used.  A lease will be acquired using the proposed ID when the resource is created.
  ##   If-None-Match: JString
  ##                : Optional.  An ETag value or the special wildcard ("*") value. Specify this header to perform the operation only if the resource's ETag does not match the value specified. The ETag must be specified in quotes.
  ##   If-Modified-Since: JString
  ##                    : Optional. A date and time value. Specify this header to perform the operation only if the resource has been modified since the specified date and time.
  ##   x-ms-version: JString
  ##               : Specifies the version of the REST protocol used for processing the request. This is required when using shared key authorization.
  ##   x-ms-rename-source: JString
  ##                     : An optional file or directory to be renamed.  The value must have the following format: "/{filesystem}/{path}".  If "x-ms-properties" is specified, the properties will overwrite the existing properties; otherwise, the existing properties will be preserved.
  ##   x-ms-content-disposition: JString
  ##                           : Optional.  The service stores this value and includes it in the "Content-Disposition" response header for "Read File" operations.
  ##   x-ms-content-type: JString
  ##                    : Optional.  The service stores this value and includes it in the "Content-Type" response header for "Read File" operations.
  ##   x-ms-source-if-modified-since: JString
  ##                                : Optional. A date and time value. Specify this header to perform the rename operation only if the source has been modified since the specified date and time.
  ##   Content-Encoding: JString
  ##                   : Optional.  Specifies which content encodings have been applied to the file. This value is returned to the client when the "Read File" operation is performed.
  section = newJObject()
  var valid_568312 = header.getOrDefault("Content-Disposition")
  valid_568312 = validateParameter(valid_568312, JString, required = false,
                                 default = nil)
  if valid_568312 != nil:
    section.add "Content-Disposition", valid_568312
  var valid_568313 = header.getOrDefault("x-ms-permissions")
  valid_568313 = validateParameter(valid_568313, JString, required = false,
                                 default = nil)
  if valid_568313 != nil:
    section.add "x-ms-permissions", valid_568313
  var valid_568314 = header.getOrDefault("x-ms-source-lease-id")
  valid_568314 = validateParameter(valid_568314, JString, required = false,
                                 default = nil)
  if valid_568314 != nil:
    section.add "x-ms-source-lease-id", valid_568314
  var valid_568315 = header.getOrDefault("If-Match")
  valid_568315 = validateParameter(valid_568315, JString, required = false,
                                 default = nil)
  if valid_568315 != nil:
    section.add "If-Match", valid_568315
  var valid_568316 = header.getOrDefault("x-ms-source-if-unmodified-since")
  valid_568316 = validateParameter(valid_568316, JString, required = false,
                                 default = nil)
  if valid_568316 != nil:
    section.add "x-ms-source-if-unmodified-since", valid_568316
  var valid_568317 = header.getOrDefault("x-ms-properties")
  valid_568317 = validateParameter(valid_568317, JString, required = false,
                                 default = nil)
  if valid_568317 != nil:
    section.add "x-ms-properties", valid_568317
  var valid_568318 = header.getOrDefault("Cache-Control")
  valid_568318 = validateParameter(valid_568318, JString, required = false,
                                 default = nil)
  if valid_568318 != nil:
    section.add "Cache-Control", valid_568318
  var valid_568319 = header.getOrDefault("Content-Language")
  valid_568319 = validateParameter(valid_568319, JString, required = false,
                                 default = nil)
  if valid_568319 != nil:
    section.add "Content-Language", valid_568319
  var valid_568320 = header.getOrDefault("x-ms-source-if-match")
  valid_568320 = validateParameter(valid_568320, JString, required = false,
                                 default = nil)
  if valid_568320 != nil:
    section.add "x-ms-source-if-match", valid_568320
  var valid_568321 = header.getOrDefault("x-ms-content-language")
  valid_568321 = validateParameter(valid_568321, JString, required = false,
                                 default = nil)
  if valid_568321 != nil:
    section.add "x-ms-content-language", valid_568321
  var valid_568322 = header.getOrDefault("If-Unmodified-Since")
  valid_568322 = validateParameter(valid_568322, JString, required = false,
                                 default = nil)
  if valid_568322 != nil:
    section.add "If-Unmodified-Since", valid_568322
  var valid_568323 = header.getOrDefault("x-ms-lease-id")
  valid_568323 = validateParameter(valid_568323, JString, required = false,
                                 default = nil)
  if valid_568323 != nil:
    section.add "x-ms-lease-id", valid_568323
  var valid_568324 = header.getOrDefault("x-ms-content-encoding")
  valid_568324 = validateParameter(valid_568324, JString, required = false,
                                 default = nil)
  if valid_568324 != nil:
    section.add "x-ms-content-encoding", valid_568324
  var valid_568325 = header.getOrDefault("x-ms-cache-control")
  valid_568325 = validateParameter(valid_568325, JString, required = false,
                                 default = nil)
  if valid_568325 != nil:
    section.add "x-ms-cache-control", valid_568325
  var valid_568326 = header.getOrDefault("x-ms-client-request-id")
  valid_568326 = validateParameter(valid_568326, JString, required = false,
                                 default = nil)
  if valid_568326 != nil:
    section.add "x-ms-client-request-id", valid_568326
  var valid_568327 = header.getOrDefault("x-ms-source-if-none-match")
  valid_568327 = validateParameter(valid_568327, JString, required = false,
                                 default = nil)
  if valid_568327 != nil:
    section.add "x-ms-source-if-none-match", valid_568327
  var valid_568328 = header.getOrDefault("x-ms-date")
  valid_568328 = validateParameter(valid_568328, JString, required = false,
                                 default = nil)
  if valid_568328 != nil:
    section.add "x-ms-date", valid_568328
  var valid_568329 = header.getOrDefault("x-ms-proposed-lease-id")
  valid_568329 = validateParameter(valid_568329, JString, required = false,
                                 default = nil)
  if valid_568329 != nil:
    section.add "x-ms-proposed-lease-id", valid_568329
  var valid_568330 = header.getOrDefault("If-None-Match")
  valid_568330 = validateParameter(valid_568330, JString, required = false,
                                 default = nil)
  if valid_568330 != nil:
    section.add "If-None-Match", valid_568330
  var valid_568331 = header.getOrDefault("If-Modified-Since")
  valid_568331 = validateParameter(valid_568331, JString, required = false,
                                 default = nil)
  if valid_568331 != nil:
    section.add "If-Modified-Since", valid_568331
  var valid_568332 = header.getOrDefault("x-ms-version")
  valid_568332 = validateParameter(valid_568332, JString, required = false,
                                 default = nil)
  if valid_568332 != nil:
    section.add "x-ms-version", valid_568332
  var valid_568333 = header.getOrDefault("x-ms-rename-source")
  valid_568333 = validateParameter(valid_568333, JString, required = false,
                                 default = nil)
  if valid_568333 != nil:
    section.add "x-ms-rename-source", valid_568333
  var valid_568334 = header.getOrDefault("x-ms-content-disposition")
  valid_568334 = validateParameter(valid_568334, JString, required = false,
                                 default = nil)
  if valid_568334 != nil:
    section.add "x-ms-content-disposition", valid_568334
  var valid_568335 = header.getOrDefault("x-ms-content-type")
  valid_568335 = validateParameter(valid_568335, JString, required = false,
                                 default = nil)
  if valid_568335 != nil:
    section.add "x-ms-content-type", valid_568335
  var valid_568336 = header.getOrDefault("x-ms-source-if-modified-since")
  valid_568336 = validateParameter(valid_568336, JString, required = false,
                                 default = nil)
  if valid_568336 != nil:
    section.add "x-ms-source-if-modified-since", valid_568336
  var valid_568337 = header.getOrDefault("Content-Encoding")
  valid_568337 = validateParameter(valid_568337, JString, required = false,
                                 default = nil)
  if valid_568337 != nil:
    section.add "Content-Encoding", valid_568337
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568338: Call_PathCreate_568303; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or rename a file or directory.    By default, the destination is overwritten and if the destination already exists and has a lease the lease is broken.  This operation supports conditional HTTP requests.  For more information, see [Specifying Conditional Headers for Blob Service Operations](https://docs.microsoft.com/en-us/rest/api/storageservices/specifying-conditional-headers-for-blob-service-operations).  To fail if the destination already exists, use a conditional request with If-None-Match: "*".
  ## 
  let valid = call_568338.validator(path, query, header, formData, body)
  let scheme = call_568338.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568338.url(scheme.get, call_568338.host, call_568338.base,
                         call_568338.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568338, url, valid)

proc call*(call_568339: Call_PathCreate_568303; path: string; filesystem: string;
          timeout: int = 0; continuation: string = ""; resource: string = "directory";
          mode: string = "legacy"): Recallable =
  ## pathCreate
  ## Create or rename a file or directory.    By default, the destination is overwritten and if the destination already exists and has a lease the lease is broken.  This operation supports conditional HTTP requests.  For more information, see [Specifying Conditional Headers for Blob Service Operations](https://docs.microsoft.com/en-us/rest/api/storageservices/specifying-conditional-headers-for-blob-service-operations).  To fail if the destination already exists, use a conditional request with If-None-Match: "*".
  ##   timeout: int
  ##          : An optional operation timeout value in seconds. The period begins when the request is received by the service. If the timeout value elapses before the operation completes, the operation fails.
  ##   continuation: string
  ##               : Optional.  When renaming a directory, the number of paths that are renamed with each invocation is limited.  If the number of paths to be renamed exceeds this limit, a continuation token is returned in this response header.  When a continuation token is returned in the response, it must be specified in a subsequent invocation of the rename operation to continue renaming the directory.
  ##   resource: string
  ##           : Required only for Create File and Create Directory. The value must be "file" or "directory".
  ##   mode: string
  ##       : Optional. Valid only when namespace is enabled. This parameter determines the behavior of the rename operation. The value must be "legacy" or "posix", and the default value will be "posix". 
  ##   path: string (required)
  ##       : The file or directory path.
  ##   filesystem: string (required)
  ##             : The filesystem identifier.
  var path_568340 = newJObject()
  var query_568341 = newJObject()
  add(query_568341, "timeout", newJInt(timeout))
  add(query_568341, "continuation", newJString(continuation))
  add(query_568341, "resource", newJString(resource))
  add(query_568341, "mode", newJString(mode))
  add(path_568340, "path", newJString(path))
  add(path_568340, "filesystem", newJString(filesystem))
  result = call_568339.call(path_568340, query_568341, nil, nil, nil)

var pathCreate* = Call_PathCreate_568303(name: "pathCreate",
                                      meth: HttpMethod.HttpPut,
                                      host: "azure.local",
                                      route: "/{filesystem}/{path}",
                                      validator: validate_PathCreate_568304,
                                      base: "", url: url_PathCreate_568305,
                                      schemes: {Scheme.Https})
type
  Call_PathGetProperties_568384 = ref object of OpenApiRestCall_567658
proc url_PathGetProperties_568386(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "filesystem" in path, "`filesystem` is a required path parameter"
  assert "path" in path, "`path` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "filesystem"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "path")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PathGetProperties_568385(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Get the properties for a file or directory, and optionally include the access control list.  This operation supports conditional HTTP requests.  For more information, see [Specifying Conditional Headers for Blob Service Operations](https://docs.microsoft.com/en-us/rest/api/storageservices/specifying-conditional-headers-for-blob-service-operations).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   path: JString (required)
  ##       : The file or directory path.
  ##   filesystem: JString (required)
  ##             : The filesystem identifier.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `path` field"
  var valid_568387 = path.getOrDefault("path")
  valid_568387 = validateParameter(valid_568387, JString, required = true,
                                 default = nil)
  if valid_568387 != nil:
    section.add "path", valid_568387
  var valid_568388 = path.getOrDefault("filesystem")
  valid_568388 = validateParameter(valid_568388, JString, required = true,
                                 default = nil)
  if valid_568388 != nil:
    section.add "filesystem", valid_568388
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : An optional operation timeout value in seconds. The period begins when the request is received by the service. If the timeout value elapses before the operation completes, the operation fails.
  ##   action: JString
  ##         : Optional. If the value is "getAccessControl" the access control list is returned in the response headers (Hierarchical Namespace must be enabled for the account).
  section = newJObject()
  var valid_568389 = query.getOrDefault("timeout")
  valid_568389 = validateParameter(valid_568389, JInt, required = false, default = nil)
  if valid_568389 != nil:
    section.add "timeout", valid_568389
  var valid_568390 = query.getOrDefault("action")
  valid_568390 = validateParameter(valid_568390, JString, required = false,
                                 default = newJString("getAccessControl"))
  if valid_568390 != nil:
    section.add "action", valid_568390
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : Optional.  An ETag value. Specify this header to perform the operation only if the resource's ETag matches the value specified. The ETag must be specified in quotes.
  ##   If-Unmodified-Since: JString
  ##                      : Optional. A date and time value. Specify this header to perform the operation only if the resource has not been modified since the specified date and time.
  ##   x-ms-client-request-id: JString
  ##                         : A UUID recorded in the analytics logs for troubleshooting and correlation.
  ##   x-ms-date: JString
  ##            : Specifies the Coordinated Universal Time (UTC) for the request.  This is required when using shared key authorization.
  ##   If-None-Match: JString
  ##                : Optional.  An ETag value or the special wildcard ("*") value. Specify this header to perform the operation only if the resource's ETag does not match the value specified. The ETag must be specified in quotes.
  ##   If-Modified-Since: JString
  ##                    : Optional. A date and time value. Specify this header to perform the operation only if the resource has been modified since the specified date and time.
  ##   x-ms-version: JString
  ##               : Specifies the version of the REST protocol used for processing the request. This is required when using shared key authorization.
  section = newJObject()
  var valid_568391 = header.getOrDefault("If-Match")
  valid_568391 = validateParameter(valid_568391, JString, required = false,
                                 default = nil)
  if valid_568391 != nil:
    section.add "If-Match", valid_568391
  var valid_568392 = header.getOrDefault("If-Unmodified-Since")
  valid_568392 = validateParameter(valid_568392, JString, required = false,
                                 default = nil)
  if valid_568392 != nil:
    section.add "If-Unmodified-Since", valid_568392
  var valid_568393 = header.getOrDefault("x-ms-client-request-id")
  valid_568393 = validateParameter(valid_568393, JString, required = false,
                                 default = nil)
  if valid_568393 != nil:
    section.add "x-ms-client-request-id", valid_568393
  var valid_568394 = header.getOrDefault("x-ms-date")
  valid_568394 = validateParameter(valid_568394, JString, required = false,
                                 default = nil)
  if valid_568394 != nil:
    section.add "x-ms-date", valid_568394
  var valid_568395 = header.getOrDefault("If-None-Match")
  valid_568395 = validateParameter(valid_568395, JString, required = false,
                                 default = nil)
  if valid_568395 != nil:
    section.add "If-None-Match", valid_568395
  var valid_568396 = header.getOrDefault("If-Modified-Since")
  valid_568396 = validateParameter(valid_568396, JString, required = false,
                                 default = nil)
  if valid_568396 != nil:
    section.add "If-Modified-Since", valid_568396
  var valid_568397 = header.getOrDefault("x-ms-version")
  valid_568397 = validateParameter(valid_568397, JString, required = false,
                                 default = nil)
  if valid_568397 != nil:
    section.add "x-ms-version", valid_568397
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568398: Call_PathGetProperties_568384; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the properties for a file or directory, and optionally include the access control list.  This operation supports conditional HTTP requests.  For more information, see [Specifying Conditional Headers for Blob Service Operations](https://docs.microsoft.com/en-us/rest/api/storageservices/specifying-conditional-headers-for-blob-service-operations).
  ## 
  let valid = call_568398.validator(path, query, header, formData, body)
  let scheme = call_568398.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568398.url(scheme.get, call_568398.host, call_568398.base,
                         call_568398.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568398, url, valid)

proc call*(call_568399: Call_PathGetProperties_568384; path: string;
          filesystem: string; timeout: int = 0; action: string = "getAccessControl"): Recallable =
  ## pathGetProperties
  ## Get the properties for a file or directory, and optionally include the access control list.  This operation supports conditional HTTP requests.  For more information, see [Specifying Conditional Headers for Blob Service Operations](https://docs.microsoft.com/en-us/rest/api/storageservices/specifying-conditional-headers-for-blob-service-operations).
  ##   timeout: int
  ##          : An optional operation timeout value in seconds. The period begins when the request is received by the service. If the timeout value elapses before the operation completes, the operation fails.
  ##   action: string
  ##         : Optional. If the value is "getAccessControl" the access control list is returned in the response headers (Hierarchical Namespace must be enabled for the account).
  ##   path: string (required)
  ##       : The file or directory path.
  ##   filesystem: string (required)
  ##             : The filesystem identifier.
  var path_568400 = newJObject()
  var query_568401 = newJObject()
  add(query_568401, "timeout", newJInt(timeout))
  add(query_568401, "action", newJString(action))
  add(path_568400, "path", newJString(path))
  add(path_568400, "filesystem", newJString(filesystem))
  result = call_568399.call(path_568400, query_568401, nil, nil, nil)

var pathGetProperties* = Call_PathGetProperties_568384(name: "pathGetProperties",
    meth: HttpMethod.HttpHead, host: "azure.local", route: "/{filesystem}/{path}",
    validator: validate_PathGetProperties_568385, base: "",
    url: url_PathGetProperties_568386, schemes: {Scheme.Https})
type
  Call_PathLease_568342 = ref object of OpenApiRestCall_567658
proc url_PathLease_568344(protocol: Scheme; host: string; base: string; route: string;
                         path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "filesystem" in path, "`filesystem` is a required path parameter"
  assert "path" in path, "`path` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "filesystem"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "path")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PathLease_568343(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Create and manage a lease to restrict write and delete access to the path. This operation supports conditional HTTP requests.  For more information, see [Specifying Conditional Headers for Blob Service Operations](https://docs.microsoft.com/en-us/rest/api/storageservices/specifying-conditional-headers-for-blob-service-operations).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   path: JString (required)
  ##       : The file or directory path.
  ##   filesystem: JString (required)
  ##             : The filesystem identifier.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `path` field"
  var valid_568345 = path.getOrDefault("path")
  valid_568345 = validateParameter(valid_568345, JString, required = true,
                                 default = nil)
  if valid_568345 != nil:
    section.add "path", valid_568345
  var valid_568346 = path.getOrDefault("filesystem")
  valid_568346 = validateParameter(valid_568346, JString, required = true,
                                 default = nil)
  if valid_568346 != nil:
    section.add "filesystem", valid_568346
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : An optional operation timeout value in seconds. The period begins when the request is received by the service. If the timeout value elapses before the operation completes, the operation fails.
  section = newJObject()
  var valid_568347 = query.getOrDefault("timeout")
  valid_568347 = validateParameter(valid_568347, JInt, required = false, default = nil)
  if valid_568347 != nil:
    section.add "timeout", valid_568347
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : Optional.  An ETag value. Specify this header to perform the operation only if the resource's ETag matches the value specified. The ETag must be specified in quotes.
  ##   x-ms-lease-duration: JInt
  ##                      : The lease duration is required to acquire a lease, and specifies the duration of the lease in seconds.  The lease duration must be between 15 and 60 seconds or -1 for infinite lease.
  ##   If-Unmodified-Since: JString
  ##                      : Optional. A date and time value. Specify this header to perform the operation only if the resource has not been modified since the specified date and time.
  ##   x-ms-lease-id: JString
  ##                : Required when "x-ms-lease-action" is "renew", "change" or "release". For the renew and release actions, this must match the current lease ID.
  ##   x-ms-client-request-id: JString
  ##                         : A UUID recorded in the analytics logs for troubleshooting and correlation.
  ##   x-ms-date: JString
  ##            : Specifies the Coordinated Universal Time (UTC) for the request.  This is required when using shared key authorization.
  ##   x-ms-lease-break-period: JInt
  ##                          : The lease break period duration is optional to break a lease, and  specifies the break period of the lease in seconds.  The lease break  duration must be between 0 and 60 seconds.
  ##   x-ms-proposed-lease-id: JString
  ##                         : Required when "x-ms-lease-action" is "acquire" or "change".  A lease will be acquired with this lease ID if the operation is successful.
  ##   If-None-Match: JString
  ##                : Optional.  An ETag value or the special wildcard ("*") value. Specify this header to perform the operation only if the resource's ETag does not match the value specified. The ETag must be specified in quotes.
  ##   If-Modified-Since: JString
  ##                    : Optional. A date and time value. Specify this header to perform the operation only if the resource has been modified since the specified date and time.
  ##   x-ms-version: JString
  ##               : Specifies the version of the REST protocol used for processing the request. This is required when using shared key authorization.
  ##   x-ms-lease-action: JString (required)
  ##                    : There are five lease actions: "acquire", "break", "change", "renew", and "release". Use "acquire" and specify the "x-ms-proposed-lease-id" and "x-ms-lease-duration" to acquire a new lease. Use "break" to break an existing lease. When a lease is broken, the lease break period is allowed to elapse, during which time no lease operation except break and release can be performed on the file. When a lease is successfully broken, the response indicates the interval in seconds until a new lease can be acquired. Use "change" and specify the current lease ID in "x-ms-lease-id" and the new lease ID in "x-ms-proposed-lease-id" to change the lease ID of an active lease. Use "renew" and specify the "x-ms-lease-id" to renew an existing lease. Use "release" and specify the "x-ms-lease-id" to release a lease.
  section = newJObject()
  var valid_568348 = header.getOrDefault("If-Match")
  valid_568348 = validateParameter(valid_568348, JString, required = false,
                                 default = nil)
  if valid_568348 != nil:
    section.add "If-Match", valid_568348
  var valid_568349 = header.getOrDefault("x-ms-lease-duration")
  valid_568349 = validateParameter(valid_568349, JInt, required = false, default = nil)
  if valid_568349 != nil:
    section.add "x-ms-lease-duration", valid_568349
  var valid_568350 = header.getOrDefault("If-Unmodified-Since")
  valid_568350 = validateParameter(valid_568350, JString, required = false,
                                 default = nil)
  if valid_568350 != nil:
    section.add "If-Unmodified-Since", valid_568350
  var valid_568351 = header.getOrDefault("x-ms-lease-id")
  valid_568351 = validateParameter(valid_568351, JString, required = false,
                                 default = nil)
  if valid_568351 != nil:
    section.add "x-ms-lease-id", valid_568351
  var valid_568352 = header.getOrDefault("x-ms-client-request-id")
  valid_568352 = validateParameter(valid_568352, JString, required = false,
                                 default = nil)
  if valid_568352 != nil:
    section.add "x-ms-client-request-id", valid_568352
  var valid_568353 = header.getOrDefault("x-ms-date")
  valid_568353 = validateParameter(valid_568353, JString, required = false,
                                 default = nil)
  if valid_568353 != nil:
    section.add "x-ms-date", valid_568353
  var valid_568354 = header.getOrDefault("x-ms-lease-break-period")
  valid_568354 = validateParameter(valid_568354, JInt, required = false, default = nil)
  if valid_568354 != nil:
    section.add "x-ms-lease-break-period", valid_568354
  var valid_568355 = header.getOrDefault("x-ms-proposed-lease-id")
  valid_568355 = validateParameter(valid_568355, JString, required = false,
                                 default = nil)
  if valid_568355 != nil:
    section.add "x-ms-proposed-lease-id", valid_568355
  var valid_568356 = header.getOrDefault("If-None-Match")
  valid_568356 = validateParameter(valid_568356, JString, required = false,
                                 default = nil)
  if valid_568356 != nil:
    section.add "If-None-Match", valid_568356
  var valid_568357 = header.getOrDefault("If-Modified-Since")
  valid_568357 = validateParameter(valid_568357, JString, required = false,
                                 default = nil)
  if valid_568357 != nil:
    section.add "If-Modified-Since", valid_568357
  var valid_568358 = header.getOrDefault("x-ms-version")
  valid_568358 = validateParameter(valid_568358, JString, required = false,
                                 default = nil)
  if valid_568358 != nil:
    section.add "x-ms-version", valid_568358
  assert header != nil, "header argument is necessary due to required `x-ms-lease-action` field"
  var valid_568359 = header.getOrDefault("x-ms-lease-action")
  valid_568359 = validateParameter(valid_568359, JString, required = true,
                                 default = newJString("acquire"))
  if valid_568359 != nil:
    section.add "x-ms-lease-action", valid_568359
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568360: Call_PathLease_568342; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create and manage a lease to restrict write and delete access to the path. This operation supports conditional HTTP requests.  For more information, see [Specifying Conditional Headers for Blob Service Operations](https://docs.microsoft.com/en-us/rest/api/storageservices/specifying-conditional-headers-for-blob-service-operations).
  ## 
  let valid = call_568360.validator(path, query, header, formData, body)
  let scheme = call_568360.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568360.url(scheme.get, call_568360.host, call_568360.base,
                         call_568360.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568360, url, valid)

proc call*(call_568361: Call_PathLease_568342; path: string; filesystem: string;
          timeout: int = 0): Recallable =
  ## pathLease
  ## Create and manage a lease to restrict write and delete access to the path. This operation supports conditional HTTP requests.  For more information, see [Specifying Conditional Headers for Blob Service Operations](https://docs.microsoft.com/en-us/rest/api/storageservices/specifying-conditional-headers-for-blob-service-operations).
  ##   timeout: int
  ##          : An optional operation timeout value in seconds. The period begins when the request is received by the service. If the timeout value elapses before the operation completes, the operation fails.
  ##   path: string (required)
  ##       : The file or directory path.
  ##   filesystem: string (required)
  ##             : The filesystem identifier.
  var path_568362 = newJObject()
  var query_568363 = newJObject()
  add(query_568363, "timeout", newJInt(timeout))
  add(path_568362, "path", newJString(path))
  add(path_568362, "filesystem", newJString(filesystem))
  result = call_568361.call(path_568362, query_568363, nil, nil, nil)

var pathLease* = Call_PathLease_568342(name: "pathLease", meth: HttpMethod.HttpPost,
                                    host: "azure.local",
                                    route: "/{filesystem}/{path}",
                                    validator: validate_PathLease_568343,
                                    base: "", url: url_PathLease_568344,
                                    schemes: {Scheme.Https})
type
  Call_PathRead_568285 = ref object of OpenApiRestCall_567658
proc url_PathRead_568287(protocol: Scheme; host: string; base: string; route: string;
                        path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "filesystem" in path, "`filesystem` is a required path parameter"
  assert "path" in path, "`path` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "filesystem"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "path")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PathRead_568286(path: JsonNode; query: JsonNode; header: JsonNode;
                             formData: JsonNode; body: JsonNode): JsonNode =
  ## Read the contents of a file.  For read operations, range requests are supported. This operation supports conditional HTTP requests.  For more information, see [Specifying Conditional Headers for Blob Service Operations](https://docs.microsoft.com/en-us/rest/api/storageservices/specifying-conditional-headers-for-blob-service-operations).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   path: JString (required)
  ##       : The file or directory path.
  ##   filesystem: JString (required)
  ##             : The filesystem identifier.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `path` field"
  var valid_568288 = path.getOrDefault("path")
  valid_568288 = validateParameter(valid_568288, JString, required = true,
                                 default = nil)
  if valid_568288 != nil:
    section.add "path", valid_568288
  var valid_568289 = path.getOrDefault("filesystem")
  valid_568289 = validateParameter(valid_568289, JString, required = true,
                                 default = nil)
  if valid_568289 != nil:
    section.add "filesystem", valid_568289
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : An optional operation timeout value in seconds. The period begins when the request is received by the service. If the timeout value elapses before the operation completes, the operation fails.
  section = newJObject()
  var valid_568290 = query.getOrDefault("timeout")
  valid_568290 = validateParameter(valid_568290, JInt, required = false, default = nil)
  if valid_568290 != nil:
    section.add "timeout", valid_568290
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : Optional.  An ETag value. Specify this header to perform the operation only if the resource's ETag matches the value specified. The ETag must be specified in quotes.
  ##   If-Unmodified-Since: JString
  ##                      : Optional. A date and time value. Specify this header to perform the operation only if the resource has not been modified since the specified date and time.
  ##   x-ms-client-request-id: JString
  ##                         : A UUID recorded in the analytics logs for troubleshooting and correlation.
  ##   x-ms-date: JString
  ##            : Specifies the Coordinated Universal Time (UTC) for the request.  This is required when using shared key authorization.
  ##   If-None-Match: JString
  ##                : Optional.  An ETag value or the special wildcard ("*") value. Specify this header to perform the operation only if the resource's ETag does not match the value specified. The ETag must be specified in quotes.
  ##   If-Modified-Since: JString
  ##                    : Optional. A date and time value. Specify this header to perform the operation only if the resource has been modified since the specified date and time.
  ##   x-ms-version: JString
  ##               : Specifies the version of the REST protocol used for processing the request. This is required when using shared key authorization.
  ##   Range: JString
  ##        : The HTTP Range request header specifies one or more byte ranges of the resource to be retrieved.
  section = newJObject()
  var valid_568291 = header.getOrDefault("If-Match")
  valid_568291 = validateParameter(valid_568291, JString, required = false,
                                 default = nil)
  if valid_568291 != nil:
    section.add "If-Match", valid_568291
  var valid_568292 = header.getOrDefault("If-Unmodified-Since")
  valid_568292 = validateParameter(valid_568292, JString, required = false,
                                 default = nil)
  if valid_568292 != nil:
    section.add "If-Unmodified-Since", valid_568292
  var valid_568293 = header.getOrDefault("x-ms-client-request-id")
  valid_568293 = validateParameter(valid_568293, JString, required = false,
                                 default = nil)
  if valid_568293 != nil:
    section.add "x-ms-client-request-id", valid_568293
  var valid_568294 = header.getOrDefault("x-ms-date")
  valid_568294 = validateParameter(valid_568294, JString, required = false,
                                 default = nil)
  if valid_568294 != nil:
    section.add "x-ms-date", valid_568294
  var valid_568295 = header.getOrDefault("If-None-Match")
  valid_568295 = validateParameter(valid_568295, JString, required = false,
                                 default = nil)
  if valid_568295 != nil:
    section.add "If-None-Match", valid_568295
  var valid_568296 = header.getOrDefault("If-Modified-Since")
  valid_568296 = validateParameter(valid_568296, JString, required = false,
                                 default = nil)
  if valid_568296 != nil:
    section.add "If-Modified-Since", valid_568296
  var valid_568297 = header.getOrDefault("x-ms-version")
  valid_568297 = validateParameter(valid_568297, JString, required = false,
                                 default = nil)
  if valid_568297 != nil:
    section.add "x-ms-version", valid_568297
  var valid_568298 = header.getOrDefault("Range")
  valid_568298 = validateParameter(valid_568298, JString, required = false,
                                 default = nil)
  if valid_568298 != nil:
    section.add "Range", valid_568298
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568299: Call_PathRead_568285; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Read the contents of a file.  For read operations, range requests are supported. This operation supports conditional HTTP requests.  For more information, see [Specifying Conditional Headers for Blob Service Operations](https://docs.microsoft.com/en-us/rest/api/storageservices/specifying-conditional-headers-for-blob-service-operations).
  ## 
  let valid = call_568299.validator(path, query, header, formData, body)
  let scheme = call_568299.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568299.url(scheme.get, call_568299.host, call_568299.base,
                         call_568299.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568299, url, valid)

proc call*(call_568300: Call_PathRead_568285; path: string; filesystem: string;
          timeout: int = 0): Recallable =
  ## pathRead
  ## Read the contents of a file.  For read operations, range requests are supported. This operation supports conditional HTTP requests.  For more information, see [Specifying Conditional Headers for Blob Service Operations](https://docs.microsoft.com/en-us/rest/api/storageservices/specifying-conditional-headers-for-blob-service-operations).
  ##   timeout: int
  ##          : An optional operation timeout value in seconds. The period begins when the request is received by the service. If the timeout value elapses before the operation completes, the operation fails.
  ##   path: string (required)
  ##       : The file or directory path.
  ##   filesystem: string (required)
  ##             : The filesystem identifier.
  var path_568301 = newJObject()
  var query_568302 = newJObject()
  add(query_568302, "timeout", newJInt(timeout))
  add(path_568301, "path", newJString(path))
  add(path_568301, "filesystem", newJString(filesystem))
  result = call_568300.call(path_568301, query_568302, nil, nil, nil)

var pathRead* = Call_PathRead_568285(name: "pathRead", meth: HttpMethod.HttpGet,
                                  host: "azure.local",
                                  route: "/{filesystem}/{path}",
                                  validator: validate_PathRead_568286, base: "",
                                  url: url_PathRead_568287,
                                  schemes: {Scheme.Https})
type
  Call_PathUpdate_568402 = ref object of OpenApiRestCall_567658
proc url_PathUpdate_568404(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "filesystem" in path, "`filesystem` is a required path parameter"
  assert "path" in path, "`path` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "filesystem"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "path")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PathUpdate_568403(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Uploads data to be appended to a file, flushes (writes) previously uploaded data to a file, sets properties for a file or directory, or sets access control for a file or directory. Data can only be appended to a file. This operation supports conditional HTTP requests. For more information, see [Specifying Conditional Headers for Blob Service Operations](https://docs.microsoft.com/en-us/rest/api/storageservices/specifying-conditional-headers-for-blob-service-operations).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   path: JString (required)
  ##       : The file or directory path.
  ##   filesystem: JString (required)
  ##             : The filesystem identifier.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `path` field"
  var valid_568405 = path.getOrDefault("path")
  valid_568405 = validateParameter(valid_568405, JString, required = true,
                                 default = nil)
  if valid_568405 != nil:
    section.add "path", valid_568405
  var valid_568406 = path.getOrDefault("filesystem")
  valid_568406 = validateParameter(valid_568406, JString, required = true,
                                 default = nil)
  if valid_568406 != nil:
    section.add "filesystem", valid_568406
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : An optional operation timeout value in seconds. The period begins when the request is received by the service. If the timeout value elapses before the operation completes, the operation fails.
  ##   action: JString (required)
  ##         : The action must be "append" to upload data to be appended to a file, "flush" to flush previously uploaded data to a file, "setProperties" to set the properties of a file or directory, or "setAccessControl" to set the owner, group, permissions, or access control list for a file or directory.  Note that Hierarchical Namespace must be enabled for the account in order to use access control.  Also note that the Access Control List (ACL) includes permissions for the owner, owning group, and others, so the x-ms-permissions and x-ms-acl request headers are mutually exclusive.
  ##   retainUncommittedData: JBool
  ##                        : Valid only for flush operations.  If "true", uncommitted data is retained after the flush operation completes; otherwise, the uncommitted data is deleted after the flush operation.  The default is false.  Data at offsets less than the specified position are written to the file when flush succeeds, but this optional parameter allows data after the flush position to be retained for a future flush operation.
  ##   position: JInt
  ##           : This parameter allows the caller to upload data in parallel and control the order in which it is appended to the file.  It is required when uploading data to be appended to the file and when flushing previously uploaded data to the file.  The value must be the position where the data is to be appended.  Uploaded data is not immediately flushed, or written, to the file.  To flush, the previously uploaded data must be contiguous, the position parameter must be specified and equal to the length of the file after all data has been written, and there must not be a request entity body included with the request.
  section = newJObject()
  var valid_568407 = query.getOrDefault("timeout")
  valid_568407 = validateParameter(valid_568407, JInt, required = false, default = nil)
  if valid_568407 != nil:
    section.add "timeout", valid_568407
  assert query != nil, "query argument is necessary due to required `action` field"
  var valid_568408 = query.getOrDefault("action")
  valid_568408 = validateParameter(valid_568408, JString, required = true,
                                 default = newJString("append"))
  if valid_568408 != nil:
    section.add "action", valid_568408
  var valid_568409 = query.getOrDefault("retainUncommittedData")
  valid_568409 = validateParameter(valid_568409, JBool, required = false, default = nil)
  if valid_568409 != nil:
    section.add "retainUncommittedData", valid_568409
  var valid_568410 = query.getOrDefault("position")
  valid_568410 = validateParameter(valid_568410, JInt, required = false, default = nil)
  if valid_568410 != nil:
    section.add "position", valid_568410
  result.add "query", section
  ## parameters in `header` object:
  ##   x-ms-permissions: JString
  ##                   : Optional and only valid if Hierarchical Namespace is enabled for the account. Sets POSIX access permissions for the file owner, the file owning group, and others. Each class may be granted read, write, or execute permission.  The sticky bit is also supported.  Both symbolic (rwxrw-rw-) and 4-digit octal notation (e.g. 0766) are supported. Invalid in conjunction with x-ms-acl.
  ##   x-ms-acl: JString
  ##           : Optional and valid only for the setAccessControl operation. Sets POSIX access control rights on files and directories. The value is a comma-separated list of access control entries that fully replaces the existing access control list (ACL).  Each access control entry (ACE) consists of a scope, a type, a user or group identifier, and permissions in the format "[scope:][type]:[id]:[permissions]". The scope must be "default" to indicate the ACE belongs to the default ACL for a directory; otherwise scope is implicit and the ACE belongs to the access ACL.  There are four ACE types: "user" grants rights to the owner or a named user, "group" grants rights to the owning group or a named group, "mask" restricts rights granted to named users and the members of groups, and "other" grants rights to all users not found in any of the other entries. The user or group identifier is omitted for entries of type "mask" and "other".  The user or group identifier is also omitted for the owner and owning group.  The permission field is a 3-character sequence where the first character is 'r' to grant read access, the second character is 'w' to grant write access, and the third character is 'x' to grant execute permission.  If access is not granted, the '-' character is used to denote that the permission is denied. For example, the following ACL grants read, write, and execute rights to the file owner and john.doe@contoso, the read right to the owning group, and nothing to everyone else: "user::rwx,user:john.doe@contoso:rwx,group::r--,other::---,mask=rwx". Invalid in conjunction with x-ms-permissions.
  ##   If-Match: JString
  ##           : Optional for Flush Data and Set Properties, but invalid for Append Data.  An ETag value. Specify this header to perform the operation only if the resource's ETag matches the value specified. The ETag must be specified in quotes.
  ##   x-ms-properties: JString
  ##                  : Optional.  User-defined properties to be stored with the file or directory, in the format of a comma-separated list of name and value pairs "n1=v1, n2=v2, ...", where each value is base64 encoded.  Valid only for the setProperties operation.  If the file or directory exists, any properties not included in the list will be removed.  All properties are removed if the header is omitted.  To merge new and existing properties, first get all existing properties and the current E-Tag, then make a conditional request with the E-Tag and include values for all properties.
  ##   x-ms-content-language: JString
  ##                        : Optional and only valid for flush and set properties operations.  The service stores this value and includes it in the "Content-Language" response header for "Read File" operations.
  ##   x-ms-group: JString
  ##             : Optional and valid only for the setAccessControl operation. Sets the owning group of the file or directory.
  ##   If-Unmodified-Since: JString
  ##                      : Optional for Flush Data and Set Properties, but invalid for Append Data. A date and time value. Specify this header to perform the operation only if the resource has not been modified since the specified date and time.
  ##   x-ms-lease-id: JString
  ##                : The lease ID must be specified if there is an active lease.
  ##   x-ms-content-encoding: JString
  ##                        : Optional and only valid for flush and set properties operations.  The service stores this value and includes it in the "Content-Encoding" response header for "Read File" operations.
  ##   x-ms-cache-control: JString
  ##                     : Optional and only valid for flush and set properties operations.  The service stores this value and includes it in the "Cache-Control" response header for "Read File" operations.
  ##   x-ms-client-request-id: JString
  ##                         : A UUID recorded in the analytics logs for troubleshooting and correlation.
  ##   x-ms-date: JString
  ##            : Specifies the Coordinated Universal Time (UTC) for the request.  This is required when using shared key authorization.
  ##   Content-Length: JString
  ##                 : Required for "Append Data" and "Flush Data".  Must be 0 for "Flush Data".  Must be the length of the request content in bytes for "Append Data".
  ##   If-None-Match: JString
  ##                : Optional for Flush Data and Set Properties, but invalid for Append Data.  An ETag value or the special wildcard ("*") value. Specify this header to perform the operation only if the resource's ETag does not match the value specified. The ETag must be specified in quotes.
  ##   If-Modified-Since: JString
  ##                    : Optional for Flush Data and Set Properties, but invalid for Append Data. A date and time value. Specify this header to perform the operation only if the resource has been modified since the specified date and time.
  ##   x-ms-owner: JString
  ##             : Optional and valid only for the setAccessControl operation. Sets the owner of the file or directory.
  ##   x-ms-version: JString
  ##               : Specifies the version of the REST protocol used for processing the request. This is required when using shared key authorization.
  ##   x-ms-content-disposition: JString
  ##                           : Optional and only valid for flush and set properties operations.  The service stores this value and includes it in the "Content-Disposition" response header for "Read File" operations.
  ##   x-ms-content-type: JString
  ##                    : Optional and only valid for flush and set properties operations.  The service stores this value and includes it in the "Content-Type" response header for "Read File" operations.
  ##   x-ms-lease-action: JString
  ##                    : Optional.  The lease action can be "renew" to renew an existing lease or "release" to release a lease.
  section = newJObject()
  var valid_568411 = header.getOrDefault("x-ms-permissions")
  valid_568411 = validateParameter(valid_568411, JString, required = false,
                                 default = nil)
  if valid_568411 != nil:
    section.add "x-ms-permissions", valid_568411
  var valid_568412 = header.getOrDefault("x-ms-acl")
  valid_568412 = validateParameter(valid_568412, JString, required = false,
                                 default = nil)
  if valid_568412 != nil:
    section.add "x-ms-acl", valid_568412
  var valid_568413 = header.getOrDefault("If-Match")
  valid_568413 = validateParameter(valid_568413, JString, required = false,
                                 default = nil)
  if valid_568413 != nil:
    section.add "If-Match", valid_568413
  var valid_568414 = header.getOrDefault("x-ms-properties")
  valid_568414 = validateParameter(valid_568414, JString, required = false,
                                 default = nil)
  if valid_568414 != nil:
    section.add "x-ms-properties", valid_568414
  var valid_568415 = header.getOrDefault("x-ms-content-language")
  valid_568415 = validateParameter(valid_568415, JString, required = false,
                                 default = nil)
  if valid_568415 != nil:
    section.add "x-ms-content-language", valid_568415
  var valid_568416 = header.getOrDefault("x-ms-group")
  valid_568416 = validateParameter(valid_568416, JString, required = false,
                                 default = nil)
  if valid_568416 != nil:
    section.add "x-ms-group", valid_568416
  var valid_568417 = header.getOrDefault("If-Unmodified-Since")
  valid_568417 = validateParameter(valid_568417, JString, required = false,
                                 default = nil)
  if valid_568417 != nil:
    section.add "If-Unmodified-Since", valid_568417
  var valid_568418 = header.getOrDefault("x-ms-lease-id")
  valid_568418 = validateParameter(valid_568418, JString, required = false,
                                 default = nil)
  if valid_568418 != nil:
    section.add "x-ms-lease-id", valid_568418
  var valid_568419 = header.getOrDefault("x-ms-content-encoding")
  valid_568419 = validateParameter(valid_568419, JString, required = false,
                                 default = nil)
  if valid_568419 != nil:
    section.add "x-ms-content-encoding", valid_568419
  var valid_568420 = header.getOrDefault("x-ms-cache-control")
  valid_568420 = validateParameter(valid_568420, JString, required = false,
                                 default = nil)
  if valid_568420 != nil:
    section.add "x-ms-cache-control", valid_568420
  var valid_568421 = header.getOrDefault("x-ms-client-request-id")
  valid_568421 = validateParameter(valid_568421, JString, required = false,
                                 default = nil)
  if valid_568421 != nil:
    section.add "x-ms-client-request-id", valid_568421
  var valid_568422 = header.getOrDefault("x-ms-date")
  valid_568422 = validateParameter(valid_568422, JString, required = false,
                                 default = nil)
  if valid_568422 != nil:
    section.add "x-ms-date", valid_568422
  var valid_568423 = header.getOrDefault("Content-Length")
  valid_568423 = validateParameter(valid_568423, JString, required = false,
                                 default = nil)
  if valid_568423 != nil:
    section.add "Content-Length", valid_568423
  var valid_568424 = header.getOrDefault("If-None-Match")
  valid_568424 = validateParameter(valid_568424, JString, required = false,
                                 default = nil)
  if valid_568424 != nil:
    section.add "If-None-Match", valid_568424
  var valid_568425 = header.getOrDefault("If-Modified-Since")
  valid_568425 = validateParameter(valid_568425, JString, required = false,
                                 default = nil)
  if valid_568425 != nil:
    section.add "If-Modified-Since", valid_568425
  var valid_568426 = header.getOrDefault("x-ms-owner")
  valid_568426 = validateParameter(valid_568426, JString, required = false,
                                 default = nil)
  if valid_568426 != nil:
    section.add "x-ms-owner", valid_568426
  var valid_568427 = header.getOrDefault("x-ms-version")
  valid_568427 = validateParameter(valid_568427, JString, required = false,
                                 default = nil)
  if valid_568427 != nil:
    section.add "x-ms-version", valid_568427
  var valid_568428 = header.getOrDefault("x-ms-content-disposition")
  valid_568428 = validateParameter(valid_568428, JString, required = false,
                                 default = nil)
  if valid_568428 != nil:
    section.add "x-ms-content-disposition", valid_568428
  var valid_568429 = header.getOrDefault("x-ms-content-type")
  valid_568429 = validateParameter(valid_568429, JString, required = false,
                                 default = nil)
  if valid_568429 != nil:
    section.add "x-ms-content-type", valid_568429
  var valid_568430 = header.getOrDefault("x-ms-lease-action")
  valid_568430 = validateParameter(valid_568430, JString, required = false,
                                 default = newJString("renew"))
  if valid_568430 != nil:
    section.add "x-ms-lease-action", valid_568430
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   requestBody: JObject
  ##              : Valid only for append operations.  The data to be uploaded and appended to the file.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568432: Call_PathUpdate_568402; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Uploads data to be appended to a file, flushes (writes) previously uploaded data to a file, sets properties for a file or directory, or sets access control for a file or directory. Data can only be appended to a file. This operation supports conditional HTTP requests. For more information, see [Specifying Conditional Headers for Blob Service Operations](https://docs.microsoft.com/en-us/rest/api/storageservices/specifying-conditional-headers-for-blob-service-operations).
  ## 
  let valid = call_568432.validator(path, query, header, formData, body)
  let scheme = call_568432.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568432.url(scheme.get, call_568432.host, call_568432.base,
                         call_568432.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568432, url, valid)

proc call*(call_568433: Call_PathUpdate_568402; path: string; filesystem: string;
          timeout: int = 0; action: string = "append";
          retainUncommittedData: bool = false; requestBody: JsonNode = nil;
          position: int = 0): Recallable =
  ## pathUpdate
  ## Uploads data to be appended to a file, flushes (writes) previously uploaded data to a file, sets properties for a file or directory, or sets access control for a file or directory. Data can only be appended to a file. This operation supports conditional HTTP requests. For more information, see [Specifying Conditional Headers for Blob Service Operations](https://docs.microsoft.com/en-us/rest/api/storageservices/specifying-conditional-headers-for-blob-service-operations).
  ##   timeout: int
  ##          : An optional operation timeout value in seconds. The period begins when the request is received by the service. If the timeout value elapses before the operation completes, the operation fails.
  ##   action: string (required)
  ##         : The action must be "append" to upload data to be appended to a file, "flush" to flush previously uploaded data to a file, "setProperties" to set the properties of a file or directory, or "setAccessControl" to set the owner, group, permissions, or access control list for a file or directory.  Note that Hierarchical Namespace must be enabled for the account in order to use access control.  Also note that the Access Control List (ACL) includes permissions for the owner, owning group, and others, so the x-ms-permissions and x-ms-acl request headers are mutually exclusive.
  ##   path: string (required)
  ##       : The file or directory path.
  ##   retainUncommittedData: bool
  ##                        : Valid only for flush operations.  If "true", uncommitted data is retained after the flush operation completes; otherwise, the uncommitted data is deleted after the flush operation.  The default is false.  Data at offsets less than the specified position are written to the file when flush succeeds, but this optional parameter allows data after the flush position to be retained for a future flush operation.
  ##   requestBody: JObject
  ##              : Valid only for append operations.  The data to be uploaded and appended to the file.
  ##   position: int
  ##           : This parameter allows the caller to upload data in parallel and control the order in which it is appended to the file.  It is required when uploading data to be appended to the file and when flushing previously uploaded data to the file.  The value must be the position where the data is to be appended.  Uploaded data is not immediately flushed, or written, to the file.  To flush, the previously uploaded data must be contiguous, the position parameter must be specified and equal to the length of the file after all data has been written, and there must not be a request entity body included with the request.
  ##   filesystem: string (required)
  ##             : The filesystem identifier.
  var path_568434 = newJObject()
  var query_568435 = newJObject()
  var body_568436 = newJObject()
  add(query_568435, "timeout", newJInt(timeout))
  add(query_568435, "action", newJString(action))
  add(path_568434, "path", newJString(path))
  add(query_568435, "retainUncommittedData", newJBool(retainUncommittedData))
  if requestBody != nil:
    body_568436 = requestBody
  add(query_568435, "position", newJInt(position))
  add(path_568434, "filesystem", newJString(filesystem))
  result = call_568433.call(path_568434, query_568435, nil, nil, body_568436)

var pathUpdate* = Call_PathUpdate_568402(name: "pathUpdate",
                                      meth: HttpMethod.HttpPatch,
                                      host: "azure.local",
                                      route: "/{filesystem}/{path}",
                                      validator: validate_PathUpdate_568403,
                                      base: "", url: url_PathUpdate_568404,
                                      schemes: {Scheme.Https})
type
  Call_PathDelete_568364 = ref object of OpenApiRestCall_567658
proc url_PathDelete_568366(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "filesystem" in path, "`filesystem` is a required path parameter"
  assert "path" in path, "`path` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "filesystem"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "path")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PathDelete_568365(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete the file or directory. This operation supports conditional HTTP requests.  For more information, see [Specifying Conditional Headers for Blob Service Operations](https://docs.microsoft.com/en-us/rest/api/storageservices/specifying-conditional-headers-for-blob-service-operations).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   path: JString (required)
  ##       : The file or directory path.
  ##   filesystem: JString (required)
  ##             : The filesystem identifier.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `path` field"
  var valid_568367 = path.getOrDefault("path")
  valid_568367 = validateParameter(valid_568367, JString, required = true,
                                 default = nil)
  if valid_568367 != nil:
    section.add "path", valid_568367
  var valid_568368 = path.getOrDefault("filesystem")
  valid_568368 = validateParameter(valid_568368, JString, required = true,
                                 default = nil)
  if valid_568368 != nil:
    section.add "filesystem", valid_568368
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : An optional operation timeout value in seconds. The period begins when the request is received by the service. If the timeout value elapses before the operation completes, the operation fails.
  ##   continuation: JString
  ##               : Optional.  When deleting a directory, the number of paths that are deleted with each invocation is limited.  If the number of paths to be deleted exceeds this limit, a continuation token is returned in this response header.  When a continuation token is returned in the response, it must be specified in a subsequent invocation of the delete operation to continue deleting the directory.
  ##   recursive: JBool
  ##            : Required and valid only when the resource is a directory.  If "true", all paths beneath the directory will be deleted. If "false" and the directory is non-empty, an error occurs.
  section = newJObject()
  var valid_568369 = query.getOrDefault("timeout")
  valid_568369 = validateParameter(valid_568369, JInt, required = false, default = nil)
  if valid_568369 != nil:
    section.add "timeout", valid_568369
  var valid_568370 = query.getOrDefault("continuation")
  valid_568370 = validateParameter(valid_568370, JString, required = false,
                                 default = nil)
  if valid_568370 != nil:
    section.add "continuation", valid_568370
  var valid_568371 = query.getOrDefault("recursive")
  valid_568371 = validateParameter(valid_568371, JBool, required = false, default = nil)
  if valid_568371 != nil:
    section.add "recursive", valid_568371
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : Optional.  An ETag value. Specify this header to perform the operation only if the resource's ETag matches the value specified. The ETag must be specified in quotes.
  ##   If-Unmodified-Since: JString
  ##                      : Optional. A date and time value. Specify this header to perform the operation only if the resource has not been modified since the specified date and time.
  ##   x-ms-lease-id: JString
  ##                : The lease ID must be specified if there is an active lease.
  ##   x-ms-client-request-id: JString
  ##                         : A UUID recorded in the analytics logs for troubleshooting and correlation.
  ##   x-ms-date: JString
  ##            : Specifies the Coordinated Universal Time (UTC) for the request.  This is required when using shared key authorization.
  ##   If-None-Match: JString
  ##                : Optional.  An ETag value or the special wildcard ("*") value. Specify this header to perform the operation only if the resource's ETag does not match the value specified. The ETag must be specified in quotes.
  ##   If-Modified-Since: JString
  ##                    : Optional. A date and time value. Specify this header to perform the operation only if the resource has been modified since the specified date and time.
  ##   x-ms-version: JString
  ##               : Specifies the version of the REST protocol used for processing the request. This is required when using shared key authorization.
  section = newJObject()
  var valid_568372 = header.getOrDefault("If-Match")
  valid_568372 = validateParameter(valid_568372, JString, required = false,
                                 default = nil)
  if valid_568372 != nil:
    section.add "If-Match", valid_568372
  var valid_568373 = header.getOrDefault("If-Unmodified-Since")
  valid_568373 = validateParameter(valid_568373, JString, required = false,
                                 default = nil)
  if valid_568373 != nil:
    section.add "If-Unmodified-Since", valid_568373
  var valid_568374 = header.getOrDefault("x-ms-lease-id")
  valid_568374 = validateParameter(valid_568374, JString, required = false,
                                 default = nil)
  if valid_568374 != nil:
    section.add "x-ms-lease-id", valid_568374
  var valid_568375 = header.getOrDefault("x-ms-client-request-id")
  valid_568375 = validateParameter(valid_568375, JString, required = false,
                                 default = nil)
  if valid_568375 != nil:
    section.add "x-ms-client-request-id", valid_568375
  var valid_568376 = header.getOrDefault("x-ms-date")
  valid_568376 = validateParameter(valid_568376, JString, required = false,
                                 default = nil)
  if valid_568376 != nil:
    section.add "x-ms-date", valid_568376
  var valid_568377 = header.getOrDefault("If-None-Match")
  valid_568377 = validateParameter(valid_568377, JString, required = false,
                                 default = nil)
  if valid_568377 != nil:
    section.add "If-None-Match", valid_568377
  var valid_568378 = header.getOrDefault("If-Modified-Since")
  valid_568378 = validateParameter(valid_568378, JString, required = false,
                                 default = nil)
  if valid_568378 != nil:
    section.add "If-Modified-Since", valid_568378
  var valid_568379 = header.getOrDefault("x-ms-version")
  valid_568379 = validateParameter(valid_568379, JString, required = false,
                                 default = nil)
  if valid_568379 != nil:
    section.add "x-ms-version", valid_568379
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568380: Call_PathDelete_568364; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete the file or directory. This operation supports conditional HTTP requests.  For more information, see [Specifying Conditional Headers for Blob Service Operations](https://docs.microsoft.com/en-us/rest/api/storageservices/specifying-conditional-headers-for-blob-service-operations).
  ## 
  let valid = call_568380.validator(path, query, header, formData, body)
  let scheme = call_568380.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568380.url(scheme.get, call_568380.host, call_568380.base,
                         call_568380.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568380, url, valid)

proc call*(call_568381: Call_PathDelete_568364; path: string; filesystem: string;
          timeout: int = 0; continuation: string = ""; recursive: bool = false): Recallable =
  ## pathDelete
  ## Delete the file or directory. This operation supports conditional HTTP requests.  For more information, see [Specifying Conditional Headers for Blob Service Operations](https://docs.microsoft.com/en-us/rest/api/storageservices/specifying-conditional-headers-for-blob-service-operations).
  ##   timeout: int
  ##          : An optional operation timeout value in seconds. The period begins when the request is received by the service. If the timeout value elapses before the operation completes, the operation fails.
  ##   continuation: string
  ##               : Optional.  When deleting a directory, the number of paths that are deleted with each invocation is limited.  If the number of paths to be deleted exceeds this limit, a continuation token is returned in this response header.  When a continuation token is returned in the response, it must be specified in a subsequent invocation of the delete operation to continue deleting the directory.
  ##   path: string (required)
  ##       : The file or directory path.
  ##   filesystem: string (required)
  ##             : The filesystem identifier.
  ##   recursive: bool
  ##            : Required and valid only when the resource is a directory.  If "true", all paths beneath the directory will be deleted. If "false" and the directory is non-empty, an error occurs.
  var path_568382 = newJObject()
  var query_568383 = newJObject()
  add(query_568383, "timeout", newJInt(timeout))
  add(query_568383, "continuation", newJString(continuation))
  add(path_568382, "path", newJString(path))
  add(path_568382, "filesystem", newJString(filesystem))
  add(query_568383, "recursive", newJBool(recursive))
  result = call_568381.call(path_568382, query_568383, nil, nil, nil)

var pathDelete* = Call_PathDelete_568364(name: "pathDelete",
                                      meth: HttpMethod.HttpDelete,
                                      host: "azure.local",
                                      route: "/{filesystem}/{path}",
                                      validator: validate_PathDelete_568365,
                                      base: "", url: url_PathDelete_568366,
                                      schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
