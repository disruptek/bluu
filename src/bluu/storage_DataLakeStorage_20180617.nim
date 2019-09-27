
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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
  macServiceName = "storage-DataLakeStorage"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_FilesystemList_593647 = ref object of OpenApiRestCall_593425
proc url_FilesystemList_593649(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_FilesystemList_593648(path: JsonNode; query: JsonNode;
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
  var valid_593808 = query.getOrDefault("timeout")
  valid_593808 = validateParameter(valid_593808, JInt, required = false, default = nil)
  if valid_593808 != nil:
    section.add "timeout", valid_593808
  var valid_593809 = query.getOrDefault("continuation")
  valid_593809 = validateParameter(valid_593809, JString, required = false,
                                 default = nil)
  if valid_593809 != nil:
    section.add "continuation", valid_593809
  assert query != nil,
        "query argument is necessary due to required `resource` field"
  var valid_593823 = query.getOrDefault("resource")
  valid_593823 = validateParameter(valid_593823, JString, required = true,
                                 default = newJString("account"))
  if valid_593823 != nil:
    section.add "resource", valid_593823
  var valid_593824 = query.getOrDefault("maxResults")
  valid_593824 = validateParameter(valid_593824, JInt, required = false, default = nil)
  if valid_593824 != nil:
    section.add "maxResults", valid_593824
  var valid_593825 = query.getOrDefault("prefix")
  valid_593825 = validateParameter(valid_593825, JString, required = false,
                                 default = nil)
  if valid_593825 != nil:
    section.add "prefix", valid_593825
  result.add "query", section
  ## parameters in `header` object:
  ##   x-ms-client-request-id: JString
  ##                         : A UUID recorded in the analytics logs for troubleshooting and correlation.
  ##   x-ms-date: JString
  ##            : Specifies the Coordinated Universal Time (UTC) for the request.  This is required when using shared key authorization.
  ##   x-ms-version: JString
  ##               : Specifies the version of the REST protocol used for processing the request. This is required when using shared key authorization.
  section = newJObject()
  var valid_593826 = header.getOrDefault("x-ms-client-request-id")
  valid_593826 = validateParameter(valid_593826, JString, required = false,
                                 default = nil)
  if valid_593826 != nil:
    section.add "x-ms-client-request-id", valid_593826
  var valid_593827 = header.getOrDefault("x-ms-date")
  valid_593827 = validateParameter(valid_593827, JString, required = false,
                                 default = nil)
  if valid_593827 != nil:
    section.add "x-ms-date", valid_593827
  var valid_593828 = header.getOrDefault("x-ms-version")
  valid_593828 = validateParameter(valid_593828, JString, required = false,
                                 default = nil)
  if valid_593828 != nil:
    section.add "x-ms-version", valid_593828
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593851: Call_FilesystemList_593647; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List filesystems and their properties in given account.
  ## 
  let valid = call_593851.validator(path, query, header, formData, body)
  let scheme = call_593851.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593851.url(scheme.get, call_593851.host, call_593851.base,
                         call_593851.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593851, url, valid)

proc call*(call_593922: Call_FilesystemList_593647; timeout: int = 0;
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
  var query_593923 = newJObject()
  add(query_593923, "timeout", newJInt(timeout))
  add(query_593923, "continuation", newJString(continuation))
  add(query_593923, "resource", newJString(resource))
  add(query_593923, "maxResults", newJInt(maxResults))
  add(query_593923, "prefix", newJString(prefix))
  result = call_593922.call(nil, query_593923, nil, nil, nil)

var filesystemList* = Call_FilesystemList_593647(name: "filesystemList",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/",
    validator: validate_FilesystemList_593648, base: "", url: url_FilesystemList_593649,
    schemes: {Scheme.Https})
type
  Call_FilesystemCreate_593994 = ref object of OpenApiRestCall_593425
proc url_FilesystemCreate_593996(protocol: Scheme; host: string; base: string;
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

proc validate_FilesystemCreate_593995(path: JsonNode; query: JsonNode;
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
  var valid_593997 = path.getOrDefault("filesystem")
  valid_593997 = validateParameter(valid_593997, JString, required = true,
                                 default = nil)
  if valid_593997 != nil:
    section.add "filesystem", valid_593997
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : An optional operation timeout value in seconds. The period begins when the request is received by the service. If the timeout value elapses before the operation completes, the operation fails.
  ##   resource: JString (required)
  ##           : The value must be "filesystem" for all filesystem operations.
  section = newJObject()
  var valid_593998 = query.getOrDefault("timeout")
  valid_593998 = validateParameter(valid_593998, JInt, required = false, default = nil)
  if valid_593998 != nil:
    section.add "timeout", valid_593998
  assert query != nil,
        "query argument is necessary due to required `resource` field"
  var valid_593999 = query.getOrDefault("resource")
  valid_593999 = validateParameter(valid_593999, JString, required = true,
                                 default = newJString("filesystem"))
  if valid_593999 != nil:
    section.add "resource", valid_593999
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
  var valid_594000 = header.getOrDefault("x-ms-properties")
  valid_594000 = validateParameter(valid_594000, JString, required = false,
                                 default = nil)
  if valid_594000 != nil:
    section.add "x-ms-properties", valid_594000
  var valid_594001 = header.getOrDefault("x-ms-client-request-id")
  valid_594001 = validateParameter(valid_594001, JString, required = false,
                                 default = nil)
  if valid_594001 != nil:
    section.add "x-ms-client-request-id", valid_594001
  var valid_594002 = header.getOrDefault("x-ms-date")
  valid_594002 = validateParameter(valid_594002, JString, required = false,
                                 default = nil)
  if valid_594002 != nil:
    section.add "x-ms-date", valid_594002
  var valid_594003 = header.getOrDefault("x-ms-version")
  valid_594003 = validateParameter(valid_594003, JString, required = false,
                                 default = nil)
  if valid_594003 != nil:
    section.add "x-ms-version", valid_594003
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594004: Call_FilesystemCreate_593994; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a filesystem rooted at the specified location. If the filesystem already exists, the operation fails.  This operation does not support conditional HTTP requests.
  ## 
  let valid = call_594004.validator(path, query, header, formData, body)
  let scheme = call_594004.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594004.url(scheme.get, call_594004.host, call_594004.base,
                         call_594004.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594004, url, valid)

proc call*(call_594005: Call_FilesystemCreate_593994; filesystem: string;
          timeout: int = 0; resource: string = "filesystem"): Recallable =
  ## filesystemCreate
  ## Create a filesystem rooted at the specified location. If the filesystem already exists, the operation fails.  This operation does not support conditional HTTP requests.
  ##   timeout: int
  ##          : An optional operation timeout value in seconds. The period begins when the request is received by the service. If the timeout value elapses before the operation completes, the operation fails.
  ##   resource: string (required)
  ##           : The value must be "filesystem" for all filesystem operations.
  ##   filesystem: string (required)
  ##             : The filesystem identifier.  The value must start and end with a letter or number and must contain only letters, numbers, and the dash (-) character.  Consecutive dashes are not permitted.  All letters must be lowercase.  The value must have between 3 and 63 characters.
  var path_594006 = newJObject()
  var query_594007 = newJObject()
  add(query_594007, "timeout", newJInt(timeout))
  add(query_594007, "resource", newJString(resource))
  add(path_594006, "filesystem", newJString(filesystem))
  result = call_594005.call(path_594006, query_594007, nil, nil, nil)

var filesystemCreate* = Call_FilesystemCreate_593994(name: "filesystemCreate",
    meth: HttpMethod.HttpPut, host: "azure.local", route: "/{filesystem}",
    validator: validate_FilesystemCreate_593995, base: "",
    url: url_FilesystemCreate_593996, schemes: {Scheme.Https})
type
  Call_FilesystemGetProperties_594023 = ref object of OpenApiRestCall_593425
proc url_FilesystemGetProperties_594025(protocol: Scheme; host: string; base: string;
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

proc validate_FilesystemGetProperties_594024(path: JsonNode; query: JsonNode;
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
  var valid_594026 = path.getOrDefault("filesystem")
  valid_594026 = validateParameter(valid_594026, JString, required = true,
                                 default = nil)
  if valid_594026 != nil:
    section.add "filesystem", valid_594026
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : An optional operation timeout value in seconds. The period begins when the request is received by the service. If the timeout value elapses before the operation completes, the operation fails.
  ##   resource: JString (required)
  ##           : The value must be "filesystem" for all filesystem operations.
  section = newJObject()
  var valid_594027 = query.getOrDefault("timeout")
  valid_594027 = validateParameter(valid_594027, JInt, required = false, default = nil)
  if valid_594027 != nil:
    section.add "timeout", valid_594027
  assert query != nil,
        "query argument is necessary due to required `resource` field"
  var valid_594028 = query.getOrDefault("resource")
  valid_594028 = validateParameter(valid_594028, JString, required = true,
                                 default = newJString("filesystem"))
  if valid_594028 != nil:
    section.add "resource", valid_594028
  result.add "query", section
  ## parameters in `header` object:
  ##   x-ms-client-request-id: JString
  ##                         : A UUID recorded in the analytics logs for troubleshooting and correlation.
  ##   x-ms-date: JString
  ##            : Specifies the Coordinated Universal Time (UTC) for the request.  This is required when using shared key authorization.
  ##   x-ms-version: JString
  ##               : Specifies the version of the REST protocol used for processing the request. This is required when using shared key authorization.
  section = newJObject()
  var valid_594029 = header.getOrDefault("x-ms-client-request-id")
  valid_594029 = validateParameter(valid_594029, JString, required = false,
                                 default = nil)
  if valid_594029 != nil:
    section.add "x-ms-client-request-id", valid_594029
  var valid_594030 = header.getOrDefault("x-ms-date")
  valid_594030 = validateParameter(valid_594030, JString, required = false,
                                 default = nil)
  if valid_594030 != nil:
    section.add "x-ms-date", valid_594030
  var valid_594031 = header.getOrDefault("x-ms-version")
  valid_594031 = validateParameter(valid_594031, JString, required = false,
                                 default = nil)
  if valid_594031 != nil:
    section.add "x-ms-version", valid_594031
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594032: Call_FilesystemGetProperties_594023; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## All system and user-defined filesystem properties are specified in the response headers.
  ## 
  let valid = call_594032.validator(path, query, header, formData, body)
  let scheme = call_594032.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594032.url(scheme.get, call_594032.host, call_594032.base,
                         call_594032.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594032, url, valid)

proc call*(call_594033: Call_FilesystemGetProperties_594023; filesystem: string;
          timeout: int = 0; resource: string = "filesystem"): Recallable =
  ## filesystemGetProperties
  ## All system and user-defined filesystem properties are specified in the response headers.
  ##   timeout: int
  ##          : An optional operation timeout value in seconds. The period begins when the request is received by the service. If the timeout value elapses before the operation completes, the operation fails.
  ##   resource: string (required)
  ##           : The value must be "filesystem" for all filesystem operations.
  ##   filesystem: string (required)
  ##             : The filesystem identifier.  The value must start and end with a letter or number and must contain only letters, numbers, and the dash (-) character.  Consecutive dashes are not permitted.  All letters must be lowercase.  The value must have between 3 and 63 characters.
  var path_594034 = newJObject()
  var query_594035 = newJObject()
  add(query_594035, "timeout", newJInt(timeout))
  add(query_594035, "resource", newJString(resource))
  add(path_594034, "filesystem", newJString(filesystem))
  result = call_594033.call(path_594034, query_594035, nil, nil, nil)

var filesystemGetProperties* = Call_FilesystemGetProperties_594023(
    name: "filesystemGetProperties", meth: HttpMethod.HttpHead, host: "azure.local",
    route: "/{filesystem}", validator: validate_FilesystemGetProperties_594024,
    base: "", url: url_FilesystemGetProperties_594025, schemes: {Scheme.Https})
type
  Call_PathList_593963 = ref object of OpenApiRestCall_593425
proc url_PathList_593965(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_PathList_593964(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_593980 = path.getOrDefault("filesystem")
  valid_593980 = validateParameter(valid_593980, JString, required = true,
                                 default = nil)
  if valid_593980 != nil:
    section.add "filesystem", valid_593980
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
  var valid_593981 = query.getOrDefault("timeout")
  valid_593981 = validateParameter(valid_593981, JInt, required = false, default = nil)
  if valid_593981 != nil:
    section.add "timeout", valid_593981
  var valid_593982 = query.getOrDefault("continuation")
  valid_593982 = validateParameter(valid_593982, JString, required = false,
                                 default = nil)
  if valid_593982 != nil:
    section.add "continuation", valid_593982
  assert query != nil,
        "query argument is necessary due to required `resource` field"
  var valid_593983 = query.getOrDefault("resource")
  valid_593983 = validateParameter(valid_593983, JString, required = true,
                                 default = newJString("filesystem"))
  if valid_593983 != nil:
    section.add "resource", valid_593983
  var valid_593984 = query.getOrDefault("directory")
  valid_593984 = validateParameter(valid_593984, JString, required = false,
                                 default = nil)
  if valid_593984 != nil:
    section.add "directory", valid_593984
  var valid_593985 = query.getOrDefault("maxResults")
  valid_593985 = validateParameter(valid_593985, JInt, required = false, default = nil)
  if valid_593985 != nil:
    section.add "maxResults", valid_593985
  var valid_593986 = query.getOrDefault("recursive")
  valid_593986 = validateParameter(valid_593986, JBool, required = true, default = nil)
  if valid_593986 != nil:
    section.add "recursive", valid_593986
  result.add "query", section
  ## parameters in `header` object:
  ##   x-ms-client-request-id: JString
  ##                         : A UUID recorded in the analytics logs for troubleshooting and correlation.
  ##   x-ms-date: JString
  ##            : Specifies the Coordinated Universal Time (UTC) for the request.  This is required when using shared key authorization.
  ##   x-ms-version: JString
  ##               : Specifies the version of the REST protocol used for processing the request. This is required when using shared key authorization.
  section = newJObject()
  var valid_593987 = header.getOrDefault("x-ms-client-request-id")
  valid_593987 = validateParameter(valid_593987, JString, required = false,
                                 default = nil)
  if valid_593987 != nil:
    section.add "x-ms-client-request-id", valid_593987
  var valid_593988 = header.getOrDefault("x-ms-date")
  valid_593988 = validateParameter(valid_593988, JString, required = false,
                                 default = nil)
  if valid_593988 != nil:
    section.add "x-ms-date", valid_593988
  var valid_593989 = header.getOrDefault("x-ms-version")
  valid_593989 = validateParameter(valid_593989, JString, required = false,
                                 default = nil)
  if valid_593989 != nil:
    section.add "x-ms-version", valid_593989
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593990: Call_PathList_593963; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List filesystem paths and their properties.
  ## 
  let valid = call_593990.validator(path, query, header, formData, body)
  let scheme = call_593990.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593990.url(scheme.get, call_593990.host, call_593990.base,
                         call_593990.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593990, url, valid)

proc call*(call_593991: Call_PathList_593963; filesystem: string; recursive: bool;
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
  var path_593992 = newJObject()
  var query_593993 = newJObject()
  add(query_593993, "timeout", newJInt(timeout))
  add(query_593993, "continuation", newJString(continuation))
  add(query_593993, "resource", newJString(resource))
  add(query_593993, "directory", newJString(directory))
  add(query_593993, "maxResults", newJInt(maxResults))
  add(path_593992, "filesystem", newJString(filesystem))
  add(query_593993, "recursive", newJBool(recursive))
  result = call_593991.call(path_593992, query_593993, nil, nil, nil)

var pathList* = Call_PathList_593963(name: "pathList", meth: HttpMethod.HttpGet,
                                  host: "azure.local", route: "/{filesystem}",
                                  validator: validate_PathList_593964, base: "",
                                  url: url_PathList_593965,
                                  schemes: {Scheme.Https})
type
  Call_FilesystemSetProperties_594036 = ref object of OpenApiRestCall_593425
proc url_FilesystemSetProperties_594038(protocol: Scheme; host: string; base: string;
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

proc validate_FilesystemSetProperties_594037(path: JsonNode; query: JsonNode;
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
  var valid_594039 = path.getOrDefault("filesystem")
  valid_594039 = validateParameter(valid_594039, JString, required = true,
                                 default = nil)
  if valid_594039 != nil:
    section.add "filesystem", valid_594039
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : An optional operation timeout value in seconds. The period begins when the request is received by the service. If the timeout value elapses before the operation completes, the operation fails.
  ##   resource: JString (required)
  ##           : The value must be "filesystem" for all filesystem operations.
  section = newJObject()
  var valid_594040 = query.getOrDefault("timeout")
  valid_594040 = validateParameter(valid_594040, JInt, required = false, default = nil)
  if valid_594040 != nil:
    section.add "timeout", valid_594040
  assert query != nil,
        "query argument is necessary due to required `resource` field"
  var valid_594041 = query.getOrDefault("resource")
  valid_594041 = validateParameter(valid_594041, JString, required = true,
                                 default = newJString("filesystem"))
  if valid_594041 != nil:
    section.add "resource", valid_594041
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
  var valid_594042 = header.getOrDefault("x-ms-properties")
  valid_594042 = validateParameter(valid_594042, JString, required = false,
                                 default = nil)
  if valid_594042 != nil:
    section.add "x-ms-properties", valid_594042
  var valid_594043 = header.getOrDefault("If-Unmodified-Since")
  valid_594043 = validateParameter(valid_594043, JString, required = false,
                                 default = nil)
  if valid_594043 != nil:
    section.add "If-Unmodified-Since", valid_594043
  var valid_594044 = header.getOrDefault("x-ms-client-request-id")
  valid_594044 = validateParameter(valid_594044, JString, required = false,
                                 default = nil)
  if valid_594044 != nil:
    section.add "x-ms-client-request-id", valid_594044
  var valid_594045 = header.getOrDefault("x-ms-date")
  valid_594045 = validateParameter(valid_594045, JString, required = false,
                                 default = nil)
  if valid_594045 != nil:
    section.add "x-ms-date", valid_594045
  var valid_594046 = header.getOrDefault("If-Modified-Since")
  valid_594046 = validateParameter(valid_594046, JString, required = false,
                                 default = nil)
  if valid_594046 != nil:
    section.add "If-Modified-Since", valid_594046
  var valid_594047 = header.getOrDefault("x-ms-version")
  valid_594047 = validateParameter(valid_594047, JString, required = false,
                                 default = nil)
  if valid_594047 != nil:
    section.add "x-ms-version", valid_594047
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594048: Call_FilesystemSetProperties_594036; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Set properties for the filesystem.  This operation supports conditional HTTP requests.  For more information, see [Specifying Conditional Headers for Blob Service Operations](https://docs.microsoft.com/en-us/rest/api/storageservices/specifying-conditional-headers-for-blob-service-operations).
  ## 
  let valid = call_594048.validator(path, query, header, formData, body)
  let scheme = call_594048.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594048.url(scheme.get, call_594048.host, call_594048.base,
                         call_594048.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594048, url, valid)

proc call*(call_594049: Call_FilesystemSetProperties_594036; filesystem: string;
          timeout: int = 0; resource: string = "filesystem"): Recallable =
  ## filesystemSetProperties
  ## Set properties for the filesystem.  This operation supports conditional HTTP requests.  For more information, see [Specifying Conditional Headers for Blob Service Operations](https://docs.microsoft.com/en-us/rest/api/storageservices/specifying-conditional-headers-for-blob-service-operations).
  ##   timeout: int
  ##          : An optional operation timeout value in seconds. The period begins when the request is received by the service. If the timeout value elapses before the operation completes, the operation fails.
  ##   resource: string (required)
  ##           : The value must be "filesystem" for all filesystem operations.
  ##   filesystem: string (required)
  ##             : The filesystem identifier.  The value must start and end with a letter or number and must contain only letters, numbers, and the dash (-) character.  Consecutive dashes are not permitted.  All letters must be lowercase.  The value must have between 3 and 63 characters.
  var path_594050 = newJObject()
  var query_594051 = newJObject()
  add(query_594051, "timeout", newJInt(timeout))
  add(query_594051, "resource", newJString(resource))
  add(path_594050, "filesystem", newJString(filesystem))
  result = call_594049.call(path_594050, query_594051, nil, nil, nil)

var filesystemSetProperties* = Call_FilesystemSetProperties_594036(
    name: "filesystemSetProperties", meth: HttpMethod.HttpPatch,
    host: "azure.local", route: "/{filesystem}",
    validator: validate_FilesystemSetProperties_594037, base: "",
    url: url_FilesystemSetProperties_594038, schemes: {Scheme.Https})
type
  Call_FilesystemDelete_594008 = ref object of OpenApiRestCall_593425
proc url_FilesystemDelete_594010(protocol: Scheme; host: string; base: string;
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

proc validate_FilesystemDelete_594009(path: JsonNode; query: JsonNode;
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
  var valid_594011 = path.getOrDefault("filesystem")
  valid_594011 = validateParameter(valid_594011, JString, required = true,
                                 default = nil)
  if valid_594011 != nil:
    section.add "filesystem", valid_594011
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : An optional operation timeout value in seconds. The period begins when the request is received by the service. If the timeout value elapses before the operation completes, the operation fails.
  ##   resource: JString (required)
  ##           : The value must be "filesystem" for all filesystem operations.
  section = newJObject()
  var valid_594012 = query.getOrDefault("timeout")
  valid_594012 = validateParameter(valid_594012, JInt, required = false, default = nil)
  if valid_594012 != nil:
    section.add "timeout", valid_594012
  assert query != nil,
        "query argument is necessary due to required `resource` field"
  var valid_594013 = query.getOrDefault("resource")
  valid_594013 = validateParameter(valid_594013, JString, required = true,
                                 default = newJString("filesystem"))
  if valid_594013 != nil:
    section.add "resource", valid_594013
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
  var valid_594014 = header.getOrDefault("If-Unmodified-Since")
  valid_594014 = validateParameter(valid_594014, JString, required = false,
                                 default = nil)
  if valid_594014 != nil:
    section.add "If-Unmodified-Since", valid_594014
  var valid_594015 = header.getOrDefault("x-ms-client-request-id")
  valid_594015 = validateParameter(valid_594015, JString, required = false,
                                 default = nil)
  if valid_594015 != nil:
    section.add "x-ms-client-request-id", valid_594015
  var valid_594016 = header.getOrDefault("x-ms-date")
  valid_594016 = validateParameter(valid_594016, JString, required = false,
                                 default = nil)
  if valid_594016 != nil:
    section.add "x-ms-date", valid_594016
  var valid_594017 = header.getOrDefault("If-Modified-Since")
  valid_594017 = validateParameter(valid_594017, JString, required = false,
                                 default = nil)
  if valid_594017 != nil:
    section.add "If-Modified-Since", valid_594017
  var valid_594018 = header.getOrDefault("x-ms-version")
  valid_594018 = validateParameter(valid_594018, JString, required = false,
                                 default = nil)
  if valid_594018 != nil:
    section.add "x-ms-version", valid_594018
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594019: Call_FilesystemDelete_594008; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Marks the filesystem for deletion.  When a filesystem is deleted, a filesystem with the same identifier cannot be created for at least 30 seconds. While the filesystem is being deleted, attempts to create a filesystem with the same identifier will fail with status code 409 (Conflict), with the service returning additional error information indicating that the filesystem is being deleted. All other operations, including operations on any files or directories within the filesystem, will fail with status code 404 (Not Found) while the filesystem is being deleted. This operation supports conditional HTTP requests.  For more information, see [Specifying Conditional Headers for Blob Service Operations](https://docs.microsoft.com/en-us/rest/api/storageservices/specifying-conditional-headers-for-blob-service-operations).
  ## 
  let valid = call_594019.validator(path, query, header, formData, body)
  let scheme = call_594019.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594019.url(scheme.get, call_594019.host, call_594019.base,
                         call_594019.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594019, url, valid)

proc call*(call_594020: Call_FilesystemDelete_594008; filesystem: string;
          timeout: int = 0; resource: string = "filesystem"): Recallable =
  ## filesystemDelete
  ## Marks the filesystem for deletion.  When a filesystem is deleted, a filesystem with the same identifier cannot be created for at least 30 seconds. While the filesystem is being deleted, attempts to create a filesystem with the same identifier will fail with status code 409 (Conflict), with the service returning additional error information indicating that the filesystem is being deleted. All other operations, including operations on any files or directories within the filesystem, will fail with status code 404 (Not Found) while the filesystem is being deleted. This operation supports conditional HTTP requests.  For more information, see [Specifying Conditional Headers for Blob Service Operations](https://docs.microsoft.com/en-us/rest/api/storageservices/specifying-conditional-headers-for-blob-service-operations).
  ##   timeout: int
  ##          : An optional operation timeout value in seconds. The period begins when the request is received by the service. If the timeout value elapses before the operation completes, the operation fails.
  ##   resource: string (required)
  ##           : The value must be "filesystem" for all filesystem operations.
  ##   filesystem: string (required)
  ##             : The filesystem identifier.  The value must start and end with a letter or number and must contain only letters, numbers, and the dash (-) character.  Consecutive dashes are not permitted.  All letters must be lowercase.  The value must have between 3 and 63 characters.
  var path_594021 = newJObject()
  var query_594022 = newJObject()
  add(query_594022, "timeout", newJInt(timeout))
  add(query_594022, "resource", newJString(resource))
  add(path_594021, "filesystem", newJString(filesystem))
  result = call_594020.call(path_594021, query_594022, nil, nil, nil)

var filesystemDelete* = Call_FilesystemDelete_594008(name: "filesystemDelete",
    meth: HttpMethod.HttpDelete, host: "azure.local", route: "/{filesystem}",
    validator: validate_FilesystemDelete_594009, base: "",
    url: url_FilesystemDelete_594010, schemes: {Scheme.Https})
type
  Call_PathCreate_594070 = ref object of OpenApiRestCall_593425
proc url_PathCreate_594072(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_PathCreate_594071(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594073 = path.getOrDefault("path")
  valid_594073 = validateParameter(valid_594073, JString, required = true,
                                 default = nil)
  if valid_594073 != nil:
    section.add "path", valid_594073
  var valid_594074 = path.getOrDefault("filesystem")
  valid_594074 = validateParameter(valid_594074, JString, required = true,
                                 default = nil)
  if valid_594074 != nil:
    section.add "filesystem", valid_594074
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
  var valid_594075 = query.getOrDefault("timeout")
  valid_594075 = validateParameter(valid_594075, JInt, required = false, default = nil)
  if valid_594075 != nil:
    section.add "timeout", valid_594075
  var valid_594076 = query.getOrDefault("continuation")
  valid_594076 = validateParameter(valid_594076, JString, required = false,
                                 default = nil)
  if valid_594076 != nil:
    section.add "continuation", valid_594076
  var valid_594077 = query.getOrDefault("resource")
  valid_594077 = validateParameter(valid_594077, JString, required = false,
                                 default = newJString("directory"))
  if valid_594077 != nil:
    section.add "resource", valid_594077
  var valid_594078 = query.getOrDefault("mode")
  valid_594078 = validateParameter(valid_594078, JString, required = false,
                                 default = newJString("legacy"))
  if valid_594078 != nil:
    section.add "mode", valid_594078
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
  var valid_594079 = header.getOrDefault("Content-Disposition")
  valid_594079 = validateParameter(valid_594079, JString, required = false,
                                 default = nil)
  if valid_594079 != nil:
    section.add "Content-Disposition", valid_594079
  var valid_594080 = header.getOrDefault("x-ms-permissions")
  valid_594080 = validateParameter(valid_594080, JString, required = false,
                                 default = nil)
  if valid_594080 != nil:
    section.add "x-ms-permissions", valid_594080
  var valid_594081 = header.getOrDefault("x-ms-source-lease-id")
  valid_594081 = validateParameter(valid_594081, JString, required = false,
                                 default = nil)
  if valid_594081 != nil:
    section.add "x-ms-source-lease-id", valid_594081
  var valid_594082 = header.getOrDefault("If-Match")
  valid_594082 = validateParameter(valid_594082, JString, required = false,
                                 default = nil)
  if valid_594082 != nil:
    section.add "If-Match", valid_594082
  var valid_594083 = header.getOrDefault("x-ms-source-if-unmodified-since")
  valid_594083 = validateParameter(valid_594083, JString, required = false,
                                 default = nil)
  if valid_594083 != nil:
    section.add "x-ms-source-if-unmodified-since", valid_594083
  var valid_594084 = header.getOrDefault("x-ms-properties")
  valid_594084 = validateParameter(valid_594084, JString, required = false,
                                 default = nil)
  if valid_594084 != nil:
    section.add "x-ms-properties", valid_594084
  var valid_594085 = header.getOrDefault("Cache-Control")
  valid_594085 = validateParameter(valid_594085, JString, required = false,
                                 default = nil)
  if valid_594085 != nil:
    section.add "Cache-Control", valid_594085
  var valid_594086 = header.getOrDefault("Content-Language")
  valid_594086 = validateParameter(valid_594086, JString, required = false,
                                 default = nil)
  if valid_594086 != nil:
    section.add "Content-Language", valid_594086
  var valid_594087 = header.getOrDefault("x-ms-source-if-match")
  valid_594087 = validateParameter(valid_594087, JString, required = false,
                                 default = nil)
  if valid_594087 != nil:
    section.add "x-ms-source-if-match", valid_594087
  var valid_594088 = header.getOrDefault("x-ms-content-language")
  valid_594088 = validateParameter(valid_594088, JString, required = false,
                                 default = nil)
  if valid_594088 != nil:
    section.add "x-ms-content-language", valid_594088
  var valid_594089 = header.getOrDefault("If-Unmodified-Since")
  valid_594089 = validateParameter(valid_594089, JString, required = false,
                                 default = nil)
  if valid_594089 != nil:
    section.add "If-Unmodified-Since", valid_594089
  var valid_594090 = header.getOrDefault("x-ms-lease-id")
  valid_594090 = validateParameter(valid_594090, JString, required = false,
                                 default = nil)
  if valid_594090 != nil:
    section.add "x-ms-lease-id", valid_594090
  var valid_594091 = header.getOrDefault("x-ms-content-encoding")
  valid_594091 = validateParameter(valid_594091, JString, required = false,
                                 default = nil)
  if valid_594091 != nil:
    section.add "x-ms-content-encoding", valid_594091
  var valid_594092 = header.getOrDefault("x-ms-cache-control")
  valid_594092 = validateParameter(valid_594092, JString, required = false,
                                 default = nil)
  if valid_594092 != nil:
    section.add "x-ms-cache-control", valid_594092
  var valid_594093 = header.getOrDefault("x-ms-client-request-id")
  valid_594093 = validateParameter(valid_594093, JString, required = false,
                                 default = nil)
  if valid_594093 != nil:
    section.add "x-ms-client-request-id", valid_594093
  var valid_594094 = header.getOrDefault("x-ms-source-if-none-match")
  valid_594094 = validateParameter(valid_594094, JString, required = false,
                                 default = nil)
  if valid_594094 != nil:
    section.add "x-ms-source-if-none-match", valid_594094
  var valid_594095 = header.getOrDefault("x-ms-date")
  valid_594095 = validateParameter(valid_594095, JString, required = false,
                                 default = nil)
  if valid_594095 != nil:
    section.add "x-ms-date", valid_594095
  var valid_594096 = header.getOrDefault("x-ms-proposed-lease-id")
  valid_594096 = validateParameter(valid_594096, JString, required = false,
                                 default = nil)
  if valid_594096 != nil:
    section.add "x-ms-proposed-lease-id", valid_594096
  var valid_594097 = header.getOrDefault("If-None-Match")
  valid_594097 = validateParameter(valid_594097, JString, required = false,
                                 default = nil)
  if valid_594097 != nil:
    section.add "If-None-Match", valid_594097
  var valid_594098 = header.getOrDefault("If-Modified-Since")
  valid_594098 = validateParameter(valid_594098, JString, required = false,
                                 default = nil)
  if valid_594098 != nil:
    section.add "If-Modified-Since", valid_594098
  var valid_594099 = header.getOrDefault("x-ms-version")
  valid_594099 = validateParameter(valid_594099, JString, required = false,
                                 default = nil)
  if valid_594099 != nil:
    section.add "x-ms-version", valid_594099
  var valid_594100 = header.getOrDefault("x-ms-rename-source")
  valid_594100 = validateParameter(valid_594100, JString, required = false,
                                 default = nil)
  if valid_594100 != nil:
    section.add "x-ms-rename-source", valid_594100
  var valid_594101 = header.getOrDefault("x-ms-content-disposition")
  valid_594101 = validateParameter(valid_594101, JString, required = false,
                                 default = nil)
  if valid_594101 != nil:
    section.add "x-ms-content-disposition", valid_594101
  var valid_594102 = header.getOrDefault("x-ms-content-type")
  valid_594102 = validateParameter(valid_594102, JString, required = false,
                                 default = nil)
  if valid_594102 != nil:
    section.add "x-ms-content-type", valid_594102
  var valid_594103 = header.getOrDefault("x-ms-source-if-modified-since")
  valid_594103 = validateParameter(valid_594103, JString, required = false,
                                 default = nil)
  if valid_594103 != nil:
    section.add "x-ms-source-if-modified-since", valid_594103
  var valid_594104 = header.getOrDefault("Content-Encoding")
  valid_594104 = validateParameter(valid_594104, JString, required = false,
                                 default = nil)
  if valid_594104 != nil:
    section.add "Content-Encoding", valid_594104
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594105: Call_PathCreate_594070; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or rename a file or directory.    By default, the destination is overwritten and if the destination already exists and has a lease the lease is broken.  This operation supports conditional HTTP requests.  For more information, see [Specifying Conditional Headers for Blob Service Operations](https://docs.microsoft.com/en-us/rest/api/storageservices/specifying-conditional-headers-for-blob-service-operations).  To fail if the destination already exists, use a conditional request with If-None-Match: "*".
  ## 
  let valid = call_594105.validator(path, query, header, formData, body)
  let scheme = call_594105.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594105.url(scheme.get, call_594105.host, call_594105.base,
                         call_594105.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594105, url, valid)

proc call*(call_594106: Call_PathCreate_594070; path: string; filesystem: string;
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
  var path_594107 = newJObject()
  var query_594108 = newJObject()
  add(query_594108, "timeout", newJInt(timeout))
  add(query_594108, "continuation", newJString(continuation))
  add(query_594108, "resource", newJString(resource))
  add(query_594108, "mode", newJString(mode))
  add(path_594107, "path", newJString(path))
  add(path_594107, "filesystem", newJString(filesystem))
  result = call_594106.call(path_594107, query_594108, nil, nil, nil)

var pathCreate* = Call_PathCreate_594070(name: "pathCreate",
                                      meth: HttpMethod.HttpPut,
                                      host: "azure.local",
                                      route: "/{filesystem}/{path}",
                                      validator: validate_PathCreate_594071,
                                      base: "", url: url_PathCreate_594072,
                                      schemes: {Scheme.Https})
type
  Call_PathGetProperties_594151 = ref object of OpenApiRestCall_593425
proc url_PathGetProperties_594153(protocol: Scheme; host: string; base: string;
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

proc validate_PathGetProperties_594152(path: JsonNode; query: JsonNode;
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
  var valid_594154 = path.getOrDefault("path")
  valid_594154 = validateParameter(valid_594154, JString, required = true,
                                 default = nil)
  if valid_594154 != nil:
    section.add "path", valid_594154
  var valid_594155 = path.getOrDefault("filesystem")
  valid_594155 = validateParameter(valid_594155, JString, required = true,
                                 default = nil)
  if valid_594155 != nil:
    section.add "filesystem", valid_594155
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : An optional operation timeout value in seconds. The period begins when the request is received by the service. If the timeout value elapses before the operation completes, the operation fails.
  ##   action: JString
  ##         : Optional. If the value is "getAccessControl" the access control list is returned in the response headers (Hierarchical Namespace must be enabled for the account).
  section = newJObject()
  var valid_594156 = query.getOrDefault("timeout")
  valid_594156 = validateParameter(valid_594156, JInt, required = false, default = nil)
  if valid_594156 != nil:
    section.add "timeout", valid_594156
  var valid_594157 = query.getOrDefault("action")
  valid_594157 = validateParameter(valid_594157, JString, required = false,
                                 default = newJString("getAccessControl"))
  if valid_594157 != nil:
    section.add "action", valid_594157
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
  var valid_594158 = header.getOrDefault("If-Match")
  valid_594158 = validateParameter(valid_594158, JString, required = false,
                                 default = nil)
  if valid_594158 != nil:
    section.add "If-Match", valid_594158
  var valid_594159 = header.getOrDefault("If-Unmodified-Since")
  valid_594159 = validateParameter(valid_594159, JString, required = false,
                                 default = nil)
  if valid_594159 != nil:
    section.add "If-Unmodified-Since", valid_594159
  var valid_594160 = header.getOrDefault("x-ms-client-request-id")
  valid_594160 = validateParameter(valid_594160, JString, required = false,
                                 default = nil)
  if valid_594160 != nil:
    section.add "x-ms-client-request-id", valid_594160
  var valid_594161 = header.getOrDefault("x-ms-date")
  valid_594161 = validateParameter(valid_594161, JString, required = false,
                                 default = nil)
  if valid_594161 != nil:
    section.add "x-ms-date", valid_594161
  var valid_594162 = header.getOrDefault("If-None-Match")
  valid_594162 = validateParameter(valid_594162, JString, required = false,
                                 default = nil)
  if valid_594162 != nil:
    section.add "If-None-Match", valid_594162
  var valid_594163 = header.getOrDefault("If-Modified-Since")
  valid_594163 = validateParameter(valid_594163, JString, required = false,
                                 default = nil)
  if valid_594163 != nil:
    section.add "If-Modified-Since", valid_594163
  var valid_594164 = header.getOrDefault("x-ms-version")
  valid_594164 = validateParameter(valid_594164, JString, required = false,
                                 default = nil)
  if valid_594164 != nil:
    section.add "x-ms-version", valid_594164
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594165: Call_PathGetProperties_594151; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the properties for a file or directory, and optionally include the access control list.  This operation supports conditional HTTP requests.  For more information, see [Specifying Conditional Headers for Blob Service Operations](https://docs.microsoft.com/en-us/rest/api/storageservices/specifying-conditional-headers-for-blob-service-operations).
  ## 
  let valid = call_594165.validator(path, query, header, formData, body)
  let scheme = call_594165.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594165.url(scheme.get, call_594165.host, call_594165.base,
                         call_594165.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594165, url, valid)

proc call*(call_594166: Call_PathGetProperties_594151; path: string;
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
  var path_594167 = newJObject()
  var query_594168 = newJObject()
  add(query_594168, "timeout", newJInt(timeout))
  add(query_594168, "action", newJString(action))
  add(path_594167, "path", newJString(path))
  add(path_594167, "filesystem", newJString(filesystem))
  result = call_594166.call(path_594167, query_594168, nil, nil, nil)

var pathGetProperties* = Call_PathGetProperties_594151(name: "pathGetProperties",
    meth: HttpMethod.HttpHead, host: "azure.local", route: "/{filesystem}/{path}",
    validator: validate_PathGetProperties_594152, base: "",
    url: url_PathGetProperties_594153, schemes: {Scheme.Https})
type
  Call_PathLease_594109 = ref object of OpenApiRestCall_593425
proc url_PathLease_594111(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_PathLease_594110(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594112 = path.getOrDefault("path")
  valid_594112 = validateParameter(valid_594112, JString, required = true,
                                 default = nil)
  if valid_594112 != nil:
    section.add "path", valid_594112
  var valid_594113 = path.getOrDefault("filesystem")
  valid_594113 = validateParameter(valid_594113, JString, required = true,
                                 default = nil)
  if valid_594113 != nil:
    section.add "filesystem", valid_594113
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : An optional operation timeout value in seconds. The period begins when the request is received by the service. If the timeout value elapses before the operation completes, the operation fails.
  section = newJObject()
  var valid_594114 = query.getOrDefault("timeout")
  valid_594114 = validateParameter(valid_594114, JInt, required = false, default = nil)
  if valid_594114 != nil:
    section.add "timeout", valid_594114
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
  var valid_594115 = header.getOrDefault("If-Match")
  valid_594115 = validateParameter(valid_594115, JString, required = false,
                                 default = nil)
  if valid_594115 != nil:
    section.add "If-Match", valid_594115
  var valid_594116 = header.getOrDefault("x-ms-lease-duration")
  valid_594116 = validateParameter(valid_594116, JInt, required = false, default = nil)
  if valid_594116 != nil:
    section.add "x-ms-lease-duration", valid_594116
  var valid_594117 = header.getOrDefault("If-Unmodified-Since")
  valid_594117 = validateParameter(valid_594117, JString, required = false,
                                 default = nil)
  if valid_594117 != nil:
    section.add "If-Unmodified-Since", valid_594117
  var valid_594118 = header.getOrDefault("x-ms-lease-id")
  valid_594118 = validateParameter(valid_594118, JString, required = false,
                                 default = nil)
  if valid_594118 != nil:
    section.add "x-ms-lease-id", valid_594118
  var valid_594119 = header.getOrDefault("x-ms-client-request-id")
  valid_594119 = validateParameter(valid_594119, JString, required = false,
                                 default = nil)
  if valid_594119 != nil:
    section.add "x-ms-client-request-id", valid_594119
  var valid_594120 = header.getOrDefault("x-ms-date")
  valid_594120 = validateParameter(valid_594120, JString, required = false,
                                 default = nil)
  if valid_594120 != nil:
    section.add "x-ms-date", valid_594120
  var valid_594121 = header.getOrDefault("x-ms-lease-break-period")
  valid_594121 = validateParameter(valid_594121, JInt, required = false, default = nil)
  if valid_594121 != nil:
    section.add "x-ms-lease-break-period", valid_594121
  var valid_594122 = header.getOrDefault("x-ms-proposed-lease-id")
  valid_594122 = validateParameter(valid_594122, JString, required = false,
                                 default = nil)
  if valid_594122 != nil:
    section.add "x-ms-proposed-lease-id", valid_594122
  var valid_594123 = header.getOrDefault("If-None-Match")
  valid_594123 = validateParameter(valid_594123, JString, required = false,
                                 default = nil)
  if valid_594123 != nil:
    section.add "If-None-Match", valid_594123
  var valid_594124 = header.getOrDefault("If-Modified-Since")
  valid_594124 = validateParameter(valid_594124, JString, required = false,
                                 default = nil)
  if valid_594124 != nil:
    section.add "If-Modified-Since", valid_594124
  var valid_594125 = header.getOrDefault("x-ms-version")
  valid_594125 = validateParameter(valid_594125, JString, required = false,
                                 default = nil)
  if valid_594125 != nil:
    section.add "x-ms-version", valid_594125
  assert header != nil, "header argument is necessary due to required `x-ms-lease-action` field"
  var valid_594126 = header.getOrDefault("x-ms-lease-action")
  valid_594126 = validateParameter(valid_594126, JString, required = true,
                                 default = newJString("acquire"))
  if valid_594126 != nil:
    section.add "x-ms-lease-action", valid_594126
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594127: Call_PathLease_594109; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create and manage a lease to restrict write and delete access to the path. This operation supports conditional HTTP requests.  For more information, see [Specifying Conditional Headers for Blob Service Operations](https://docs.microsoft.com/en-us/rest/api/storageservices/specifying-conditional-headers-for-blob-service-operations).
  ## 
  let valid = call_594127.validator(path, query, header, formData, body)
  let scheme = call_594127.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594127.url(scheme.get, call_594127.host, call_594127.base,
                         call_594127.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594127, url, valid)

proc call*(call_594128: Call_PathLease_594109; path: string; filesystem: string;
          timeout: int = 0): Recallable =
  ## pathLease
  ## Create and manage a lease to restrict write and delete access to the path. This operation supports conditional HTTP requests.  For more information, see [Specifying Conditional Headers for Blob Service Operations](https://docs.microsoft.com/en-us/rest/api/storageservices/specifying-conditional-headers-for-blob-service-operations).
  ##   timeout: int
  ##          : An optional operation timeout value in seconds. The period begins when the request is received by the service. If the timeout value elapses before the operation completes, the operation fails.
  ##   path: string (required)
  ##       : The file or directory path.
  ##   filesystem: string (required)
  ##             : The filesystem identifier.
  var path_594129 = newJObject()
  var query_594130 = newJObject()
  add(query_594130, "timeout", newJInt(timeout))
  add(path_594129, "path", newJString(path))
  add(path_594129, "filesystem", newJString(filesystem))
  result = call_594128.call(path_594129, query_594130, nil, nil, nil)

var pathLease* = Call_PathLease_594109(name: "pathLease", meth: HttpMethod.HttpPost,
                                    host: "azure.local",
                                    route: "/{filesystem}/{path}",
                                    validator: validate_PathLease_594110,
                                    base: "", url: url_PathLease_594111,
                                    schemes: {Scheme.Https})
type
  Call_PathRead_594052 = ref object of OpenApiRestCall_593425
proc url_PathRead_594054(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_PathRead_594053(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594055 = path.getOrDefault("path")
  valid_594055 = validateParameter(valid_594055, JString, required = true,
                                 default = nil)
  if valid_594055 != nil:
    section.add "path", valid_594055
  var valid_594056 = path.getOrDefault("filesystem")
  valid_594056 = validateParameter(valid_594056, JString, required = true,
                                 default = nil)
  if valid_594056 != nil:
    section.add "filesystem", valid_594056
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : An optional operation timeout value in seconds. The period begins when the request is received by the service. If the timeout value elapses before the operation completes, the operation fails.
  section = newJObject()
  var valid_594057 = query.getOrDefault("timeout")
  valid_594057 = validateParameter(valid_594057, JInt, required = false, default = nil)
  if valid_594057 != nil:
    section.add "timeout", valid_594057
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
  var valid_594058 = header.getOrDefault("If-Match")
  valid_594058 = validateParameter(valid_594058, JString, required = false,
                                 default = nil)
  if valid_594058 != nil:
    section.add "If-Match", valid_594058
  var valid_594059 = header.getOrDefault("If-Unmodified-Since")
  valid_594059 = validateParameter(valid_594059, JString, required = false,
                                 default = nil)
  if valid_594059 != nil:
    section.add "If-Unmodified-Since", valid_594059
  var valid_594060 = header.getOrDefault("x-ms-client-request-id")
  valid_594060 = validateParameter(valid_594060, JString, required = false,
                                 default = nil)
  if valid_594060 != nil:
    section.add "x-ms-client-request-id", valid_594060
  var valid_594061 = header.getOrDefault("x-ms-date")
  valid_594061 = validateParameter(valid_594061, JString, required = false,
                                 default = nil)
  if valid_594061 != nil:
    section.add "x-ms-date", valid_594061
  var valid_594062 = header.getOrDefault("If-None-Match")
  valid_594062 = validateParameter(valid_594062, JString, required = false,
                                 default = nil)
  if valid_594062 != nil:
    section.add "If-None-Match", valid_594062
  var valid_594063 = header.getOrDefault("If-Modified-Since")
  valid_594063 = validateParameter(valid_594063, JString, required = false,
                                 default = nil)
  if valid_594063 != nil:
    section.add "If-Modified-Since", valid_594063
  var valid_594064 = header.getOrDefault("x-ms-version")
  valid_594064 = validateParameter(valid_594064, JString, required = false,
                                 default = nil)
  if valid_594064 != nil:
    section.add "x-ms-version", valid_594064
  var valid_594065 = header.getOrDefault("Range")
  valid_594065 = validateParameter(valid_594065, JString, required = false,
                                 default = nil)
  if valid_594065 != nil:
    section.add "Range", valid_594065
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594066: Call_PathRead_594052; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Read the contents of a file.  For read operations, range requests are supported. This operation supports conditional HTTP requests.  For more information, see [Specifying Conditional Headers for Blob Service Operations](https://docs.microsoft.com/en-us/rest/api/storageservices/specifying-conditional-headers-for-blob-service-operations).
  ## 
  let valid = call_594066.validator(path, query, header, formData, body)
  let scheme = call_594066.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594066.url(scheme.get, call_594066.host, call_594066.base,
                         call_594066.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594066, url, valid)

proc call*(call_594067: Call_PathRead_594052; path: string; filesystem: string;
          timeout: int = 0): Recallable =
  ## pathRead
  ## Read the contents of a file.  For read operations, range requests are supported. This operation supports conditional HTTP requests.  For more information, see [Specifying Conditional Headers for Blob Service Operations](https://docs.microsoft.com/en-us/rest/api/storageservices/specifying-conditional-headers-for-blob-service-operations).
  ##   timeout: int
  ##          : An optional operation timeout value in seconds. The period begins when the request is received by the service. If the timeout value elapses before the operation completes, the operation fails.
  ##   path: string (required)
  ##       : The file or directory path.
  ##   filesystem: string (required)
  ##             : The filesystem identifier.
  var path_594068 = newJObject()
  var query_594069 = newJObject()
  add(query_594069, "timeout", newJInt(timeout))
  add(path_594068, "path", newJString(path))
  add(path_594068, "filesystem", newJString(filesystem))
  result = call_594067.call(path_594068, query_594069, nil, nil, nil)

var pathRead* = Call_PathRead_594052(name: "pathRead", meth: HttpMethod.HttpGet,
                                  host: "azure.local",
                                  route: "/{filesystem}/{path}",
                                  validator: validate_PathRead_594053, base: "",
                                  url: url_PathRead_594054,
                                  schemes: {Scheme.Https})
type
  Call_PathUpdate_594169 = ref object of OpenApiRestCall_593425
proc url_PathUpdate_594171(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_PathUpdate_594170(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594172 = path.getOrDefault("path")
  valid_594172 = validateParameter(valid_594172, JString, required = true,
                                 default = nil)
  if valid_594172 != nil:
    section.add "path", valid_594172
  var valid_594173 = path.getOrDefault("filesystem")
  valid_594173 = validateParameter(valid_594173, JString, required = true,
                                 default = nil)
  if valid_594173 != nil:
    section.add "filesystem", valid_594173
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
  var valid_594174 = query.getOrDefault("timeout")
  valid_594174 = validateParameter(valid_594174, JInt, required = false, default = nil)
  if valid_594174 != nil:
    section.add "timeout", valid_594174
  assert query != nil, "query argument is necessary due to required `action` field"
  var valid_594175 = query.getOrDefault("action")
  valid_594175 = validateParameter(valid_594175, JString, required = true,
                                 default = newJString("append"))
  if valid_594175 != nil:
    section.add "action", valid_594175
  var valid_594176 = query.getOrDefault("retainUncommittedData")
  valid_594176 = validateParameter(valid_594176, JBool, required = false, default = nil)
  if valid_594176 != nil:
    section.add "retainUncommittedData", valid_594176
  var valid_594177 = query.getOrDefault("position")
  valid_594177 = validateParameter(valid_594177, JInt, required = false, default = nil)
  if valid_594177 != nil:
    section.add "position", valid_594177
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
  var valid_594178 = header.getOrDefault("x-ms-permissions")
  valid_594178 = validateParameter(valid_594178, JString, required = false,
                                 default = nil)
  if valid_594178 != nil:
    section.add "x-ms-permissions", valid_594178
  var valid_594179 = header.getOrDefault("x-ms-acl")
  valid_594179 = validateParameter(valid_594179, JString, required = false,
                                 default = nil)
  if valid_594179 != nil:
    section.add "x-ms-acl", valid_594179
  var valid_594180 = header.getOrDefault("If-Match")
  valid_594180 = validateParameter(valid_594180, JString, required = false,
                                 default = nil)
  if valid_594180 != nil:
    section.add "If-Match", valid_594180
  var valid_594181 = header.getOrDefault("x-ms-properties")
  valid_594181 = validateParameter(valid_594181, JString, required = false,
                                 default = nil)
  if valid_594181 != nil:
    section.add "x-ms-properties", valid_594181
  var valid_594182 = header.getOrDefault("x-ms-content-language")
  valid_594182 = validateParameter(valid_594182, JString, required = false,
                                 default = nil)
  if valid_594182 != nil:
    section.add "x-ms-content-language", valid_594182
  var valid_594183 = header.getOrDefault("x-ms-group")
  valid_594183 = validateParameter(valid_594183, JString, required = false,
                                 default = nil)
  if valid_594183 != nil:
    section.add "x-ms-group", valid_594183
  var valid_594184 = header.getOrDefault("If-Unmodified-Since")
  valid_594184 = validateParameter(valid_594184, JString, required = false,
                                 default = nil)
  if valid_594184 != nil:
    section.add "If-Unmodified-Since", valid_594184
  var valid_594185 = header.getOrDefault("x-ms-lease-id")
  valid_594185 = validateParameter(valid_594185, JString, required = false,
                                 default = nil)
  if valid_594185 != nil:
    section.add "x-ms-lease-id", valid_594185
  var valid_594186 = header.getOrDefault("x-ms-content-encoding")
  valid_594186 = validateParameter(valid_594186, JString, required = false,
                                 default = nil)
  if valid_594186 != nil:
    section.add "x-ms-content-encoding", valid_594186
  var valid_594187 = header.getOrDefault("x-ms-cache-control")
  valid_594187 = validateParameter(valid_594187, JString, required = false,
                                 default = nil)
  if valid_594187 != nil:
    section.add "x-ms-cache-control", valid_594187
  var valid_594188 = header.getOrDefault("x-ms-client-request-id")
  valid_594188 = validateParameter(valid_594188, JString, required = false,
                                 default = nil)
  if valid_594188 != nil:
    section.add "x-ms-client-request-id", valid_594188
  var valid_594189 = header.getOrDefault("x-ms-date")
  valid_594189 = validateParameter(valid_594189, JString, required = false,
                                 default = nil)
  if valid_594189 != nil:
    section.add "x-ms-date", valid_594189
  var valid_594190 = header.getOrDefault("Content-Length")
  valid_594190 = validateParameter(valid_594190, JString, required = false,
                                 default = nil)
  if valid_594190 != nil:
    section.add "Content-Length", valid_594190
  var valid_594191 = header.getOrDefault("If-None-Match")
  valid_594191 = validateParameter(valid_594191, JString, required = false,
                                 default = nil)
  if valid_594191 != nil:
    section.add "If-None-Match", valid_594191
  var valid_594192 = header.getOrDefault("If-Modified-Since")
  valid_594192 = validateParameter(valid_594192, JString, required = false,
                                 default = nil)
  if valid_594192 != nil:
    section.add "If-Modified-Since", valid_594192
  var valid_594193 = header.getOrDefault("x-ms-owner")
  valid_594193 = validateParameter(valid_594193, JString, required = false,
                                 default = nil)
  if valid_594193 != nil:
    section.add "x-ms-owner", valid_594193
  var valid_594194 = header.getOrDefault("x-ms-version")
  valid_594194 = validateParameter(valid_594194, JString, required = false,
                                 default = nil)
  if valid_594194 != nil:
    section.add "x-ms-version", valid_594194
  var valid_594195 = header.getOrDefault("x-ms-content-disposition")
  valid_594195 = validateParameter(valid_594195, JString, required = false,
                                 default = nil)
  if valid_594195 != nil:
    section.add "x-ms-content-disposition", valid_594195
  var valid_594196 = header.getOrDefault("x-ms-content-type")
  valid_594196 = validateParameter(valid_594196, JString, required = false,
                                 default = nil)
  if valid_594196 != nil:
    section.add "x-ms-content-type", valid_594196
  var valid_594197 = header.getOrDefault("x-ms-lease-action")
  valid_594197 = validateParameter(valid_594197, JString, required = false,
                                 default = newJString("renew"))
  if valid_594197 != nil:
    section.add "x-ms-lease-action", valid_594197
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   requestBody: JObject
  ##              : Valid only for append operations.  The data to be uploaded and appended to the file.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594199: Call_PathUpdate_594169; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Uploads data to be appended to a file, flushes (writes) previously uploaded data to a file, sets properties for a file or directory, or sets access control for a file or directory. Data can only be appended to a file. This operation supports conditional HTTP requests. For more information, see [Specifying Conditional Headers for Blob Service Operations](https://docs.microsoft.com/en-us/rest/api/storageservices/specifying-conditional-headers-for-blob-service-operations).
  ## 
  let valid = call_594199.validator(path, query, header, formData, body)
  let scheme = call_594199.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594199.url(scheme.get, call_594199.host, call_594199.base,
                         call_594199.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594199, url, valid)

proc call*(call_594200: Call_PathUpdate_594169; path: string; filesystem: string;
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
  var path_594201 = newJObject()
  var query_594202 = newJObject()
  var body_594203 = newJObject()
  add(query_594202, "timeout", newJInt(timeout))
  add(query_594202, "action", newJString(action))
  add(path_594201, "path", newJString(path))
  add(query_594202, "retainUncommittedData", newJBool(retainUncommittedData))
  if requestBody != nil:
    body_594203 = requestBody
  add(query_594202, "position", newJInt(position))
  add(path_594201, "filesystem", newJString(filesystem))
  result = call_594200.call(path_594201, query_594202, nil, nil, body_594203)

var pathUpdate* = Call_PathUpdate_594169(name: "pathUpdate",
                                      meth: HttpMethod.HttpPatch,
                                      host: "azure.local",
                                      route: "/{filesystem}/{path}",
                                      validator: validate_PathUpdate_594170,
                                      base: "", url: url_PathUpdate_594171,
                                      schemes: {Scheme.Https})
type
  Call_PathDelete_594131 = ref object of OpenApiRestCall_593425
proc url_PathDelete_594133(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_PathDelete_594132(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594134 = path.getOrDefault("path")
  valid_594134 = validateParameter(valid_594134, JString, required = true,
                                 default = nil)
  if valid_594134 != nil:
    section.add "path", valid_594134
  var valid_594135 = path.getOrDefault("filesystem")
  valid_594135 = validateParameter(valid_594135, JString, required = true,
                                 default = nil)
  if valid_594135 != nil:
    section.add "filesystem", valid_594135
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : An optional operation timeout value in seconds. The period begins when the request is received by the service. If the timeout value elapses before the operation completes, the operation fails.
  ##   continuation: JString
  ##               : Optional.  When deleting a directory, the number of paths that are deleted with each invocation is limited.  If the number of paths to be deleted exceeds this limit, a continuation token is returned in this response header.  When a continuation token is returned in the response, it must be specified in a subsequent invocation of the delete operation to continue deleting the directory.
  ##   recursive: JBool
  ##            : Required and valid only when the resource is a directory.  If "true", all paths beneath the directory will be deleted. If "false" and the directory is non-empty, an error occurs.
  section = newJObject()
  var valid_594136 = query.getOrDefault("timeout")
  valid_594136 = validateParameter(valid_594136, JInt, required = false, default = nil)
  if valid_594136 != nil:
    section.add "timeout", valid_594136
  var valid_594137 = query.getOrDefault("continuation")
  valid_594137 = validateParameter(valid_594137, JString, required = false,
                                 default = nil)
  if valid_594137 != nil:
    section.add "continuation", valid_594137
  var valid_594138 = query.getOrDefault("recursive")
  valid_594138 = validateParameter(valid_594138, JBool, required = false, default = nil)
  if valid_594138 != nil:
    section.add "recursive", valid_594138
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
  var valid_594139 = header.getOrDefault("If-Match")
  valid_594139 = validateParameter(valid_594139, JString, required = false,
                                 default = nil)
  if valid_594139 != nil:
    section.add "If-Match", valid_594139
  var valid_594140 = header.getOrDefault("If-Unmodified-Since")
  valid_594140 = validateParameter(valid_594140, JString, required = false,
                                 default = nil)
  if valid_594140 != nil:
    section.add "If-Unmodified-Since", valid_594140
  var valid_594141 = header.getOrDefault("x-ms-lease-id")
  valid_594141 = validateParameter(valid_594141, JString, required = false,
                                 default = nil)
  if valid_594141 != nil:
    section.add "x-ms-lease-id", valid_594141
  var valid_594142 = header.getOrDefault("x-ms-client-request-id")
  valid_594142 = validateParameter(valid_594142, JString, required = false,
                                 default = nil)
  if valid_594142 != nil:
    section.add "x-ms-client-request-id", valid_594142
  var valid_594143 = header.getOrDefault("x-ms-date")
  valid_594143 = validateParameter(valid_594143, JString, required = false,
                                 default = nil)
  if valid_594143 != nil:
    section.add "x-ms-date", valid_594143
  var valid_594144 = header.getOrDefault("If-None-Match")
  valid_594144 = validateParameter(valid_594144, JString, required = false,
                                 default = nil)
  if valid_594144 != nil:
    section.add "If-None-Match", valid_594144
  var valid_594145 = header.getOrDefault("If-Modified-Since")
  valid_594145 = validateParameter(valid_594145, JString, required = false,
                                 default = nil)
  if valid_594145 != nil:
    section.add "If-Modified-Since", valid_594145
  var valid_594146 = header.getOrDefault("x-ms-version")
  valid_594146 = validateParameter(valid_594146, JString, required = false,
                                 default = nil)
  if valid_594146 != nil:
    section.add "x-ms-version", valid_594146
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594147: Call_PathDelete_594131; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete the file or directory. This operation supports conditional HTTP requests.  For more information, see [Specifying Conditional Headers for Blob Service Operations](https://docs.microsoft.com/en-us/rest/api/storageservices/specifying-conditional-headers-for-blob-service-operations).
  ## 
  let valid = call_594147.validator(path, query, header, formData, body)
  let scheme = call_594147.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594147.url(scheme.get, call_594147.host, call_594147.base,
                         call_594147.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594147, url, valid)

proc call*(call_594148: Call_PathDelete_594131; path: string; filesystem: string;
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
  var path_594149 = newJObject()
  var query_594150 = newJObject()
  add(query_594150, "timeout", newJInt(timeout))
  add(query_594150, "continuation", newJString(continuation))
  add(path_594149, "path", newJString(path))
  add(path_594149, "filesystem", newJString(filesystem))
  add(query_594150, "recursive", newJBool(recursive))
  result = call_594148.call(path_594149, query_594150, nil, nil, nil)

var pathDelete* = Call_PathDelete_594131(name: "pathDelete",
                                      meth: HttpMethod.HttpDelete,
                                      host: "azure.local",
                                      route: "/{filesystem}/{path}",
                                      validator: validate_PathDelete_594132,
                                      base: "", url: url_PathDelete_594133,
                                      schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
