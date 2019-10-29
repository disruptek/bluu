
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: DataLakeStoreFileSystemManagementClient
## version: 2015-10-01-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## Creates an Azure Data Lake Store filesystem client.
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

  OpenApiRestCall_563539 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563539](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563539): Option[Scheme] {.used.} =
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
  macServiceName = "datalake-store-filesystem"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_FileSystemSetFileExpiry_563761 = ref object of OpenApiRestCall_563539
proc url_FileSystemSetFileExpiry_563763(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "filePath" in path, "`filePath` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/WebHdfsExt/"),
               (kind: VariableSegment, value: "filePath")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FileSystemSetFileExpiry_563762(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets or removes the expiration time on the specified file. This operation can only be executed against files. Folders are not supported.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   filePath: JString (required)
  ##           : The Data Lake Store path (starting with '/') of the file on which to set or remove the expiration time.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `filePath` field"
  var valid_563938 = path.getOrDefault("filePath")
  valid_563938 = validateParameter(valid_563938, JString, required = true,
                                 default = nil)
  if valid_563938 != nil:
    section.add "filePath", valid_563938
  result.add "path", section
  ## parameters in `query` object:
  ##   expireTime: JInt
  ##             : The time that the file will expire, corresponding to the ExpiryOption that was set.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   expiryOption: JString (required)
  ##               : Indicates the type of expiration to use for the file: 1. NeverExpire: ExpireTime is ignored. 2. RelativeToNow: ExpireTime is an integer in milliseconds representing the expiration date relative to when file expiration is updated. 3. RelativeToCreationDate: ExpireTime is an integer in milliseconds representing the expiration date relative to file creation. 4. Absolute: ExpireTime is an integer in milliseconds, as a Unix timestamp relative to 1/1/1970 00:00:00.
  ##   op: JString (required)
  ##     : The constant value for the operation.
  section = newJObject()
  var valid_563939 = query.getOrDefault("expireTime")
  valid_563939 = validateParameter(valid_563939, JInt, required = false, default = nil)
  if valid_563939 != nil:
    section.add "expireTime", valid_563939
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563940 = query.getOrDefault("api-version")
  valid_563940 = validateParameter(valid_563940, JString, required = true,
                                 default = nil)
  if valid_563940 != nil:
    section.add "api-version", valid_563940
  var valid_563954 = query.getOrDefault("expiryOption")
  valid_563954 = validateParameter(valid_563954, JString, required = true,
                                 default = newJString("NeverExpire"))
  if valid_563954 != nil:
    section.add "expiryOption", valid_563954
  var valid_563955 = query.getOrDefault("op")
  valid_563955 = validateParameter(valid_563955, JString, required = true,
                                 default = newJString("SETEXPIRY"))
  if valid_563955 != nil:
    section.add "op", valid_563955
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563978: Call_FileSystemSetFileExpiry_563761; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sets or removes the expiration time on the specified file. This operation can only be executed against files. Folders are not supported.
  ## 
  let valid = call_563978.validator(path, query, header, formData, body)
  let scheme = call_563978.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563978.url(scheme.get, call_563978.host, call_563978.base,
                         call_563978.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563978, url, valid)

proc call*(call_564049: Call_FileSystemSetFileExpiry_563761; apiVersion: string;
          filePath: string; expireTime: int = 0; expiryOption: string = "NeverExpire";
          op: string = "SETEXPIRY"): Recallable =
  ## fileSystemSetFileExpiry
  ## Sets or removes the expiration time on the specified file. This operation can only be executed against files. Folders are not supported.
  ##   expireTime: int
  ##             : The time that the file will expire, corresponding to the ExpiryOption that was set.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   filePath: string (required)
  ##           : The Data Lake Store path (starting with '/') of the file on which to set or remove the expiration time.
  ##   expiryOption: string (required)
  ##               : Indicates the type of expiration to use for the file: 1. NeverExpire: ExpireTime is ignored. 2. RelativeToNow: ExpireTime is an integer in milliseconds representing the expiration date relative to when file expiration is updated. 3. RelativeToCreationDate: ExpireTime is an integer in milliseconds representing the expiration date relative to file creation. 4. Absolute: ExpireTime is an integer in milliseconds, as a Unix timestamp relative to 1/1/1970 00:00:00.
  ##   op: string (required)
  ##     : The constant value for the operation.
  var path_564050 = newJObject()
  var query_564052 = newJObject()
  add(query_564052, "expireTime", newJInt(expireTime))
  add(query_564052, "api-version", newJString(apiVersion))
  add(path_564050, "filePath", newJString(filePath))
  add(query_564052, "expiryOption", newJString(expiryOption))
  add(query_564052, "op", newJString(op))
  result = call_564049.call(path_564050, query_564052, nil, nil, nil)

var fileSystemSetFileExpiry* = Call_FileSystemSetFileExpiry_563761(
    name: "fileSystemSetFileExpiry", meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/WebHdfsExt/{filePath}", validator: validate_FileSystemSetFileExpiry_563762,
    base: "", url: url_FileSystemSetFileExpiry_563763, schemes: {Scheme.Https})
type
  Call_FileSystemConcurrentAppend_564091 = ref object of OpenApiRestCall_563539
proc url_FileSystemConcurrentAppend_564093(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "filePath" in path, "`filePath` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/WebHdfsExt/"),
               (kind: VariableSegment, value: "filePath")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FileSystemConcurrentAppend_564092(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Appends to the specified file. This method supports multiple concurrent appends to the file. NOTE: ConcurrentAppend and normal (serial) Append CANNOT be used interchangeably; once a file has been appended to using either of these append options, it can only be appended to using that append option. ConcurrentAppend DOES NOT guarantee order and can result in duplicated data landing in the target file. In order to close a file after using ConcurrentAppend, call the Flush method.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   filePath: JString (required)
  ##           : The Data Lake Store path (starting with '/') of the file to which to append using concurrent append.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `filePath` field"
  var valid_564094 = path.getOrDefault("filePath")
  valid_564094 = validateParameter(valid_564094, JString, required = true,
                                 default = nil)
  if valid_564094 != nil:
    section.add "filePath", valid_564094
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   op: JString (required)
  ##     : The constant value for the operation.
  ##   appendMode: JString
  ##             : Indicates the concurrent append call should create the file if it doesn't exist or just open the existing file for append
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564095 = query.getOrDefault("api-version")
  valid_564095 = validateParameter(valid_564095, JString, required = true,
                                 default = nil)
  if valid_564095 != nil:
    section.add "api-version", valid_564095
  var valid_564096 = query.getOrDefault("op")
  valid_564096 = validateParameter(valid_564096, JString, required = true,
                                 default = newJString("CONCURRENTAPPEND"))
  if valid_564096 != nil:
    section.add "op", valid_564096
  var valid_564097 = query.getOrDefault("appendMode")
  valid_564097 = validateParameter(valid_564097, JString, required = false,
                                 default = newJString("autocreate"))
  if valid_564097 != nil:
    section.add "appendMode", valid_564097
  result.add "query", section
  ## parameters in `header` object:
  ##   Transfer-Encoding: JString (required)
  ##                    : Indicates the data being sent to the server is being streamed in chunks.
  section = newJObject()
  assert header != nil, "header argument is necessary due to required `Transfer-Encoding` field"
  var valid_564098 = header.getOrDefault("Transfer-Encoding")
  valid_564098 = validateParameter(valid_564098, JString, required = true,
                                 default = newJString("chunked"))
  if valid_564098 != nil:
    section.add "Transfer-Encoding", valid_564098
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   streamContents: JObject (required)
  ##                 : The file contents to include when appending to the file.  The maximum content size is 4MB.  For content larger than 4MB you must append the content in 4MB chunks.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564100: Call_FileSystemConcurrentAppend_564091; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Appends to the specified file. This method supports multiple concurrent appends to the file. NOTE: ConcurrentAppend and normal (serial) Append CANNOT be used interchangeably; once a file has been appended to using either of these append options, it can only be appended to using that append option. ConcurrentAppend DOES NOT guarantee order and can result in duplicated data landing in the target file. In order to close a file after using ConcurrentAppend, call the Flush method.
  ## 
  let valid = call_564100.validator(path, query, header, formData, body)
  let scheme = call_564100.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564100.url(scheme.get, call_564100.host, call_564100.base,
                         call_564100.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564100, url, valid)

proc call*(call_564101: Call_FileSystemConcurrentAppend_564091;
          streamContents: JsonNode; apiVersion: string; filePath: string;
          op: string = "CONCURRENTAPPEND"; appendMode: string = "autocreate"): Recallable =
  ## fileSystemConcurrentAppend
  ## Appends to the specified file. This method supports multiple concurrent appends to the file. NOTE: ConcurrentAppend and normal (serial) Append CANNOT be used interchangeably; once a file has been appended to using either of these append options, it can only be appended to using that append option. ConcurrentAppend DOES NOT guarantee order and can result in duplicated data landing in the target file. In order to close a file after using ConcurrentAppend, call the Flush method.
  ##   streamContents: JObject (required)
  ##                 : The file contents to include when appending to the file.  The maximum content size is 4MB.  For content larger than 4MB you must append the content in 4MB chunks.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   filePath: string (required)
  ##           : The Data Lake Store path (starting with '/') of the file to which to append using concurrent append.
  ##   op: string (required)
  ##     : The constant value for the operation.
  ##   appendMode: string
  ##             : Indicates the concurrent append call should create the file if it doesn't exist or just open the existing file for append
  var path_564102 = newJObject()
  var query_564103 = newJObject()
  var body_564104 = newJObject()
  if streamContents != nil:
    body_564104 = streamContents
  add(query_564103, "api-version", newJString(apiVersion))
  add(path_564102, "filePath", newJString(filePath))
  add(query_564103, "op", newJString(op))
  add(query_564103, "appendMode", newJString(appendMode))
  result = call_564101.call(path_564102, query_564103, nil, nil, body_564104)

var fileSystemConcurrentAppend* = Call_FileSystemConcurrentAppend_564091(
    name: "fileSystemConcurrentAppend", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/WebHdfsExt/{filePath}",
    validator: validate_FileSystemConcurrentAppend_564092, base: "",
    url: url_FileSystemConcurrentAppend_564093, schemes: {Scheme.Https})
type
  Call_FileSystemMkdirs_564116 = ref object of OpenApiRestCall_563539
proc url_FileSystemMkdirs_564118(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "path" in path, "`path` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/webhdfs/v1/"),
               (kind: VariableSegment, value: "path")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FileSystemMkdirs_564117(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Creates a directory.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   path: JString (required)
  ##       : The Data Lake Store path (starting with '/') of the directory to create.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `path` field"
  var valid_564119 = path.getOrDefault("path")
  valid_564119 = validateParameter(valid_564119, JString, required = true,
                                 default = nil)
  if valid_564119 != nil:
    section.add "path", valid_564119
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   op: JString (required)
  ##     : The constant value for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564120 = query.getOrDefault("api-version")
  valid_564120 = validateParameter(valid_564120, JString, required = true,
                                 default = nil)
  if valid_564120 != nil:
    section.add "api-version", valid_564120
  var valid_564121 = query.getOrDefault("op")
  valid_564121 = validateParameter(valid_564121, JString, required = true,
                                 default = newJString("MKDIRS"))
  if valid_564121 != nil:
    section.add "op", valid_564121
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564122: Call_FileSystemMkdirs_564116; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a directory.
  ## 
  let valid = call_564122.validator(path, query, header, formData, body)
  let scheme = call_564122.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564122.url(scheme.get, call_564122.host, call_564122.base,
                         call_564122.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564122, url, valid)

proc call*(call_564123: Call_FileSystemMkdirs_564116; apiVersion: string;
          path: string; op: string = "MKDIRS"): Recallable =
  ## fileSystemMkdirs
  ## Creates a directory.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   op: string (required)
  ##     : The constant value for the operation.
  ##   path: string (required)
  ##       : The Data Lake Store path (starting with '/') of the directory to create.
  var path_564124 = newJObject()
  var query_564125 = newJObject()
  add(query_564125, "api-version", newJString(apiVersion))
  add(query_564125, "op", newJString(op))
  add(path_564124, "path", newJString(path))
  result = call_564123.call(path_564124, query_564125, nil, nil, nil)

var fileSystemMkdirs* = Call_FileSystemMkdirs_564116(name: "fileSystemMkdirs",
    meth: HttpMethod.HttpPut, host: "azure.local", route: "/webhdfs/v1/{path}",
    validator: validate_FileSystemMkdirs_564117, base: "",
    url: url_FileSystemMkdirs_564118, schemes: {Scheme.Https})
type
  Call_FileSystemCheckAccess_564105 = ref object of OpenApiRestCall_563539
proc url_FileSystemCheckAccess_564107(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "path" in path, "`path` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/webhdfs/v1/"),
               (kind: VariableSegment, value: "path")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FileSystemCheckAccess_564106(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Checks if the specified access is available at the given path.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   path: JString (required)
  ##       : The Data Lake Store path (starting with '/') of the file or directory for which to check access.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `path` field"
  var valid_564108 = path.getOrDefault("path")
  valid_564108 = validateParameter(valid_564108, JString, required = true,
                                 default = nil)
  if valid_564108 != nil:
    section.add "path", valid_564108
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   op: JString (required)
  ##     : The constant value for the operation.
  ##   fsaction: JString
  ##           : File system operation read/write/execute in string form, matching regex pattern '[rwx-]{3}'
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564109 = query.getOrDefault("api-version")
  valid_564109 = validateParameter(valid_564109, JString, required = true,
                                 default = nil)
  if valid_564109 != nil:
    section.add "api-version", valid_564109
  var valid_564110 = query.getOrDefault("op")
  valid_564110 = validateParameter(valid_564110, JString, required = true,
                                 default = newJString("CHECKACCESS"))
  if valid_564110 != nil:
    section.add "op", valid_564110
  var valid_564111 = query.getOrDefault("fsaction")
  valid_564111 = validateParameter(valid_564111, JString, required = false,
                                 default = nil)
  if valid_564111 != nil:
    section.add "fsaction", valid_564111
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564112: Call_FileSystemCheckAccess_564105; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks if the specified access is available at the given path.
  ## 
  let valid = call_564112.validator(path, query, header, formData, body)
  let scheme = call_564112.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564112.url(scheme.get, call_564112.host, call_564112.base,
                         call_564112.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564112, url, valid)

proc call*(call_564113: Call_FileSystemCheckAccess_564105; apiVersion: string;
          path: string; op: string = "CHECKACCESS"; fsaction: string = ""): Recallable =
  ## fileSystemCheckAccess
  ## Checks if the specified access is available at the given path.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   op: string (required)
  ##     : The constant value for the operation.
  ##   path: string (required)
  ##       : The Data Lake Store path (starting with '/') of the file or directory for which to check access.
  ##   fsaction: string
  ##           : File system operation read/write/execute in string form, matching regex pattern '[rwx-]{3}'
  var path_564114 = newJObject()
  var query_564115 = newJObject()
  add(query_564115, "api-version", newJString(apiVersion))
  add(query_564115, "op", newJString(op))
  add(path_564114, "path", newJString(path))
  add(query_564115, "fsaction", newJString(fsaction))
  result = call_564113.call(path_564114, query_564115, nil, nil, nil)

var fileSystemCheckAccess* = Call_FileSystemCheckAccess_564105(
    name: "fileSystemCheckAccess", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/webhdfs/v1/{path}", validator: validate_FileSystemCheckAccess_564106,
    base: "", url: url_FileSystemCheckAccess_564107, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
