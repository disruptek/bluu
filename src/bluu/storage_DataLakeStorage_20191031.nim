
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: Azure Data Lake Storage
## version: 2019-10-31
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

  OpenApiRestCall_573658 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_573658](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_573658): Option[Scheme] {.used.} =
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
  Call_FilesystemList_573880 = ref object of OpenApiRestCall_573658
proc url_FilesystemList_573882(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_FilesystemList_573881(path: JsonNode; query: JsonNode;
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
  var valid_574041 = query.getOrDefault("timeout")
  valid_574041 = validateParameter(valid_574041, JInt, required = false, default = nil)
  if valid_574041 != nil:
    section.add "timeout", valid_574041
  var valid_574042 = query.getOrDefault("continuation")
  valid_574042 = validateParameter(valid_574042, JString, required = false,
                                 default = nil)
  if valid_574042 != nil:
    section.add "continuation", valid_574042
  assert query != nil,
        "query argument is necessary due to required `resource` field"
  var valid_574056 = query.getOrDefault("resource")
  valid_574056 = validateParameter(valid_574056, JString, required = true,
                                 default = newJString("account"))
  if valid_574056 != nil:
    section.add "resource", valid_574056
  var valid_574057 = query.getOrDefault("maxResults")
  valid_574057 = validateParameter(valid_574057, JInt, required = false, default = nil)
  if valid_574057 != nil:
    section.add "maxResults", valid_574057
  var valid_574058 = query.getOrDefault("prefix")
  valid_574058 = validateParameter(valid_574058, JString, required = false,
                                 default = nil)
  if valid_574058 != nil:
    section.add "prefix", valid_574058
  result.add "query", section
  ## parameters in `header` object:
  ##   x-ms-client-request-id: JString
  ##                         : A UUID recorded in the analytics logs for troubleshooting and correlation.
  ##   x-ms-date: JString
  ##            : Specifies the Coordinated Universal Time (UTC) for the request.  This is required when using shared key authorization.
  ##   x-ms-version: JString
  ##               : Specifies the version of the REST protocol used for processing the request. This is required when using shared key authorization.
  section = newJObject()
  var valid_574059 = header.getOrDefault("x-ms-client-request-id")
  valid_574059 = validateParameter(valid_574059, JString, required = false,
                                 default = nil)
  if valid_574059 != nil:
    section.add "x-ms-client-request-id", valid_574059
  var valid_574060 = header.getOrDefault("x-ms-date")
  valid_574060 = validateParameter(valid_574060, JString, required = false,
                                 default = nil)
  if valid_574060 != nil:
    section.add "x-ms-date", valid_574060
  var valid_574061 = header.getOrDefault("x-ms-version")
  valid_574061 = validateParameter(valid_574061, JString, required = false,
                                 default = nil)
  if valid_574061 != nil:
    section.add "x-ms-version", valid_574061
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574084: Call_FilesystemList_573880; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List filesystems and their properties in given account.
  ## 
  let valid = call_574084.validator(path, query, header, formData, body)
  let scheme = call_574084.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574084.url(scheme.get, call_574084.host, call_574084.base,
                         call_574084.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574084, url, valid)

proc call*(call_574155: Call_FilesystemList_573880; timeout: int = 0;
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
  var query_574156 = newJObject()
  add(query_574156, "timeout", newJInt(timeout))
  add(query_574156, "continuation", newJString(continuation))
  add(query_574156, "resource", newJString(resource))
  add(query_574156, "maxResults", newJInt(maxResults))
  add(query_574156, "prefix", newJString(prefix))
  result = call_574155.call(nil, query_574156, nil, nil, nil)

var filesystemList* = Call_FilesystemList_573880(name: "filesystemList",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/",
    validator: validate_FilesystemList_573881, base: "", url: url_FilesystemList_573882,
    schemes: {Scheme.Https})
type
  Call_FilesystemCreate_574228 = ref object of OpenApiRestCall_573658
proc url_FilesystemCreate_574230(protocol: Scheme; host: string; base: string;
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

proc validate_FilesystemCreate_574229(path: JsonNode; query: JsonNode;
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
  var valid_574231 = path.getOrDefault("filesystem")
  valid_574231 = validateParameter(valid_574231, JString, required = true,
                                 default = nil)
  if valid_574231 != nil:
    section.add "filesystem", valid_574231
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : An optional operation timeout value in seconds. The period begins when the request is received by the service. If the timeout value elapses before the operation completes, the operation fails.
  ##   resource: JString (required)
  ##           : The value must be "filesystem" for all filesystem operations.
  section = newJObject()
  var valid_574232 = query.getOrDefault("timeout")
  valid_574232 = validateParameter(valid_574232, JInt, required = false, default = nil)
  if valid_574232 != nil:
    section.add "timeout", valid_574232
  assert query != nil,
        "query argument is necessary due to required `resource` field"
  var valid_574233 = query.getOrDefault("resource")
  valid_574233 = validateParameter(valid_574233, JString, required = true,
                                 default = newJString("filesystem"))
  if valid_574233 != nil:
    section.add "resource", valid_574233
  result.add "query", section
  ## parameters in `header` object:
  ##   x-ms-properties: JString
  ##                  : User-defined properties to be stored with the filesystem, in the format of a comma-separated list of name and value pairs "n1=v1, n2=v2, ...", where each value is a base64 encoded string. Note that the string may only contain ASCII characters in the ISO-8859-1 character set.
  ##   x-ms-client-request-id: JString
  ##                         : A UUID recorded in the analytics logs for troubleshooting and correlation.
  ##   x-ms-date: JString
  ##            : Specifies the Coordinated Universal Time (UTC) for the request.  This is required when using shared key authorization.
  ##   x-ms-version: JString
  ##               : Specifies the version of the REST protocol used for processing the request. This is required when using shared key authorization.
  section = newJObject()
  var valid_574234 = header.getOrDefault("x-ms-properties")
  valid_574234 = validateParameter(valid_574234, JString, required = false,
                                 default = nil)
  if valid_574234 != nil:
    section.add "x-ms-properties", valid_574234
  var valid_574235 = header.getOrDefault("x-ms-client-request-id")
  valid_574235 = validateParameter(valid_574235, JString, required = false,
                                 default = nil)
  if valid_574235 != nil:
    section.add "x-ms-client-request-id", valid_574235
  var valid_574236 = header.getOrDefault("x-ms-date")
  valid_574236 = validateParameter(valid_574236, JString, required = false,
                                 default = nil)
  if valid_574236 != nil:
    section.add "x-ms-date", valid_574236
  var valid_574237 = header.getOrDefault("x-ms-version")
  valid_574237 = validateParameter(valid_574237, JString, required = false,
                                 default = nil)
  if valid_574237 != nil:
    section.add "x-ms-version", valid_574237
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574238: Call_FilesystemCreate_574228; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a filesystem rooted at the specified location. If the filesystem already exists, the operation fails.  This operation does not support conditional HTTP requests.
  ## 
  let valid = call_574238.validator(path, query, header, formData, body)
  let scheme = call_574238.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574238.url(scheme.get, call_574238.host, call_574238.base,
                         call_574238.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574238, url, valid)

proc call*(call_574239: Call_FilesystemCreate_574228; filesystem: string;
          timeout: int = 0; resource: string = "filesystem"): Recallable =
  ## filesystemCreate
  ## Create a filesystem rooted at the specified location. If the filesystem already exists, the operation fails.  This operation does not support conditional HTTP requests.
  ##   timeout: int
  ##          : An optional operation timeout value in seconds. The period begins when the request is received by the service. If the timeout value elapses before the operation completes, the operation fails.
  ##   resource: string (required)
  ##           : The value must be "filesystem" for all filesystem operations.
  ##   filesystem: string (required)
  ##             : The filesystem identifier.  The value must start and end with a letter or number and must contain only letters, numbers, and the dash (-) character.  Consecutive dashes are not permitted.  All letters must be lowercase.  The value must have between 3 and 63 characters.
  var path_574240 = newJObject()
  var query_574241 = newJObject()
  add(query_574241, "timeout", newJInt(timeout))
  add(query_574241, "resource", newJString(resource))
  add(path_574240, "filesystem", newJString(filesystem))
  result = call_574239.call(path_574240, query_574241, nil, nil, nil)

var filesystemCreate* = Call_FilesystemCreate_574228(name: "filesystemCreate",
    meth: HttpMethod.HttpPut, host: "azure.local", route: "/{filesystem}",
    validator: validate_FilesystemCreate_574229, base: "",
    url: url_FilesystemCreate_574230, schemes: {Scheme.Https})
type
  Call_FilesystemGetProperties_574257 = ref object of OpenApiRestCall_573658
proc url_FilesystemGetProperties_574259(protocol: Scheme; host: string; base: string;
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

proc validate_FilesystemGetProperties_574258(path: JsonNode; query: JsonNode;
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
  var valid_574260 = path.getOrDefault("filesystem")
  valid_574260 = validateParameter(valid_574260, JString, required = true,
                                 default = nil)
  if valid_574260 != nil:
    section.add "filesystem", valid_574260
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : An optional operation timeout value in seconds. The period begins when the request is received by the service. If the timeout value elapses before the operation completes, the operation fails.
  ##   resource: JString (required)
  ##           : The value must be "filesystem" for all filesystem operations.
  section = newJObject()
  var valid_574261 = query.getOrDefault("timeout")
  valid_574261 = validateParameter(valid_574261, JInt, required = false, default = nil)
  if valid_574261 != nil:
    section.add "timeout", valid_574261
  assert query != nil,
        "query argument is necessary due to required `resource` field"
  var valid_574262 = query.getOrDefault("resource")
  valid_574262 = validateParameter(valid_574262, JString, required = true,
                                 default = newJString("filesystem"))
  if valid_574262 != nil:
    section.add "resource", valid_574262
  result.add "query", section
  ## parameters in `header` object:
  ##   x-ms-client-request-id: JString
  ##                         : A UUID recorded in the analytics logs for troubleshooting and correlation.
  ##   x-ms-date: JString
  ##            : Specifies the Coordinated Universal Time (UTC) for the request.  This is required when using shared key authorization.
  ##   x-ms-version: JString
  ##               : Specifies the version of the REST protocol used for processing the request. This is required when using shared key authorization.
  section = newJObject()
  var valid_574263 = header.getOrDefault("x-ms-client-request-id")
  valid_574263 = validateParameter(valid_574263, JString, required = false,
                                 default = nil)
  if valid_574263 != nil:
    section.add "x-ms-client-request-id", valid_574263
  var valid_574264 = header.getOrDefault("x-ms-date")
  valid_574264 = validateParameter(valid_574264, JString, required = false,
                                 default = nil)
  if valid_574264 != nil:
    section.add "x-ms-date", valid_574264
  var valid_574265 = header.getOrDefault("x-ms-version")
  valid_574265 = validateParameter(valid_574265, JString, required = false,
                                 default = nil)
  if valid_574265 != nil:
    section.add "x-ms-version", valid_574265
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574266: Call_FilesystemGetProperties_574257; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## All system and user-defined filesystem properties are specified in the response headers.
  ## 
  let valid = call_574266.validator(path, query, header, formData, body)
  let scheme = call_574266.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574266.url(scheme.get, call_574266.host, call_574266.base,
                         call_574266.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574266, url, valid)

proc call*(call_574267: Call_FilesystemGetProperties_574257; filesystem: string;
          timeout: int = 0; resource: string = "filesystem"): Recallable =
  ## filesystemGetProperties
  ## All system and user-defined filesystem properties are specified in the response headers.
  ##   timeout: int
  ##          : An optional operation timeout value in seconds. The period begins when the request is received by the service. If the timeout value elapses before the operation completes, the operation fails.
  ##   resource: string (required)
  ##           : The value must be "filesystem" for all filesystem operations.
  ##   filesystem: string (required)
  ##             : The filesystem identifier.  The value must start and end with a letter or number and must contain only letters, numbers, and the dash (-) character.  Consecutive dashes are not permitted.  All letters must be lowercase.  The value must have between 3 and 63 characters.
  var path_574268 = newJObject()
  var query_574269 = newJObject()
  add(query_574269, "timeout", newJInt(timeout))
  add(query_574269, "resource", newJString(resource))
  add(path_574268, "filesystem", newJString(filesystem))
  result = call_574267.call(path_574268, query_574269, nil, nil, nil)

var filesystemGetProperties* = Call_FilesystemGetProperties_574257(
    name: "filesystemGetProperties", meth: HttpMethod.HttpHead, host: "azure.local",
    route: "/{filesystem}", validator: validate_FilesystemGetProperties_574258,
    base: "", url: url_FilesystemGetProperties_574259, schemes: {Scheme.Https})
type
  Call_PathList_574196 = ref object of OpenApiRestCall_573658
proc url_PathList_574198(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_PathList_574197(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_574213 = path.getOrDefault("filesystem")
  valid_574213 = validateParameter(valid_574213, JString, required = true,
                                 default = nil)
  if valid_574213 != nil:
    section.add "filesystem", valid_574213
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : An optional operation timeout value in seconds. The period begins when the request is received by the service. If the timeout value elapses before the operation completes, the operation fails.
  ##   continuation: JString
  ##               : The number of paths returned with each invocation is limited. If the number of paths to be returned exceeds this limit, a continuation token is returned in the response header x-ms-continuation. When a continuation token is  returned in the response, it must be specified in a subsequent invocation of the list operation to continue listing the paths.
  ##   upn: JBool
  ##      : Optional. Valid only when Hierarchical Namespace is enabled for the account. If "true", the user identity values returned in the owner and group fields of each list entry will be transformed from Azure Active Directory Object IDs to User Principal Names.  If "false", the values will be returned as Azure Active Directory Object IDs. The default value is false. Note that group and application Object IDs are not translated because they do not have unique friendly names.
  ##   resource: JString (required)
  ##           : The value must be "filesystem" for all filesystem operations.
  ##   directory: JString
  ##            : Filters results to paths within the specified directory. An error occurs if the directory does not exist.
  ##   maxResults: JInt
  ##             : An optional value that specifies the maximum number of items to return. If omitted or greater than 5,000, the response will include up to 5,000 items.
  ##   recursive: JBool (required)
  ##            : If "true", all paths are listed; otherwise, only paths at the root of the filesystem are listed.  If "directory" is specified, the list will only include paths that share the same root.
  section = newJObject()
  var valid_574214 = query.getOrDefault("timeout")
  valid_574214 = validateParameter(valid_574214, JInt, required = false, default = nil)
  if valid_574214 != nil:
    section.add "timeout", valid_574214
  var valid_574215 = query.getOrDefault("continuation")
  valid_574215 = validateParameter(valid_574215, JString, required = false,
                                 default = nil)
  if valid_574215 != nil:
    section.add "continuation", valid_574215
  var valid_574216 = query.getOrDefault("upn")
  valid_574216 = validateParameter(valid_574216, JBool, required = false, default = nil)
  if valid_574216 != nil:
    section.add "upn", valid_574216
  assert query != nil,
        "query argument is necessary due to required `resource` field"
  var valid_574217 = query.getOrDefault("resource")
  valid_574217 = validateParameter(valid_574217, JString, required = true,
                                 default = newJString("filesystem"))
  if valid_574217 != nil:
    section.add "resource", valid_574217
  var valid_574218 = query.getOrDefault("directory")
  valid_574218 = validateParameter(valid_574218, JString, required = false,
                                 default = nil)
  if valid_574218 != nil:
    section.add "directory", valid_574218
  var valid_574219 = query.getOrDefault("maxResults")
  valid_574219 = validateParameter(valid_574219, JInt, required = false, default = nil)
  if valid_574219 != nil:
    section.add "maxResults", valid_574219
  var valid_574220 = query.getOrDefault("recursive")
  valid_574220 = validateParameter(valid_574220, JBool, required = true, default = nil)
  if valid_574220 != nil:
    section.add "recursive", valid_574220
  result.add "query", section
  ## parameters in `header` object:
  ##   x-ms-client-request-id: JString
  ##                         : A UUID recorded in the analytics logs for troubleshooting and correlation.
  ##   x-ms-date: JString
  ##            : Specifies the Coordinated Universal Time (UTC) for the request.  This is required when using shared key authorization.
  ##   x-ms-version: JString
  ##               : Specifies the version of the REST protocol used for processing the request. This is required when using shared key authorization.
  section = newJObject()
  var valid_574221 = header.getOrDefault("x-ms-client-request-id")
  valid_574221 = validateParameter(valid_574221, JString, required = false,
                                 default = nil)
  if valid_574221 != nil:
    section.add "x-ms-client-request-id", valid_574221
  var valid_574222 = header.getOrDefault("x-ms-date")
  valid_574222 = validateParameter(valid_574222, JString, required = false,
                                 default = nil)
  if valid_574222 != nil:
    section.add "x-ms-date", valid_574222
  var valid_574223 = header.getOrDefault("x-ms-version")
  valid_574223 = validateParameter(valid_574223, JString, required = false,
                                 default = nil)
  if valid_574223 != nil:
    section.add "x-ms-version", valid_574223
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574224: Call_PathList_574196; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List filesystem paths and their properties.
  ## 
  let valid = call_574224.validator(path, query, header, formData, body)
  let scheme = call_574224.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574224.url(scheme.get, call_574224.host, call_574224.base,
                         call_574224.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574224, url, valid)

proc call*(call_574225: Call_PathList_574196; filesystem: string; recursive: bool;
          timeout: int = 0; continuation: string = ""; upn: bool = false;
          resource: string = "filesystem"; directory: string = ""; maxResults: int = 0): Recallable =
  ## pathList
  ## List filesystem paths and their properties.
  ##   timeout: int
  ##          : An optional operation timeout value in seconds. The period begins when the request is received by the service. If the timeout value elapses before the operation completes, the operation fails.
  ##   continuation: string
  ##               : The number of paths returned with each invocation is limited. If the number of paths to be returned exceeds this limit, a continuation token is returned in the response header x-ms-continuation. When a continuation token is  returned in the response, it must be specified in a subsequent invocation of the list operation to continue listing the paths.
  ##   upn: bool
  ##      : Optional. Valid only when Hierarchical Namespace is enabled for the account. If "true", the user identity values returned in the owner and group fields of each list entry will be transformed from Azure Active Directory Object IDs to User Principal Names.  If "false", the values will be returned as Azure Active Directory Object IDs. The default value is false. Note that group and application Object IDs are not translated because they do not have unique friendly names.
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
  var path_574226 = newJObject()
  var query_574227 = newJObject()
  add(query_574227, "timeout", newJInt(timeout))
  add(query_574227, "continuation", newJString(continuation))
  add(query_574227, "upn", newJBool(upn))
  add(query_574227, "resource", newJString(resource))
  add(query_574227, "directory", newJString(directory))
  add(query_574227, "maxResults", newJInt(maxResults))
  add(path_574226, "filesystem", newJString(filesystem))
  add(query_574227, "recursive", newJBool(recursive))
  result = call_574225.call(path_574226, query_574227, nil, nil, nil)

var pathList* = Call_PathList_574196(name: "pathList", meth: HttpMethod.HttpGet,
                                  host: "azure.local", route: "/{filesystem}",
                                  validator: validate_PathList_574197, base: "",
                                  url: url_PathList_574198,
                                  schemes: {Scheme.Https})
type
  Call_FilesystemSetProperties_574270 = ref object of OpenApiRestCall_573658
proc url_FilesystemSetProperties_574272(protocol: Scheme; host: string; base: string;
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

proc validate_FilesystemSetProperties_574271(path: JsonNode; query: JsonNode;
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
  var valid_574273 = path.getOrDefault("filesystem")
  valid_574273 = validateParameter(valid_574273, JString, required = true,
                                 default = nil)
  if valid_574273 != nil:
    section.add "filesystem", valid_574273
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : An optional operation timeout value in seconds. The period begins when the request is received by the service. If the timeout value elapses before the operation completes, the operation fails.
  ##   resource: JString (required)
  ##           : The value must be "filesystem" for all filesystem operations.
  section = newJObject()
  var valid_574274 = query.getOrDefault("timeout")
  valid_574274 = validateParameter(valid_574274, JInt, required = false, default = nil)
  if valid_574274 != nil:
    section.add "timeout", valid_574274
  assert query != nil,
        "query argument is necessary due to required `resource` field"
  var valid_574275 = query.getOrDefault("resource")
  valid_574275 = validateParameter(valid_574275, JString, required = true,
                                 default = newJString("filesystem"))
  if valid_574275 != nil:
    section.add "resource", valid_574275
  result.add "query", section
  ## parameters in `header` object:
  ##   x-ms-properties: JString
  ##                  : Optional. User-defined properties to be stored with the filesystem, in the format of a comma-separated list of name and value pairs "n1=v1, n2=v2, ...", where each value is a base64 encoded string. Note that the string may only contain ASCII characters in the ISO-8859-1 character set.  If the filesystem exists, any properties not included in the list will be removed.  All properties are removed if the header is omitted.  To merge new and existing properties, first get all existing properties and the current E-Tag, then make a conditional request with the E-Tag and include values for all properties.
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
  var valid_574276 = header.getOrDefault("x-ms-properties")
  valid_574276 = validateParameter(valid_574276, JString, required = false,
                                 default = nil)
  if valid_574276 != nil:
    section.add "x-ms-properties", valid_574276
  var valid_574277 = header.getOrDefault("If-Unmodified-Since")
  valid_574277 = validateParameter(valid_574277, JString, required = false,
                                 default = nil)
  if valid_574277 != nil:
    section.add "If-Unmodified-Since", valid_574277
  var valid_574278 = header.getOrDefault("x-ms-client-request-id")
  valid_574278 = validateParameter(valid_574278, JString, required = false,
                                 default = nil)
  if valid_574278 != nil:
    section.add "x-ms-client-request-id", valid_574278
  var valid_574279 = header.getOrDefault("x-ms-date")
  valid_574279 = validateParameter(valid_574279, JString, required = false,
                                 default = nil)
  if valid_574279 != nil:
    section.add "x-ms-date", valid_574279
  var valid_574280 = header.getOrDefault("If-Modified-Since")
  valid_574280 = validateParameter(valid_574280, JString, required = false,
                                 default = nil)
  if valid_574280 != nil:
    section.add "If-Modified-Since", valid_574280
  var valid_574281 = header.getOrDefault("x-ms-version")
  valid_574281 = validateParameter(valid_574281, JString, required = false,
                                 default = nil)
  if valid_574281 != nil:
    section.add "x-ms-version", valid_574281
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574282: Call_FilesystemSetProperties_574270; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Set properties for the filesystem.  This operation supports conditional HTTP requests.  For more information, see [Specifying Conditional Headers for Blob Service Operations](https://docs.microsoft.com/en-us/rest/api/storageservices/specifying-conditional-headers-for-blob-service-operations).
  ## 
  let valid = call_574282.validator(path, query, header, formData, body)
  let scheme = call_574282.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574282.url(scheme.get, call_574282.host, call_574282.base,
                         call_574282.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574282, url, valid)

proc call*(call_574283: Call_FilesystemSetProperties_574270; filesystem: string;
          timeout: int = 0; resource: string = "filesystem"): Recallable =
  ## filesystemSetProperties
  ## Set properties for the filesystem.  This operation supports conditional HTTP requests.  For more information, see [Specifying Conditional Headers for Blob Service Operations](https://docs.microsoft.com/en-us/rest/api/storageservices/specifying-conditional-headers-for-blob-service-operations).
  ##   timeout: int
  ##          : An optional operation timeout value in seconds. The period begins when the request is received by the service. If the timeout value elapses before the operation completes, the operation fails.
  ##   resource: string (required)
  ##           : The value must be "filesystem" for all filesystem operations.
  ##   filesystem: string (required)
  ##             : The filesystem identifier.  The value must start and end with a letter or number and must contain only letters, numbers, and the dash (-) character.  Consecutive dashes are not permitted.  All letters must be lowercase.  The value must have between 3 and 63 characters.
  var path_574284 = newJObject()
  var query_574285 = newJObject()
  add(query_574285, "timeout", newJInt(timeout))
  add(query_574285, "resource", newJString(resource))
  add(path_574284, "filesystem", newJString(filesystem))
  result = call_574283.call(path_574284, query_574285, nil, nil, nil)

var filesystemSetProperties* = Call_FilesystemSetProperties_574270(
    name: "filesystemSetProperties", meth: HttpMethod.HttpPatch,
    host: "azure.local", route: "/{filesystem}",
    validator: validate_FilesystemSetProperties_574271, base: "",
    url: url_FilesystemSetProperties_574272, schemes: {Scheme.Https})
type
  Call_FilesystemDelete_574242 = ref object of OpenApiRestCall_573658
proc url_FilesystemDelete_574244(protocol: Scheme; host: string; base: string;
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

proc validate_FilesystemDelete_574243(path: JsonNode; query: JsonNode;
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
  var valid_574245 = path.getOrDefault("filesystem")
  valid_574245 = validateParameter(valid_574245, JString, required = true,
                                 default = nil)
  if valid_574245 != nil:
    section.add "filesystem", valid_574245
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : An optional operation timeout value in seconds. The period begins when the request is received by the service. If the timeout value elapses before the operation completes, the operation fails.
  ##   resource: JString (required)
  ##           : The value must be "filesystem" for all filesystem operations.
  section = newJObject()
  var valid_574246 = query.getOrDefault("timeout")
  valid_574246 = validateParameter(valid_574246, JInt, required = false, default = nil)
  if valid_574246 != nil:
    section.add "timeout", valid_574246
  assert query != nil,
        "query argument is necessary due to required `resource` field"
  var valid_574247 = query.getOrDefault("resource")
  valid_574247 = validateParameter(valid_574247, JString, required = true,
                                 default = newJString("filesystem"))
  if valid_574247 != nil:
    section.add "resource", valid_574247
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
  var valid_574248 = header.getOrDefault("If-Unmodified-Since")
  valid_574248 = validateParameter(valid_574248, JString, required = false,
                                 default = nil)
  if valid_574248 != nil:
    section.add "If-Unmodified-Since", valid_574248
  var valid_574249 = header.getOrDefault("x-ms-client-request-id")
  valid_574249 = validateParameter(valid_574249, JString, required = false,
                                 default = nil)
  if valid_574249 != nil:
    section.add "x-ms-client-request-id", valid_574249
  var valid_574250 = header.getOrDefault("x-ms-date")
  valid_574250 = validateParameter(valid_574250, JString, required = false,
                                 default = nil)
  if valid_574250 != nil:
    section.add "x-ms-date", valid_574250
  var valid_574251 = header.getOrDefault("If-Modified-Since")
  valid_574251 = validateParameter(valid_574251, JString, required = false,
                                 default = nil)
  if valid_574251 != nil:
    section.add "If-Modified-Since", valid_574251
  var valid_574252 = header.getOrDefault("x-ms-version")
  valid_574252 = validateParameter(valid_574252, JString, required = false,
                                 default = nil)
  if valid_574252 != nil:
    section.add "x-ms-version", valid_574252
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574253: Call_FilesystemDelete_574242; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Marks the filesystem for deletion.  When a filesystem is deleted, a filesystem with the same identifier cannot be created for at least 30 seconds. While the filesystem is being deleted, attempts to create a filesystem with the same identifier will fail with status code 409 (Conflict), with the service returning additional error information indicating that the filesystem is being deleted. All other operations, including operations on any files or directories within the filesystem, will fail with status code 404 (Not Found) while the filesystem is being deleted. This operation supports conditional HTTP requests.  For more information, see [Specifying Conditional Headers for Blob Service Operations](https://docs.microsoft.com/en-us/rest/api/storageservices/specifying-conditional-headers-for-blob-service-operations).
  ## 
  let valid = call_574253.validator(path, query, header, formData, body)
  let scheme = call_574253.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574253.url(scheme.get, call_574253.host, call_574253.base,
                         call_574253.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574253, url, valid)

proc call*(call_574254: Call_FilesystemDelete_574242; filesystem: string;
          timeout: int = 0; resource: string = "filesystem"): Recallable =
  ## filesystemDelete
  ## Marks the filesystem for deletion.  When a filesystem is deleted, a filesystem with the same identifier cannot be created for at least 30 seconds. While the filesystem is being deleted, attempts to create a filesystem with the same identifier will fail with status code 409 (Conflict), with the service returning additional error information indicating that the filesystem is being deleted. All other operations, including operations on any files or directories within the filesystem, will fail with status code 404 (Not Found) while the filesystem is being deleted. This operation supports conditional HTTP requests.  For more information, see [Specifying Conditional Headers for Blob Service Operations](https://docs.microsoft.com/en-us/rest/api/storageservices/specifying-conditional-headers-for-blob-service-operations).
  ##   timeout: int
  ##          : An optional operation timeout value in seconds. The period begins when the request is received by the service. If the timeout value elapses before the operation completes, the operation fails.
  ##   resource: string (required)
  ##           : The value must be "filesystem" for all filesystem operations.
  ##   filesystem: string (required)
  ##             : The filesystem identifier.  The value must start and end with a letter or number and must contain only letters, numbers, and the dash (-) character.  Consecutive dashes are not permitted.  All letters must be lowercase.  The value must have between 3 and 63 characters.
  var path_574255 = newJObject()
  var query_574256 = newJObject()
  add(query_574256, "timeout", newJInt(timeout))
  add(query_574256, "resource", newJString(resource))
  add(path_574255, "filesystem", newJString(filesystem))
  result = call_574254.call(path_574255, query_574256, nil, nil, nil)

var filesystemDelete* = Call_FilesystemDelete_574242(name: "filesystemDelete",
    meth: HttpMethod.HttpDelete, host: "azure.local", route: "/{filesystem}",
    validator: validate_FilesystemDelete_574243, base: "",
    url: url_FilesystemDelete_574244, schemes: {Scheme.Https})
type
  Call_PathCreate_574306 = ref object of OpenApiRestCall_573658
proc url_PathCreate_574308(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_PathCreate_574307(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_574309 = path.getOrDefault("path")
  valid_574309 = validateParameter(valid_574309, JString, required = true,
                                 default = nil)
  if valid_574309 != nil:
    section.add "path", valid_574309
  var valid_574310 = path.getOrDefault("filesystem")
  valid_574310 = validateParameter(valid_574310, JString, required = true,
                                 default = nil)
  if valid_574310 != nil:
    section.add "filesystem", valid_574310
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
  var valid_574311 = query.getOrDefault("timeout")
  valid_574311 = validateParameter(valid_574311, JInt, required = false, default = nil)
  if valid_574311 != nil:
    section.add "timeout", valid_574311
  var valid_574312 = query.getOrDefault("continuation")
  valid_574312 = validateParameter(valid_574312, JString, required = false,
                                 default = nil)
  if valid_574312 != nil:
    section.add "continuation", valid_574312
  var valid_574313 = query.getOrDefault("resource")
  valid_574313 = validateParameter(valid_574313, JString, required = false,
                                 default = newJString("directory"))
  if valid_574313 != nil:
    section.add "resource", valid_574313
  var valid_574314 = query.getOrDefault("mode")
  valid_574314 = validateParameter(valid_574314, JString, required = false,
                                 default = newJString("legacy"))
  if valid_574314 != nil:
    section.add "mode", valid_574314
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
  ##                  : Optional.  User-defined properties to be stored with the file or directory, in the format of a comma-separated list of name and value pairs "n1=v1, n2=v2, ...", where each value is a base64 encoded string. Note that the string may only contain ASCII characters in the ISO-8859-1 character set.
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
  ##   If-None-Match: JString
  ##                : Optional.  An ETag value or the special wildcard ("*") value. Specify this header to perform the operation only if the resource's ETag does not match the value specified. The ETag must be specified in quotes.
  ##   If-Modified-Since: JString
  ##                    : Optional. A date and time value. Specify this header to perform the operation only if the resource has been modified since the specified date and time.
  ##   x-ms-umask: JString
  ##             : Optional and only valid if Hierarchical Namespace is enabled for the account. When creating a file or directory and the parent folder does not have a default ACL, the umask restricts the permissions of the file or directory to be created.  The resulting permission is given by p & ^u, where p is the permission and u is the umask.  For example, if p is 0777 and u is 0057, then the resulting permission is 0720.  The default permission is 0777 for a directory and 0666 for a file.  The default umask is 0027.  The umask must be specified in 4-digit octal notation (e.g. 0766).
  ##   x-ms-version: JString
  ##               : Specifies the version of the REST protocol used for processing the request. This is required when using shared key authorization.
  ##   x-ms-rename-source: JString
  ##                     : An optional file or directory to be renamed.  The value must have the following format: "/{filesystem}/{path}".  If "x-ms-properties" is specified, the properties will overwrite the existing properties; otherwise, the existing properties will be preserved. This value must be a URL percent-encoded string. Note that the string may only contain ASCII characters in the ISO-8859-1 character set.
  ##   x-ms-content-disposition: JString
  ##                           : Optional.  The service stores this value and includes it in the "Content-Disposition" response header for "Read File" operations.
  ##   x-ms-content-type: JString
  ##                    : Optional.  The service stores this value and includes it in the "Content-Type" response header for "Read File" operations.
  ##   x-ms-source-if-modified-since: JString
  ##                                : Optional. A date and time value. Specify this header to perform the rename operation only if the source has been modified since the specified date and time.
  ##   Content-Encoding: JString
  ##                   : Optional.  Specifies which content encodings have been applied to the file. This value is returned to the client when the "Read File" operation is performed.
  section = newJObject()
  var valid_574315 = header.getOrDefault("Content-Disposition")
  valid_574315 = validateParameter(valid_574315, JString, required = false,
                                 default = nil)
  if valid_574315 != nil:
    section.add "Content-Disposition", valid_574315
  var valid_574316 = header.getOrDefault("x-ms-permissions")
  valid_574316 = validateParameter(valid_574316, JString, required = false,
                                 default = nil)
  if valid_574316 != nil:
    section.add "x-ms-permissions", valid_574316
  var valid_574317 = header.getOrDefault("x-ms-source-lease-id")
  valid_574317 = validateParameter(valid_574317, JString, required = false,
                                 default = nil)
  if valid_574317 != nil:
    section.add "x-ms-source-lease-id", valid_574317
  var valid_574318 = header.getOrDefault("If-Match")
  valid_574318 = validateParameter(valid_574318, JString, required = false,
                                 default = nil)
  if valid_574318 != nil:
    section.add "If-Match", valid_574318
  var valid_574319 = header.getOrDefault("x-ms-source-if-unmodified-since")
  valid_574319 = validateParameter(valid_574319, JString, required = false,
                                 default = nil)
  if valid_574319 != nil:
    section.add "x-ms-source-if-unmodified-since", valid_574319
  var valid_574320 = header.getOrDefault("x-ms-properties")
  valid_574320 = validateParameter(valid_574320, JString, required = false,
                                 default = nil)
  if valid_574320 != nil:
    section.add "x-ms-properties", valid_574320
  var valid_574321 = header.getOrDefault("Cache-Control")
  valid_574321 = validateParameter(valid_574321, JString, required = false,
                                 default = nil)
  if valid_574321 != nil:
    section.add "Cache-Control", valid_574321
  var valid_574322 = header.getOrDefault("Content-Language")
  valid_574322 = validateParameter(valid_574322, JString, required = false,
                                 default = nil)
  if valid_574322 != nil:
    section.add "Content-Language", valid_574322
  var valid_574323 = header.getOrDefault("x-ms-source-if-match")
  valid_574323 = validateParameter(valid_574323, JString, required = false,
                                 default = nil)
  if valid_574323 != nil:
    section.add "x-ms-source-if-match", valid_574323
  var valid_574324 = header.getOrDefault("x-ms-content-language")
  valid_574324 = validateParameter(valid_574324, JString, required = false,
                                 default = nil)
  if valid_574324 != nil:
    section.add "x-ms-content-language", valid_574324
  var valid_574325 = header.getOrDefault("If-Unmodified-Since")
  valid_574325 = validateParameter(valid_574325, JString, required = false,
                                 default = nil)
  if valid_574325 != nil:
    section.add "If-Unmodified-Since", valid_574325
  var valid_574326 = header.getOrDefault("x-ms-lease-id")
  valid_574326 = validateParameter(valid_574326, JString, required = false,
                                 default = nil)
  if valid_574326 != nil:
    section.add "x-ms-lease-id", valid_574326
  var valid_574327 = header.getOrDefault("x-ms-content-encoding")
  valid_574327 = validateParameter(valid_574327, JString, required = false,
                                 default = nil)
  if valid_574327 != nil:
    section.add "x-ms-content-encoding", valid_574327
  var valid_574328 = header.getOrDefault("x-ms-cache-control")
  valid_574328 = validateParameter(valid_574328, JString, required = false,
                                 default = nil)
  if valid_574328 != nil:
    section.add "x-ms-cache-control", valid_574328
  var valid_574329 = header.getOrDefault("x-ms-client-request-id")
  valid_574329 = validateParameter(valid_574329, JString, required = false,
                                 default = nil)
  if valid_574329 != nil:
    section.add "x-ms-client-request-id", valid_574329
  var valid_574330 = header.getOrDefault("x-ms-source-if-none-match")
  valid_574330 = validateParameter(valid_574330, JString, required = false,
                                 default = nil)
  if valid_574330 != nil:
    section.add "x-ms-source-if-none-match", valid_574330
  var valid_574331 = header.getOrDefault("x-ms-date")
  valid_574331 = validateParameter(valid_574331, JString, required = false,
                                 default = nil)
  if valid_574331 != nil:
    section.add "x-ms-date", valid_574331
  var valid_574332 = header.getOrDefault("If-None-Match")
  valid_574332 = validateParameter(valid_574332, JString, required = false,
                                 default = nil)
  if valid_574332 != nil:
    section.add "If-None-Match", valid_574332
  var valid_574333 = header.getOrDefault("If-Modified-Since")
  valid_574333 = validateParameter(valid_574333, JString, required = false,
                                 default = nil)
  if valid_574333 != nil:
    section.add "If-Modified-Since", valid_574333
  var valid_574334 = header.getOrDefault("x-ms-umask")
  valid_574334 = validateParameter(valid_574334, JString, required = false,
                                 default = nil)
  if valid_574334 != nil:
    section.add "x-ms-umask", valid_574334
  var valid_574335 = header.getOrDefault("x-ms-version")
  valid_574335 = validateParameter(valid_574335, JString, required = false,
                                 default = nil)
  if valid_574335 != nil:
    section.add "x-ms-version", valid_574335
  var valid_574336 = header.getOrDefault("x-ms-rename-source")
  valid_574336 = validateParameter(valid_574336, JString, required = false,
                                 default = nil)
  if valid_574336 != nil:
    section.add "x-ms-rename-source", valid_574336
  var valid_574337 = header.getOrDefault("x-ms-content-disposition")
  valid_574337 = validateParameter(valid_574337, JString, required = false,
                                 default = nil)
  if valid_574337 != nil:
    section.add "x-ms-content-disposition", valid_574337
  var valid_574338 = header.getOrDefault("x-ms-content-type")
  valid_574338 = validateParameter(valid_574338, JString, required = false,
                                 default = nil)
  if valid_574338 != nil:
    section.add "x-ms-content-type", valid_574338
  var valid_574339 = header.getOrDefault("x-ms-source-if-modified-since")
  valid_574339 = validateParameter(valid_574339, JString, required = false,
                                 default = nil)
  if valid_574339 != nil:
    section.add "x-ms-source-if-modified-since", valid_574339
  var valid_574340 = header.getOrDefault("Content-Encoding")
  valid_574340 = validateParameter(valid_574340, JString, required = false,
                                 default = nil)
  if valid_574340 != nil:
    section.add "Content-Encoding", valid_574340
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574341: Call_PathCreate_574306; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or rename a file or directory.    By default, the destination is overwritten and if the destination already exists and has a lease the lease is broken.  This operation supports conditional HTTP requests.  For more information, see [Specifying Conditional Headers for Blob Service Operations](https://docs.microsoft.com/en-us/rest/api/storageservices/specifying-conditional-headers-for-blob-service-operations).  To fail if the destination already exists, use a conditional request with If-None-Match: "*".
  ## 
  let valid = call_574341.validator(path, query, header, formData, body)
  let scheme = call_574341.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574341.url(scheme.get, call_574341.host, call_574341.base,
                         call_574341.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574341, url, valid)

proc call*(call_574342: Call_PathCreate_574306; path: string; filesystem: string;
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
  var path_574343 = newJObject()
  var query_574344 = newJObject()
  add(query_574344, "timeout", newJInt(timeout))
  add(query_574344, "continuation", newJString(continuation))
  add(query_574344, "resource", newJString(resource))
  add(query_574344, "mode", newJString(mode))
  add(path_574343, "path", newJString(path))
  add(path_574343, "filesystem", newJString(filesystem))
  result = call_574342.call(path_574343, query_574344, nil, nil, nil)

var pathCreate* = Call_PathCreate_574306(name: "pathCreate",
                                      meth: HttpMethod.HttpPut,
                                      host: "azure.local",
                                      route: "/{filesystem}/{path}",
                                      validator: validate_PathCreate_574307,
                                      base: "", url: url_PathCreate_574308,
                                      schemes: {Scheme.Https})
type
  Call_PathGetProperties_574387 = ref object of OpenApiRestCall_573658
proc url_PathGetProperties_574389(protocol: Scheme; host: string; base: string;
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

proc validate_PathGetProperties_574388(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Get Properties returns all system and user defined properties for a path. Get Status returns all system defined properties for a path. Get Access Control List returns the access control list for a path. This operation supports conditional HTTP requests.  For more information, see [Specifying Conditional Headers for Blob Service Operations](https://docs.microsoft.com/en-us/rest/api/storageservices/specifying-conditional-headers-for-blob-service-operations).
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
  var valid_574390 = path.getOrDefault("path")
  valid_574390 = validateParameter(valid_574390, JString, required = true,
                                 default = nil)
  if valid_574390 != nil:
    section.add "path", valid_574390
  var valid_574391 = path.getOrDefault("filesystem")
  valid_574391 = validateParameter(valid_574391, JString, required = true,
                                 default = nil)
  if valid_574391 != nil:
    section.add "filesystem", valid_574391
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : An optional operation timeout value in seconds. The period begins when the request is received by the service. If the timeout value elapses before the operation completes, the operation fails.
  ##   action: JString
  ##         : Optional. If the value is "getStatus" only the system defined properties for the path are returned. If the value is "getAccessControl" the access control list is returned in the response headers (Hierarchical Namespace must be enabled for the account), otherwise the properties are returned.
  ##   upn: JBool
  ##      : Optional. Valid only when Hierarchical Namespace is enabled for the account. If "true", the user identity values returned in the x-ms-owner, x-ms-group, and x-ms-acl response headers will be transformed from Azure Active Directory Object IDs to User Principal Names.  If "false", the values will be returned as Azure Active Directory Object IDs. The default value is false. Note that group and application Object IDs are not translated because they do not have unique friendly names.
  ##   fsAction: JString
  ##           : Required only for check access action. Valid only when Hierarchical Namespace is enabled for the account. File system operation read/write/execute in string form, matching regex pattern '[rwx-]{3}'
  section = newJObject()
  var valid_574392 = query.getOrDefault("timeout")
  valid_574392 = validateParameter(valid_574392, JInt, required = false, default = nil)
  if valid_574392 != nil:
    section.add "timeout", valid_574392
  var valid_574393 = query.getOrDefault("action")
  valid_574393 = validateParameter(valid_574393, JString, required = false,
                                 default = newJString("getAccessControl"))
  if valid_574393 != nil:
    section.add "action", valid_574393
  var valid_574394 = query.getOrDefault("upn")
  valid_574394 = validateParameter(valid_574394, JBool, required = false, default = nil)
  if valid_574394 != nil:
    section.add "upn", valid_574394
  var valid_574395 = query.getOrDefault("fsAction")
  valid_574395 = validateParameter(valid_574395, JString, required = false,
                                 default = nil)
  if valid_574395 != nil:
    section.add "fsAction", valid_574395
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : Optional.  An ETag value. Specify this header to perform the operation only if the resource's ETag matches the value specified. The ETag must be specified in quotes.
  ##   If-Unmodified-Since: JString
  ##                      : Optional. A date and time value. Specify this header to perform the operation only if the resource has not been modified since the specified date and time.
  ##   x-ms-lease-id: JString
  ##                : Optional. If this header is specified, the operation will be performed only if both of the following conditions are met: i) the path's lease is currently active and ii) the lease ID specified in the request matches that of the path.
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
  var valid_574396 = header.getOrDefault("If-Match")
  valid_574396 = validateParameter(valid_574396, JString, required = false,
                                 default = nil)
  if valid_574396 != nil:
    section.add "If-Match", valid_574396
  var valid_574397 = header.getOrDefault("If-Unmodified-Since")
  valid_574397 = validateParameter(valid_574397, JString, required = false,
                                 default = nil)
  if valid_574397 != nil:
    section.add "If-Unmodified-Since", valid_574397
  var valid_574398 = header.getOrDefault("x-ms-lease-id")
  valid_574398 = validateParameter(valid_574398, JString, required = false,
                                 default = nil)
  if valid_574398 != nil:
    section.add "x-ms-lease-id", valid_574398
  var valid_574399 = header.getOrDefault("x-ms-client-request-id")
  valid_574399 = validateParameter(valid_574399, JString, required = false,
                                 default = nil)
  if valid_574399 != nil:
    section.add "x-ms-client-request-id", valid_574399
  var valid_574400 = header.getOrDefault("x-ms-date")
  valid_574400 = validateParameter(valid_574400, JString, required = false,
                                 default = nil)
  if valid_574400 != nil:
    section.add "x-ms-date", valid_574400
  var valid_574401 = header.getOrDefault("If-None-Match")
  valid_574401 = validateParameter(valid_574401, JString, required = false,
                                 default = nil)
  if valid_574401 != nil:
    section.add "If-None-Match", valid_574401
  var valid_574402 = header.getOrDefault("If-Modified-Since")
  valid_574402 = validateParameter(valid_574402, JString, required = false,
                                 default = nil)
  if valid_574402 != nil:
    section.add "If-Modified-Since", valid_574402
  var valid_574403 = header.getOrDefault("x-ms-version")
  valid_574403 = validateParameter(valid_574403, JString, required = false,
                                 default = nil)
  if valid_574403 != nil:
    section.add "x-ms-version", valid_574403
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574404: Call_PathGetProperties_574387; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get Properties returns all system and user defined properties for a path. Get Status returns all system defined properties for a path. Get Access Control List returns the access control list for a path. This operation supports conditional HTTP requests.  For more information, see [Specifying Conditional Headers for Blob Service Operations](https://docs.microsoft.com/en-us/rest/api/storageservices/specifying-conditional-headers-for-blob-service-operations).
  ## 
  let valid = call_574404.validator(path, query, header, formData, body)
  let scheme = call_574404.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574404.url(scheme.get, call_574404.host, call_574404.base,
                         call_574404.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574404, url, valid)

proc call*(call_574405: Call_PathGetProperties_574387; path: string;
          filesystem: string; timeout: int = 0; action: string = "getAccessControl";
          upn: bool = false; fsAction: string = ""): Recallable =
  ## pathGetProperties
  ## Get Properties returns all system and user defined properties for a path. Get Status returns all system defined properties for a path. Get Access Control List returns the access control list for a path. This operation supports conditional HTTP requests.  For more information, see [Specifying Conditional Headers for Blob Service Operations](https://docs.microsoft.com/en-us/rest/api/storageservices/specifying-conditional-headers-for-blob-service-operations).
  ##   timeout: int
  ##          : An optional operation timeout value in seconds. The period begins when the request is received by the service. If the timeout value elapses before the operation completes, the operation fails.
  ##   action: string
  ##         : Optional. If the value is "getStatus" only the system defined properties for the path are returned. If the value is "getAccessControl" the access control list is returned in the response headers (Hierarchical Namespace must be enabled for the account), otherwise the properties are returned.
  ##   upn: bool
  ##      : Optional. Valid only when Hierarchical Namespace is enabled for the account. If "true", the user identity values returned in the x-ms-owner, x-ms-group, and x-ms-acl response headers will be transformed from Azure Active Directory Object IDs to User Principal Names.  If "false", the values will be returned as Azure Active Directory Object IDs. The default value is false. Note that group and application Object IDs are not translated because they do not have unique friendly names.
  ##   path: string (required)
  ##       : The file or directory path.
  ##   fsAction: string
  ##           : Required only for check access action. Valid only when Hierarchical Namespace is enabled for the account. File system operation read/write/execute in string form, matching regex pattern '[rwx-]{3}'
  ##   filesystem: string (required)
  ##             : The filesystem identifier.
  var path_574406 = newJObject()
  var query_574407 = newJObject()
  add(query_574407, "timeout", newJInt(timeout))
  add(query_574407, "action", newJString(action))
  add(query_574407, "upn", newJBool(upn))
  add(path_574406, "path", newJString(path))
  add(query_574407, "fsAction", newJString(fsAction))
  add(path_574406, "filesystem", newJString(filesystem))
  result = call_574405.call(path_574406, query_574407, nil, nil, nil)

var pathGetProperties* = Call_PathGetProperties_574387(name: "pathGetProperties",
    meth: HttpMethod.HttpHead, host: "azure.local", route: "/{filesystem}/{path}",
    validator: validate_PathGetProperties_574388, base: "",
    url: url_PathGetProperties_574389, schemes: {Scheme.Https})
type
  Call_PathLease_574345 = ref object of OpenApiRestCall_573658
proc url_PathLease_574347(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_PathLease_574346(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_574348 = path.getOrDefault("path")
  valid_574348 = validateParameter(valid_574348, JString, required = true,
                                 default = nil)
  if valid_574348 != nil:
    section.add "path", valid_574348
  var valid_574349 = path.getOrDefault("filesystem")
  valid_574349 = validateParameter(valid_574349, JString, required = true,
                                 default = nil)
  if valid_574349 != nil:
    section.add "filesystem", valid_574349
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : An optional operation timeout value in seconds. The period begins when the request is received by the service. If the timeout value elapses before the operation completes, the operation fails.
  section = newJObject()
  var valid_574350 = query.getOrDefault("timeout")
  valid_574350 = validateParameter(valid_574350, JInt, required = false, default = nil)
  if valid_574350 != nil:
    section.add "timeout", valid_574350
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
  var valid_574351 = header.getOrDefault("If-Match")
  valid_574351 = validateParameter(valid_574351, JString, required = false,
                                 default = nil)
  if valid_574351 != nil:
    section.add "If-Match", valid_574351
  var valid_574352 = header.getOrDefault("x-ms-lease-duration")
  valid_574352 = validateParameter(valid_574352, JInt, required = false, default = nil)
  if valid_574352 != nil:
    section.add "x-ms-lease-duration", valid_574352
  var valid_574353 = header.getOrDefault("If-Unmodified-Since")
  valid_574353 = validateParameter(valid_574353, JString, required = false,
                                 default = nil)
  if valid_574353 != nil:
    section.add "If-Unmodified-Since", valid_574353
  var valid_574354 = header.getOrDefault("x-ms-lease-id")
  valid_574354 = validateParameter(valid_574354, JString, required = false,
                                 default = nil)
  if valid_574354 != nil:
    section.add "x-ms-lease-id", valid_574354
  var valid_574355 = header.getOrDefault("x-ms-client-request-id")
  valid_574355 = validateParameter(valid_574355, JString, required = false,
                                 default = nil)
  if valid_574355 != nil:
    section.add "x-ms-client-request-id", valid_574355
  var valid_574356 = header.getOrDefault("x-ms-date")
  valid_574356 = validateParameter(valid_574356, JString, required = false,
                                 default = nil)
  if valid_574356 != nil:
    section.add "x-ms-date", valid_574356
  var valid_574357 = header.getOrDefault("x-ms-lease-break-period")
  valid_574357 = validateParameter(valid_574357, JInt, required = false, default = nil)
  if valid_574357 != nil:
    section.add "x-ms-lease-break-period", valid_574357
  var valid_574358 = header.getOrDefault("x-ms-proposed-lease-id")
  valid_574358 = validateParameter(valid_574358, JString, required = false,
                                 default = nil)
  if valid_574358 != nil:
    section.add "x-ms-proposed-lease-id", valid_574358
  var valid_574359 = header.getOrDefault("If-None-Match")
  valid_574359 = validateParameter(valid_574359, JString, required = false,
                                 default = nil)
  if valid_574359 != nil:
    section.add "If-None-Match", valid_574359
  var valid_574360 = header.getOrDefault("If-Modified-Since")
  valid_574360 = validateParameter(valid_574360, JString, required = false,
                                 default = nil)
  if valid_574360 != nil:
    section.add "If-Modified-Since", valid_574360
  var valid_574361 = header.getOrDefault("x-ms-version")
  valid_574361 = validateParameter(valid_574361, JString, required = false,
                                 default = nil)
  if valid_574361 != nil:
    section.add "x-ms-version", valid_574361
  assert header != nil, "header argument is necessary due to required `x-ms-lease-action` field"
  var valid_574362 = header.getOrDefault("x-ms-lease-action")
  valid_574362 = validateParameter(valid_574362, JString, required = true,
                                 default = newJString("acquire"))
  if valid_574362 != nil:
    section.add "x-ms-lease-action", valid_574362
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574363: Call_PathLease_574345; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create and manage a lease to restrict write and delete access to the path. This operation supports conditional HTTP requests.  For more information, see [Specifying Conditional Headers for Blob Service Operations](https://docs.microsoft.com/en-us/rest/api/storageservices/specifying-conditional-headers-for-blob-service-operations).
  ## 
  let valid = call_574363.validator(path, query, header, formData, body)
  let scheme = call_574363.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574363.url(scheme.get, call_574363.host, call_574363.base,
                         call_574363.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574363, url, valid)

proc call*(call_574364: Call_PathLease_574345; path: string; filesystem: string;
          timeout: int = 0): Recallable =
  ## pathLease
  ## Create and manage a lease to restrict write and delete access to the path. This operation supports conditional HTTP requests.  For more information, see [Specifying Conditional Headers for Blob Service Operations](https://docs.microsoft.com/en-us/rest/api/storageservices/specifying-conditional-headers-for-blob-service-operations).
  ##   timeout: int
  ##          : An optional operation timeout value in seconds. The period begins when the request is received by the service. If the timeout value elapses before the operation completes, the operation fails.
  ##   path: string (required)
  ##       : The file or directory path.
  ##   filesystem: string (required)
  ##             : The filesystem identifier.
  var path_574365 = newJObject()
  var query_574366 = newJObject()
  add(query_574366, "timeout", newJInt(timeout))
  add(path_574365, "path", newJString(path))
  add(path_574365, "filesystem", newJString(filesystem))
  result = call_574364.call(path_574365, query_574366, nil, nil, nil)

var pathLease* = Call_PathLease_574345(name: "pathLease", meth: HttpMethod.HttpPost,
                                    host: "azure.local",
                                    route: "/{filesystem}/{path}",
                                    validator: validate_PathLease_574346,
                                    base: "", url: url_PathLease_574347,
                                    schemes: {Scheme.Https})
type
  Call_PathRead_574286 = ref object of OpenApiRestCall_573658
proc url_PathRead_574288(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_PathRead_574287(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_574289 = path.getOrDefault("path")
  valid_574289 = validateParameter(valid_574289, JString, required = true,
                                 default = nil)
  if valid_574289 != nil:
    section.add "path", valid_574289
  var valid_574290 = path.getOrDefault("filesystem")
  valid_574290 = validateParameter(valid_574290, JString, required = true,
                                 default = nil)
  if valid_574290 != nil:
    section.add "filesystem", valid_574290
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : An optional operation timeout value in seconds. The period begins when the request is received by the service. If the timeout value elapses before the operation completes, the operation fails.
  section = newJObject()
  var valid_574291 = query.getOrDefault("timeout")
  valid_574291 = validateParameter(valid_574291, JInt, required = false, default = nil)
  if valid_574291 != nil:
    section.add "timeout", valid_574291
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : Optional.  An ETag value. Specify this header to perform the operation only if the resource's ETag matches the value specified. The ETag must be specified in quotes.
  ##   If-Unmodified-Since: JString
  ##                      : Optional. A date and time value. Specify this header to perform the operation only if the resource has not been modified since the specified date and time.
  ##   x-ms-lease-id: JString
  ##                : Optional. If this header is specified, the operation will be performed only if both of the following conditions are met: i) the path's lease is currently active and ii) the lease ID specified in the request matches that of the path.
  ##   x-ms-client-request-id: JString
  ##                         : A UUID recorded in the analytics logs for troubleshooting and correlation.
  ##   x-ms-date: JString
  ##            : Specifies the Coordinated Universal Time (UTC) for the request.  This is required when using shared key authorization.
  ##   If-None-Match: JString
  ##                : Optional.  An ETag value or the special wildcard ("*") value. Specify this header to perform the operation only if the resource's ETag does not match the value specified. The ETag must be specified in quotes.
  ##   If-Modified-Since: JString
  ##                    : Optional. A date and time value. Specify this header to perform the operation only if the resource has been modified since the specified date and time.
  ##   x-ms-range-get-content-md5: JBool
  ##                             : Optional. When this header is set to "true" and specified together with the Range header, the service returns the MD5 hash for the range, as long as the range is less than or equal to 4MB in size. If this header is specified without the Range header, the service returns status code 400 (Bad Request). If this header is set to true when the range exceeds 4 MB in size, the service returns status code 400 (Bad Request).
  ##   x-ms-version: JString
  ##               : Specifies the version of the REST protocol used for processing the request. This is required when using shared key authorization.
  ##   Range: JString
  ##        : The HTTP Range request header specifies one or more byte ranges of the resource to be retrieved.
  section = newJObject()
  var valid_574292 = header.getOrDefault("If-Match")
  valid_574292 = validateParameter(valid_574292, JString, required = false,
                                 default = nil)
  if valid_574292 != nil:
    section.add "If-Match", valid_574292
  var valid_574293 = header.getOrDefault("If-Unmodified-Since")
  valid_574293 = validateParameter(valid_574293, JString, required = false,
                                 default = nil)
  if valid_574293 != nil:
    section.add "If-Unmodified-Since", valid_574293
  var valid_574294 = header.getOrDefault("x-ms-lease-id")
  valid_574294 = validateParameter(valid_574294, JString, required = false,
                                 default = nil)
  if valid_574294 != nil:
    section.add "x-ms-lease-id", valid_574294
  var valid_574295 = header.getOrDefault("x-ms-client-request-id")
  valid_574295 = validateParameter(valid_574295, JString, required = false,
                                 default = nil)
  if valid_574295 != nil:
    section.add "x-ms-client-request-id", valid_574295
  var valid_574296 = header.getOrDefault("x-ms-date")
  valid_574296 = validateParameter(valid_574296, JString, required = false,
                                 default = nil)
  if valid_574296 != nil:
    section.add "x-ms-date", valid_574296
  var valid_574297 = header.getOrDefault("If-None-Match")
  valid_574297 = validateParameter(valid_574297, JString, required = false,
                                 default = nil)
  if valid_574297 != nil:
    section.add "If-None-Match", valid_574297
  var valid_574298 = header.getOrDefault("If-Modified-Since")
  valid_574298 = validateParameter(valid_574298, JString, required = false,
                                 default = nil)
  if valid_574298 != nil:
    section.add "If-Modified-Since", valid_574298
  var valid_574299 = header.getOrDefault("x-ms-range-get-content-md5")
  valid_574299 = validateParameter(valid_574299, JBool, required = false, default = nil)
  if valid_574299 != nil:
    section.add "x-ms-range-get-content-md5", valid_574299
  var valid_574300 = header.getOrDefault("x-ms-version")
  valid_574300 = validateParameter(valid_574300, JString, required = false,
                                 default = nil)
  if valid_574300 != nil:
    section.add "x-ms-version", valid_574300
  var valid_574301 = header.getOrDefault("Range")
  valid_574301 = validateParameter(valid_574301, JString, required = false,
                                 default = nil)
  if valid_574301 != nil:
    section.add "Range", valid_574301
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574302: Call_PathRead_574286; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Read the contents of a file.  For read operations, range requests are supported. This operation supports conditional HTTP requests.  For more information, see [Specifying Conditional Headers for Blob Service Operations](https://docs.microsoft.com/en-us/rest/api/storageservices/specifying-conditional-headers-for-blob-service-operations).
  ## 
  let valid = call_574302.validator(path, query, header, formData, body)
  let scheme = call_574302.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574302.url(scheme.get, call_574302.host, call_574302.base,
                         call_574302.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574302, url, valid)

proc call*(call_574303: Call_PathRead_574286; path: string; filesystem: string;
          timeout: int = 0): Recallable =
  ## pathRead
  ## Read the contents of a file.  For read operations, range requests are supported. This operation supports conditional HTTP requests.  For more information, see [Specifying Conditional Headers for Blob Service Operations](https://docs.microsoft.com/en-us/rest/api/storageservices/specifying-conditional-headers-for-blob-service-operations).
  ##   timeout: int
  ##          : An optional operation timeout value in seconds. The period begins when the request is received by the service. If the timeout value elapses before the operation completes, the operation fails.
  ##   path: string (required)
  ##       : The file or directory path.
  ##   filesystem: string (required)
  ##             : The filesystem identifier.
  var path_574304 = newJObject()
  var query_574305 = newJObject()
  add(query_574305, "timeout", newJInt(timeout))
  add(path_574304, "path", newJString(path))
  add(path_574304, "filesystem", newJString(filesystem))
  result = call_574303.call(path_574304, query_574305, nil, nil, nil)

var pathRead* = Call_PathRead_574286(name: "pathRead", meth: HttpMethod.HttpGet,
                                  host: "azure.local",
                                  route: "/{filesystem}/{path}",
                                  validator: validate_PathRead_574287, base: "",
                                  url: url_PathRead_574288,
                                  schemes: {Scheme.Https})
type
  Call_PathUpdate_574408 = ref object of OpenApiRestCall_573658
proc url_PathUpdate_574410(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_PathUpdate_574409(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_574411 = path.getOrDefault("path")
  valid_574411 = validateParameter(valid_574411, JString, required = true,
                                 default = nil)
  if valid_574411 != nil:
    section.add "path", valid_574411
  var valid_574412 = path.getOrDefault("filesystem")
  valid_574412 = validateParameter(valid_574412, JString, required = true,
                                 default = nil)
  if valid_574412 != nil:
    section.add "filesystem", valid_574412
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : An optional operation timeout value in seconds. The period begins when the request is received by the service. If the timeout value elapses before the operation completes, the operation fails.
  ##   action: JString (required)
  ##         : The action must be "append" to upload data to be appended to a file, "flush" to flush previously uploaded data to a file, "setProperties" to set the properties of a file or directory, or "setAccessControl" to set the owner, group, permissions, or access control list for a file or directory.  Note that Hierarchical Namespace must be enabled for the account in order to use access control.  Also note that the Access Control List (ACL) includes permissions for the owner, owning group, and others, so the x-ms-permissions and x-ms-acl request headers are mutually exclusive.
  ##   close: JBool
  ##        : Azure Storage Events allow applications to receive notifications when files change. When Azure Storage Events are enabled, a file changed event is raised. This event has a property indicating whether this is the final change to distinguish the difference between an intermediate flush to a file stream and the final close of a file stream. The close query parameter is valid only when the action is "flush" and change notifications are enabled. If the value of close is "true" and the flush operation completes successfully, the service raises a file change notification with a property indicating that this is the final update (the file stream has been closed). If "false" a change notification is raised indicating the file has changed. The default is false. This query parameter is set to true by the Hadoop ABFS driver to indicate that the file stream has been closed."
  ##   retainUncommittedData: JBool
  ##                        : Valid only for flush operations.  If "true", uncommitted data is retained after the flush operation completes; otherwise, the uncommitted data is deleted after the flush operation.  The default is false.  Data at offsets less than the specified position are written to the file when flush succeeds, but this optional parameter allows data after the flush position to be retained for a future flush operation.
  ##   position: JInt
  ##           : This parameter allows the caller to upload data in parallel and control the order in which it is appended to the file.  It is required when uploading data to be appended to the file and when flushing previously uploaded data to the file.  The value must be the position where the data is to be appended.  Uploaded data is not immediately flushed, or written, to the file.  To flush, the previously uploaded data must be contiguous, the position parameter must be specified and equal to the length of the file after all data has been written, and there must not be a request entity body included with the request.
  section = newJObject()
  var valid_574413 = query.getOrDefault("timeout")
  valid_574413 = validateParameter(valid_574413, JInt, required = false, default = nil)
  if valid_574413 != nil:
    section.add "timeout", valid_574413
  assert query != nil, "query argument is necessary due to required `action` field"
  var valid_574414 = query.getOrDefault("action")
  valid_574414 = validateParameter(valid_574414, JString, required = true,
                                 default = newJString("append"))
  if valid_574414 != nil:
    section.add "action", valid_574414
  var valid_574415 = query.getOrDefault("close")
  valid_574415 = validateParameter(valid_574415, JBool, required = false, default = nil)
  if valid_574415 != nil:
    section.add "close", valid_574415
  var valid_574416 = query.getOrDefault("retainUncommittedData")
  valid_574416 = validateParameter(valid_574416, JBool, required = false, default = nil)
  if valid_574416 != nil:
    section.add "retainUncommittedData", valid_574416
  var valid_574417 = query.getOrDefault("position")
  valid_574417 = validateParameter(valid_574417, JInt, required = false, default = nil)
  if valid_574417 != nil:
    section.add "position", valid_574417
  result.add "query", section
  ## parameters in `header` object:
  ##   x-ms-permissions: JString
  ##                   : Optional and only valid if Hierarchical Namespace is enabled for the account. Sets POSIX access permissions for the file owner, the file owning group, and others. Each class may be granted read, write, or execute permission.  The sticky bit is also supported.  Both symbolic (rwxrw-rw-) and 4-digit octal notation (e.g. 0766) are supported. Invalid in conjunction with x-ms-acl.
  ##   x-ms-acl: JString
  ##           : Optional and valid only for the setAccessControl operation. Sets POSIX access control rights on files and directories. The value is a comma-separated list of access control entries that fully replaces the existing access control list (ACL).  Each access control entry (ACE) consists of a scope, a type, a user or group identifier, and permissions in the format "[scope:][type]:[id]:[permissions]". The scope must be "default" to indicate the ACE belongs to the default ACL for a directory; otherwise scope is implicit and the ACE belongs to the access ACL.  There are four ACE types: "user" grants rights to the owner or a named user, "group" grants rights to the owning group or a named group, "mask" restricts rights granted to named users and the members of groups, and "other" grants rights to all users not found in any of the other entries. The user or group identifier is omitted for entries of type "mask" and "other".  The user or group identifier is also omitted for the owner and owning group.  The permission field is a 3-character sequence where the first character is 'r' to grant read access, the second character is 'w' to grant write access, and the third character is 'x' to grant execute permission.  If access is not granted, the '-' character is used to denote that the permission is denied. For example, the following ACL grants read, write, and execute rights to the file owner and john.doe@contoso, the read right to the owning group, and nothing to everyone else: "user::rwx,user:john.doe@contoso:rwx,group::r--,other::---,mask=rwx". Invalid in conjunction with x-ms-permissions.
  ##   If-Match: JString
  ##           : Optional for Flush Data and Set Properties, but invalid for Append Data.  An ETag value. Specify this header to perform the operation only if the resource's ETag matches the value specified. The ETag must be specified in quotes.
  ##   Content-MD5: JString
  ##              : Optional. An MD5 hash of the request content. This header is valid on "Append" and "Flush" operations. This hash is used to verify the integrity of the request content during transport. When this header is specified, the storage service compares the hash of the content that has arrived with this header value. If the two hashes do not match, the operation will fail with error code 400 (Bad Request). Note that this MD5 hash is not stored with the file. This header is associated with the request content, and not with the stored content of the file itself.
  ##   x-ms-properties: JString
  ##                  : Optional.  User-defined properties to be stored with the file or directory, in the format of a comma-separated list of name and value pairs "n1=v1, n2=v2, ...", where each value is a base64 encoded string. Note that the string may only contain ASCII characters in the ISO-8859-1 character set. Valid only for the setProperties operation. If the file or directory exists, any properties not included in the list will be removed.  All properties are removed if the header is omitted.  To merge new and existing properties, first get all existing properties and the current E-Tag, then make a conditional request with the E-Tag and include values for all properties.
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
  ##   Content-Length: JInt
  ##                 : Required for "Append Data" and "Flush Data".  Must be 0 for "Flush Data".  Must be the length of the request content in bytes for "Append Data".
  ##   If-None-Match: JString
  ##                : Optional for Flush Data and Set Properties, but invalid for Append Data.  An ETag value or the special wildcard ("*") value. Specify this header to perform the operation only if the resource's ETag does not match the value specified. The ETag must be specified in quotes.
  ##   If-Modified-Since: JString
  ##                    : Optional for Flush Data and Set Properties, but invalid for Append Data. A date and time value. Specify this header to perform the operation only if the resource has been modified since the specified date and time.
  ##   x-ms-content-md5: JString
  ##                   : Optional and only valid for "Flush & Set Properties" operations.  The service stores this value and includes it in the "Content-Md5" response header for "Read & Get Properties" operations. If this property is not specified on the request, then the property will be cleared for the file. Subsequent calls to "Read & Get Properties" will not return this property unless it is explicitly set on that file again.
  ##   x-ms-owner: JString
  ##             : Optional and valid only for the setAccessControl operation. Sets the owner of the file or directory.
  ##   x-ms-version: JString
  ##               : Specifies the version of the REST protocol used for processing the request. This is required when using shared key authorization.
  ##   x-ms-content-disposition: JString
  ##                           : Optional and only valid for flush and set properties operations.  The service stores this value and includes it in the "Content-Disposition" response header for "Read File" operations.
  ##   x-ms-content-type: JString
  ##                    : Optional and only valid for flush and set properties operations.  The service stores this value and includes it in the "Content-Type" response header for "Read File" operations.
  section = newJObject()
  var valid_574418 = header.getOrDefault("x-ms-permissions")
  valid_574418 = validateParameter(valid_574418, JString, required = false,
                                 default = nil)
  if valid_574418 != nil:
    section.add "x-ms-permissions", valid_574418
  var valid_574419 = header.getOrDefault("x-ms-acl")
  valid_574419 = validateParameter(valid_574419, JString, required = false,
                                 default = nil)
  if valid_574419 != nil:
    section.add "x-ms-acl", valid_574419
  var valid_574420 = header.getOrDefault("If-Match")
  valid_574420 = validateParameter(valid_574420, JString, required = false,
                                 default = nil)
  if valid_574420 != nil:
    section.add "If-Match", valid_574420
  var valid_574421 = header.getOrDefault("Content-MD5")
  valid_574421 = validateParameter(valid_574421, JString, required = false,
                                 default = nil)
  if valid_574421 != nil:
    section.add "Content-MD5", valid_574421
  var valid_574422 = header.getOrDefault("x-ms-properties")
  valid_574422 = validateParameter(valid_574422, JString, required = false,
                                 default = nil)
  if valid_574422 != nil:
    section.add "x-ms-properties", valid_574422
  var valid_574423 = header.getOrDefault("x-ms-content-language")
  valid_574423 = validateParameter(valid_574423, JString, required = false,
                                 default = nil)
  if valid_574423 != nil:
    section.add "x-ms-content-language", valid_574423
  var valid_574424 = header.getOrDefault("x-ms-group")
  valid_574424 = validateParameter(valid_574424, JString, required = false,
                                 default = nil)
  if valid_574424 != nil:
    section.add "x-ms-group", valid_574424
  var valid_574425 = header.getOrDefault("If-Unmodified-Since")
  valid_574425 = validateParameter(valid_574425, JString, required = false,
                                 default = nil)
  if valid_574425 != nil:
    section.add "If-Unmodified-Since", valid_574425
  var valid_574426 = header.getOrDefault("x-ms-lease-id")
  valid_574426 = validateParameter(valid_574426, JString, required = false,
                                 default = nil)
  if valid_574426 != nil:
    section.add "x-ms-lease-id", valid_574426
  var valid_574427 = header.getOrDefault("x-ms-content-encoding")
  valid_574427 = validateParameter(valid_574427, JString, required = false,
                                 default = nil)
  if valid_574427 != nil:
    section.add "x-ms-content-encoding", valid_574427
  var valid_574428 = header.getOrDefault("x-ms-cache-control")
  valid_574428 = validateParameter(valid_574428, JString, required = false,
                                 default = nil)
  if valid_574428 != nil:
    section.add "x-ms-cache-control", valid_574428
  var valid_574429 = header.getOrDefault("x-ms-client-request-id")
  valid_574429 = validateParameter(valid_574429, JString, required = false,
                                 default = nil)
  if valid_574429 != nil:
    section.add "x-ms-client-request-id", valid_574429
  var valid_574430 = header.getOrDefault("x-ms-date")
  valid_574430 = validateParameter(valid_574430, JString, required = false,
                                 default = nil)
  if valid_574430 != nil:
    section.add "x-ms-date", valid_574430
  var valid_574431 = header.getOrDefault("Content-Length")
  valid_574431 = validateParameter(valid_574431, JInt, required = false, default = nil)
  if valid_574431 != nil:
    section.add "Content-Length", valid_574431
  var valid_574432 = header.getOrDefault("If-None-Match")
  valid_574432 = validateParameter(valid_574432, JString, required = false,
                                 default = nil)
  if valid_574432 != nil:
    section.add "If-None-Match", valid_574432
  var valid_574433 = header.getOrDefault("If-Modified-Since")
  valid_574433 = validateParameter(valid_574433, JString, required = false,
                                 default = nil)
  if valid_574433 != nil:
    section.add "If-Modified-Since", valid_574433
  var valid_574434 = header.getOrDefault("x-ms-content-md5")
  valid_574434 = validateParameter(valid_574434, JString, required = false,
                                 default = nil)
  if valid_574434 != nil:
    section.add "x-ms-content-md5", valid_574434
  var valid_574435 = header.getOrDefault("x-ms-owner")
  valid_574435 = validateParameter(valid_574435, JString, required = false,
                                 default = nil)
  if valid_574435 != nil:
    section.add "x-ms-owner", valid_574435
  var valid_574436 = header.getOrDefault("x-ms-version")
  valid_574436 = validateParameter(valid_574436, JString, required = false,
                                 default = nil)
  if valid_574436 != nil:
    section.add "x-ms-version", valid_574436
  var valid_574437 = header.getOrDefault("x-ms-content-disposition")
  valid_574437 = validateParameter(valid_574437, JString, required = false,
                                 default = nil)
  if valid_574437 != nil:
    section.add "x-ms-content-disposition", valid_574437
  var valid_574438 = header.getOrDefault("x-ms-content-type")
  valid_574438 = validateParameter(valid_574438, JString, required = false,
                                 default = nil)
  if valid_574438 != nil:
    section.add "x-ms-content-type", valid_574438
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   requestBody: JObject
  ##              : Valid only for append operations.  The data to be uploaded and appended to the file.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574440: Call_PathUpdate_574408; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Uploads data to be appended to a file, flushes (writes) previously uploaded data to a file, sets properties for a file or directory, or sets access control for a file or directory. Data can only be appended to a file. This operation supports conditional HTTP requests. For more information, see [Specifying Conditional Headers for Blob Service Operations](https://docs.microsoft.com/en-us/rest/api/storageservices/specifying-conditional-headers-for-blob-service-operations).
  ## 
  let valid = call_574440.validator(path, query, header, formData, body)
  let scheme = call_574440.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574440.url(scheme.get, call_574440.host, call_574440.base,
                         call_574440.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574440, url, valid)

proc call*(call_574441: Call_PathUpdate_574408; path: string; filesystem: string;
          timeout: int = 0; action: string = "append"; close: bool = false;
          retainUncommittedData: bool = false; requestBody: JsonNode = nil;
          position: int = 0): Recallable =
  ## pathUpdate
  ## Uploads data to be appended to a file, flushes (writes) previously uploaded data to a file, sets properties for a file or directory, or sets access control for a file or directory. Data can only be appended to a file. This operation supports conditional HTTP requests. For more information, see [Specifying Conditional Headers for Blob Service Operations](https://docs.microsoft.com/en-us/rest/api/storageservices/specifying-conditional-headers-for-blob-service-operations).
  ##   timeout: int
  ##          : An optional operation timeout value in seconds. The period begins when the request is received by the service. If the timeout value elapses before the operation completes, the operation fails.
  ##   action: string (required)
  ##         : The action must be "append" to upload data to be appended to a file, "flush" to flush previously uploaded data to a file, "setProperties" to set the properties of a file or directory, or "setAccessControl" to set the owner, group, permissions, or access control list for a file or directory.  Note that Hierarchical Namespace must be enabled for the account in order to use access control.  Also note that the Access Control List (ACL) includes permissions for the owner, owning group, and others, so the x-ms-permissions and x-ms-acl request headers are mutually exclusive.
  ##   close: bool
  ##        : Azure Storage Events allow applications to receive notifications when files change. When Azure Storage Events are enabled, a file changed event is raised. This event has a property indicating whether this is the final change to distinguish the difference between an intermediate flush to a file stream and the final close of a file stream. The close query parameter is valid only when the action is "flush" and change notifications are enabled. If the value of close is "true" and the flush operation completes successfully, the service raises a file change notification with a property indicating that this is the final update (the file stream has been closed). If "false" a change notification is raised indicating the file has changed. The default is false. This query parameter is set to true by the Hadoop ABFS driver to indicate that the file stream has been closed."
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
  var path_574442 = newJObject()
  var query_574443 = newJObject()
  var body_574444 = newJObject()
  add(query_574443, "timeout", newJInt(timeout))
  add(query_574443, "action", newJString(action))
  add(query_574443, "close", newJBool(close))
  add(path_574442, "path", newJString(path))
  add(query_574443, "retainUncommittedData", newJBool(retainUncommittedData))
  if requestBody != nil:
    body_574444 = requestBody
  add(query_574443, "position", newJInt(position))
  add(path_574442, "filesystem", newJString(filesystem))
  result = call_574441.call(path_574442, query_574443, nil, nil, body_574444)

var pathUpdate* = Call_PathUpdate_574408(name: "pathUpdate",
                                      meth: HttpMethod.HttpPatch,
                                      host: "azure.local",
                                      route: "/{filesystem}/{path}",
                                      validator: validate_PathUpdate_574409,
                                      base: "", url: url_PathUpdate_574410,
                                      schemes: {Scheme.Https})
type
  Call_PathDelete_574367 = ref object of OpenApiRestCall_573658
proc url_PathDelete_574369(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_PathDelete_574368(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_574370 = path.getOrDefault("path")
  valid_574370 = validateParameter(valid_574370, JString, required = true,
                                 default = nil)
  if valid_574370 != nil:
    section.add "path", valid_574370
  var valid_574371 = path.getOrDefault("filesystem")
  valid_574371 = validateParameter(valid_574371, JString, required = true,
                                 default = nil)
  if valid_574371 != nil:
    section.add "filesystem", valid_574371
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : An optional operation timeout value in seconds. The period begins when the request is received by the service. If the timeout value elapses before the operation completes, the operation fails.
  ##   continuation: JString
  ##               : Optional.  When deleting a directory, the number of paths that are deleted with each invocation is limited.  If the number of paths to be deleted exceeds this limit, a continuation token is returned in this response header.  When a continuation token is returned in the response, it must be specified in a subsequent invocation of the delete operation to continue deleting the directory.
  ##   recursive: JBool
  ##            : Required and valid only when the resource is a directory.  If "true", all paths beneath the directory will be deleted. If "false" and the directory is non-empty, an error occurs.
  section = newJObject()
  var valid_574372 = query.getOrDefault("timeout")
  valid_574372 = validateParameter(valid_574372, JInt, required = false, default = nil)
  if valid_574372 != nil:
    section.add "timeout", valid_574372
  var valid_574373 = query.getOrDefault("continuation")
  valid_574373 = validateParameter(valid_574373, JString, required = false,
                                 default = nil)
  if valid_574373 != nil:
    section.add "continuation", valid_574373
  var valid_574374 = query.getOrDefault("recursive")
  valid_574374 = validateParameter(valid_574374, JBool, required = false, default = nil)
  if valid_574374 != nil:
    section.add "recursive", valid_574374
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
  var valid_574375 = header.getOrDefault("If-Match")
  valid_574375 = validateParameter(valid_574375, JString, required = false,
                                 default = nil)
  if valid_574375 != nil:
    section.add "If-Match", valid_574375
  var valid_574376 = header.getOrDefault("If-Unmodified-Since")
  valid_574376 = validateParameter(valid_574376, JString, required = false,
                                 default = nil)
  if valid_574376 != nil:
    section.add "If-Unmodified-Since", valid_574376
  var valid_574377 = header.getOrDefault("x-ms-lease-id")
  valid_574377 = validateParameter(valid_574377, JString, required = false,
                                 default = nil)
  if valid_574377 != nil:
    section.add "x-ms-lease-id", valid_574377
  var valid_574378 = header.getOrDefault("x-ms-client-request-id")
  valid_574378 = validateParameter(valid_574378, JString, required = false,
                                 default = nil)
  if valid_574378 != nil:
    section.add "x-ms-client-request-id", valid_574378
  var valid_574379 = header.getOrDefault("x-ms-date")
  valid_574379 = validateParameter(valid_574379, JString, required = false,
                                 default = nil)
  if valid_574379 != nil:
    section.add "x-ms-date", valid_574379
  var valid_574380 = header.getOrDefault("If-None-Match")
  valid_574380 = validateParameter(valid_574380, JString, required = false,
                                 default = nil)
  if valid_574380 != nil:
    section.add "If-None-Match", valid_574380
  var valid_574381 = header.getOrDefault("If-Modified-Since")
  valid_574381 = validateParameter(valid_574381, JString, required = false,
                                 default = nil)
  if valid_574381 != nil:
    section.add "If-Modified-Since", valid_574381
  var valid_574382 = header.getOrDefault("x-ms-version")
  valid_574382 = validateParameter(valid_574382, JString, required = false,
                                 default = nil)
  if valid_574382 != nil:
    section.add "x-ms-version", valid_574382
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574383: Call_PathDelete_574367; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete the file or directory. This operation supports conditional HTTP requests.  For more information, see [Specifying Conditional Headers for Blob Service Operations](https://docs.microsoft.com/en-us/rest/api/storageservices/specifying-conditional-headers-for-blob-service-operations).
  ## 
  let valid = call_574383.validator(path, query, header, formData, body)
  let scheme = call_574383.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574383.url(scheme.get, call_574383.host, call_574383.base,
                         call_574383.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574383, url, valid)

proc call*(call_574384: Call_PathDelete_574367; path: string; filesystem: string;
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
  var path_574385 = newJObject()
  var query_574386 = newJObject()
  add(query_574386, "timeout", newJInt(timeout))
  add(query_574386, "continuation", newJString(continuation))
  add(path_574385, "path", newJString(path))
  add(path_574385, "filesystem", newJString(filesystem))
  add(query_574386, "recursive", newJBool(recursive))
  result = call_574384.call(path_574385, query_574386, nil, nil, nil)

var pathDelete* = Call_PathDelete_574367(name: "pathDelete",
                                      meth: HttpMethod.HttpDelete,
                                      host: "azure.local",
                                      route: "/{filesystem}/{path}",
                                      validator: validate_PathDelete_574368,
                                      base: "", url: url_PathDelete_574369,
                                      schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
