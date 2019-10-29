
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
  Call_FilesystemCreate_564128 = ref object of OpenApiRestCall_563556
proc url_FilesystemCreate_564130(protocol: Scheme; host: string; base: string;
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

proc validate_FilesystemCreate_564129(path: JsonNode; query: JsonNode;
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
  var valid_564131 = path.getOrDefault("filesystem")
  valid_564131 = validateParameter(valid_564131, JString, required = true,
                                 default = nil)
  if valid_564131 != nil:
    section.add "filesystem", valid_564131
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : An optional operation timeout value in seconds. The period begins when the request is received by the service. If the timeout value elapses before the operation completes, the operation fails.
  ##   resource: JString (required)
  ##           : The value must be "filesystem" for all filesystem operations.
  section = newJObject()
  var valid_564132 = query.getOrDefault("timeout")
  valid_564132 = validateParameter(valid_564132, JInt, required = false, default = nil)
  if valid_564132 != nil:
    section.add "timeout", valid_564132
  assert query != nil,
        "query argument is necessary due to required `resource` field"
  var valid_564133 = query.getOrDefault("resource")
  valid_564133 = validateParameter(valid_564133, JString, required = true,
                                 default = newJString("filesystem"))
  if valid_564133 != nil:
    section.add "resource", valid_564133
  result.add "query", section
  ## parameters in `header` object:
  ##   x-ms-version: JString
  ##               : Specifies the version of the REST protocol used for processing the request. This is required when using shared key authorization.
  ##   x-ms-date: JString
  ##            : Specifies the Coordinated Universal Time (UTC) for the request.  This is required when using shared key authorization.
  ##   x-ms-properties: JString
  ##                  : User-defined properties to be stored with the filesystem, in the format of a comma-separated list of name and value pairs "n1=v1, n2=v2, ...", where each value is a base64 encoded string. Note that the string may only contain ASCII characters in the ISO-8859-1 character set.
  ##   x-ms-client-request-id: JString
  ##                         : A UUID recorded in the analytics logs for troubleshooting and correlation.
  section = newJObject()
  var valid_564134 = header.getOrDefault("x-ms-version")
  valid_564134 = validateParameter(valid_564134, JString, required = false,
                                 default = nil)
  if valid_564134 != nil:
    section.add "x-ms-version", valid_564134
  var valid_564135 = header.getOrDefault("x-ms-date")
  valid_564135 = validateParameter(valid_564135, JString, required = false,
                                 default = nil)
  if valid_564135 != nil:
    section.add "x-ms-date", valid_564135
  var valid_564136 = header.getOrDefault("x-ms-properties")
  valid_564136 = validateParameter(valid_564136, JString, required = false,
                                 default = nil)
  if valid_564136 != nil:
    section.add "x-ms-properties", valid_564136
  var valid_564137 = header.getOrDefault("x-ms-client-request-id")
  valid_564137 = validateParameter(valid_564137, JString, required = false,
                                 default = nil)
  if valid_564137 != nil:
    section.add "x-ms-client-request-id", valid_564137
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564138: Call_FilesystemCreate_564128; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a filesystem rooted at the specified location. If the filesystem already exists, the operation fails.  This operation does not support conditional HTTP requests.
  ## 
  let valid = call_564138.validator(path, query, header, formData, body)
  let scheme = call_564138.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564138.url(scheme.get, call_564138.host, call_564138.base,
                         call_564138.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564138, url, valid)

proc call*(call_564139: Call_FilesystemCreate_564128; filesystem: string;
          timeout: int = 0; resource: string = "filesystem"): Recallable =
  ## filesystemCreate
  ## Create a filesystem rooted at the specified location. If the filesystem already exists, the operation fails.  This operation does not support conditional HTTP requests.
  ##   timeout: int
  ##          : An optional operation timeout value in seconds. The period begins when the request is received by the service. If the timeout value elapses before the operation completes, the operation fails.
  ##   resource: string (required)
  ##           : The value must be "filesystem" for all filesystem operations.
  ##   filesystem: string (required)
  ##             : The filesystem identifier.  The value must start and end with a letter or number and must contain only letters, numbers, and the dash (-) character.  Consecutive dashes are not permitted.  All letters must be lowercase.  The value must have between 3 and 63 characters.
  var path_564140 = newJObject()
  var query_564141 = newJObject()
  add(query_564141, "timeout", newJInt(timeout))
  add(query_564141, "resource", newJString(resource))
  add(path_564140, "filesystem", newJString(filesystem))
  result = call_564139.call(path_564140, query_564141, nil, nil, nil)

var filesystemCreate* = Call_FilesystemCreate_564128(name: "filesystemCreate",
    meth: HttpMethod.HttpPut, host: "azure.local", route: "/{filesystem}",
    validator: validate_FilesystemCreate_564129, base: "",
    url: url_FilesystemCreate_564130, schemes: {Scheme.Https})
type
  Call_FilesystemGetProperties_564157 = ref object of OpenApiRestCall_563556
proc url_FilesystemGetProperties_564159(protocol: Scheme; host: string; base: string;
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

proc validate_FilesystemGetProperties_564158(path: JsonNode; query: JsonNode;
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
  var valid_564160 = path.getOrDefault("filesystem")
  valid_564160 = validateParameter(valid_564160, JString, required = true,
                                 default = nil)
  if valid_564160 != nil:
    section.add "filesystem", valid_564160
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : An optional operation timeout value in seconds. The period begins when the request is received by the service. If the timeout value elapses before the operation completes, the operation fails.
  ##   resource: JString (required)
  ##           : The value must be "filesystem" for all filesystem operations.
  section = newJObject()
  var valid_564161 = query.getOrDefault("timeout")
  valid_564161 = validateParameter(valid_564161, JInt, required = false, default = nil)
  if valid_564161 != nil:
    section.add "timeout", valid_564161
  assert query != nil,
        "query argument is necessary due to required `resource` field"
  var valid_564162 = query.getOrDefault("resource")
  valid_564162 = validateParameter(valid_564162, JString, required = true,
                                 default = newJString("filesystem"))
  if valid_564162 != nil:
    section.add "resource", valid_564162
  result.add "query", section
  ## parameters in `header` object:
  ##   x-ms-version: JString
  ##               : Specifies the version of the REST protocol used for processing the request. This is required when using shared key authorization.
  ##   x-ms-date: JString
  ##            : Specifies the Coordinated Universal Time (UTC) for the request.  This is required when using shared key authorization.
  ##   x-ms-client-request-id: JString
  ##                         : A UUID recorded in the analytics logs for troubleshooting and correlation.
  section = newJObject()
  var valid_564163 = header.getOrDefault("x-ms-version")
  valid_564163 = validateParameter(valid_564163, JString, required = false,
                                 default = nil)
  if valid_564163 != nil:
    section.add "x-ms-version", valid_564163
  var valid_564164 = header.getOrDefault("x-ms-date")
  valid_564164 = validateParameter(valid_564164, JString, required = false,
                                 default = nil)
  if valid_564164 != nil:
    section.add "x-ms-date", valid_564164
  var valid_564165 = header.getOrDefault("x-ms-client-request-id")
  valid_564165 = validateParameter(valid_564165, JString, required = false,
                                 default = nil)
  if valid_564165 != nil:
    section.add "x-ms-client-request-id", valid_564165
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564166: Call_FilesystemGetProperties_564157; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## All system and user-defined filesystem properties are specified in the response headers.
  ## 
  let valid = call_564166.validator(path, query, header, formData, body)
  let scheme = call_564166.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564166.url(scheme.get, call_564166.host, call_564166.base,
                         call_564166.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564166, url, valid)

proc call*(call_564167: Call_FilesystemGetProperties_564157; filesystem: string;
          timeout: int = 0; resource: string = "filesystem"): Recallable =
  ## filesystemGetProperties
  ## All system and user-defined filesystem properties are specified in the response headers.
  ##   timeout: int
  ##          : An optional operation timeout value in seconds. The period begins when the request is received by the service. If the timeout value elapses before the operation completes, the operation fails.
  ##   resource: string (required)
  ##           : The value must be "filesystem" for all filesystem operations.
  ##   filesystem: string (required)
  ##             : The filesystem identifier.  The value must start and end with a letter or number and must contain only letters, numbers, and the dash (-) character.  Consecutive dashes are not permitted.  All letters must be lowercase.  The value must have between 3 and 63 characters.
  var path_564168 = newJObject()
  var query_564169 = newJObject()
  add(query_564169, "timeout", newJInt(timeout))
  add(query_564169, "resource", newJString(resource))
  add(path_564168, "filesystem", newJString(filesystem))
  result = call_564167.call(path_564168, query_564169, nil, nil, nil)

var filesystemGetProperties* = Call_FilesystemGetProperties_564157(
    name: "filesystemGetProperties", meth: HttpMethod.HttpHead, host: "azure.local",
    route: "/{filesystem}", validator: validate_FilesystemGetProperties_564158,
    base: "", url: url_FilesystemGetProperties_564159, schemes: {Scheme.Https})
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
  ##   upn: JBool
  ##      : Optional. Valid only when Hierarchical Namespace is enabled for the account. If "true", the user identity values returned in the owner and group fields of each list entry will be transformed from Azure Active Directory Object IDs to User Principal Names.  If "false", the values will be returned as Azure Active Directory Object IDs. The default value is false. Note that group and application Object IDs are not translated because they do not have unique friendly names.
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
  var valid_564119 = query.getOrDefault("upn")
  valid_564119 = validateParameter(valid_564119, JBool, required = false, default = nil)
  if valid_564119 != nil:
    section.add "upn", valid_564119
  var valid_564120 = query.getOrDefault("maxResults")
  valid_564120 = validateParameter(valid_564120, JInt, required = false, default = nil)
  if valid_564120 != nil:
    section.add "maxResults", valid_564120
  result.add "query", section
  ## parameters in `header` object:
  ##   x-ms-version: JString
  ##               : Specifies the version of the REST protocol used for processing the request. This is required when using shared key authorization.
  ##   x-ms-date: JString
  ##            : Specifies the Coordinated Universal Time (UTC) for the request.  This is required when using shared key authorization.
  ##   x-ms-client-request-id: JString
  ##                         : A UUID recorded in the analytics logs for troubleshooting and correlation.
  section = newJObject()
  var valid_564121 = header.getOrDefault("x-ms-version")
  valid_564121 = validateParameter(valid_564121, JString, required = false,
                                 default = nil)
  if valid_564121 != nil:
    section.add "x-ms-version", valid_564121
  var valid_564122 = header.getOrDefault("x-ms-date")
  valid_564122 = validateParameter(valid_564122, JString, required = false,
                                 default = nil)
  if valid_564122 != nil:
    section.add "x-ms-date", valid_564122
  var valid_564123 = header.getOrDefault("x-ms-client-request-id")
  valid_564123 = validateParameter(valid_564123, JString, required = false,
                                 default = nil)
  if valid_564123 != nil:
    section.add "x-ms-client-request-id", valid_564123
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564124: Call_PathList_564096; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List filesystem paths and their properties.
  ## 
  let valid = call_564124.validator(path, query, header, formData, body)
  let scheme = call_564124.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564124.url(scheme.get, call_564124.host, call_564124.base,
                         call_564124.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564124, url, valid)

proc call*(call_564125: Call_PathList_564096; recursive: bool; filesystem: string;
          directory: string = ""; continuation: string = ""; timeout: int = 0;
          resource: string = "filesystem"; upn: bool = false; maxResults: int = 0): Recallable =
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
  ##   upn: bool
  ##      : Optional. Valid only when Hierarchical Namespace is enabled for the account. If "true", the user identity values returned in the owner and group fields of each list entry will be transformed from Azure Active Directory Object IDs to User Principal Names.  If "false", the values will be returned as Azure Active Directory Object IDs. The default value is false. Note that group and application Object IDs are not translated because they do not have unique friendly names.
  ##   filesystem: string (required)
  ##             : The filesystem identifier.  The value must start and end with a letter or number and must contain only letters, numbers, and the dash (-) character.  Consecutive dashes are not permitted.  All letters must be lowercase.  The value must have between 3 and 63 characters.
  ##   maxResults: int
  ##             : An optional value that specifies the maximum number of items to return. If omitted or greater than 5,000, the response will include up to 5,000 items.
  var path_564126 = newJObject()
  var query_564127 = newJObject()
  add(query_564127, "recursive", newJBool(recursive))
  add(query_564127, "directory", newJString(directory))
  add(query_564127, "continuation", newJString(continuation))
  add(query_564127, "timeout", newJInt(timeout))
  add(query_564127, "resource", newJString(resource))
  add(query_564127, "upn", newJBool(upn))
  add(path_564126, "filesystem", newJString(filesystem))
  add(query_564127, "maxResults", newJInt(maxResults))
  result = call_564125.call(path_564126, query_564127, nil, nil, nil)

var pathList* = Call_PathList_564096(name: "pathList", meth: HttpMethod.HttpGet,
                                  host: "azure.local", route: "/{filesystem}",
                                  validator: validate_PathList_564097, base: "",
                                  url: url_PathList_564098,
                                  schemes: {Scheme.Https})
type
  Call_FilesystemSetProperties_564170 = ref object of OpenApiRestCall_563556
proc url_FilesystemSetProperties_564172(protocol: Scheme; host: string; base: string;
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

proc validate_FilesystemSetProperties_564171(path: JsonNode; query: JsonNode;
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
  var valid_564173 = path.getOrDefault("filesystem")
  valid_564173 = validateParameter(valid_564173, JString, required = true,
                                 default = nil)
  if valid_564173 != nil:
    section.add "filesystem", valid_564173
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : An optional operation timeout value in seconds. The period begins when the request is received by the service. If the timeout value elapses before the operation completes, the operation fails.
  ##   resource: JString (required)
  ##           : The value must be "filesystem" for all filesystem operations.
  section = newJObject()
  var valid_564174 = query.getOrDefault("timeout")
  valid_564174 = validateParameter(valid_564174, JInt, required = false, default = nil)
  if valid_564174 != nil:
    section.add "timeout", valid_564174
  assert query != nil,
        "query argument is necessary due to required `resource` field"
  var valid_564175 = query.getOrDefault("resource")
  valid_564175 = validateParameter(valid_564175, JString, required = true,
                                 default = newJString("filesystem"))
  if valid_564175 != nil:
    section.add "resource", valid_564175
  result.add "query", section
  ## parameters in `header` object:
  ##   x-ms-version: JString
  ##               : Specifies the version of the REST protocol used for processing the request. This is required when using shared key authorization.
  ##   x-ms-date: JString
  ##            : Specifies the Coordinated Universal Time (UTC) for the request.  This is required when using shared key authorization.
  ##   x-ms-properties: JString
  ##                  : Optional. User-defined properties to be stored with the filesystem, in the format of a comma-separated list of name and value pairs "n1=v1, n2=v2, ...", where each value is a base64 encoded string. Note that the string may only contain ASCII characters in the ISO-8859-1 character set.  If the filesystem exists, any properties not included in the list will be removed.  All properties are removed if the header is omitted.  To merge new and existing properties, first get all existing properties and the current E-Tag, then make a conditional request with the E-Tag and include values for all properties.
  ##   If-Unmodified-Since: JString
  ##                      : Optional. A date and time value. Specify this header to perform the operation only if the resource has not been modified since the specified date and time.
  ##   x-ms-client-request-id: JString
  ##                         : A UUID recorded in the analytics logs for troubleshooting and correlation.
  ##   If-Modified-Since: JString
  ##                    : Optional. A date and time value. Specify this header to perform the operation only if the resource has been modified since the specified date and time.
  section = newJObject()
  var valid_564176 = header.getOrDefault("x-ms-version")
  valid_564176 = validateParameter(valid_564176, JString, required = false,
                                 default = nil)
  if valid_564176 != nil:
    section.add "x-ms-version", valid_564176
  var valid_564177 = header.getOrDefault("x-ms-date")
  valid_564177 = validateParameter(valid_564177, JString, required = false,
                                 default = nil)
  if valid_564177 != nil:
    section.add "x-ms-date", valid_564177
  var valid_564178 = header.getOrDefault("x-ms-properties")
  valid_564178 = validateParameter(valid_564178, JString, required = false,
                                 default = nil)
  if valid_564178 != nil:
    section.add "x-ms-properties", valid_564178
  var valid_564179 = header.getOrDefault("If-Unmodified-Since")
  valid_564179 = validateParameter(valid_564179, JString, required = false,
                                 default = nil)
  if valid_564179 != nil:
    section.add "If-Unmodified-Since", valid_564179
  var valid_564180 = header.getOrDefault("x-ms-client-request-id")
  valid_564180 = validateParameter(valid_564180, JString, required = false,
                                 default = nil)
  if valid_564180 != nil:
    section.add "x-ms-client-request-id", valid_564180
  var valid_564181 = header.getOrDefault("If-Modified-Since")
  valid_564181 = validateParameter(valid_564181, JString, required = false,
                                 default = nil)
  if valid_564181 != nil:
    section.add "If-Modified-Since", valid_564181
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564182: Call_FilesystemSetProperties_564170; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Set properties for the filesystem.  This operation supports conditional HTTP requests.  For more information, see [Specifying Conditional Headers for Blob Service Operations](https://docs.microsoft.com/en-us/rest/api/storageservices/specifying-conditional-headers-for-blob-service-operations).
  ## 
  let valid = call_564182.validator(path, query, header, formData, body)
  let scheme = call_564182.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564182.url(scheme.get, call_564182.host, call_564182.base,
                         call_564182.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564182, url, valid)

proc call*(call_564183: Call_FilesystemSetProperties_564170; filesystem: string;
          timeout: int = 0; resource: string = "filesystem"): Recallable =
  ## filesystemSetProperties
  ## Set properties for the filesystem.  This operation supports conditional HTTP requests.  For more information, see [Specifying Conditional Headers for Blob Service Operations](https://docs.microsoft.com/en-us/rest/api/storageservices/specifying-conditional-headers-for-blob-service-operations).
  ##   timeout: int
  ##          : An optional operation timeout value in seconds. The period begins when the request is received by the service. If the timeout value elapses before the operation completes, the operation fails.
  ##   resource: string (required)
  ##           : The value must be "filesystem" for all filesystem operations.
  ##   filesystem: string (required)
  ##             : The filesystem identifier.  The value must start and end with a letter or number and must contain only letters, numbers, and the dash (-) character.  Consecutive dashes are not permitted.  All letters must be lowercase.  The value must have between 3 and 63 characters.
  var path_564184 = newJObject()
  var query_564185 = newJObject()
  add(query_564185, "timeout", newJInt(timeout))
  add(query_564185, "resource", newJString(resource))
  add(path_564184, "filesystem", newJString(filesystem))
  result = call_564183.call(path_564184, query_564185, nil, nil, nil)

var filesystemSetProperties* = Call_FilesystemSetProperties_564170(
    name: "filesystemSetProperties", meth: HttpMethod.HttpPatch,
    host: "azure.local", route: "/{filesystem}",
    validator: validate_FilesystemSetProperties_564171, base: "",
    url: url_FilesystemSetProperties_564172, schemes: {Scheme.Https})
type
  Call_FilesystemDelete_564142 = ref object of OpenApiRestCall_563556
proc url_FilesystemDelete_564144(protocol: Scheme; host: string; base: string;
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

proc validate_FilesystemDelete_564143(path: JsonNode; query: JsonNode;
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
  var valid_564145 = path.getOrDefault("filesystem")
  valid_564145 = validateParameter(valid_564145, JString, required = true,
                                 default = nil)
  if valid_564145 != nil:
    section.add "filesystem", valid_564145
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : An optional operation timeout value in seconds. The period begins when the request is received by the service. If the timeout value elapses before the operation completes, the operation fails.
  ##   resource: JString (required)
  ##           : The value must be "filesystem" for all filesystem operations.
  section = newJObject()
  var valid_564146 = query.getOrDefault("timeout")
  valid_564146 = validateParameter(valid_564146, JInt, required = false, default = nil)
  if valid_564146 != nil:
    section.add "timeout", valid_564146
  assert query != nil,
        "query argument is necessary due to required `resource` field"
  var valid_564147 = query.getOrDefault("resource")
  valid_564147 = validateParameter(valid_564147, JString, required = true,
                                 default = newJString("filesystem"))
  if valid_564147 != nil:
    section.add "resource", valid_564147
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
  var valid_564148 = header.getOrDefault("x-ms-version")
  valid_564148 = validateParameter(valid_564148, JString, required = false,
                                 default = nil)
  if valid_564148 != nil:
    section.add "x-ms-version", valid_564148
  var valid_564149 = header.getOrDefault("x-ms-date")
  valid_564149 = validateParameter(valid_564149, JString, required = false,
                                 default = nil)
  if valid_564149 != nil:
    section.add "x-ms-date", valid_564149
  var valid_564150 = header.getOrDefault("If-Unmodified-Since")
  valid_564150 = validateParameter(valid_564150, JString, required = false,
                                 default = nil)
  if valid_564150 != nil:
    section.add "If-Unmodified-Since", valid_564150
  var valid_564151 = header.getOrDefault("x-ms-client-request-id")
  valid_564151 = validateParameter(valid_564151, JString, required = false,
                                 default = nil)
  if valid_564151 != nil:
    section.add "x-ms-client-request-id", valid_564151
  var valid_564152 = header.getOrDefault("If-Modified-Since")
  valid_564152 = validateParameter(valid_564152, JString, required = false,
                                 default = nil)
  if valid_564152 != nil:
    section.add "If-Modified-Since", valid_564152
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564153: Call_FilesystemDelete_564142; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Marks the filesystem for deletion.  When a filesystem is deleted, a filesystem with the same identifier cannot be created for at least 30 seconds. While the filesystem is being deleted, attempts to create a filesystem with the same identifier will fail with status code 409 (Conflict), with the service returning additional error information indicating that the filesystem is being deleted. All other operations, including operations on any files or directories within the filesystem, will fail with status code 404 (Not Found) while the filesystem is being deleted. This operation supports conditional HTTP requests.  For more information, see [Specifying Conditional Headers for Blob Service Operations](https://docs.microsoft.com/en-us/rest/api/storageservices/specifying-conditional-headers-for-blob-service-operations).
  ## 
  let valid = call_564153.validator(path, query, header, formData, body)
  let scheme = call_564153.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564153.url(scheme.get, call_564153.host, call_564153.base,
                         call_564153.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564153, url, valid)

proc call*(call_564154: Call_FilesystemDelete_564142; filesystem: string;
          timeout: int = 0; resource: string = "filesystem"): Recallable =
  ## filesystemDelete
  ## Marks the filesystem for deletion.  When a filesystem is deleted, a filesystem with the same identifier cannot be created for at least 30 seconds. While the filesystem is being deleted, attempts to create a filesystem with the same identifier will fail with status code 409 (Conflict), with the service returning additional error information indicating that the filesystem is being deleted. All other operations, including operations on any files or directories within the filesystem, will fail with status code 404 (Not Found) while the filesystem is being deleted. This operation supports conditional HTTP requests.  For more information, see [Specifying Conditional Headers for Blob Service Operations](https://docs.microsoft.com/en-us/rest/api/storageservices/specifying-conditional-headers-for-blob-service-operations).
  ##   timeout: int
  ##          : An optional operation timeout value in seconds. The period begins when the request is received by the service. If the timeout value elapses before the operation completes, the operation fails.
  ##   resource: string (required)
  ##           : The value must be "filesystem" for all filesystem operations.
  ##   filesystem: string (required)
  ##             : The filesystem identifier.  The value must start and end with a letter or number and must contain only letters, numbers, and the dash (-) character.  Consecutive dashes are not permitted.  All letters must be lowercase.  The value must have between 3 and 63 characters.
  var path_564155 = newJObject()
  var query_564156 = newJObject()
  add(query_564156, "timeout", newJInt(timeout))
  add(query_564156, "resource", newJString(resource))
  add(path_564155, "filesystem", newJString(filesystem))
  result = call_564154.call(path_564155, query_564156, nil, nil, nil)

var filesystemDelete* = Call_FilesystemDelete_564142(name: "filesystemDelete",
    meth: HttpMethod.HttpDelete, host: "azure.local", route: "/{filesystem}",
    validator: validate_FilesystemDelete_564143, base: "",
    url: url_FilesystemDelete_564144, schemes: {Scheme.Https})
type
  Call_PathCreate_564206 = ref object of OpenApiRestCall_563556
proc url_PathCreate_564208(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_PathCreate_564207(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564209 = path.getOrDefault("path")
  valid_564209 = validateParameter(valid_564209, JString, required = true,
                                 default = nil)
  if valid_564209 != nil:
    section.add "path", valid_564209
  var valid_564210 = path.getOrDefault("filesystem")
  valid_564210 = validateParameter(valid_564210, JString, required = true,
                                 default = nil)
  if valid_564210 != nil:
    section.add "filesystem", valid_564210
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
  var valid_564211 = query.getOrDefault("mode")
  valid_564211 = validateParameter(valid_564211, JString, required = false,
                                 default = newJString("legacy"))
  if valid_564211 != nil:
    section.add "mode", valid_564211
  var valid_564212 = query.getOrDefault("continuation")
  valid_564212 = validateParameter(valid_564212, JString, required = false,
                                 default = nil)
  if valid_564212 != nil:
    section.add "continuation", valid_564212
  var valid_564213 = query.getOrDefault("timeout")
  valid_564213 = validateParameter(valid_564213, JInt, required = false, default = nil)
  if valid_564213 != nil:
    section.add "timeout", valid_564213
  var valid_564214 = query.getOrDefault("resource")
  valid_564214 = validateParameter(valid_564214, JString, required = false,
                                 default = newJString("directory"))
  if valid_564214 != nil:
    section.add "resource", valid_564214
  result.add "query", section
  ## parameters in `header` object:
  ##   Cache-Control: JString
  ##                : Optional.  The service stores this value and includes it in the "Cache-Control" response header for "Read File" operations for "Read File" operations.
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
  ##                     : An optional file or directory to be renamed.  The value must have the following format: "/{filesystem}/{path}".  If "x-ms-properties" is specified, the properties will overwrite the existing properties; otherwise, the existing properties will be preserved. This value must be a URL percent-encoded string. Note that the string may only contain ASCII characters in the ISO-8859-1 character set.
  ##   x-ms-date: JString
  ##            : Specifies the Coordinated Universal Time (UTC) for the request.  This is required when using shared key authorization.
  ##   x-ms-content-type: JString
  ##                    : Optional.  The service stores this value and includes it in the "Content-Type" response header for "Read File" operations.
  ##   x-ms-properties: JString
  ##                  : Optional.  User-defined properties to be stored with the file or directory, in the format of a comma-separated list of name and value pairs "n1=v1, n2=v2, ...", where each value is a base64 encoded string. Note that the string may only contain ASCII characters in the ISO-8859-1 character set.
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
  ##   x-ms-umask: JString
  ##             : Optional and only valid if Hierarchical Namespace is enabled for the account. When creating a file or directory and the parent folder does not have a default ACL, the umask restricts the permissions of the file or directory to be created.  The resulting permission is given by p & ^u, where p is the permission and u is the umask.  For example, if p is 0777 and u is 0057, then the resulting permission is 0720.  The default permission is 0777 for a directory and 0666 for a file.  The default umask is 0027.  The umask must be specified in 4-digit octal notation (e.g. 0766).
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
  var valid_564215 = header.getOrDefault("Cache-Control")
  valid_564215 = validateParameter(valid_564215, JString, required = false,
                                 default = nil)
  if valid_564215 != nil:
    section.add "Cache-Control", valid_564215
  var valid_564216 = header.getOrDefault("x-ms-lease-id")
  valid_564216 = validateParameter(valid_564216, JString, required = false,
                                 default = nil)
  if valid_564216 != nil:
    section.add "x-ms-lease-id", valid_564216
  var valid_564217 = header.getOrDefault("x-ms-permissions")
  valid_564217 = validateParameter(valid_564217, JString, required = false,
                                 default = nil)
  if valid_564217 != nil:
    section.add "x-ms-permissions", valid_564217
  var valid_564218 = header.getOrDefault("x-ms-version")
  valid_564218 = validateParameter(valid_564218, JString, required = false,
                                 default = nil)
  if valid_564218 != nil:
    section.add "x-ms-version", valid_564218
  var valid_564219 = header.getOrDefault("x-ms-source-if-unmodified-since")
  valid_564219 = validateParameter(valid_564219, JString, required = false,
                                 default = nil)
  if valid_564219 != nil:
    section.add "x-ms-source-if-unmodified-since", valid_564219
  var valid_564220 = header.getOrDefault("x-ms-source-lease-id")
  valid_564220 = validateParameter(valid_564220, JString, required = false,
                                 default = nil)
  if valid_564220 != nil:
    section.add "x-ms-source-lease-id", valid_564220
  var valid_564221 = header.getOrDefault("x-ms-rename-source")
  valid_564221 = validateParameter(valid_564221, JString, required = false,
                                 default = nil)
  if valid_564221 != nil:
    section.add "x-ms-rename-source", valid_564221
  var valid_564222 = header.getOrDefault("x-ms-date")
  valid_564222 = validateParameter(valid_564222, JString, required = false,
                                 default = nil)
  if valid_564222 != nil:
    section.add "x-ms-date", valid_564222
  var valid_564223 = header.getOrDefault("x-ms-content-type")
  valid_564223 = validateParameter(valid_564223, JString, required = false,
                                 default = nil)
  if valid_564223 != nil:
    section.add "x-ms-content-type", valid_564223
  var valid_564224 = header.getOrDefault("x-ms-properties")
  valid_564224 = validateParameter(valid_564224, JString, required = false,
                                 default = nil)
  if valid_564224 != nil:
    section.add "x-ms-properties", valid_564224
  var valid_564225 = header.getOrDefault("Content-Disposition")
  valid_564225 = validateParameter(valid_564225, JString, required = false,
                                 default = nil)
  if valid_564225 != nil:
    section.add "Content-Disposition", valid_564225
  var valid_564226 = header.getOrDefault("Content-Encoding")
  valid_564226 = validateParameter(valid_564226, JString, required = false,
                                 default = nil)
  if valid_564226 != nil:
    section.add "Content-Encoding", valid_564226
  var valid_564227 = header.getOrDefault("x-ms-content-disposition")
  valid_564227 = validateParameter(valid_564227, JString, required = false,
                                 default = nil)
  if valid_564227 != nil:
    section.add "x-ms-content-disposition", valid_564227
  var valid_564228 = header.getOrDefault("If-Unmodified-Since")
  valid_564228 = validateParameter(valid_564228, JString, required = false,
                                 default = nil)
  if valid_564228 != nil:
    section.add "If-Unmodified-Since", valid_564228
  var valid_564229 = header.getOrDefault("x-ms-client-request-id")
  valid_564229 = validateParameter(valid_564229, JString, required = false,
                                 default = nil)
  if valid_564229 != nil:
    section.add "x-ms-client-request-id", valid_564229
  var valid_564230 = header.getOrDefault("If-Modified-Since")
  valid_564230 = validateParameter(valid_564230, JString, required = false,
                                 default = nil)
  if valid_564230 != nil:
    section.add "If-Modified-Since", valid_564230
  var valid_564231 = header.getOrDefault("If-None-Match")
  valid_564231 = validateParameter(valid_564231, JString, required = false,
                                 default = nil)
  if valid_564231 != nil:
    section.add "If-None-Match", valid_564231
  var valid_564232 = header.getOrDefault("x-ms-source-if-none-match")
  valid_564232 = validateParameter(valid_564232, JString, required = false,
                                 default = nil)
  if valid_564232 != nil:
    section.add "x-ms-source-if-none-match", valid_564232
  var valid_564233 = header.getOrDefault("x-ms-cache-control")
  valid_564233 = validateParameter(valid_564233, JString, required = false,
                                 default = nil)
  if valid_564233 != nil:
    section.add "x-ms-cache-control", valid_564233
  var valid_564234 = header.getOrDefault("x-ms-source-if-modified-since")
  valid_564234 = validateParameter(valid_564234, JString, required = false,
                                 default = nil)
  if valid_564234 != nil:
    section.add "x-ms-source-if-modified-since", valid_564234
  var valid_564235 = header.getOrDefault("x-ms-umask")
  valid_564235 = validateParameter(valid_564235, JString, required = false,
                                 default = nil)
  if valid_564235 != nil:
    section.add "x-ms-umask", valid_564235
  var valid_564236 = header.getOrDefault("Content-Language")
  valid_564236 = validateParameter(valid_564236, JString, required = false,
                                 default = nil)
  if valid_564236 != nil:
    section.add "Content-Language", valid_564236
  var valid_564237 = header.getOrDefault("x-ms-content-encoding")
  valid_564237 = validateParameter(valid_564237, JString, required = false,
                                 default = nil)
  if valid_564237 != nil:
    section.add "x-ms-content-encoding", valid_564237
  var valid_564238 = header.getOrDefault("x-ms-content-language")
  valid_564238 = validateParameter(valid_564238, JString, required = false,
                                 default = nil)
  if valid_564238 != nil:
    section.add "x-ms-content-language", valid_564238
  var valid_564239 = header.getOrDefault("If-Match")
  valid_564239 = validateParameter(valid_564239, JString, required = false,
                                 default = nil)
  if valid_564239 != nil:
    section.add "If-Match", valid_564239
  var valid_564240 = header.getOrDefault("x-ms-source-if-match")
  valid_564240 = validateParameter(valid_564240, JString, required = false,
                                 default = nil)
  if valid_564240 != nil:
    section.add "x-ms-source-if-match", valid_564240
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564241: Call_PathCreate_564206; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or rename a file or directory.    By default, the destination is overwritten and if the destination already exists and has a lease the lease is broken.  This operation supports conditional HTTP requests.  For more information, see [Specifying Conditional Headers for Blob Service Operations](https://docs.microsoft.com/en-us/rest/api/storageservices/specifying-conditional-headers-for-blob-service-operations).  To fail if the destination already exists, use a conditional request with If-None-Match: "*".
  ## 
  let valid = call_564241.validator(path, query, header, formData, body)
  let scheme = call_564241.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564241.url(scheme.get, call_564241.host, call_564241.base,
                         call_564241.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564241, url, valid)

proc call*(call_564242: Call_PathCreate_564206; path: string; filesystem: string;
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
  var path_564243 = newJObject()
  var query_564244 = newJObject()
  add(query_564244, "mode", newJString(mode))
  add(query_564244, "continuation", newJString(continuation))
  add(query_564244, "timeout", newJInt(timeout))
  add(query_564244, "resource", newJString(resource))
  add(path_564243, "path", newJString(path))
  add(path_564243, "filesystem", newJString(filesystem))
  result = call_564242.call(path_564243, query_564244, nil, nil, nil)

var pathCreate* = Call_PathCreate_564206(name: "pathCreate",
                                      meth: HttpMethod.HttpPut,
                                      host: "azure.local",
                                      route: "/{filesystem}/{path}",
                                      validator: validate_PathCreate_564207,
                                      base: "", url: url_PathCreate_564208,
                                      schemes: {Scheme.Https})
type
  Call_PathGetProperties_564287 = ref object of OpenApiRestCall_563556
proc url_PathGetProperties_564289(protocol: Scheme; host: string; base: string;
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

proc validate_PathGetProperties_564288(path: JsonNode; query: JsonNode;
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
  var valid_564290 = path.getOrDefault("path")
  valid_564290 = validateParameter(valid_564290, JString, required = true,
                                 default = nil)
  if valid_564290 != nil:
    section.add "path", valid_564290
  var valid_564291 = path.getOrDefault("filesystem")
  valid_564291 = validateParameter(valid_564291, JString, required = true,
                                 default = nil)
  if valid_564291 != nil:
    section.add "filesystem", valid_564291
  result.add "path", section
  ## parameters in `query` object:
  ##   fsAction: JString
  ##           : Required only for check access action. Valid only when Hierarchical Namespace is enabled for the account. File system operation read/write/execute in string form, matching regex pattern '[rwx-]{3}'
  ##   action: JString
  ##         : Optional. If the value is "getStatus" only the system defined properties for the path are returned. If the value is "getAccessControl" the access control list is returned in the response headers (Hierarchical Namespace must be enabled for the account), otherwise the properties are returned.
  ##   timeout: JInt
  ##          : An optional operation timeout value in seconds. The period begins when the request is received by the service. If the timeout value elapses before the operation completes, the operation fails.
  ##   upn: JBool
  ##      : Optional. Valid only when Hierarchical Namespace is enabled for the account. If "true", the user identity values returned in the x-ms-owner, x-ms-group, and x-ms-acl response headers will be transformed from Azure Active Directory Object IDs to User Principal Names.  If "false", the values will be returned as Azure Active Directory Object IDs. The default value is false. Note that group and application Object IDs are not translated because they do not have unique friendly names.
  section = newJObject()
  var valid_564292 = query.getOrDefault("fsAction")
  valid_564292 = validateParameter(valid_564292, JString, required = false,
                                 default = nil)
  if valid_564292 != nil:
    section.add "fsAction", valid_564292
  var valid_564293 = query.getOrDefault("action")
  valid_564293 = validateParameter(valid_564293, JString, required = false,
                                 default = newJString("getAccessControl"))
  if valid_564293 != nil:
    section.add "action", valid_564293
  var valid_564294 = query.getOrDefault("timeout")
  valid_564294 = validateParameter(valid_564294, JInt, required = false, default = nil)
  if valid_564294 != nil:
    section.add "timeout", valid_564294
  var valid_564295 = query.getOrDefault("upn")
  valid_564295 = validateParameter(valid_564295, JBool, required = false, default = nil)
  if valid_564295 != nil:
    section.add "upn", valid_564295
  result.add "query", section
  ## parameters in `header` object:
  ##   x-ms-lease-id: JString
  ##                : Optional. If this header is specified, the operation will be performed only if both of the following conditions are met: i) the path's lease is currently active and ii) the lease ID specified in the request matches that of the path.
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
  var valid_564296 = header.getOrDefault("x-ms-lease-id")
  valid_564296 = validateParameter(valid_564296, JString, required = false,
                                 default = nil)
  if valid_564296 != nil:
    section.add "x-ms-lease-id", valid_564296
  var valid_564297 = header.getOrDefault("x-ms-version")
  valid_564297 = validateParameter(valid_564297, JString, required = false,
                                 default = nil)
  if valid_564297 != nil:
    section.add "x-ms-version", valid_564297
  var valid_564298 = header.getOrDefault("x-ms-date")
  valid_564298 = validateParameter(valid_564298, JString, required = false,
                                 default = nil)
  if valid_564298 != nil:
    section.add "x-ms-date", valid_564298
  var valid_564299 = header.getOrDefault("If-Unmodified-Since")
  valid_564299 = validateParameter(valid_564299, JString, required = false,
                                 default = nil)
  if valid_564299 != nil:
    section.add "If-Unmodified-Since", valid_564299
  var valid_564300 = header.getOrDefault("x-ms-client-request-id")
  valid_564300 = validateParameter(valid_564300, JString, required = false,
                                 default = nil)
  if valid_564300 != nil:
    section.add "x-ms-client-request-id", valid_564300
  var valid_564301 = header.getOrDefault("If-Modified-Since")
  valid_564301 = validateParameter(valid_564301, JString, required = false,
                                 default = nil)
  if valid_564301 != nil:
    section.add "If-Modified-Since", valid_564301
  var valid_564302 = header.getOrDefault("If-None-Match")
  valid_564302 = validateParameter(valid_564302, JString, required = false,
                                 default = nil)
  if valid_564302 != nil:
    section.add "If-None-Match", valid_564302
  var valid_564303 = header.getOrDefault("If-Match")
  valid_564303 = validateParameter(valid_564303, JString, required = false,
                                 default = nil)
  if valid_564303 != nil:
    section.add "If-Match", valid_564303
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564304: Call_PathGetProperties_564287; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get Properties returns all system and user defined properties for a path. Get Status returns all system defined properties for a path. Get Access Control List returns the access control list for a path. This operation supports conditional HTTP requests.  For more information, see [Specifying Conditional Headers for Blob Service Operations](https://docs.microsoft.com/en-us/rest/api/storageservices/specifying-conditional-headers-for-blob-service-operations).
  ## 
  let valid = call_564304.validator(path, query, header, formData, body)
  let scheme = call_564304.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564304.url(scheme.get, call_564304.host, call_564304.base,
                         call_564304.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564304, url, valid)

proc call*(call_564305: Call_PathGetProperties_564287; path: string;
          filesystem: string; fsAction: string = "";
          action: string = "getAccessControl"; timeout: int = 0; upn: bool = false): Recallable =
  ## pathGetProperties
  ## Get Properties returns all system and user defined properties for a path. Get Status returns all system defined properties for a path. Get Access Control List returns the access control list for a path. This operation supports conditional HTTP requests.  For more information, see [Specifying Conditional Headers for Blob Service Operations](https://docs.microsoft.com/en-us/rest/api/storageservices/specifying-conditional-headers-for-blob-service-operations).
  ##   fsAction: string
  ##           : Required only for check access action. Valid only when Hierarchical Namespace is enabled for the account. File system operation read/write/execute in string form, matching regex pattern '[rwx-]{3}'
  ##   action: string
  ##         : Optional. If the value is "getStatus" only the system defined properties for the path are returned. If the value is "getAccessControl" the access control list is returned in the response headers (Hierarchical Namespace must be enabled for the account), otherwise the properties are returned.
  ##   timeout: int
  ##          : An optional operation timeout value in seconds. The period begins when the request is received by the service. If the timeout value elapses before the operation completes, the operation fails.
  ##   upn: bool
  ##      : Optional. Valid only when Hierarchical Namespace is enabled for the account. If "true", the user identity values returned in the x-ms-owner, x-ms-group, and x-ms-acl response headers will be transformed from Azure Active Directory Object IDs to User Principal Names.  If "false", the values will be returned as Azure Active Directory Object IDs. The default value is false. Note that group and application Object IDs are not translated because they do not have unique friendly names.
  ##   path: string (required)
  ##       : The file or directory path.
  ##   filesystem: string (required)
  ##             : The filesystem identifier.
  var path_564306 = newJObject()
  var query_564307 = newJObject()
  add(query_564307, "fsAction", newJString(fsAction))
  add(query_564307, "action", newJString(action))
  add(query_564307, "timeout", newJInt(timeout))
  add(query_564307, "upn", newJBool(upn))
  add(path_564306, "path", newJString(path))
  add(path_564306, "filesystem", newJString(filesystem))
  result = call_564305.call(path_564306, query_564307, nil, nil, nil)

var pathGetProperties* = Call_PathGetProperties_564287(name: "pathGetProperties",
    meth: HttpMethod.HttpHead, host: "azure.local", route: "/{filesystem}/{path}",
    validator: validate_PathGetProperties_564288, base: "",
    url: url_PathGetProperties_564289, schemes: {Scheme.Https})
type
  Call_PathLease_564245 = ref object of OpenApiRestCall_563556
proc url_PathLease_564247(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_PathLease_564246(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564248 = path.getOrDefault("path")
  valid_564248 = validateParameter(valid_564248, JString, required = true,
                                 default = nil)
  if valid_564248 != nil:
    section.add "path", valid_564248
  var valid_564249 = path.getOrDefault("filesystem")
  valid_564249 = validateParameter(valid_564249, JString, required = true,
                                 default = nil)
  if valid_564249 != nil:
    section.add "filesystem", valid_564249
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : An optional operation timeout value in seconds. The period begins when the request is received by the service. If the timeout value elapses before the operation completes, the operation fails.
  section = newJObject()
  var valid_564250 = query.getOrDefault("timeout")
  valid_564250 = validateParameter(valid_564250, JInt, required = false, default = nil)
  if valid_564250 != nil:
    section.add "timeout", valid_564250
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
  var valid_564251 = header.getOrDefault("x-ms-lease-duration")
  valid_564251 = validateParameter(valid_564251, JInt, required = false, default = nil)
  if valid_564251 != nil:
    section.add "x-ms-lease-duration", valid_564251
  var valid_564252 = header.getOrDefault("x-ms-proposed-lease-id")
  valid_564252 = validateParameter(valid_564252, JString, required = false,
                                 default = nil)
  if valid_564252 != nil:
    section.add "x-ms-proposed-lease-id", valid_564252
  var valid_564253 = header.getOrDefault("x-ms-lease-id")
  valid_564253 = validateParameter(valid_564253, JString, required = false,
                                 default = nil)
  if valid_564253 != nil:
    section.add "x-ms-lease-id", valid_564253
  var valid_564254 = header.getOrDefault("x-ms-version")
  valid_564254 = validateParameter(valid_564254, JString, required = false,
                                 default = nil)
  if valid_564254 != nil:
    section.add "x-ms-version", valid_564254
  var valid_564255 = header.getOrDefault("x-ms-date")
  valid_564255 = validateParameter(valid_564255, JString, required = false,
                                 default = nil)
  if valid_564255 != nil:
    section.add "x-ms-date", valid_564255
  var valid_564256 = header.getOrDefault("If-Unmodified-Since")
  valid_564256 = validateParameter(valid_564256, JString, required = false,
                                 default = nil)
  if valid_564256 != nil:
    section.add "If-Unmodified-Since", valid_564256
  var valid_564257 = header.getOrDefault("x-ms-client-request-id")
  valid_564257 = validateParameter(valid_564257, JString, required = false,
                                 default = nil)
  if valid_564257 != nil:
    section.add "x-ms-client-request-id", valid_564257
  var valid_564258 = header.getOrDefault("If-Modified-Since")
  valid_564258 = validateParameter(valid_564258, JString, required = false,
                                 default = nil)
  if valid_564258 != nil:
    section.add "If-Modified-Since", valid_564258
  var valid_564259 = header.getOrDefault("If-None-Match")
  valid_564259 = validateParameter(valid_564259, JString, required = false,
                                 default = nil)
  if valid_564259 != nil:
    section.add "If-None-Match", valid_564259
  var valid_564260 = header.getOrDefault("x-ms-lease-break-period")
  valid_564260 = validateParameter(valid_564260, JInt, required = false, default = nil)
  if valid_564260 != nil:
    section.add "x-ms-lease-break-period", valid_564260
  assert header != nil, "header argument is necessary due to required `x-ms-lease-action` field"
  var valid_564261 = header.getOrDefault("x-ms-lease-action")
  valid_564261 = validateParameter(valid_564261, JString, required = true,
                                 default = newJString("acquire"))
  if valid_564261 != nil:
    section.add "x-ms-lease-action", valid_564261
  var valid_564262 = header.getOrDefault("If-Match")
  valid_564262 = validateParameter(valid_564262, JString, required = false,
                                 default = nil)
  if valid_564262 != nil:
    section.add "If-Match", valid_564262
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564263: Call_PathLease_564245; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create and manage a lease to restrict write and delete access to the path. This operation supports conditional HTTP requests.  For more information, see [Specifying Conditional Headers for Blob Service Operations](https://docs.microsoft.com/en-us/rest/api/storageservices/specifying-conditional-headers-for-blob-service-operations).
  ## 
  let valid = call_564263.validator(path, query, header, formData, body)
  let scheme = call_564263.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564263.url(scheme.get, call_564263.host, call_564263.base,
                         call_564263.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564263, url, valid)

proc call*(call_564264: Call_PathLease_564245; path: string; filesystem: string;
          timeout: int = 0): Recallable =
  ## pathLease
  ## Create and manage a lease to restrict write and delete access to the path. This operation supports conditional HTTP requests.  For more information, see [Specifying Conditional Headers for Blob Service Operations](https://docs.microsoft.com/en-us/rest/api/storageservices/specifying-conditional-headers-for-blob-service-operations).
  ##   timeout: int
  ##          : An optional operation timeout value in seconds. The period begins when the request is received by the service. If the timeout value elapses before the operation completes, the operation fails.
  ##   path: string (required)
  ##       : The file or directory path.
  ##   filesystem: string (required)
  ##             : The filesystem identifier.
  var path_564265 = newJObject()
  var query_564266 = newJObject()
  add(query_564266, "timeout", newJInt(timeout))
  add(path_564265, "path", newJString(path))
  add(path_564265, "filesystem", newJString(filesystem))
  result = call_564264.call(path_564265, query_564266, nil, nil, nil)

var pathLease* = Call_PathLease_564245(name: "pathLease", meth: HttpMethod.HttpPost,
                                    host: "azure.local",
                                    route: "/{filesystem}/{path}",
                                    validator: validate_PathLease_564246,
                                    base: "", url: url_PathLease_564247,
                                    schemes: {Scheme.Https})
type
  Call_PathRead_564186 = ref object of OpenApiRestCall_563556
proc url_PathRead_564188(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_PathRead_564187(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564189 = path.getOrDefault("path")
  valid_564189 = validateParameter(valid_564189, JString, required = true,
                                 default = nil)
  if valid_564189 != nil:
    section.add "path", valid_564189
  var valid_564190 = path.getOrDefault("filesystem")
  valid_564190 = validateParameter(valid_564190, JString, required = true,
                                 default = nil)
  if valid_564190 != nil:
    section.add "filesystem", valid_564190
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : An optional operation timeout value in seconds. The period begins when the request is received by the service. If the timeout value elapses before the operation completes, the operation fails.
  section = newJObject()
  var valid_564191 = query.getOrDefault("timeout")
  valid_564191 = validateParameter(valid_564191, JInt, required = false, default = nil)
  if valid_564191 != nil:
    section.add "timeout", valid_564191
  result.add "query", section
  ## parameters in `header` object:
  ##   x-ms-lease-id: JString
  ##                : Optional. If this header is specified, the operation will be performed only if both of the following conditions are met: i) the path's lease is currently active and ii) the lease ID specified in the request matches that of the path.
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
  ##   x-ms-range-get-content-md5: JBool
  ##                             : Optional. When this header is set to "true" and specified together with the Range header, the service returns the MD5 hash for the range, as long as the range is less than or equal to 4MB in size. If this header is specified without the Range header, the service returns status code 400 (Bad Request). If this header is set to true when the range exceeds 4 MB in size, the service returns status code 400 (Bad Request).
  section = newJObject()
  var valid_564192 = header.getOrDefault("x-ms-lease-id")
  valid_564192 = validateParameter(valid_564192, JString, required = false,
                                 default = nil)
  if valid_564192 != nil:
    section.add "x-ms-lease-id", valid_564192
  var valid_564193 = header.getOrDefault("x-ms-version")
  valid_564193 = validateParameter(valid_564193, JString, required = false,
                                 default = nil)
  if valid_564193 != nil:
    section.add "x-ms-version", valid_564193
  var valid_564194 = header.getOrDefault("x-ms-date")
  valid_564194 = validateParameter(valid_564194, JString, required = false,
                                 default = nil)
  if valid_564194 != nil:
    section.add "x-ms-date", valid_564194
  var valid_564195 = header.getOrDefault("If-Unmodified-Since")
  valid_564195 = validateParameter(valid_564195, JString, required = false,
                                 default = nil)
  if valid_564195 != nil:
    section.add "If-Unmodified-Since", valid_564195
  var valid_564196 = header.getOrDefault("x-ms-client-request-id")
  valid_564196 = validateParameter(valid_564196, JString, required = false,
                                 default = nil)
  if valid_564196 != nil:
    section.add "x-ms-client-request-id", valid_564196
  var valid_564197 = header.getOrDefault("Range")
  valid_564197 = validateParameter(valid_564197, JString, required = false,
                                 default = nil)
  if valid_564197 != nil:
    section.add "Range", valid_564197
  var valid_564198 = header.getOrDefault("If-Modified-Since")
  valid_564198 = validateParameter(valid_564198, JString, required = false,
                                 default = nil)
  if valid_564198 != nil:
    section.add "If-Modified-Since", valid_564198
  var valid_564199 = header.getOrDefault("If-None-Match")
  valid_564199 = validateParameter(valid_564199, JString, required = false,
                                 default = nil)
  if valid_564199 != nil:
    section.add "If-None-Match", valid_564199
  var valid_564200 = header.getOrDefault("If-Match")
  valid_564200 = validateParameter(valid_564200, JString, required = false,
                                 default = nil)
  if valid_564200 != nil:
    section.add "If-Match", valid_564200
  var valid_564201 = header.getOrDefault("x-ms-range-get-content-md5")
  valid_564201 = validateParameter(valid_564201, JBool, required = false, default = nil)
  if valid_564201 != nil:
    section.add "x-ms-range-get-content-md5", valid_564201
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564202: Call_PathRead_564186; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Read the contents of a file.  For read operations, range requests are supported. This operation supports conditional HTTP requests.  For more information, see [Specifying Conditional Headers for Blob Service Operations](https://docs.microsoft.com/en-us/rest/api/storageservices/specifying-conditional-headers-for-blob-service-operations).
  ## 
  let valid = call_564202.validator(path, query, header, formData, body)
  let scheme = call_564202.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564202.url(scheme.get, call_564202.host, call_564202.base,
                         call_564202.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564202, url, valid)

proc call*(call_564203: Call_PathRead_564186; path: string; filesystem: string;
          timeout: int = 0): Recallable =
  ## pathRead
  ## Read the contents of a file.  For read operations, range requests are supported. This operation supports conditional HTTP requests.  For more information, see [Specifying Conditional Headers for Blob Service Operations](https://docs.microsoft.com/en-us/rest/api/storageservices/specifying-conditional-headers-for-blob-service-operations).
  ##   timeout: int
  ##          : An optional operation timeout value in seconds. The period begins when the request is received by the service. If the timeout value elapses before the operation completes, the operation fails.
  ##   path: string (required)
  ##       : The file or directory path.
  ##   filesystem: string (required)
  ##             : The filesystem identifier.
  var path_564204 = newJObject()
  var query_564205 = newJObject()
  add(query_564205, "timeout", newJInt(timeout))
  add(path_564204, "path", newJString(path))
  add(path_564204, "filesystem", newJString(filesystem))
  result = call_564203.call(path_564204, query_564205, nil, nil, nil)

var pathRead* = Call_PathRead_564186(name: "pathRead", meth: HttpMethod.HttpGet,
                                  host: "azure.local",
                                  route: "/{filesystem}/{path}",
                                  validator: validate_PathRead_564187, base: "",
                                  url: url_PathRead_564188,
                                  schemes: {Scheme.Https})
type
  Call_PathUpdate_564308 = ref object of OpenApiRestCall_563556
proc url_PathUpdate_564310(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_PathUpdate_564309(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564311 = path.getOrDefault("path")
  valid_564311 = validateParameter(valid_564311, JString, required = true,
                                 default = nil)
  if valid_564311 != nil:
    section.add "path", valid_564311
  var valid_564312 = path.getOrDefault("filesystem")
  valid_564312 = validateParameter(valid_564312, JString, required = true,
                                 default = nil)
  if valid_564312 != nil:
    section.add "filesystem", valid_564312
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
  ##   close: JBool
  ##        : Azure Storage Events allow applications to receive notifications when files change. When Azure Storage Events are enabled, a file changed event is raised. This event has a property indicating whether this is the final change to distinguish the difference between an intermediate flush to a file stream and the final close of a file stream. The close query parameter is valid only when the action is "flush" and change notifications are enabled. If the value of close is "true" and the flush operation completes successfully, the service raises a file change notification with a property indicating that this is the final update (the file stream has been closed). If "false" a change notification is raised indicating the file has changed. The default is false. This query parameter is set to true by the Hadoop ABFS driver to indicate that the file stream has been closed."
  section = newJObject()
  assert query != nil, "query argument is necessary due to required `action` field"
  var valid_564313 = query.getOrDefault("action")
  valid_564313 = validateParameter(valid_564313, JString, required = true,
                                 default = newJString("append"))
  if valid_564313 != nil:
    section.add "action", valid_564313
  var valid_564314 = query.getOrDefault("position")
  valid_564314 = validateParameter(valid_564314, JInt, required = false, default = nil)
  if valid_564314 != nil:
    section.add "position", valid_564314
  var valid_564315 = query.getOrDefault("retainUncommittedData")
  valid_564315 = validateParameter(valid_564315, JBool, required = false, default = nil)
  if valid_564315 != nil:
    section.add "retainUncommittedData", valid_564315
  var valid_564316 = query.getOrDefault("timeout")
  valid_564316 = validateParameter(valid_564316, JInt, required = false, default = nil)
  if valid_564316 != nil:
    section.add "timeout", valid_564316
  var valid_564317 = query.getOrDefault("close")
  valid_564317 = validateParameter(valid_564317, JBool, required = false, default = nil)
  if valid_564317 != nil:
    section.add "close", valid_564317
  result.add "query", section
  ## parameters in `header` object:
  ##   x-ms-lease-id: JString
  ##                : The lease ID must be specified if there is an active lease.
  ##   x-ms-permissions: JString
  ##                   : Optional and only valid if Hierarchical Namespace is enabled for the account. Sets POSIX access permissions for the file owner, the file owning group, and others. Each class may be granted read, write, or execute permission.  The sticky bit is also supported.  Both symbolic (rwxrw-rw-) and 4-digit octal notation (e.g. 0766) are supported. Invalid in conjunction with x-ms-acl.
  ##   x-ms-version: JString
  ##               : Specifies the version of the REST protocol used for processing the request. This is required when using shared key authorization.
  ##   Content-Length: JInt
  ##                 : Required for "Append Data" and "Flush Data".  Must be 0 for "Flush Data".  Must be the length of the request content in bytes for "Append Data".
  ##   x-ms-date: JString
  ##            : Specifies the Coordinated Universal Time (UTC) for the request.  This is required when using shared key authorization.
  ##   x-ms-content-type: JString
  ##                    : Optional and only valid for flush and set properties operations.  The service stores this value and includes it in the "Content-Type" response header for "Read File" operations.
  ##   x-ms-properties: JString
  ##                  : Optional.  User-defined properties to be stored with the file or directory, in the format of a comma-separated list of name and value pairs "n1=v1, n2=v2, ...", where each value is a base64 encoded string. Note that the string may only contain ASCII characters in the ISO-8859-1 character set. Valid only for the setProperties operation. If the file or directory exists, any properties not included in the list will be removed.  All properties are removed if the header is omitted.  To merge new and existing properties, first get all existing properties and the current E-Tag, then make a conditional request with the E-Tag and include values for all properties.
  ##   x-ms-acl: JString
  ##           : Optional and valid only for the setAccessControl operation. Sets POSIX access control rights on files and directories. The value is a comma-separated list of access control entries that fully replaces the existing access control list (ACL).  Each access control entry (ACE) consists of a scope, a type, a user or group identifier, and permissions in the format "[scope:][type]:[id]:[permissions]". The scope must be "default" to indicate the ACE belongs to the default ACL for a directory; otherwise scope is implicit and the ACE belongs to the access ACL.  There are four ACE types: "user" grants rights to the owner or a named user, "group" grants rights to the owning group or a named group, "mask" restricts rights granted to named users and the members of groups, and "other" grants rights to all users not found in any of the other entries. The user or group identifier is omitted for entries of type "mask" and "other".  The user or group identifier is also omitted for the owner and owning group.  The permission field is a 3-character sequence where the first character is 'r' to grant read access, the second character is 'w' to grant write access, and the third character is 'x' to grant execute permission.  If access is not granted, the '-' character is used to denote that the permission is denied. For example, the following ACL grants read, write, and execute rights to the file owner and john.doe@contoso, the read right to the owning group, and nothing to everyone else: "user::rwx,user:john.doe@contoso:rwx,group::r--,other::---,mask=rwx". Invalid in conjunction with x-ms-permissions.
  ##   x-ms-content-disposition: JString
  ##                           : Optional and only valid for flush and set properties operations.  The service stores this value and includes it in the "Content-Disposition" response header for "Read File" operations.
  ##   x-ms-client-request-id: JString
  ##                         : A UUID recorded in the analytics logs for troubleshooting and correlation.
  ##   If-Unmodified-Since: JString
  ##                      : Optional for Flush Data and Set Properties, but invalid for Append Data. A date and time value. Specify this header to perform the operation only if the resource has not been modified since the specified date and time.
  ##   Content-MD5: JString
  ##              : Optional. An MD5 hash of the request content. This header is valid on "Append" and "Flush" operations. This hash is used to verify the integrity of the request content during transport. When this header is specified, the storage service compares the hash of the content that has arrived with this header value. If the two hashes do not match, the operation will fail with error code 400 (Bad Request). Note that this MD5 hash is not stored with the file. This header is associated with the request content, and not with the stored content of the file itself.
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
  ##   x-ms-content-md5: JString
  ##                   : Optional and only valid for "Flush & Set Properties" operations.  The service stores this value and includes it in the "Content-Md5" response header for "Read & Get Properties" operations. If this property is not specified on the request, then the property will be cleared for the file. Subsequent calls to "Read & Get Properties" will not return this property unless it is explicitly set on that file again.
  ##   x-ms-content-encoding: JString
  ##                        : Optional and only valid for flush and set properties operations.  The service stores this value and includes it in the "Content-Encoding" response header for "Read File" operations.
  ##   x-ms-content-language: JString
  ##                        : Optional and only valid for flush and set properties operations.  The service stores this value and includes it in the "Content-Language" response header for "Read File" operations.
  ##   If-Match: JString
  ##           : Optional for Flush Data and Set Properties, but invalid for Append Data.  An ETag value. Specify this header to perform the operation only if the resource's ETag matches the value specified. The ETag must be specified in quotes.
  section = newJObject()
  var valid_564318 = header.getOrDefault("x-ms-lease-id")
  valid_564318 = validateParameter(valid_564318, JString, required = false,
                                 default = nil)
  if valid_564318 != nil:
    section.add "x-ms-lease-id", valid_564318
  var valid_564319 = header.getOrDefault("x-ms-permissions")
  valid_564319 = validateParameter(valid_564319, JString, required = false,
                                 default = nil)
  if valid_564319 != nil:
    section.add "x-ms-permissions", valid_564319
  var valid_564320 = header.getOrDefault("x-ms-version")
  valid_564320 = validateParameter(valid_564320, JString, required = false,
                                 default = nil)
  if valid_564320 != nil:
    section.add "x-ms-version", valid_564320
  var valid_564321 = header.getOrDefault("Content-Length")
  valid_564321 = validateParameter(valid_564321, JInt, required = false, default = nil)
  if valid_564321 != nil:
    section.add "Content-Length", valid_564321
  var valid_564322 = header.getOrDefault("x-ms-date")
  valid_564322 = validateParameter(valid_564322, JString, required = false,
                                 default = nil)
  if valid_564322 != nil:
    section.add "x-ms-date", valid_564322
  var valid_564323 = header.getOrDefault("x-ms-content-type")
  valid_564323 = validateParameter(valid_564323, JString, required = false,
                                 default = nil)
  if valid_564323 != nil:
    section.add "x-ms-content-type", valid_564323
  var valid_564324 = header.getOrDefault("x-ms-properties")
  valid_564324 = validateParameter(valid_564324, JString, required = false,
                                 default = nil)
  if valid_564324 != nil:
    section.add "x-ms-properties", valid_564324
  var valid_564325 = header.getOrDefault("x-ms-acl")
  valid_564325 = validateParameter(valid_564325, JString, required = false,
                                 default = nil)
  if valid_564325 != nil:
    section.add "x-ms-acl", valid_564325
  var valid_564326 = header.getOrDefault("x-ms-content-disposition")
  valid_564326 = validateParameter(valid_564326, JString, required = false,
                                 default = nil)
  if valid_564326 != nil:
    section.add "x-ms-content-disposition", valid_564326
  var valid_564327 = header.getOrDefault("x-ms-client-request-id")
  valid_564327 = validateParameter(valid_564327, JString, required = false,
                                 default = nil)
  if valid_564327 != nil:
    section.add "x-ms-client-request-id", valid_564327
  var valid_564328 = header.getOrDefault("If-Unmodified-Since")
  valid_564328 = validateParameter(valid_564328, JString, required = false,
                                 default = nil)
  if valid_564328 != nil:
    section.add "If-Unmodified-Since", valid_564328
  var valid_564329 = header.getOrDefault("Content-MD5")
  valid_564329 = validateParameter(valid_564329, JString, required = false,
                                 default = nil)
  if valid_564329 != nil:
    section.add "Content-MD5", valid_564329
  var valid_564330 = header.getOrDefault("If-Modified-Since")
  valid_564330 = validateParameter(valid_564330, JString, required = false,
                                 default = nil)
  if valid_564330 != nil:
    section.add "If-Modified-Since", valid_564330
  var valid_564331 = header.getOrDefault("If-None-Match")
  valid_564331 = validateParameter(valid_564331, JString, required = false,
                                 default = nil)
  if valid_564331 != nil:
    section.add "If-None-Match", valid_564331
  var valid_564332 = header.getOrDefault("x-ms-cache-control")
  valid_564332 = validateParameter(valid_564332, JString, required = false,
                                 default = nil)
  if valid_564332 != nil:
    section.add "x-ms-cache-control", valid_564332
  var valid_564333 = header.getOrDefault("x-ms-owner")
  valid_564333 = validateParameter(valid_564333, JString, required = false,
                                 default = nil)
  if valid_564333 != nil:
    section.add "x-ms-owner", valid_564333
  var valid_564334 = header.getOrDefault("x-ms-group")
  valid_564334 = validateParameter(valid_564334, JString, required = false,
                                 default = nil)
  if valid_564334 != nil:
    section.add "x-ms-group", valid_564334
  var valid_564335 = header.getOrDefault("x-ms-content-md5")
  valid_564335 = validateParameter(valid_564335, JString, required = false,
                                 default = nil)
  if valid_564335 != nil:
    section.add "x-ms-content-md5", valid_564335
  var valid_564336 = header.getOrDefault("x-ms-content-encoding")
  valid_564336 = validateParameter(valid_564336, JString, required = false,
                                 default = nil)
  if valid_564336 != nil:
    section.add "x-ms-content-encoding", valid_564336
  var valid_564337 = header.getOrDefault("x-ms-content-language")
  valid_564337 = validateParameter(valid_564337, JString, required = false,
                                 default = nil)
  if valid_564337 != nil:
    section.add "x-ms-content-language", valid_564337
  var valid_564338 = header.getOrDefault("If-Match")
  valid_564338 = validateParameter(valid_564338, JString, required = false,
                                 default = nil)
  if valid_564338 != nil:
    section.add "If-Match", valid_564338
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   requestBody: JObject
  ##              : Valid only for append operations.  The data to be uploaded and appended to the file.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564340: Call_PathUpdate_564308; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Uploads data to be appended to a file, flushes (writes) previously uploaded data to a file, sets properties for a file or directory, or sets access control for a file or directory. Data can only be appended to a file. This operation supports conditional HTTP requests. For more information, see [Specifying Conditional Headers for Blob Service Operations](https://docs.microsoft.com/en-us/rest/api/storageservices/specifying-conditional-headers-for-blob-service-operations).
  ## 
  let valid = call_564340.validator(path, query, header, formData, body)
  let scheme = call_564340.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564340.url(scheme.get, call_564340.host, call_564340.base,
                         call_564340.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564340, url, valid)

proc call*(call_564341: Call_PathUpdate_564308; path: string; filesystem: string;
          action: string = "append"; position: int = 0;
          retainUncommittedData: bool = false; timeout: int = 0;
          requestBody: JsonNode = nil; close: bool = false): Recallable =
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
  ##   close: bool
  ##        : Azure Storage Events allow applications to receive notifications when files change. When Azure Storage Events are enabled, a file changed event is raised. This event has a property indicating whether this is the final change to distinguish the difference between an intermediate flush to a file stream and the final close of a file stream. The close query parameter is valid only when the action is "flush" and change notifications are enabled. If the value of close is "true" and the flush operation completes successfully, the service raises a file change notification with a property indicating that this is the final update (the file stream has been closed). If "false" a change notification is raised indicating the file has changed. The default is false. This query parameter is set to true by the Hadoop ABFS driver to indicate that the file stream has been closed."
  ##   path: string (required)
  ##       : The file or directory path.
  ##   filesystem: string (required)
  ##             : The filesystem identifier.
  var path_564342 = newJObject()
  var query_564343 = newJObject()
  var body_564344 = newJObject()
  add(query_564343, "action", newJString(action))
  add(query_564343, "position", newJInt(position))
  add(query_564343, "retainUncommittedData", newJBool(retainUncommittedData))
  add(query_564343, "timeout", newJInt(timeout))
  if requestBody != nil:
    body_564344 = requestBody
  add(query_564343, "close", newJBool(close))
  add(path_564342, "path", newJString(path))
  add(path_564342, "filesystem", newJString(filesystem))
  result = call_564341.call(path_564342, query_564343, nil, nil, body_564344)

var pathUpdate* = Call_PathUpdate_564308(name: "pathUpdate",
                                      meth: HttpMethod.HttpPatch,
                                      host: "azure.local",
                                      route: "/{filesystem}/{path}",
                                      validator: validate_PathUpdate_564309,
                                      base: "", url: url_PathUpdate_564310,
                                      schemes: {Scheme.Https})
type
  Call_PathDelete_564267 = ref object of OpenApiRestCall_563556
proc url_PathDelete_564269(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_PathDelete_564268(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564270 = path.getOrDefault("path")
  valid_564270 = validateParameter(valid_564270, JString, required = true,
                                 default = nil)
  if valid_564270 != nil:
    section.add "path", valid_564270
  var valid_564271 = path.getOrDefault("filesystem")
  valid_564271 = validateParameter(valid_564271, JString, required = true,
                                 default = nil)
  if valid_564271 != nil:
    section.add "filesystem", valid_564271
  result.add "path", section
  ## parameters in `query` object:
  ##   recursive: JBool
  ##            : Required and valid only when the resource is a directory.  If "true", all paths beneath the directory will be deleted. If "false" and the directory is non-empty, an error occurs.
  ##   continuation: JString
  ##               : Optional.  When deleting a directory, the number of paths that are deleted with each invocation is limited.  If the number of paths to be deleted exceeds this limit, a continuation token is returned in this response header.  When a continuation token is returned in the response, it must be specified in a subsequent invocation of the delete operation to continue deleting the directory.
  ##   timeout: JInt
  ##          : An optional operation timeout value in seconds. The period begins when the request is received by the service. If the timeout value elapses before the operation completes, the operation fails.
  section = newJObject()
  var valid_564272 = query.getOrDefault("recursive")
  valid_564272 = validateParameter(valid_564272, JBool, required = false, default = nil)
  if valid_564272 != nil:
    section.add "recursive", valid_564272
  var valid_564273 = query.getOrDefault("continuation")
  valid_564273 = validateParameter(valid_564273, JString, required = false,
                                 default = nil)
  if valid_564273 != nil:
    section.add "continuation", valid_564273
  var valid_564274 = query.getOrDefault("timeout")
  valid_564274 = validateParameter(valid_564274, JInt, required = false, default = nil)
  if valid_564274 != nil:
    section.add "timeout", valid_564274
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
  var valid_564275 = header.getOrDefault("x-ms-lease-id")
  valid_564275 = validateParameter(valid_564275, JString, required = false,
                                 default = nil)
  if valid_564275 != nil:
    section.add "x-ms-lease-id", valid_564275
  var valid_564276 = header.getOrDefault("x-ms-version")
  valid_564276 = validateParameter(valid_564276, JString, required = false,
                                 default = nil)
  if valid_564276 != nil:
    section.add "x-ms-version", valid_564276
  var valid_564277 = header.getOrDefault("x-ms-date")
  valid_564277 = validateParameter(valid_564277, JString, required = false,
                                 default = nil)
  if valid_564277 != nil:
    section.add "x-ms-date", valid_564277
  var valid_564278 = header.getOrDefault("If-Unmodified-Since")
  valid_564278 = validateParameter(valid_564278, JString, required = false,
                                 default = nil)
  if valid_564278 != nil:
    section.add "If-Unmodified-Since", valid_564278
  var valid_564279 = header.getOrDefault("x-ms-client-request-id")
  valid_564279 = validateParameter(valid_564279, JString, required = false,
                                 default = nil)
  if valid_564279 != nil:
    section.add "x-ms-client-request-id", valid_564279
  var valid_564280 = header.getOrDefault("If-Modified-Since")
  valid_564280 = validateParameter(valid_564280, JString, required = false,
                                 default = nil)
  if valid_564280 != nil:
    section.add "If-Modified-Since", valid_564280
  var valid_564281 = header.getOrDefault("If-None-Match")
  valid_564281 = validateParameter(valid_564281, JString, required = false,
                                 default = nil)
  if valid_564281 != nil:
    section.add "If-None-Match", valid_564281
  var valid_564282 = header.getOrDefault("If-Match")
  valid_564282 = validateParameter(valid_564282, JString, required = false,
                                 default = nil)
  if valid_564282 != nil:
    section.add "If-Match", valid_564282
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564283: Call_PathDelete_564267; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete the file or directory. This operation supports conditional HTTP requests.  For more information, see [Specifying Conditional Headers for Blob Service Operations](https://docs.microsoft.com/en-us/rest/api/storageservices/specifying-conditional-headers-for-blob-service-operations).
  ## 
  let valid = call_564283.validator(path, query, header, formData, body)
  let scheme = call_564283.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564283.url(scheme.get, call_564283.host, call_564283.base,
                         call_564283.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564283, url, valid)

proc call*(call_564284: Call_PathDelete_564267; path: string; filesystem: string;
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
  var path_564285 = newJObject()
  var query_564286 = newJObject()
  add(query_564286, "recursive", newJBool(recursive))
  add(query_564286, "continuation", newJString(continuation))
  add(query_564286, "timeout", newJInt(timeout))
  add(path_564285, "path", newJString(path))
  add(path_564285, "filesystem", newJString(filesystem))
  result = call_564284.call(path_564285, query_564286, nil, nil, nil)

var pathDelete* = Call_PathDelete_564267(name: "pathDelete",
                                      meth: HttpMethod.HttpDelete,
                                      host: "azure.local",
                                      route: "/{filesystem}/{path}",
                                      validator: validate_PathDelete_564268,
                                      base: "", url: url_PathDelete_564269,
                                      schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
