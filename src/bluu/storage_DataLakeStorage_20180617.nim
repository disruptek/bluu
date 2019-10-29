
import
  json, options, hashes, uri, rest, os, uri, httpcore

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
  macServiceName = "storage-DataLakeStorage"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_FilesystemList_563778 = ref object of OpenApiRestCall_563556
proc url_FilesystemList_563780(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_FilesystemList_563779(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## List filesystems and their properties in given account.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   prefix: JString
  ##         : Filters results to filesystems within the specified prefix.
  ##   continuation: JString
  ##               : The number of filesystems returned with each invocation is limited. If the number of filesystems to be returned exceeds this limit, a continuation token is returned in the response header x-ms-continuation. When a continuation token is  returned in the response, it must be specified in a subsequent invocation of the list operation to continue listing the filesystems.
  ##   timeout: JInt
  ##          : An optional operation timeout value in seconds. The period begins when the request is received by the service. If the timeout value elapses before the operation completes, the operation fails.
  ##   resource: JString (required)
  ##           : The value must be "account" for all account operations.
  ##   maxResults: JInt
  ##             : An optional value that specifies the maximum number of items to return. If omitted or greater than 5,000, the response will include up to 5,000 items.
  section = newJObject()
  var valid_563941 = query.getOrDefault("prefix")
  valid_563941 = validateParameter(valid_563941, JString, required = false,
                                 default = nil)
  if valid_563941 != nil:
    section.add "prefix", valid_563941
  var valid_563942 = query.getOrDefault("continuation")
  valid_563942 = validateParameter(valid_563942, JString, required = false,
                                 default = nil)
  if valid_563942 != nil:
    section.add "continuation", valid_563942
  var valid_563943 = query.getOrDefault("timeout")
  valid_563943 = validateParameter(valid_563943, JInt, required = false, default = nil)
  if valid_563943 != nil:
    section.add "timeout", valid_563943
  assert query != nil,
        "query argument is necessary due to required `resource` field"
  var valid_563957 = query.getOrDefault("resource")
  valid_563957 = validateParameter(valid_563957, JString, required = true,
                                 default = newJString("account"))
  if valid_563957 != nil:
    section.add "resource", valid_563957
  var valid_563958 = query.getOrDefault("maxResults")
  valid_563958 = validateParameter(valid_563958, JInt, required = false, default = nil)
  if valid_563958 != nil:
    section.add "maxResults", valid_563958
  result.add "query", section
  ## parameters in `header` object:
  ##   x-ms-version: JString
  ##               : Specifies the version of the REST protocol used for processing the request. This is required when using shared key authorization.
  ##   x-ms-date: JString
  ##            : Specifies the Coordinated Universal Time (UTC) for the request.  This is required when using shared key authorization.
  ##   x-ms-client-request-id: JString
  ##                         : A UUID recorded in the analytics logs for troubleshooting and correlation.
  section = newJObject()
  var valid_563959 = header.getOrDefault("x-ms-version")
  valid_563959 = validateParameter(valid_563959, JString, required = false,
                                 default = nil)
  if valid_563959 != nil:
    section.add "x-ms-version", valid_563959
  var valid_563960 = header.getOrDefault("x-ms-date")
  valid_563960 = validateParameter(valid_563960, JString, required = false,
                                 default = nil)
  if valid_563960 != nil:
    section.add "x-ms-date", valid_563960
  var valid_563961 = header.getOrDefault("x-ms-client-request-id")
  valid_563961 = validateParameter(valid_563961, JString, required = false,
                                 default = nil)
  if valid_563961 != nil:
    section.add "x-ms-client-request-id", valid_563961
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563984: Call_FilesystemList_563778; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List filesystems and their properties in given account.
  ## 
  let valid = call_563984.validator(path, query, header, formData, body)
  let scheme = call_563984.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563984.url(scheme.get, call_563984.host, call_563984.base,
                         call_563984.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563984, url, valid)

proc call*(call_564055: Call_FilesystemList_563778; prefix: string = "";
          continuation: string = ""; timeout: int = 0; resource: string = "account";
          maxResults: int = 0): Recallable =
  ## filesystemList
  ## List filesystems and their properties in given account.
  ##   prefix: string
  ##         : Filters results to filesystems within the specified prefix.
  ##   continuation: string
  ##               : The number of filesystems returned with each invocation is limited. If the number of filesystems to be returned exceeds this limit, a continuation token is returned in the response header x-ms-continuation. When a continuation token is  returned in the response, it must be specified in a subsequent invocation of the list operation to continue listing the filesystems.
  ##   timeout: int
  ##          : An optional operation timeout value in seconds. The period begins when the request is received by the service. If the timeout value elapses before the operation completes, the operation fails.
  ##   resource: string (required)
  ##           : The value must be "account" for all account operations.
  ##   maxResults: int
  ##             : An optional value that specifies the maximum number of items to return. If omitted or greater than 5,000, the response will include up to 5,000 items.
  var query_564056 = newJObject()
  add(query_564056, "prefix", newJString(prefix))
  add(query_564056, "continuation", newJString(continuation))
  add(query_564056, "timeout", newJInt(timeout))
  add(query_564056, "resource", newJString(resource))
  add(query_564056, "maxResults", newJInt(maxResults))
  result = call_564055.call(nil, query_564056, nil, nil, nil)

var filesystemList* = Call_FilesystemList_563778(name: "filesystemList",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/",
    validator: validate_FilesystemList_563779, base: "", url: url_FilesystemList_563780,
    schemes: {Scheme.Https})
type
  Call_FilesystemCreate_564127 = ref object of OpenApiRestCall_563556
proc url_FilesystemCreate_564129(protocol: Scheme; host: string; base: string;
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

proc validate_FilesystemCreate_564128(path: JsonNode; query: JsonNode;
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
  var valid_564130 = path.getOrDefault("filesystem")
  valid_564130 = validateParameter(valid_564130, JString, required = true,
                                 default = nil)
  if valid_564130 != nil:
    section.add "filesystem", valid_564130
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : An optional operation timeout value in seconds. The period begins when the request is received by the service. If the timeout value elapses before the operation completes, the operation fails.
  ##   resource: JString (required)
  ##           : The value must be "filesystem" for all filesystem operations.
  section = newJObject()
  var valid_564131 = query.getOrDefault("timeout")
  valid_564131 = validateParameter(valid_564131, JInt, required = false, default = nil)
  if valid_564131 != nil:
    section.add "timeout", valid_564131
  assert query != nil,
        "query argument is necessary due to required `resource` field"
  var valid_564132 = query.getOrDefault("resource")
  valid_564132 = validateParameter(valid_564132, JString, required = true,
                                 default = newJString("filesystem"))
  if valid_564132 != nil:
    section.add "resource", valid_564132
  result.add "query", section
  ## parameters in `header` object:
  ##   x-ms-version: JString
  ##               : Specifies the version of the REST protocol used for processing the request. This is required when using shared key authorization.
  ##   x-ms-date: JString
  ##            : Specifies the Coordinated Universal Time (UTC) for the request.  This is required when using shared key authorization.
  ##   x-ms-properties: JString
  ##                  : User-defined properties to be stored with the filesystem, in the format of a comma-separated list of name and value pairs "n1=v1, n2=v2, ...", where each value is base64 encoded.
  ##   x-ms-client-request-id: JString
  ##                         : A UUID recorded in the analytics logs for troubleshooting and correlation.
  section = newJObject()
  var valid_564133 = header.getOrDefault("x-ms-version")
  valid_564133 = validateParameter(valid_564133, JString, required = false,
                                 default = nil)
  if valid_564133 != nil:
    section.add "x-ms-version", valid_564133
  var valid_564134 = header.getOrDefault("x-ms-date")
  valid_564134 = validateParameter(valid_564134, JString, required = false,
                                 default = nil)
  if valid_564134 != nil:
    section.add "x-ms-date", valid_564134
  var valid_564135 = header.getOrDefault("x-ms-properties")
  valid_564135 = validateParameter(valid_564135, JString, required = false,
                                 default = nil)
  if valid_564135 != nil:
    section.add "x-ms-properties", valid_564135
  var valid_564136 = header.getOrDefault("x-ms-client-request-id")
  valid_564136 = validateParameter(valid_564136, JString, required = false,
                                 default = nil)
  if valid_564136 != nil:
    section.add "x-ms-client-request-id", valid_564136
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564137: Call_FilesystemCreate_564127; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a filesystem rooted at the specified location. If the filesystem already exists, the operation fails.  This operation does not support conditional HTTP requests.
  ## 
  let valid = call_564137.validator(path, query, header, formData, body)
  let scheme = call_564137.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564137.url(scheme.get, call_564137.host, call_564137.base,
                         call_564137.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564137, url, valid)

proc call*(call_564138: Call_FilesystemCreate_564127; filesystem: string;
          timeout: int = 0; resource: string = "filesystem"): Recallable =
  ## filesystemCreate
  ## Create a filesystem rooted at the specified location. If the filesystem already exists, the operation fails.  This operation does not support conditional HTTP requests.
  ##   timeout: int
  ##          : An optional operation timeout value in seconds. The period begins when the request is received by the service. If the timeout value elapses before the operation completes, the operation fails.
  ##   resource: string (required)
  ##           : The value must be "filesystem" for all filesystem operations.
  ##   filesystem: string (required)
  ##             : The filesystem identifier.  The value must start and end with a letter or number and must contain only letters, numbers, and the dash (-) character.  Consecutive dashes are not permitted.  All letters must be lowercase.  The value must have between 3 and 63 characters.
  var path_564139 = newJObject()
  var query_564140 = newJObject()
  add(query_564140, "timeout", newJInt(timeout))
  add(query_564140, "resource", newJString(resource))
  add(path_564139, "filesystem", newJString(filesystem))
  result = call_564138.call(path_564139, query_564140, nil, nil, nil)

var filesystemCreate* = Call_FilesystemCreate_564127(name: "filesystemCreate",
    meth: HttpMethod.HttpPut, host: "azure.local", route: "/{filesystem}",
    validator: validate_FilesystemCreate_564128, base: "",
    url: url_FilesystemCreate_564129, schemes: {Scheme.Https})
type
  Call_FilesystemGetProperties_564156 = ref object of OpenApiRestCall_563556
proc url_FilesystemGetProperties_564158(protocol: Scheme; host: string; base: string;
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

proc validate_FilesystemGetProperties_564157(path: JsonNode; query: JsonNode;
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
  var valid_564159 = path.getOrDefault("filesystem")
  valid_564159 = validateParameter(valid_564159, JString, required = true,
                                 default = nil)
  if valid_564159 != nil:
    section.add "filesystem", valid_564159
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : An optional operation timeout value in seconds. The period begins when the request is received by the service. If the timeout value elapses before the operation completes, the operation fails.
  ##   resource: JString (required)
  ##           : The value must be "filesystem" for all filesystem operations.
  section = newJObject()
  var valid_564160 = query.getOrDefault("timeout")
  valid_564160 = validateParameter(valid_564160, JInt, required = false, default = nil)
  if valid_564160 != nil:
    section.add "timeout", valid_564160
  assert query != nil,
        "query argument is necessary due to required `resource` field"
  var valid_564161 = query.getOrDefault("resource")
  valid_564161 = validateParameter(valid_564161, JString, required = true,
                                 default = newJString("filesystem"))
  if valid_564161 != nil:
    section.add "resource", valid_564161
  result.add "query", section
  ## parameters in `header` object:
  ##   x-ms-version: JString
  ##               : Specifies the version of the REST protocol used for processing the request. This is required when using shared key authorization.
  ##   x-ms-date: JString
  ##            : Specifies the Coordinated Universal Time (UTC) for the request.  This is required when using shared key authorization.
  ##   x-ms-client-request-id: JString
  ##                         : A UUID recorded in the analytics logs for troubleshooting and correlation.
  section = newJObject()
  var valid_564162 = header.getOrDefault("x-ms-version")
  valid_564162 = validateParameter(valid_564162, JString, required = false,
                                 default = nil)
  if valid_564162 != nil:
    section.add "x-ms-version", valid_564162
  var valid_564163 = header.getOrDefault("x-ms-date")
  valid_564163 = validateParameter(valid_564163, JString, required = false,
                                 default = nil)
  if valid_564163 != nil:
    section.add "x-ms-date", valid_564163
  var valid_564164 = header.getOrDefault("x-ms-client-request-id")
  valid_564164 = validateParameter(valid_564164, JString, required = false,
                                 default = nil)
  if valid_564164 != nil:
    section.add "x-ms-client-request-id", valid_564164
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564165: Call_FilesystemGetProperties_564156; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## All system and user-defined filesystem properties are specified in the response headers.
  ## 
  let valid = call_564165.validator(path, query, header, formData, body)
  let scheme = call_564165.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564165.url(scheme.get, call_564165.host, call_564165.base,
                         call_564165.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564165, url, valid)

proc call*(call_564166: Call_FilesystemGetProperties_564156; filesystem: string;
          timeout: int = 0; resource: string = "filesystem"): Recallable =
  ## filesystemGetProperties
  ## All system and user-defined filesystem properties are specified in the response headers.
  ##   timeout: int
  ##          : An optional operation timeout value in seconds. The period begins when the request is received by the service. If the timeout value elapses before the operation completes, the operation fails.
  ##   resource: string (required)
  ##           : The value must be "filesystem" for all filesystem operations.
  ##   filesystem: string (required)
  ##             : The filesystem identifier.  The value must start and end with a letter or number and must contain only letters, numbers, and the dash (-) character.  Consecutive dashes are not permitted.  All letters must be lowercase.  The value must have between 3 and 63 characters.
  var path_564167 = newJObject()
  var query_564168 = newJObject()
  add(query_564168, "timeout", newJInt(timeout))
  add(query_564168, "resource", newJString(resource))
  add(path_564167, "filesystem", newJString(filesystem))
  result = call_564166.call(path_564167, query_564168, nil, nil, nil)

var filesystemGetProperties* = Call_FilesystemGetProperties_564156(
    name: "filesystemGetProperties", meth: HttpMethod.HttpHead, host: "azure.local",
    route: "/{filesystem}", validator: validate_FilesystemGetProperties_564157,
    base: "", url: url_FilesystemGetProperties_564158, schemes: {Scheme.Https})
type
  Call_PathList_564096 = ref object of OpenApiRestCall_563556
proc url_PathList_564098(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_PathList_564097(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564113 = path.getOrDefault("filesystem")
  valid_564113 = validateParameter(valid_564113, JString, required = true,
                                 default = nil)
  if valid_564113 != nil:
    section.add "filesystem", valid_564113
  result.add "path", section
  ## parameters in `query` object:
  ##   recursive: JBool (required)
  ##            : If "true", all paths are listed; otherwise, only paths at the root of the filesystem are listed.  If "directory" is specified, the list will only include paths that share the same root.
  ##   directory: JString
  ##            : Filters results to paths within the specified directory. An error occurs if the directory does not exist.
  ##   continuation: JString
  ##               : The number of paths returned with each invocation is limited. If the number of paths to be returned exceeds this limit, a continuation token is returned in the response header x-ms-continuation. When a continuation token is  returned in the response, it must be specified in a subsequent invocation of the list operation to continue listing the paths.
  ##   timeout: JInt
  ##          : An optional operation timeout value in seconds. The period begins when the request is received by the service. If the timeout value elapses before the operation completes, the operation fails.
  ##   resource: JString (required)
  ##           : The value must be "filesystem" for all filesystem operations.
  ##   maxResults: JInt
  ##             : An optional value that specifies the maximum number of items to return. If omitted or greater than 5,000, the response will include up to 5,000 items.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `recursive` field"
  var valid_564114 = query.getOrDefault("recursive")
  valid_564114 = validateParameter(valid_564114, JBool, required = true, default = nil)
  if valid_564114 != nil:
    section.add "recursive", valid_564114
  var valid_564115 = query.getOrDefault("directory")
  valid_564115 = validateParameter(valid_564115, JString, required = false,
                                 default = nil)
  if valid_564115 != nil:
    section.add "directory", valid_564115
  var valid_564116 = query.getOrDefault("continuation")
  valid_564116 = validateParameter(valid_564116, JString, required = false,
                                 default = nil)
  if valid_564116 != nil:
    section.add "continuation", valid_564116
  var valid_564117 = query.getOrDefault("timeout")
  valid_564117 = validateParameter(valid_564117, JInt, required = false, default = nil)
  if valid_564117 != nil:
    section.add "timeout", valid_564117
  var valid_564118 = query.getOrDefault("resource")
  valid_564118 = validateParameter(valid_564118, JString, required = true,
                                 default = newJString("filesystem"))
  if valid_564118 != nil:
    section.add "resource", valid_564118
  var valid_564119 = query.getOrDefault("maxResults")
  valid_564119 = validateParameter(valid_564119, JInt, required = false, default = nil)
  if valid_564119 != nil:
    section.add "maxResults", valid_564119
  result.add "query", section
  ## parameters in `header` object:
  ##   x-ms-version: JString
  ##               : Specifies the version of the REST protocol used for processing the request. This is required when using shared key authorization.
  ##   x-ms-date: JString
  ##            : Specifies the Coordinated Universal Time (UTC) for the request.  This is required when using shared key authorization.
  ##   x-ms-client-request-id: JString
  ##                         : A UUID recorded in the analytics logs for troubleshooting and correlation.
  section = newJObject()
  var valid_564120 = header.getOrDefault("x-ms-version")
  valid_564120 = validateParameter(valid_564120, JString, required = false,
                                 default = nil)
  if valid_564120 != nil:
    section.add "x-ms-version", valid_564120
  var valid_564121 = header.getOrDefault("x-ms-date")
  valid_564121 = validateParameter(valid_564121, JString, required = false,
                                 default = nil)
  if valid_564121 != nil:
    section.add "x-ms-date", valid_564121
  var valid_564122 = header.getOrDefault("x-ms-client-request-id")
  valid_564122 = validateParameter(valid_564122, JString, required = false,
                                 default = nil)
  if valid_564122 != nil:
    section.add "x-ms-client-request-id", valid_564122
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564123: Call_PathList_564096; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List filesystem paths and their properties.
  ## 
  let valid = call_564123.validator(path, query, header, formData, body)
  let scheme = call_564123.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564123.url(scheme.get, call_564123.host, call_564123.base,
                         call_564123.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564123, url, valid)

proc call*(call_564124: Call_PathList_564096; recursive: bool; filesystem: string;
          directory: string = ""; continuation: string = ""; timeout: int = 0;
          resource: string = "filesystem"; maxResults: int = 0): Recallable =
  ## pathList
  ## List filesystem paths and their properties.
  ##   recursive: bool (required)
  ##            : If "true", all paths are listed; otherwise, only paths at the root of the filesystem are listed.  If "directory" is specified, the list will only include paths that share the same root.
  ##   directory: string
  ##            : Filters results to paths within the specified directory. An error occurs if the directory does not exist.
  ##   continuation: string
  ##               : The number of paths returned with each invocation is limited. If the number of paths to be returned exceeds this limit, a continuation token is returned in the response header x-ms-continuation. When a continuation token is  returned in the response, it must be specified in a subsequent invocation of the list operation to continue listing the paths.
  ##   timeout: int
  ##          : An optional operation timeout value in seconds. The period begins when the request is received by the service. If the timeout value elapses before the operation completes, the operation fails.
  ##   resource: string (required)
  ##           : The value must be "filesystem" for all filesystem operations.
  ##   filesystem: string (required)
  ##             : The filesystem identifier.  The value must start and end with a letter or number and must contain only letters, numbers, and the dash (-) character.  Consecutive dashes are not permitted.  All letters must be lowercase.  The value must have between 3 and 63 characters.
  ##   maxResults: int
  ##             : An optional value that specifies the maximum number of items to return. If omitted or greater than 5,000, the response will include up to 5,000 items.
  var path_564125 = newJObject()
  var query_564126 = newJObject()
  add(query_564126, "recursive", newJBool(recursive))
  add(query_564126, "directory", newJString(directory))
  add(query_564126, "continuation", newJString(continuation))
  add(query_564126, "timeout", newJInt(timeout))
  add(query_564126, "resource", newJString(resource))
  add(path_564125, "filesystem", newJString(filesystem))
  add(query_564126, "maxResults", newJInt(maxResults))
  result = call_564124.call(path_564125, query_564126, nil, nil, nil)

var pathList* = Call_PathList_564096(name: "pathList", meth: HttpMethod.HttpGet,
                                  host: "azure.local", route: "/{filesystem}",
                                  validator: validate_PathList_564097, base: "",
                                  url: url_PathList_564098,
                                  schemes: {Scheme.Https})
type
  Call_FilesystemSetProperties_564169 = ref object of OpenApiRestCall_563556
proc url_FilesystemSetProperties_564171(protocol: Scheme; host: string; base: string;
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

proc validate_FilesystemSetProperties_564170(path: JsonNode; query: JsonNode;
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
  var valid_564172 = path.getOrDefault("filesystem")
  valid_564172 = validateParameter(valid_564172, JString, required = true,
                                 default = nil)
  if valid_564172 != nil:
    section.add "filesystem", valid_564172
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : An optional operation timeout value in seconds. The period begins when the request is received by the service. If the timeout value elapses before the operation completes, the operation fails.
  ##   resource: JString (required)
  ##           : The value must be "filesystem" for all filesystem operations.
  section = newJObject()
  var valid_564173 = query.getOrDefault("timeout")
  valid_564173 = validateParameter(valid_564173, JInt, required = false, default = nil)
  if valid_564173 != nil:
    section.add "timeout", valid_564173
  assert query != nil,
        "query argument is necessary due to required `resource` field"
  var valid_564174 = query.getOrDefault("resource")
  valid_564174 = validateParameter(valid_564174, JString, required = true,
                                 default = newJString("filesystem"))
  if valid_564174 != nil:
    section.add "resource", valid_564174
  result.add "query", section
  ## parameters in `header` object:
  ##   x-ms-version: JString
  ##               : Specifies the version of the REST protocol used for processing the request. This is required when using shared key authorization.
  ##   x-ms-date: JString
  ##            : Specifies the Coordinated Universal Time (UTC) for the request.  This is required when using shared key authorization.
  ##   x-ms-properties: JString
  ##                  : Optional. User-defined properties to be stored with the filesystem, in the format of a comma-separated list of name and value pairs "n1=v1, n2=v2, ...", where each value is base64 encoded.  If the filesystem exists, any properties not included in the list will be removed.  All properties are removed if the header is omitted.  To merge new and existing properties, first get all existing properties and the current E-Tag, then make a conditional request with the E-Tag and include values for all properties.
  ##   If-Unmodified-Since: JString
  ##                      : Optional. A date and time value. Specify this header to perform the operation only if the resource has not been modified since the specified date and time.
  ##   x-ms-client-request-id: JString
  ##                         : A UUID recorded in the analytics logs for troubleshooting and correlation.
  ##   If-Modified-Since: JString
  ##                    : Optional. A date and time value. Specify this header to perform the operation only if the resource has been modified since the specified date and time.
  section = newJObject()
  var valid_564175 = header.getOrDefault("x-ms-version")
  valid_564175 = validateParameter(valid_564175, JString, required = false,
                                 default = nil)
  if valid_564175 != nil:
    section.add "x-ms-version", valid_564175
  var valid_564176 = header.getOrDefault("x-ms-date")
  valid_564176 = validateParameter(valid_564176, JString, required = false,
                                 default = nil)
  if valid_564176 != nil:
    section.add "x-ms-date", valid_564176
  var valid_564177 = header.getOrDefault("x-ms-properties")
  valid_564177 = validateParameter(valid_564177, JString, required = false,
                                 default = nil)
  if valid_564177 != nil:
    section.add "x-ms-properties", valid_564177
  var valid_564178 = header.getOrDefault("If-Unmodified-Since")
  valid_564178 = validateParameter(valid_564178, JString, required = false,
                                 default = nil)
  if valid_564178 != nil:
    section.add "If-Unmodified-Since", valid_564178
  var valid_564179 = header.getOrDefault("x-ms-client-request-id")
  valid_564179 = validateParameter(valid_564179, JString, required = false,
                                 default = nil)
  if valid_564179 != nil:
    section.add "x-ms-client-request-id", valid_564179
  var valid_564180 = header.getOrDefault("If-Modified-Since")
  valid_564180 = validateParameter(valid_564180, JString, required = false,
                                 default = nil)
  if valid_564180 != nil:
    section.add "If-Modified-Since", valid_564180
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564181: Call_FilesystemSetProperties_564169; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Set properties for the filesystem.  This operation supports conditional HTTP requests.  For more information, see [Specifying Conditional Headers for Blob Service Operations](https://docs.microsoft.com/en-us/rest/api/storageservices/specifying-conditional-headers-for-blob-service-operations).
  ## 
  let valid = call_564181.validator(path, query, header, formData, body)
  let scheme = call_564181.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564181.url(scheme.get, call_564181.host, call_564181.base,
                         call_564181.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564181, url, valid)

proc call*(call_564182: Call_FilesystemSetProperties_564169; filesystem: string;
          timeout: int = 0; resource: string = "filesystem"): Recallable =
  ## filesystemSetProperties
  ## Set properties for the filesystem.  This operation supports conditional HTTP requests.  For more information, see [Specifying Conditional Headers for Blob Service Operations](https://docs.microsoft.com/en-us/rest/api/storageservices/specifying-conditional-headers-for-blob-service-operations).
  ##   timeout: int
  ##          : An optional operation timeout value in seconds. The period begins when the request is received by the service. If the timeout value elapses before the operation completes, the operation fails.
  ##   resource: string (required)
  ##           : The value must be "filesystem" for all filesystem operations.
  ##   filesystem: string (required)
  ##             : The filesystem identifier.  The value must start and end with a letter or number and must contain only letters, numbers, and the dash (-) character.  Consecutive dashes are not permitted.  All letters must be lowercase.  The value must have between 3 and 63 characters.
  var path_564183 = newJObject()
  var query_564184 = newJObject()
  add(query_564184, "timeout", newJInt(timeout))
  add(query_564184, "resource", newJString(resource))
  add(path_564183, "filesystem", newJString(filesystem))
  result = call_564182.call(path_564183, query_564184, nil, nil, nil)

var filesystemSetProperties* = Call_FilesystemSetProperties_564169(
    name: "filesystemSetProperties", meth: HttpMethod.HttpPatch,
    host: "azure.local", route: "/{filesystem}",
    validator: validate_FilesystemSetProperties_564170, base: "",
    url: url_FilesystemSetProperties_564171, schemes: {Scheme.Https})
type
  Call_FilesystemDelete_564141 = ref object of OpenApiRestCall_563556
proc url_FilesystemDelete_564143(protocol: Scheme; host: string; base: string;
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

proc validate_FilesystemDelete_564142(path: JsonNode; query: JsonNode;
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
  var valid_564144 = path.getOrDefault("filesystem")
  valid_564144 = validateParameter(valid_564144, JString, required = true,
                                 default = nil)
  if valid_564144 != nil:
    section.add "filesystem", valid_564144
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : An optional operation timeout value in seconds. The period begins when the request is received by the service. If the timeout value elapses before the operation completes, the operation fails.
  ##   resource: JString (required)
  ##           : The value must be "filesystem" for all filesystem operations.
  section = newJObject()
  var valid_564145 = query.getOrDefault("timeout")
  valid_564145 = validateParameter(valid_564145, JInt, required = false, default = nil)
  if valid_564145 != nil:
    section.add "timeout", valid_564145
  assert query != nil,
        "query argument is necessary due to required `resource` field"
  var valid_564146 = query.getOrDefault("resource")
  valid_564146 = validateParameter(valid_564146, JString, required = true,
                                 default = newJString("filesystem"))
  if valid_564146 != nil:
    section.add "resource", valid_564146
  result.add "query", section
  ## parameters in `header` object:
  ##   x-ms-version: JString
  ##               : Specifies the version of the REST protocol used for processing the request. This is required when using shared key authorization.
  ##   x-ms-date: JString
  ##            : Specifies the Coordinated Universal Time (UTC) for the request.  This is required when using shared key authorization.
  ##   If-Unmodified-Since: JString
  ##                      : Optional. A date and time value. Specify this header to perform the operation only if the resource has not been modified since the specified date and time.
  ##   x-ms-client-request-id: JString
  ##                         : A UUID recorded in the analytics logs for troubleshooting and correlation.
  ##   If-Modified-Since: JString
  ##                    : Optional. A date and time value. Specify this header to perform the operation only if the resource has been modified since the specified date and time.
  section = newJObject()
  var valid_564147 = header.getOrDefault("x-ms-version")
  valid_564147 = validateParameter(valid_564147, JString, required = false,
                                 default = nil)
  if valid_564147 != nil:
    section.add "x-ms-version", valid_564147
  var valid_564148 = header.getOrDefault("x-ms-date")
  valid_564148 = validateParameter(valid_564148, JString, required = false,
                                 default = nil)
  if valid_564148 != nil:
    section.add "x-ms-date", valid_564148
  var valid_564149 = header.getOrDefault("If-Unmodified-Since")
  valid_564149 = validateParameter(valid_564149, JString, required = false,
                                 default = nil)
  if valid_564149 != nil:
    section.add "If-Unmodified-Since", valid_564149
  var valid_564150 = header.getOrDefault("x-ms-client-request-id")
  valid_564150 = validateParameter(valid_564150, JString, required = false,
                                 default = nil)
  if valid_564150 != nil:
    section.add "x-ms-client-request-id", valid_564150
  var valid_564151 = header.getOrDefault("If-Modified-Since")
  valid_564151 = validateParameter(valid_564151, JString, required = false,
                                 default = nil)
  if valid_564151 != nil:
    section.add "If-Modified-Since", valid_564151
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564152: Call_FilesystemDelete_564141; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Marks the filesystem for deletion.  When a filesystem is deleted, a filesystem with the same identifier cannot be created for at least 30 seconds. While the filesystem is being deleted, attempts to create a filesystem with the same identifier will fail with status code 409 (Conflict), with the service returning additional error information indicating that the filesystem is being deleted. All other operations, including operations on any files or directories within the filesystem, will fail with status code 404 (Not Found) while the filesystem is being deleted. This operation supports conditional HTTP requests.  For more information, see [Specifying Conditional Headers for Blob Service Operations](https://docs.microsoft.com/en-us/rest/api/storageservices/specifying-conditional-headers-for-blob-service-operations).
  ## 
  let valid = call_564152.validator(path, query, header, formData, body)
  let scheme = call_564152.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564152.url(scheme.get, call_564152.host, call_564152.base,
                         call_564152.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564152, url, valid)

proc call*(call_564153: Call_FilesystemDelete_564141; filesystem: string;
          timeout: int = 0; resource: string = "filesystem"): Recallable =
  ## filesystemDelete
  ## Marks the filesystem for deletion.  When a filesystem is deleted, a filesystem with the same identifier cannot be created for at least 30 seconds. While the filesystem is being deleted, attempts to create a filesystem with the same identifier will fail with status code 409 (Conflict), with the service returning additional error information indicating that the filesystem is being deleted. All other operations, including operations on any files or directories within the filesystem, will fail with status code 404 (Not Found) while the filesystem is being deleted. This operation supports conditional HTTP requests.  For more information, see [Specifying Conditional Headers for Blob Service Operations](https://docs.microsoft.com/en-us/rest/api/storageservices/specifying-conditional-headers-for-blob-service-operations).
  ##   timeout: int
  ##          : An optional operation timeout value in seconds. The period begins when the request is received by the service. If the timeout value elapses before the operation completes, the operation fails.
  ##   resource: string (required)
  ##           : The value must be "filesystem" for all filesystem operations.
  ##   filesystem: string (required)
  ##             : The filesystem identifier.  The value must start and end with a letter or number and must contain only letters, numbers, and the dash (-) character.  Consecutive dashes are not permitted.  All letters must be lowercase.  The value must have between 3 and 63 characters.
  var path_564154 = newJObject()
  var query_564155 = newJObject()
  add(query_564155, "timeout", newJInt(timeout))
  add(query_564155, "resource", newJString(resource))
  add(path_564154, "filesystem", newJString(filesystem))
  result = call_564153.call(path_564154, query_564155, nil, nil, nil)

var filesystemDelete* = Call_FilesystemDelete_564141(name: "filesystemDelete",
    meth: HttpMethod.HttpDelete, host: "azure.local", route: "/{filesystem}",
    validator: validate_FilesystemDelete_564142, base: "",
    url: url_FilesystemDelete_564143, schemes: {Scheme.Https})
type
  Call_PathCreate_564203 = ref object of OpenApiRestCall_563556
proc url_PathCreate_564205(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_PathCreate_564204(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564206 = path.getOrDefault("path")
  valid_564206 = validateParameter(valid_564206, JString, required = true,
                                 default = nil)
  if valid_564206 != nil:
    section.add "path", valid_564206
  var valid_564207 = path.getOrDefault("filesystem")
  valid_564207 = validateParameter(valid_564207, JString, required = true,
                                 default = nil)
  if valid_564207 != nil:
    section.add "filesystem", valid_564207
  result.add "path", section
  ## parameters in `query` object:
  ##   mode: JString
  ##       : Optional. Valid only when namespace is enabled. This parameter determines the behavior of the rename operation. The value must be "legacy" or "posix", and the default value will be "posix". 
  ##   continuation: JString
  ##               : Optional.  When renaming a directory, the number of paths that are renamed with each invocation is limited.  If the number of paths to be renamed exceeds this limit, a continuation token is returned in this response header.  When a continuation token is returned in the response, it must be specified in a subsequent invocation of the rename operation to continue renaming the directory.
  ##   timeout: JInt
  ##          : An optional operation timeout value in seconds. The period begins when the request is received by the service. If the timeout value elapses before the operation completes, the operation fails.
  ##   resource: JString
  ##           : Required only for Create File and Create Directory. The value must be "file" or "directory".
  section = newJObject()
  var valid_564208 = query.getOrDefault("mode")
  valid_564208 = validateParameter(valid_564208, JString, required = false,
                                 default = newJString("legacy"))
  if valid_564208 != nil:
    section.add "mode", valid_564208
  var valid_564209 = query.getOrDefault("continuation")
  valid_564209 = validateParameter(valid_564209, JString, required = false,
                                 default = nil)
  if valid_564209 != nil:
    section.add "continuation", valid_564209
  var valid_564210 = query.getOrDefault("timeout")
  valid_564210 = validateParameter(valid_564210, JInt, required = false, default = nil)
  if valid_564210 != nil:
    section.add "timeout", valid_564210
  var valid_564211 = query.getOrDefault("resource")
  valid_564211 = validateParameter(valid_564211, JString, required = false,
                                 default = newJString("directory"))
  if valid_564211 != nil:
    section.add "resource", valid_564211
  result.add "query", section
  ## parameters in `header` object:
  ##   Cache-Control: JString
  ##                : Optional.  The service stores this value and includes it in the "Cache-Control" response header for "Read File" operations for "Read File" operations.
  ##   x-ms-proposed-lease-id: JString
  ##                         : Optional for create operations.  Required when "x-ms-lease-action" is used.  A lease will be acquired using the proposed ID when the resource is created.
  ##   x-ms-lease-id: JString
  ##                : Optional.  A lease ID for the path specified in the URI.  The path to be overwritten must have an active lease and the lease ID must match.
  ##   x-ms-permissions: JString
  ##                   : Optional and only valid if Hierarchical Namespace is enabled for the account. Sets POSIX access permissions for the file owner, the file owning group, and others. Each class may be granted read, write, or execute permission.  The sticky bit is also supported.  Both symbolic (rwxrw-rw-) and 4-digit octal notation (e.g. 0766) are supported.
  ##   x-ms-version: JString
  ##               : Specifies the version of the REST protocol used for processing the request. This is required when using shared key authorization.
  ##   x-ms-source-if-unmodified-since: JString
  ##                                  : Optional. A date and time value. Specify this header to perform the rename operation only if the source has not been modified since the specified date and time.
  ##   x-ms-source-lease-id: JString
  ##                       : Optional for rename operations.  A lease ID for the source path.  The source path must have an active lease and the lease ID must match.
  ##   x-ms-rename-source: JString
  ##                     : An optional file or directory to be renamed.  The value must have the following format: "/{filesystem}/{path}".  If "x-ms-properties" is specified, the properties will overwrite the existing properties; otherwise, the existing properties will be preserved.
  ##   x-ms-date: JString
  ##            : Specifies the Coordinated Universal Time (UTC) for the request.  This is required when using shared key authorization.
  ##   x-ms-content-type: JString
  ##                    : Optional.  The service stores this value and includes it in the "Content-Type" response header for "Read File" operations.
  ##   x-ms-properties: JString
  ##                  : Optional.  User-defined properties to be stored with the file or directory, in the format of a comma-separated list of name and value pairs "n1=v1, n2=v2, ...", where each value is base64 encoded.
  ##   Content-Disposition: JString
  ##                      : Optional.  The service stores this value and includes it in the "Content-Disposition" response header for "Read File" operations.
  ##   Content-Encoding: JString
  ##                   : Optional.  Specifies which content encodings have been applied to the file. This value is returned to the client when the "Read File" operation is performed.
  ##   x-ms-content-disposition: JString
  ##                           : Optional.  The service stores this value and includes it in the "Content-Disposition" response header for "Read File" operations.
  ##   If-Unmodified-Since: JString
  ##                      : Optional. A date and time value. Specify this header to perform the operation only if the resource has not been modified since the specified date and time.
  ##   x-ms-client-request-id: JString
  ##                         : A UUID recorded in the analytics logs for troubleshooting and correlation.
  ##   If-Modified-Since: JString
  ##                    : Optional. A date and time value. Specify this header to perform the operation only if the resource has been modified since the specified date and time.
  ##   If-None-Match: JString
  ##                : Optional.  An ETag value or the special wildcard ("*") value. Specify this header to perform the operation only if the resource's ETag does not match the value specified. The ETag must be specified in quotes.
  ##   x-ms-source-if-none-match: JString
  ##                            : Optional.  An ETag value or the special wildcard ("*") value. Specify this header to perform the rename operation only if the source's ETag does not match the value specified. The ETag must be specified in quotes.
  ##   x-ms-cache-control: JString
  ##                     : Optional.  The service stores this value and includes it in the "Cache-Control" response header for "Read File" operations.
  ##   x-ms-source-if-modified-since: JString
  ##                                : Optional. A date and time value. Specify this header to perform the rename operation only if the source has been modified since the specified date and time.
  ##   Content-Language: JString
  ##                   : Optional.  Specifies the natural language used by the intended audience for the file.
  ##   x-ms-content-encoding: JString
  ##                        : Optional.  The service stores this value and includes it in the "Content-Encoding" response header for "Read File" operations.
  ##   x-ms-content-language: JString
  ##                        : Optional.  The service stores this value and includes it in the "Content-Language" response header for "Read File" operations.
  ##   If-Match: JString
  ##           : Optional.  An ETag value. Specify this header to perform the operation only if the resource's ETag matches the value specified. The ETag must be specified in quotes.
  ##   x-ms-source-if-match: JString
  ##                       : Optional.  An ETag value. Specify this header to perform the rename operation only if the source's ETag matches the value specified. The ETag must be specified in quotes.
  section = newJObject()
  var valid_564212 = header.getOrDefault("Cache-Control")
  valid_564212 = validateParameter(valid_564212, JString, required = false,
                                 default = nil)
  if valid_564212 != nil:
    section.add "Cache-Control", valid_564212
  var valid_564213 = header.getOrDefault("x-ms-proposed-lease-id")
  valid_564213 = validateParameter(valid_564213, JString, required = false,
                                 default = nil)
  if valid_564213 != nil:
    section.add "x-ms-proposed-lease-id", valid_564213
  var valid_564214 = header.getOrDefault("x-ms-lease-id")
  valid_564214 = validateParameter(valid_564214, JString, required = false,
                                 default = nil)
  if valid_564214 != nil:
    section.add "x-ms-lease-id", valid_564214
  var valid_564215 = header.getOrDefault("x-ms-permissions")
  valid_564215 = validateParameter(valid_564215, JString, required = false,
                                 default = nil)
  if valid_564215 != nil:
    section.add "x-ms-permissions", valid_564215
  var valid_564216 = header.getOrDefault("x-ms-version")
  valid_564216 = validateParameter(valid_564216, JString, required = false,
                                 default = nil)
  if valid_564216 != nil:
    section.add "x-ms-version", valid_564216
  var valid_564217 = header.getOrDefault("x-ms-source-if-unmodified-since")
  valid_564217 = validateParameter(valid_564217, JString, required = false,
                                 default = nil)
  if valid_564217 != nil:
    section.add "x-ms-source-if-unmodified-since", valid_564217
  var valid_564218 = header.getOrDefault("x-ms-source-lease-id")
  valid_564218 = validateParameter(valid_564218, JString, required = false,
                                 default = nil)
  if valid_564218 != nil:
    section.add "x-ms-source-lease-id", valid_564218
  var valid_564219 = header.getOrDefault("x-ms-rename-source")
  valid_564219 = validateParameter(valid_564219, JString, required = false,
                                 default = nil)
  if valid_564219 != nil:
    section.add "x-ms-rename-source", valid_564219
  var valid_564220 = header.getOrDefault("x-ms-date")
  valid_564220 = validateParameter(valid_564220, JString, required = false,
                                 default = nil)
  if valid_564220 != nil:
    section.add "x-ms-date", valid_564220
  var valid_564221 = header.getOrDefault("x-ms-content-type")
  valid_564221 = validateParameter(valid_564221, JString, required = false,
                                 default = nil)
  if valid_564221 != nil:
    section.add "x-ms-content-type", valid_564221
  var valid_564222 = header.getOrDefault("x-ms-properties")
  valid_564222 = validateParameter(valid_564222, JString, required = false,
                                 default = nil)
  if valid_564222 != nil:
    section.add "x-ms-properties", valid_564222
  var valid_564223 = header.getOrDefault("Content-Disposition")
  valid_564223 = validateParameter(valid_564223, JString, required = false,
                                 default = nil)
  if valid_564223 != nil:
    section.add "Content-Disposition", valid_564223
  var valid_564224 = header.getOrDefault("Content-Encoding")
  valid_564224 = validateParameter(valid_564224, JString, required = false,
                                 default = nil)
  if valid_564224 != nil:
    section.add "Content-Encoding", valid_564224
  var valid_564225 = header.getOrDefault("x-ms-content-disposition")
  valid_564225 = validateParameter(valid_564225, JString, required = false,
                                 default = nil)
  if valid_564225 != nil:
    section.add "x-ms-content-disposition", valid_564225
  var valid_564226 = header.getOrDefault("If-Unmodified-Since")
  valid_564226 = validateParameter(valid_564226, JString, required = false,
                                 default = nil)
  if valid_564226 != nil:
    section.add "If-Unmodified-Since", valid_564226
  var valid_564227 = header.getOrDefault("x-ms-client-request-id")
  valid_564227 = validateParameter(valid_564227, JString, required = false,
                                 default = nil)
  if valid_564227 != nil:
    section.add "x-ms-client-request-id", valid_564227
  var valid_564228 = header.getOrDefault("If-Modified-Since")
  valid_564228 = validateParameter(valid_564228, JString, required = false,
                                 default = nil)
  if valid_564228 != nil:
    section.add "If-Modified-Since", valid_564228
  var valid_564229 = header.getOrDefault("If-None-Match")
  valid_564229 = validateParameter(valid_564229, JString, required = false,
                                 default = nil)
  if valid_564229 != nil:
    section.add "If-None-Match", valid_564229
  var valid_564230 = header.getOrDefault("x-ms-source-if-none-match")
  valid_564230 = validateParameter(valid_564230, JString, required = false,
                                 default = nil)
  if valid_564230 != nil:
    section.add "x-ms-source-if-none-match", valid_564230
  var valid_564231 = header.getOrDefault("x-ms-cache-control")
  valid_564231 = validateParameter(valid_564231, JString, required = false,
                                 default = nil)
  if valid_564231 != nil:
    section.add "x-ms-cache-control", valid_564231
  var valid_564232 = header.getOrDefault("x-ms-source-if-modified-since")
  valid_564232 = validateParameter(valid_564232, JString, required = false,
                                 default = nil)
  if valid_564232 != nil:
    section.add "x-ms-source-if-modified-since", valid_564232
  var valid_564233 = header.getOrDefault("Content-Language")
  valid_564233 = validateParameter(valid_564233, JString, required = false,
                                 default = nil)
  if valid_564233 != nil:
    section.add "Content-Language", valid_564233
  var valid_564234 = header.getOrDefault("x-ms-content-encoding")
  valid_564234 = validateParameter(valid_564234, JString, required = false,
                                 default = nil)
  if valid_564234 != nil:
    section.add "x-ms-content-encoding", valid_564234
  var valid_564235 = header.getOrDefault("x-ms-content-language")
  valid_564235 = validateParameter(valid_564235, JString, required = false,
                                 default = nil)
  if valid_564235 != nil:
    section.add "x-ms-content-language", valid_564235
  var valid_564236 = header.getOrDefault("If-Match")
  valid_564236 = validateParameter(valid_564236, JString, required = false,
                                 default = nil)
  if valid_564236 != nil:
    section.add "If-Match", valid_564236
  var valid_564237 = header.getOrDefault("x-ms-source-if-match")
  valid_564237 = validateParameter(valid_564237, JString, required = false,
                                 default = nil)
  if valid_564237 != nil:
    section.add "x-ms-source-if-match", valid_564237
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564238: Call_PathCreate_564203; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or rename a file or directory.    By default, the destination is overwritten and if the destination already exists and has a lease the lease is broken.  This operation supports conditional HTTP requests.  For more information, see [Specifying Conditional Headers for Blob Service Operations](https://docs.microsoft.com/en-us/rest/api/storageservices/specifying-conditional-headers-for-blob-service-operations).  To fail if the destination already exists, use a conditional request with If-None-Match: "*".
  ## 
  let valid = call_564238.validator(path, query, header, formData, body)
  let scheme = call_564238.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564238.url(scheme.get, call_564238.host, call_564238.base,
                         call_564238.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564238, url, valid)

proc call*(call_564239: Call_PathCreate_564203; path: string; filesystem: string;
          mode: string = "legacy"; continuation: string = ""; timeout: int = 0;
          resource: string = "directory"): Recallable =
  ## pathCreate
  ## Create or rename a file or directory.    By default, the destination is overwritten and if the destination already exists and has a lease the lease is broken.  This operation supports conditional HTTP requests.  For more information, see [Specifying Conditional Headers for Blob Service Operations](https://docs.microsoft.com/en-us/rest/api/storageservices/specifying-conditional-headers-for-blob-service-operations).  To fail if the destination already exists, use a conditional request with If-None-Match: "*".
  ##   mode: string
  ##       : Optional. Valid only when namespace is enabled. This parameter determines the behavior of the rename operation. The value must be "legacy" or "posix", and the default value will be "posix". 
  ##   continuation: string
  ##               : Optional.  When renaming a directory, the number of paths that are renamed with each invocation is limited.  If the number of paths to be renamed exceeds this limit, a continuation token is returned in this response header.  When a continuation token is returned in the response, it must be specified in a subsequent invocation of the rename operation to continue renaming the directory.
  ##   timeout: int
  ##          : An optional operation timeout value in seconds. The period begins when the request is received by the service. If the timeout value elapses before the operation completes, the operation fails.
  ##   resource: string
  ##           : Required only for Create File and Create Directory. The value must be "file" or "directory".
  ##   path: string (required)
  ##       : The file or directory path.
  ##   filesystem: string (required)
  ##             : The filesystem identifier.
  var path_564240 = newJObject()
  var query_564241 = newJObject()
  add(query_564241, "mode", newJString(mode))
  add(query_564241, "continuation", newJString(continuation))
  add(query_564241, "timeout", newJInt(timeout))
  add(query_564241, "resource", newJString(resource))
  add(path_564240, "path", newJString(path))
  add(path_564240, "filesystem", newJString(filesystem))
  result = call_564239.call(path_564240, query_564241, nil, nil, nil)

var pathCreate* = Call_PathCreate_564203(name: "pathCreate",
                                      meth: HttpMethod.HttpPut,
                                      host: "azure.local",
                                      route: "/{filesystem}/{path}",
                                      validator: validate_PathCreate_564204,
                                      base: "", url: url_PathCreate_564205,
                                      schemes: {Scheme.Https})
type
  Call_PathGetProperties_564284 = ref object of OpenApiRestCall_563556
proc url_PathGetProperties_564286(protocol: Scheme; host: string; base: string;
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

proc validate_PathGetProperties_564285(path: JsonNode; query: JsonNode;
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
  var valid_564287 = path.getOrDefault("path")
  valid_564287 = validateParameter(valid_564287, JString, required = true,
                                 default = nil)
  if valid_564287 != nil:
    section.add "path", valid_564287
  var valid_564288 = path.getOrDefault("filesystem")
  valid_564288 = validateParameter(valid_564288, JString, required = true,
                                 default = nil)
  if valid_564288 != nil:
    section.add "filesystem", valid_564288
  result.add "path", section
  ## parameters in `query` object:
  ##   action: JString
  ##         : Optional. If the value is "getAccessControl" the access control list is returned in the response headers (Hierarchical Namespace must be enabled for the account).
  ##   timeout: JInt
  ##          : An optional operation timeout value in seconds. The period begins when the request is received by the service. If the timeout value elapses before the operation completes, the operation fails.
  section = newJObject()
  var valid_564289 = query.getOrDefault("action")
  valid_564289 = validateParameter(valid_564289, JString, required = false,
                                 default = newJString("getAccessControl"))
  if valid_564289 != nil:
    section.add "action", valid_564289
  var valid_564290 = query.getOrDefault("timeout")
  valid_564290 = validateParameter(valid_564290, JInt, required = false, default = nil)
  if valid_564290 != nil:
    section.add "timeout", valid_564290
  result.add "query", section
  ## parameters in `header` object:
  ##   x-ms-version: JString
  ##               : Specifies the version of the REST protocol used for processing the request. This is required when using shared key authorization.
  ##   x-ms-date: JString
  ##            : Specifies the Coordinated Universal Time (UTC) for the request.  This is required when using shared key authorization.
  ##   If-Unmodified-Since: JString
  ##                      : Optional. A date and time value. Specify this header to perform the operation only if the resource has not been modified since the specified date and time.
  ##   x-ms-client-request-id: JString
  ##                         : A UUID recorded in the analytics logs for troubleshooting and correlation.
  ##   If-Modified-Since: JString
  ##                    : Optional. A date and time value. Specify this header to perform the operation only if the resource has been modified since the specified date and time.
  ##   If-None-Match: JString
  ##                : Optional.  An ETag value or the special wildcard ("*") value. Specify this header to perform the operation only if the resource's ETag does not match the value specified. The ETag must be specified in quotes.
  ##   If-Match: JString
  ##           : Optional.  An ETag value. Specify this header to perform the operation only if the resource's ETag matches the value specified. The ETag must be specified in quotes.
  section = newJObject()
  var valid_564291 = header.getOrDefault("x-ms-version")
  valid_564291 = validateParameter(valid_564291, JString, required = false,
                                 default = nil)
  if valid_564291 != nil:
    section.add "x-ms-version", valid_564291
  var valid_564292 = header.getOrDefault("x-ms-date")
  valid_564292 = validateParameter(valid_564292, JString, required = false,
                                 default = nil)
  if valid_564292 != nil:
    section.add "x-ms-date", valid_564292
  var valid_564293 = header.getOrDefault("If-Unmodified-Since")
  valid_564293 = validateParameter(valid_564293, JString, required = false,
                                 default = nil)
  if valid_564293 != nil:
    section.add "If-Unmodified-Since", valid_564293
  var valid_564294 = header.getOrDefault("x-ms-client-request-id")
  valid_564294 = validateParameter(valid_564294, JString, required = false,
                                 default = nil)
  if valid_564294 != nil:
    section.add "x-ms-client-request-id", valid_564294
  var valid_564295 = header.getOrDefault("If-Modified-Since")
  valid_564295 = validateParameter(valid_564295, JString, required = false,
                                 default = nil)
  if valid_564295 != nil:
    section.add "If-Modified-Since", valid_564295
  var valid_564296 = header.getOrDefault("If-None-Match")
  valid_564296 = validateParameter(valid_564296, JString, required = false,
                                 default = nil)
  if valid_564296 != nil:
    section.add "If-None-Match", valid_564296
  var valid_564297 = header.getOrDefault("If-Match")
  valid_564297 = validateParameter(valid_564297, JString, required = false,
                                 default = nil)
  if valid_564297 != nil:
    section.add "If-Match", valid_564297
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564298: Call_PathGetProperties_564284; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the properties for a file or directory, and optionally include the access control list.  This operation supports conditional HTTP requests.  For more information, see [Specifying Conditional Headers for Blob Service Operations](https://docs.microsoft.com/en-us/rest/api/storageservices/specifying-conditional-headers-for-blob-service-operations).
  ## 
  let valid = call_564298.validator(path, query, header, formData, body)
  let scheme = call_564298.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564298.url(scheme.get, call_564298.host, call_564298.base,
                         call_564298.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564298, url, valid)

proc call*(call_564299: Call_PathGetProperties_564284; path: string;
          filesystem: string; action: string = "getAccessControl"; timeout: int = 0): Recallable =
  ## pathGetProperties
  ## Get the properties for a file or directory, and optionally include the access control list.  This operation supports conditional HTTP requests.  For more information, see [Specifying Conditional Headers for Blob Service Operations](https://docs.microsoft.com/en-us/rest/api/storageservices/specifying-conditional-headers-for-blob-service-operations).
  ##   action: string
  ##         : Optional. If the value is "getAccessControl" the access control list is returned in the response headers (Hierarchical Namespace must be enabled for the account).
  ##   timeout: int
  ##          : An optional operation timeout value in seconds. The period begins when the request is received by the service. If the timeout value elapses before the operation completes, the operation fails.
  ##   path: string (required)
  ##       : The file or directory path.
  ##   filesystem: string (required)
  ##             : The filesystem identifier.
  var path_564300 = newJObject()
  var query_564301 = newJObject()
  add(query_564301, "action", newJString(action))
  add(query_564301, "timeout", newJInt(timeout))
  add(path_564300, "path", newJString(path))
  add(path_564300, "filesystem", newJString(filesystem))
  result = call_564299.call(path_564300, query_564301, nil, nil, nil)

var pathGetProperties* = Call_PathGetProperties_564284(name: "pathGetProperties",
    meth: HttpMethod.HttpHead, host: "azure.local", route: "/{filesystem}/{path}",
    validator: validate_PathGetProperties_564285, base: "",
    url: url_PathGetProperties_564286, schemes: {Scheme.Https})
type
  Call_PathLease_564242 = ref object of OpenApiRestCall_563556
proc url_PathLease_564244(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_PathLease_564243(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564245 = path.getOrDefault("path")
  valid_564245 = validateParameter(valid_564245, JString, required = true,
                                 default = nil)
  if valid_564245 != nil:
    section.add "path", valid_564245
  var valid_564246 = path.getOrDefault("filesystem")
  valid_564246 = validateParameter(valid_564246, JString, required = true,
                                 default = nil)
  if valid_564246 != nil:
    section.add "filesystem", valid_564246
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : An optional operation timeout value in seconds. The period begins when the request is received by the service. If the timeout value elapses before the operation completes, the operation fails.
  section = newJObject()
  var valid_564247 = query.getOrDefault("timeout")
  valid_564247 = validateParameter(valid_564247, JInt, required = false, default = nil)
  if valid_564247 != nil:
    section.add "timeout", valid_564247
  result.add "query", section
  ## parameters in `header` object:
  ##   x-ms-lease-duration: JInt
  ##                      : The lease duration is required to acquire a lease, and specifies the duration of the lease in seconds.  The lease duration must be between 15 and 60 seconds or -1 for infinite lease.
  ##   x-ms-proposed-lease-id: JString
  ##                         : Required when "x-ms-lease-action" is "acquire" or "change".  A lease will be acquired with this lease ID if the operation is successful.
  ##   x-ms-lease-id: JString
  ##                : Required when "x-ms-lease-action" is "renew", "change" or "release". For the renew and release actions, this must match the current lease ID.
  ##   x-ms-version: JString
  ##               : Specifies the version of the REST protocol used for processing the request. This is required when using shared key authorization.
  ##   x-ms-date: JString
  ##            : Specifies the Coordinated Universal Time (UTC) for the request.  This is required when using shared key authorization.
  ##   If-Unmodified-Since: JString
  ##                      : Optional. A date and time value. Specify this header to perform the operation only if the resource has not been modified since the specified date and time.
  ##   x-ms-client-request-id: JString
  ##                         : A UUID recorded in the analytics logs for troubleshooting and correlation.
  ##   If-Modified-Since: JString
  ##                    : Optional. A date and time value. Specify this header to perform the operation only if the resource has been modified since the specified date and time.
  ##   If-None-Match: JString
  ##                : Optional.  An ETag value or the special wildcard ("*") value. Specify this header to perform the operation only if the resource's ETag does not match the value specified. The ETag must be specified in quotes.
  ##   x-ms-lease-break-period: JInt
  ##                          : The lease break period duration is optional to break a lease, and  specifies the break period of the lease in seconds.  The lease break  duration must be between 0 and 60 seconds.
  ##   x-ms-lease-action: JString (required)
  ##                    : There are five lease actions: "acquire", "break", "change", "renew", and "release". Use "acquire" and specify the "x-ms-proposed-lease-id" and "x-ms-lease-duration" to acquire a new lease. Use "break" to break an existing lease. When a lease is broken, the lease break period is allowed to elapse, during which time no lease operation except break and release can be performed on the file. When a lease is successfully broken, the response indicates the interval in seconds until a new lease can be acquired. Use "change" and specify the current lease ID in "x-ms-lease-id" and the new lease ID in "x-ms-proposed-lease-id" to change the lease ID of an active lease. Use "renew" and specify the "x-ms-lease-id" to renew an existing lease. Use "release" and specify the "x-ms-lease-id" to release a lease.
  ##   If-Match: JString
  ##           : Optional.  An ETag value. Specify this header to perform the operation only if the resource's ETag matches the value specified. The ETag must be specified in quotes.
  section = newJObject()
  var valid_564248 = header.getOrDefault("x-ms-lease-duration")
  valid_564248 = validateParameter(valid_564248, JInt, required = false, default = nil)
  if valid_564248 != nil:
    section.add "x-ms-lease-duration", valid_564248
  var valid_564249 = header.getOrDefault("x-ms-proposed-lease-id")
  valid_564249 = validateParameter(valid_564249, JString, required = false,
                                 default = nil)
  if valid_564249 != nil:
    section.add "x-ms-proposed-lease-id", valid_564249
  var valid_564250 = header.getOrDefault("x-ms-lease-id")
  valid_564250 = validateParameter(valid_564250, JString, required = false,
                                 default = nil)
  if valid_564250 != nil:
    section.add "x-ms-lease-id", valid_564250
  var valid_564251 = header.getOrDefault("x-ms-version")
  valid_564251 = validateParameter(valid_564251, JString, required = false,
                                 default = nil)
  if valid_564251 != nil:
    section.add "x-ms-version", valid_564251
  var valid_564252 = header.getOrDefault("x-ms-date")
  valid_564252 = validateParameter(valid_564252, JString, required = false,
                                 default = nil)
  if valid_564252 != nil:
    section.add "x-ms-date", valid_564252
  var valid_564253 = header.getOrDefault("If-Unmodified-Since")
  valid_564253 = validateParameter(valid_564253, JString, required = false,
                                 default = nil)
  if valid_564253 != nil:
    section.add "If-Unmodified-Since", valid_564253
  var valid_564254 = header.getOrDefault("x-ms-client-request-id")
  valid_564254 = validateParameter(valid_564254, JString, required = false,
                                 default = nil)
  if valid_564254 != nil:
    section.add "x-ms-client-request-id", valid_564254
  var valid_564255 = header.getOrDefault("If-Modified-Since")
  valid_564255 = validateParameter(valid_564255, JString, required = false,
                                 default = nil)
  if valid_564255 != nil:
    section.add "If-Modified-Since", valid_564255
  var valid_564256 = header.getOrDefault("If-None-Match")
  valid_564256 = validateParameter(valid_564256, JString, required = false,
                                 default = nil)
  if valid_564256 != nil:
    section.add "If-None-Match", valid_564256
  var valid_564257 = header.getOrDefault("x-ms-lease-break-period")
  valid_564257 = validateParameter(valid_564257, JInt, required = false, default = nil)
  if valid_564257 != nil:
    section.add "x-ms-lease-break-period", valid_564257
  assert header != nil, "header argument is necessary due to required `x-ms-lease-action` field"
  var valid_564258 = header.getOrDefault("x-ms-lease-action")
  valid_564258 = validateParameter(valid_564258, JString, required = true,
                                 default = newJString("acquire"))
  if valid_564258 != nil:
    section.add "x-ms-lease-action", valid_564258
  var valid_564259 = header.getOrDefault("If-Match")
  valid_564259 = validateParameter(valid_564259, JString, required = false,
                                 default = nil)
  if valid_564259 != nil:
    section.add "If-Match", valid_564259
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564260: Call_PathLease_564242; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create and manage a lease to restrict write and delete access to the path. This operation supports conditional HTTP requests.  For more information, see [Specifying Conditional Headers for Blob Service Operations](https://docs.microsoft.com/en-us/rest/api/storageservices/specifying-conditional-headers-for-blob-service-operations).
  ## 
  let valid = call_564260.validator(path, query, header, formData, body)
  let scheme = call_564260.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564260.url(scheme.get, call_564260.host, call_564260.base,
                         call_564260.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564260, url, valid)

proc call*(call_564261: Call_PathLease_564242; path: string; filesystem: string;
          timeout: int = 0): Recallable =
  ## pathLease
  ## Create and manage a lease to restrict write and delete access to the path. This operation supports conditional HTTP requests.  For more information, see [Specifying Conditional Headers for Blob Service Operations](https://docs.microsoft.com/en-us/rest/api/storageservices/specifying-conditional-headers-for-blob-service-operations).
  ##   timeout: int
  ##          : An optional operation timeout value in seconds. The period begins when the request is received by the service. If the timeout value elapses before the operation completes, the operation fails.
  ##   path: string (required)
  ##       : The file or directory path.
  ##   filesystem: string (required)
  ##             : The filesystem identifier.
  var path_564262 = newJObject()
  var query_564263 = newJObject()
  add(query_564263, "timeout", newJInt(timeout))
  add(path_564262, "path", newJString(path))
  add(path_564262, "filesystem", newJString(filesystem))
  result = call_564261.call(path_564262, query_564263, nil, nil, nil)

var pathLease* = Call_PathLease_564242(name: "pathLease", meth: HttpMethod.HttpPost,
                                    host: "azure.local",
                                    route: "/{filesystem}/{path}",
                                    validator: validate_PathLease_564243,
                                    base: "", url: url_PathLease_564244,
                                    schemes: {Scheme.Https})
type
  Call_PathRead_564185 = ref object of OpenApiRestCall_563556
proc url_PathRead_564187(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_PathRead_564186(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564188 = path.getOrDefault("path")
  valid_564188 = validateParameter(valid_564188, JString, required = true,
                                 default = nil)
  if valid_564188 != nil:
    section.add "path", valid_564188
  var valid_564189 = path.getOrDefault("filesystem")
  valid_564189 = validateParameter(valid_564189, JString, required = true,
                                 default = nil)
  if valid_564189 != nil:
    section.add "filesystem", valid_564189
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : An optional operation timeout value in seconds. The period begins when the request is received by the service. If the timeout value elapses before the operation completes, the operation fails.
  section = newJObject()
  var valid_564190 = query.getOrDefault("timeout")
  valid_564190 = validateParameter(valid_564190, JInt, required = false, default = nil)
  if valid_564190 != nil:
    section.add "timeout", valid_564190
  result.add "query", section
  ## parameters in `header` object:
  ##   x-ms-version: JString
  ##               : Specifies the version of the REST protocol used for processing the request. This is required when using shared key authorization.
  ##   x-ms-date: JString
  ##            : Specifies the Coordinated Universal Time (UTC) for the request.  This is required when using shared key authorization.
  ##   If-Unmodified-Since: JString
  ##                      : Optional. A date and time value. Specify this header to perform the operation only if the resource has not been modified since the specified date and time.
  ##   x-ms-client-request-id: JString
  ##                         : A UUID recorded in the analytics logs for troubleshooting and correlation.
  ##   Range: JString
  ##        : The HTTP Range request header specifies one or more byte ranges of the resource to be retrieved.
  ##   If-Modified-Since: JString
  ##                    : Optional. A date and time value. Specify this header to perform the operation only if the resource has been modified since the specified date and time.
  ##   If-None-Match: JString
  ##                : Optional.  An ETag value or the special wildcard ("*") value. Specify this header to perform the operation only if the resource's ETag does not match the value specified. The ETag must be specified in quotes.
  ##   If-Match: JString
  ##           : Optional.  An ETag value. Specify this header to perform the operation only if the resource's ETag matches the value specified. The ETag must be specified in quotes.
  section = newJObject()
  var valid_564191 = header.getOrDefault("x-ms-version")
  valid_564191 = validateParameter(valid_564191, JString, required = false,
                                 default = nil)
  if valid_564191 != nil:
    section.add "x-ms-version", valid_564191
  var valid_564192 = header.getOrDefault("x-ms-date")
  valid_564192 = validateParameter(valid_564192, JString, required = false,
                                 default = nil)
  if valid_564192 != nil:
    section.add "x-ms-date", valid_564192
  var valid_564193 = header.getOrDefault("If-Unmodified-Since")
  valid_564193 = validateParameter(valid_564193, JString, required = false,
                                 default = nil)
  if valid_564193 != nil:
    section.add "If-Unmodified-Since", valid_564193
  var valid_564194 = header.getOrDefault("x-ms-client-request-id")
  valid_564194 = validateParameter(valid_564194, JString, required = false,
                                 default = nil)
  if valid_564194 != nil:
    section.add "x-ms-client-request-id", valid_564194
  var valid_564195 = header.getOrDefault("Range")
  valid_564195 = validateParameter(valid_564195, JString, required = false,
                                 default = nil)
  if valid_564195 != nil:
    section.add "Range", valid_564195
  var valid_564196 = header.getOrDefault("If-Modified-Since")
  valid_564196 = validateParameter(valid_564196, JString, required = false,
                                 default = nil)
  if valid_564196 != nil:
    section.add "If-Modified-Since", valid_564196
  var valid_564197 = header.getOrDefault("If-None-Match")
  valid_564197 = validateParameter(valid_564197, JString, required = false,
                                 default = nil)
  if valid_564197 != nil:
    section.add "If-None-Match", valid_564197
  var valid_564198 = header.getOrDefault("If-Match")
  valid_564198 = validateParameter(valid_564198, JString, required = false,
                                 default = nil)
  if valid_564198 != nil:
    section.add "If-Match", valid_564198
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564199: Call_PathRead_564185; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Read the contents of a file.  For read operations, range requests are supported. This operation supports conditional HTTP requests.  For more information, see [Specifying Conditional Headers for Blob Service Operations](https://docs.microsoft.com/en-us/rest/api/storageservices/specifying-conditional-headers-for-blob-service-operations).
  ## 
  let valid = call_564199.validator(path, query, header, formData, body)
  let scheme = call_564199.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564199.url(scheme.get, call_564199.host, call_564199.base,
                         call_564199.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564199, url, valid)

proc call*(call_564200: Call_PathRead_564185; path: string; filesystem: string;
          timeout: int = 0): Recallable =
  ## pathRead
  ## Read the contents of a file.  For read operations, range requests are supported. This operation supports conditional HTTP requests.  For more information, see [Specifying Conditional Headers for Blob Service Operations](https://docs.microsoft.com/en-us/rest/api/storageservices/specifying-conditional-headers-for-blob-service-operations).
  ##   timeout: int
  ##          : An optional operation timeout value in seconds. The period begins when the request is received by the service. If the timeout value elapses before the operation completes, the operation fails.
  ##   path: string (required)
  ##       : The file or directory path.
  ##   filesystem: string (required)
  ##             : The filesystem identifier.
  var path_564201 = newJObject()
  var query_564202 = newJObject()
  add(query_564202, "timeout", newJInt(timeout))
  add(path_564201, "path", newJString(path))
  add(path_564201, "filesystem", newJString(filesystem))
  result = call_564200.call(path_564201, query_564202, nil, nil, nil)

var pathRead* = Call_PathRead_564185(name: "pathRead", meth: HttpMethod.HttpGet,
                                  host: "azure.local",
                                  route: "/{filesystem}/{path}",
                                  validator: validate_PathRead_564186, base: "",
                                  url: url_PathRead_564187,
                                  schemes: {Scheme.Https})
type
  Call_PathUpdate_564302 = ref object of OpenApiRestCall_563556
proc url_PathUpdate_564304(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_PathUpdate_564303(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564305 = path.getOrDefault("path")
  valid_564305 = validateParameter(valid_564305, JString, required = true,
                                 default = nil)
  if valid_564305 != nil:
    section.add "path", valid_564305
  var valid_564306 = path.getOrDefault("filesystem")
  valid_564306 = validateParameter(valid_564306, JString, required = true,
                                 default = nil)
  if valid_564306 != nil:
    section.add "filesystem", valid_564306
  result.add "path", section
  ## parameters in `query` object:
  ##   action: JString (required)
  ##         : The action must be "append" to upload data to be appended to a file, "flush" to flush previously uploaded data to a file, "setProperties" to set the properties of a file or directory, or "setAccessControl" to set the owner, group, permissions, or access control list for a file or directory.  Note that Hierarchical Namespace must be enabled for the account in order to use access control.  Also note that the Access Control List (ACL) includes permissions for the owner, owning group, and others, so the x-ms-permissions and x-ms-acl request headers are mutually exclusive.
  ##   position: JInt
  ##           : This parameter allows the caller to upload data in parallel and control the order in which it is appended to the file.  It is required when uploading data to be appended to the file and when flushing previously uploaded data to the file.  The value must be the position where the data is to be appended.  Uploaded data is not immediately flushed, or written, to the file.  To flush, the previously uploaded data must be contiguous, the position parameter must be specified and equal to the length of the file after all data has been written, and there must not be a request entity body included with the request.
  ##   retainUncommittedData: JBool
  ##                        : Valid only for flush operations.  If "true", uncommitted data is retained after the flush operation completes; otherwise, the uncommitted data is deleted after the flush operation.  The default is false.  Data at offsets less than the specified position are written to the file when flush succeeds, but this optional parameter allows data after the flush position to be retained for a future flush operation.
  ##   timeout: JInt
  ##          : An optional operation timeout value in seconds. The period begins when the request is received by the service. If the timeout value elapses before the operation completes, the operation fails.
  section = newJObject()
  assert query != nil, "query argument is necessary due to required `action` field"
  var valid_564307 = query.getOrDefault("action")
  valid_564307 = validateParameter(valid_564307, JString, required = true,
                                 default = newJString("append"))
  if valid_564307 != nil:
    section.add "action", valid_564307
  var valid_564308 = query.getOrDefault("position")
  valid_564308 = validateParameter(valid_564308, JInt, required = false, default = nil)
  if valid_564308 != nil:
    section.add "position", valid_564308
  var valid_564309 = query.getOrDefault("retainUncommittedData")
  valid_564309 = validateParameter(valid_564309, JBool, required = false, default = nil)
  if valid_564309 != nil:
    section.add "retainUncommittedData", valid_564309
  var valid_564310 = query.getOrDefault("timeout")
  valid_564310 = validateParameter(valid_564310, JInt, required = false, default = nil)
  if valid_564310 != nil:
    section.add "timeout", valid_564310
  result.add "query", section
  ## parameters in `header` object:
  ##   x-ms-lease-id: JString
  ##                : The lease ID must be specified if there is an active lease.
  ##   x-ms-permissions: JString
  ##                   : Optional and only valid if Hierarchical Namespace is enabled for the account. Sets POSIX access permissions for the file owner, the file owning group, and others. Each class may be granted read, write, or execute permission.  The sticky bit is also supported.  Both symbolic (rwxrw-rw-) and 4-digit octal notation (e.g. 0766) are supported. Invalid in conjunction with x-ms-acl.
  ##   x-ms-version: JString
  ##               : Specifies the version of the REST protocol used for processing the request. This is required when using shared key authorization.
  ##   Content-Length: JString
  ##                 : Required for "Append Data" and "Flush Data".  Must be 0 for "Flush Data".  Must be the length of the request content in bytes for "Append Data".
  ##   x-ms-date: JString
  ##            : Specifies the Coordinated Universal Time (UTC) for the request.  This is required when using shared key authorization.
  ##   x-ms-content-type: JString
  ##                    : Optional and only valid for flush and set properties operations.  The service stores this value and includes it in the "Content-Type" response header for "Read File" operations.
  ##   x-ms-properties: JString
  ##                  : Optional.  User-defined properties to be stored with the file or directory, in the format of a comma-separated list of name and value pairs "n1=v1, n2=v2, ...", where each value is base64 encoded.  Valid only for the setProperties operation.  If the file or directory exists, any properties not included in the list will be removed.  All properties are removed if the header is omitted.  To merge new and existing properties, first get all existing properties and the current E-Tag, then make a conditional request with the E-Tag and include values for all properties.
  ##   x-ms-acl: JString
  ##           : Optional and valid only for the setAccessControl operation. Sets POSIX access control rights on files and directories. The value is a comma-separated list of access control entries that fully replaces the existing access control list (ACL).  Each access control entry (ACE) consists of a scope, a type, a user or group identifier, and permissions in the format "[scope:][type]:[id]:[permissions]". The scope must be "default" to indicate the ACE belongs to the default ACL for a directory; otherwise scope is implicit and the ACE belongs to the access ACL.  There are four ACE types: "user" grants rights to the owner or a named user, "group" grants rights to the owning group or a named group, "mask" restricts rights granted to named users and the members of groups, and "other" grants rights to all users not found in any of the other entries. The user or group identifier is omitted for entries of type "mask" and "other".  The user or group identifier is also omitted for the owner and owning group.  The permission field is a 3-character sequence where the first character is 'r' to grant read access, the second character is 'w' to grant write access, and the third character is 'x' to grant execute permission.  If access is not granted, the '-' character is used to denote that the permission is denied. For example, the following ACL grants read, write, and execute rights to the file owner and john.doe@contoso, the read right to the owning group, and nothing to everyone else: "user::rwx,user:john.doe@contoso:rwx,group::r--,other::---,mask=rwx". Invalid in conjunction with x-ms-permissions.
  ##   x-ms-content-disposition: JString
  ##                           : Optional and only valid for flush and set properties operations.  The service stores this value and includes it in the "Content-Disposition" response header for "Read File" operations.
  ##   If-Unmodified-Since: JString
  ##                      : Optional for Flush Data and Set Properties, but invalid for Append Data. A date and time value. Specify this header to perform the operation only if the resource has not been modified since the specified date and time.
  ##   x-ms-client-request-id: JString
  ##                         : A UUID recorded in the analytics logs for troubleshooting and correlation.
  ##   If-Modified-Since: JString
  ##                    : Optional for Flush Data and Set Properties, but invalid for Append Data. A date and time value. Specify this header to perform the operation only if the resource has been modified since the specified date and time.
  ##   If-None-Match: JString
  ##                : Optional for Flush Data and Set Properties, but invalid for Append Data.  An ETag value or the special wildcard ("*") value. Specify this header to perform the operation only if the resource's ETag does not match the value specified. The ETag must be specified in quotes.
  ##   x-ms-cache-control: JString
  ##                     : Optional and only valid for flush and set properties operations.  The service stores this value and includes it in the "Cache-Control" response header for "Read File" operations.
  ##   x-ms-owner: JString
  ##             : Optional and valid only for the setAccessControl operation. Sets the owner of the file or directory.
  ##   x-ms-group: JString
  ##             : Optional and valid only for the setAccessControl operation. Sets the owning group of the file or directory.
  ##   x-ms-content-encoding: JString
  ##                        : Optional and only valid for flush and set properties operations.  The service stores this value and includes it in the "Content-Encoding" response header for "Read File" operations.
  ##   x-ms-content-language: JString
  ##                        : Optional and only valid for flush and set properties operations.  The service stores this value and includes it in the "Content-Language" response header for "Read File" operations.
  ##   x-ms-lease-action: JString
  ##                    : Optional.  The lease action can be "renew" to renew an existing lease or "release" to release a lease.
  ##   If-Match: JString
  ##           : Optional for Flush Data and Set Properties, but invalid for Append Data.  An ETag value. Specify this header to perform the operation only if the resource's ETag matches the value specified. The ETag must be specified in quotes.
  section = newJObject()
  var valid_564311 = header.getOrDefault("x-ms-lease-id")
  valid_564311 = validateParameter(valid_564311, JString, required = false,
                                 default = nil)
  if valid_564311 != nil:
    section.add "x-ms-lease-id", valid_564311
  var valid_564312 = header.getOrDefault("x-ms-permissions")
  valid_564312 = validateParameter(valid_564312, JString, required = false,
                                 default = nil)
  if valid_564312 != nil:
    section.add "x-ms-permissions", valid_564312
  var valid_564313 = header.getOrDefault("x-ms-version")
  valid_564313 = validateParameter(valid_564313, JString, required = false,
                                 default = nil)
  if valid_564313 != nil:
    section.add "x-ms-version", valid_564313
  var valid_564314 = header.getOrDefault("Content-Length")
  valid_564314 = validateParameter(valid_564314, JString, required = false,
                                 default = nil)
  if valid_564314 != nil:
    section.add "Content-Length", valid_564314
  var valid_564315 = header.getOrDefault("x-ms-date")
  valid_564315 = validateParameter(valid_564315, JString, required = false,
                                 default = nil)
  if valid_564315 != nil:
    section.add "x-ms-date", valid_564315
  var valid_564316 = header.getOrDefault("x-ms-content-type")
  valid_564316 = validateParameter(valid_564316, JString, required = false,
                                 default = nil)
  if valid_564316 != nil:
    section.add "x-ms-content-type", valid_564316
  var valid_564317 = header.getOrDefault("x-ms-properties")
  valid_564317 = validateParameter(valid_564317, JString, required = false,
                                 default = nil)
  if valid_564317 != nil:
    section.add "x-ms-properties", valid_564317
  var valid_564318 = header.getOrDefault("x-ms-acl")
  valid_564318 = validateParameter(valid_564318, JString, required = false,
                                 default = nil)
  if valid_564318 != nil:
    section.add "x-ms-acl", valid_564318
  var valid_564319 = header.getOrDefault("x-ms-content-disposition")
  valid_564319 = validateParameter(valid_564319, JString, required = false,
                                 default = nil)
  if valid_564319 != nil:
    section.add "x-ms-content-disposition", valid_564319
  var valid_564320 = header.getOrDefault("If-Unmodified-Since")
  valid_564320 = validateParameter(valid_564320, JString, required = false,
                                 default = nil)
  if valid_564320 != nil:
    section.add "If-Unmodified-Since", valid_564320
  var valid_564321 = header.getOrDefault("x-ms-client-request-id")
  valid_564321 = validateParameter(valid_564321, JString, required = false,
                                 default = nil)
  if valid_564321 != nil:
    section.add "x-ms-client-request-id", valid_564321
  var valid_564322 = header.getOrDefault("If-Modified-Since")
  valid_564322 = validateParameter(valid_564322, JString, required = false,
                                 default = nil)
  if valid_564322 != nil:
    section.add "If-Modified-Since", valid_564322
  var valid_564323 = header.getOrDefault("If-None-Match")
  valid_564323 = validateParameter(valid_564323, JString, required = false,
                                 default = nil)
  if valid_564323 != nil:
    section.add "If-None-Match", valid_564323
  var valid_564324 = header.getOrDefault("x-ms-cache-control")
  valid_564324 = validateParameter(valid_564324, JString, required = false,
                                 default = nil)
  if valid_564324 != nil:
    section.add "x-ms-cache-control", valid_564324
  var valid_564325 = header.getOrDefault("x-ms-owner")
  valid_564325 = validateParameter(valid_564325, JString, required = false,
                                 default = nil)
  if valid_564325 != nil:
    section.add "x-ms-owner", valid_564325
  var valid_564326 = header.getOrDefault("x-ms-group")
  valid_564326 = validateParameter(valid_564326, JString, required = false,
                                 default = nil)
  if valid_564326 != nil:
    section.add "x-ms-group", valid_564326
  var valid_564327 = header.getOrDefault("x-ms-content-encoding")
  valid_564327 = validateParameter(valid_564327, JString, required = false,
                                 default = nil)
  if valid_564327 != nil:
    section.add "x-ms-content-encoding", valid_564327
  var valid_564328 = header.getOrDefault("x-ms-content-language")
  valid_564328 = validateParameter(valid_564328, JString, required = false,
                                 default = nil)
  if valid_564328 != nil:
    section.add "x-ms-content-language", valid_564328
  var valid_564329 = header.getOrDefault("x-ms-lease-action")
  valid_564329 = validateParameter(valid_564329, JString, required = false,
                                 default = newJString("renew"))
  if valid_564329 != nil:
    section.add "x-ms-lease-action", valid_564329
  var valid_564330 = header.getOrDefault("If-Match")
  valid_564330 = validateParameter(valid_564330, JString, required = false,
                                 default = nil)
  if valid_564330 != nil:
    section.add "If-Match", valid_564330
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   requestBody: JObject
  ##              : Valid only for append operations.  The data to be uploaded and appended to the file.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564332: Call_PathUpdate_564302; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Uploads data to be appended to a file, flushes (writes) previously uploaded data to a file, sets properties for a file or directory, or sets access control for a file or directory. Data can only be appended to a file. This operation supports conditional HTTP requests. For more information, see [Specifying Conditional Headers for Blob Service Operations](https://docs.microsoft.com/en-us/rest/api/storageservices/specifying-conditional-headers-for-blob-service-operations).
  ## 
  let valid = call_564332.validator(path, query, header, formData, body)
  let scheme = call_564332.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564332.url(scheme.get, call_564332.host, call_564332.base,
                         call_564332.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564332, url, valid)

proc call*(call_564333: Call_PathUpdate_564302; path: string; filesystem: string;
          action: string = "append"; position: int = 0;
          retainUncommittedData: bool = false; timeout: int = 0;
          requestBody: JsonNode = nil): Recallable =
  ## pathUpdate
  ## Uploads data to be appended to a file, flushes (writes) previously uploaded data to a file, sets properties for a file or directory, or sets access control for a file or directory. Data can only be appended to a file. This operation supports conditional HTTP requests. For more information, see [Specifying Conditional Headers for Blob Service Operations](https://docs.microsoft.com/en-us/rest/api/storageservices/specifying-conditional-headers-for-blob-service-operations).
  ##   action: string (required)
  ##         : The action must be "append" to upload data to be appended to a file, "flush" to flush previously uploaded data to a file, "setProperties" to set the properties of a file or directory, or "setAccessControl" to set the owner, group, permissions, or access control list for a file or directory.  Note that Hierarchical Namespace must be enabled for the account in order to use access control.  Also note that the Access Control List (ACL) includes permissions for the owner, owning group, and others, so the x-ms-permissions and x-ms-acl request headers are mutually exclusive.
  ##   position: int
  ##           : This parameter allows the caller to upload data in parallel and control the order in which it is appended to the file.  It is required when uploading data to be appended to the file and when flushing previously uploaded data to the file.  The value must be the position where the data is to be appended.  Uploaded data is not immediately flushed, or written, to the file.  To flush, the previously uploaded data must be contiguous, the position parameter must be specified and equal to the length of the file after all data has been written, and there must not be a request entity body included with the request.
  ##   retainUncommittedData: bool
  ##                        : Valid only for flush operations.  If "true", uncommitted data is retained after the flush operation completes; otherwise, the uncommitted data is deleted after the flush operation.  The default is false.  Data at offsets less than the specified position are written to the file when flush succeeds, but this optional parameter allows data after the flush position to be retained for a future flush operation.
  ##   timeout: int
  ##          : An optional operation timeout value in seconds. The period begins when the request is received by the service. If the timeout value elapses before the operation completes, the operation fails.
  ##   requestBody: JObject
  ##              : Valid only for append operations.  The data to be uploaded and appended to the file.
  ##   path: string (required)
  ##       : The file or directory path.
  ##   filesystem: string (required)
  ##             : The filesystem identifier.
  var path_564334 = newJObject()
  var query_564335 = newJObject()
  var body_564336 = newJObject()
  add(query_564335, "action", newJString(action))
  add(query_564335, "position", newJInt(position))
  add(query_564335, "retainUncommittedData", newJBool(retainUncommittedData))
  add(query_564335, "timeout", newJInt(timeout))
  if requestBody != nil:
    body_564336 = requestBody
  add(path_564334, "path", newJString(path))
  add(path_564334, "filesystem", newJString(filesystem))
  result = call_564333.call(path_564334, query_564335, nil, nil, body_564336)

var pathUpdate* = Call_PathUpdate_564302(name: "pathUpdate",
                                      meth: HttpMethod.HttpPatch,
                                      host: "azure.local",
                                      route: "/{filesystem}/{path}",
                                      validator: validate_PathUpdate_564303,
                                      base: "", url: url_PathUpdate_564304,
                                      schemes: {Scheme.Https})
type
  Call_PathDelete_564264 = ref object of OpenApiRestCall_563556
proc url_PathDelete_564266(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_PathDelete_564265(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564267 = path.getOrDefault("path")
  valid_564267 = validateParameter(valid_564267, JString, required = true,
                                 default = nil)
  if valid_564267 != nil:
    section.add "path", valid_564267
  var valid_564268 = path.getOrDefault("filesystem")
  valid_564268 = validateParameter(valid_564268, JString, required = true,
                                 default = nil)
  if valid_564268 != nil:
    section.add "filesystem", valid_564268
  result.add "path", section
  ## parameters in `query` object:
  ##   recursive: JBool
  ##            : Required and valid only when the resource is a directory.  If "true", all paths beneath the directory will be deleted. If "false" and the directory is non-empty, an error occurs.
  ##   continuation: JString
  ##               : Optional.  When deleting a directory, the number of paths that are deleted with each invocation is limited.  If the number of paths to be deleted exceeds this limit, a continuation token is returned in this response header.  When a continuation token is returned in the response, it must be specified in a subsequent invocation of the delete operation to continue deleting the directory.
  ##   timeout: JInt
  ##          : An optional operation timeout value in seconds. The period begins when the request is received by the service. If the timeout value elapses before the operation completes, the operation fails.
  section = newJObject()
  var valid_564269 = query.getOrDefault("recursive")
  valid_564269 = validateParameter(valid_564269, JBool, required = false, default = nil)
  if valid_564269 != nil:
    section.add "recursive", valid_564269
  var valid_564270 = query.getOrDefault("continuation")
  valid_564270 = validateParameter(valid_564270, JString, required = false,
                                 default = nil)
  if valid_564270 != nil:
    section.add "continuation", valid_564270
  var valid_564271 = query.getOrDefault("timeout")
  valid_564271 = validateParameter(valid_564271, JInt, required = false, default = nil)
  if valid_564271 != nil:
    section.add "timeout", valid_564271
  result.add "query", section
  ## parameters in `header` object:
  ##   x-ms-lease-id: JString
  ##                : The lease ID must be specified if there is an active lease.
  ##   x-ms-version: JString
  ##               : Specifies the version of the REST protocol used for processing the request. This is required when using shared key authorization.
  ##   x-ms-date: JString
  ##            : Specifies the Coordinated Universal Time (UTC) for the request.  This is required when using shared key authorization.
  ##   If-Unmodified-Since: JString
  ##                      : Optional. A date and time value. Specify this header to perform the operation only if the resource has not been modified since the specified date and time.
  ##   x-ms-client-request-id: JString
  ##                         : A UUID recorded in the analytics logs for troubleshooting and correlation.
  ##   If-Modified-Since: JString
  ##                    : Optional. A date and time value. Specify this header to perform the operation only if the resource has been modified since the specified date and time.
  ##   If-None-Match: JString
  ##                : Optional.  An ETag value or the special wildcard ("*") value. Specify this header to perform the operation only if the resource's ETag does not match the value specified. The ETag must be specified in quotes.
  ##   If-Match: JString
  ##           : Optional.  An ETag value. Specify this header to perform the operation only if the resource's ETag matches the value specified. The ETag must be specified in quotes.
  section = newJObject()
  var valid_564272 = header.getOrDefault("x-ms-lease-id")
  valid_564272 = validateParameter(valid_564272, JString, required = false,
                                 default = nil)
  if valid_564272 != nil:
    section.add "x-ms-lease-id", valid_564272
  var valid_564273 = header.getOrDefault("x-ms-version")
  valid_564273 = validateParameter(valid_564273, JString, required = false,
                                 default = nil)
  if valid_564273 != nil:
    section.add "x-ms-version", valid_564273
  var valid_564274 = header.getOrDefault("x-ms-date")
  valid_564274 = validateParameter(valid_564274, JString, required = false,
                                 default = nil)
  if valid_564274 != nil:
    section.add "x-ms-date", valid_564274
  var valid_564275 = header.getOrDefault("If-Unmodified-Since")
  valid_564275 = validateParameter(valid_564275, JString, required = false,
                                 default = nil)
  if valid_564275 != nil:
    section.add "If-Unmodified-Since", valid_564275
  var valid_564276 = header.getOrDefault("x-ms-client-request-id")
  valid_564276 = validateParameter(valid_564276, JString, required = false,
                                 default = nil)
  if valid_564276 != nil:
    section.add "x-ms-client-request-id", valid_564276
  var valid_564277 = header.getOrDefault("If-Modified-Since")
  valid_564277 = validateParameter(valid_564277, JString, required = false,
                                 default = nil)
  if valid_564277 != nil:
    section.add "If-Modified-Since", valid_564277
  var valid_564278 = header.getOrDefault("If-None-Match")
  valid_564278 = validateParameter(valid_564278, JString, required = false,
                                 default = nil)
  if valid_564278 != nil:
    section.add "If-None-Match", valid_564278
  var valid_564279 = header.getOrDefault("If-Match")
  valid_564279 = validateParameter(valid_564279, JString, required = false,
                                 default = nil)
  if valid_564279 != nil:
    section.add "If-Match", valid_564279
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564280: Call_PathDelete_564264; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete the file or directory. This operation supports conditional HTTP requests.  For more information, see [Specifying Conditional Headers for Blob Service Operations](https://docs.microsoft.com/en-us/rest/api/storageservices/specifying-conditional-headers-for-blob-service-operations).
  ## 
  let valid = call_564280.validator(path, query, header, formData, body)
  let scheme = call_564280.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564280.url(scheme.get, call_564280.host, call_564280.base,
                         call_564280.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564280, url, valid)

proc call*(call_564281: Call_PathDelete_564264; path: string; filesystem: string;
          recursive: bool = false; continuation: string = ""; timeout: int = 0): Recallable =
  ## pathDelete
  ## Delete the file or directory. This operation supports conditional HTTP requests.  For more information, see [Specifying Conditional Headers for Blob Service Operations](https://docs.microsoft.com/en-us/rest/api/storageservices/specifying-conditional-headers-for-blob-service-operations).
  ##   recursive: bool
  ##            : Required and valid only when the resource is a directory.  If "true", all paths beneath the directory will be deleted. If "false" and the directory is non-empty, an error occurs.
  ##   continuation: string
  ##               : Optional.  When deleting a directory, the number of paths that are deleted with each invocation is limited.  If the number of paths to be deleted exceeds this limit, a continuation token is returned in this response header.  When a continuation token is returned in the response, it must be specified in a subsequent invocation of the delete operation to continue deleting the directory.
  ##   timeout: int
  ##          : An optional operation timeout value in seconds. The period begins when the request is received by the service. If the timeout value elapses before the operation completes, the operation fails.
  ##   path: string (required)
  ##       : The file or directory path.
  ##   filesystem: string (required)
  ##             : The filesystem identifier.
  var path_564282 = newJObject()
  var query_564283 = newJObject()
  add(query_564283, "recursive", newJBool(recursive))
  add(query_564283, "continuation", newJString(continuation))
  add(query_564283, "timeout", newJInt(timeout))
  add(path_564282, "path", newJString(path))
  add(path_564282, "filesystem", newJString(filesystem))
  result = call_564281.call(path_564282, query_564283, nil, nil, nil)

var pathDelete* = Call_PathDelete_564264(name: "pathDelete",
                                      meth: HttpMethod.HttpDelete,
                                      host: "azure.local",
                                      route: "/{filesystem}/{path}",
                                      validator: validate_PathDelete_564265,
                                      base: "", url: url_PathDelete_564266,
                                      schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
