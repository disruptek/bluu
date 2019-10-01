
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_567641 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567641](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567641): Option[Scheme] {.used.} =
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
  macServiceName = "datalake-store-filesystem"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_FileSystemSetFileExpiry_567863 = ref object of OpenApiRestCall_567641
proc url_FileSystemSetFileExpiry_567865(protocol: Scheme; host: string; base: string;
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

proc validate_FileSystemSetFileExpiry_567864(path: JsonNode; query: JsonNode;
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
  var valid_568038 = path.getOrDefault("filePath")
  valid_568038 = validateParameter(valid_568038, JString, required = true,
                                 default = nil)
  if valid_568038 != nil:
    section.add "filePath", valid_568038
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   op: JString (required)
  ##     : The constant value for the operation.
  ##   expiryOption: JString (required)
  ##               : Indicates the type of expiration to use for the file: 1. NeverExpire: ExpireTime is ignored. 2. RelativeToNow: ExpireTime is an integer in milliseconds representing the expiration date relative to when file expiration is updated. 3. RelativeToCreationDate: ExpireTime is an integer in milliseconds representing the expiration date relative to file creation. 4. Absolute: ExpireTime is an integer in milliseconds, as a Unix timestamp relative to 1/1/1970 00:00:00.
  ##   expireTime: JInt
  ##             : The time that the file will expire, corresponding to the ExpiryOption that was set.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568039 = query.getOrDefault("api-version")
  valid_568039 = validateParameter(valid_568039, JString, required = true,
                                 default = nil)
  if valid_568039 != nil:
    section.add "api-version", valid_568039
  var valid_568053 = query.getOrDefault("op")
  valid_568053 = validateParameter(valid_568053, JString, required = true,
                                 default = newJString("SETEXPIRY"))
  if valid_568053 != nil:
    section.add "op", valid_568053
  var valid_568054 = query.getOrDefault("expiryOption")
  valid_568054 = validateParameter(valid_568054, JString, required = true,
                                 default = newJString("NeverExpire"))
  if valid_568054 != nil:
    section.add "expiryOption", valid_568054
  var valid_568055 = query.getOrDefault("expireTime")
  valid_568055 = validateParameter(valid_568055, JInt, required = false, default = nil)
  if valid_568055 != nil:
    section.add "expireTime", valid_568055
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568078: Call_FileSystemSetFileExpiry_567863; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sets or removes the expiration time on the specified file. This operation can only be executed against files. Folders are not supported.
  ## 
  let valid = call_568078.validator(path, query, header, formData, body)
  let scheme = call_568078.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568078.url(scheme.get, call_568078.host, call_568078.base,
                         call_568078.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568078, url, valid)

proc call*(call_568149: Call_FileSystemSetFileExpiry_567863; apiVersion: string;
          filePath: string; op: string = "SETEXPIRY";
          expiryOption: string = "NeverExpire"; expireTime: int = 0): Recallable =
  ## fileSystemSetFileExpiry
  ## Sets or removes the expiration time on the specified file. This operation can only be executed against files. Folders are not supported.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   filePath: string (required)
  ##           : The Data Lake Store path (starting with '/') of the file on which to set or remove the expiration time.
  ##   op: string (required)
  ##     : The constant value for the operation.
  ##   expiryOption: string (required)
  ##               : Indicates the type of expiration to use for the file: 1. NeverExpire: ExpireTime is ignored. 2. RelativeToNow: ExpireTime is an integer in milliseconds representing the expiration date relative to when file expiration is updated. 3. RelativeToCreationDate: ExpireTime is an integer in milliseconds representing the expiration date relative to file creation. 4. Absolute: ExpireTime is an integer in milliseconds, as a Unix timestamp relative to 1/1/1970 00:00:00.
  ##   expireTime: int
  ##             : The time that the file will expire, corresponding to the ExpiryOption that was set.
  var path_568150 = newJObject()
  var query_568152 = newJObject()
  add(query_568152, "api-version", newJString(apiVersion))
  add(path_568150, "filePath", newJString(filePath))
  add(query_568152, "op", newJString(op))
  add(query_568152, "expiryOption", newJString(expiryOption))
  add(query_568152, "expireTime", newJInt(expireTime))
  result = call_568149.call(path_568150, query_568152, nil, nil, nil)

var fileSystemSetFileExpiry* = Call_FileSystemSetFileExpiry_567863(
    name: "fileSystemSetFileExpiry", meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/WebHdfsExt/{filePath}", validator: validate_FileSystemSetFileExpiry_567864,
    base: "", url: url_FileSystemSetFileExpiry_567865, schemes: {Scheme.Https})
type
  Call_FileSystemConcurrentAppend_568191 = ref object of OpenApiRestCall_567641
proc url_FileSystemConcurrentAppend_568193(protocol: Scheme; host: string;
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

proc validate_FileSystemConcurrentAppend_568192(path: JsonNode; query: JsonNode;
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
  var valid_568194 = path.getOrDefault("filePath")
  valid_568194 = validateParameter(valid_568194, JString, required = true,
                                 default = nil)
  if valid_568194 != nil:
    section.add "filePath", valid_568194
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
  var valid_568195 = query.getOrDefault("api-version")
  valid_568195 = validateParameter(valid_568195, JString, required = true,
                                 default = nil)
  if valid_568195 != nil:
    section.add "api-version", valid_568195
  var valid_568196 = query.getOrDefault("op")
  valid_568196 = validateParameter(valid_568196, JString, required = true,
                                 default = newJString("CONCURRENTAPPEND"))
  if valid_568196 != nil:
    section.add "op", valid_568196
  var valid_568197 = query.getOrDefault("appendMode")
  valid_568197 = validateParameter(valid_568197, JString, required = false,
                                 default = newJString("autocreate"))
  if valid_568197 != nil:
    section.add "appendMode", valid_568197
  result.add "query", section
  ## parameters in `header` object:
  ##   Transfer-Encoding: JString (required)
  ##                    : Indicates the data being sent to the server is being streamed in chunks.
  section = newJObject()
  assert header != nil, "header argument is necessary due to required `Transfer-Encoding` field"
  var valid_568198 = header.getOrDefault("Transfer-Encoding")
  valid_568198 = validateParameter(valid_568198, JString, required = true,
                                 default = newJString("chunked"))
  if valid_568198 != nil:
    section.add "Transfer-Encoding", valid_568198
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

proc call*(call_568200: Call_FileSystemConcurrentAppend_568191; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Appends to the specified file. This method supports multiple concurrent appends to the file. NOTE: ConcurrentAppend and normal (serial) Append CANNOT be used interchangeably; once a file has been appended to using either of these append options, it can only be appended to using that append option. ConcurrentAppend DOES NOT guarantee order and can result in duplicated data landing in the target file. In order to close a file after using ConcurrentAppend, call the Flush method.
  ## 
  let valid = call_568200.validator(path, query, header, formData, body)
  let scheme = call_568200.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568200.url(scheme.get, call_568200.host, call_568200.base,
                         call_568200.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568200, url, valid)

proc call*(call_568201: Call_FileSystemConcurrentAppend_568191; apiVersion: string;
          filePath: string; streamContents: JsonNode;
          op: string = "CONCURRENTAPPEND"; appendMode: string = "autocreate"): Recallable =
  ## fileSystemConcurrentAppend
  ## Appends to the specified file. This method supports multiple concurrent appends to the file. NOTE: ConcurrentAppend and normal (serial) Append CANNOT be used interchangeably; once a file has been appended to using either of these append options, it can only be appended to using that append option. ConcurrentAppend DOES NOT guarantee order and can result in duplicated data landing in the target file. In order to close a file after using ConcurrentAppend, call the Flush method.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   filePath: string (required)
  ##           : The Data Lake Store path (starting with '/') of the file to which to append using concurrent append.
  ##   op: string (required)
  ##     : The constant value for the operation.
  ##   streamContents: JObject (required)
  ##                 : The file contents to include when appending to the file.  The maximum content size is 4MB.  For content larger than 4MB you must append the content in 4MB chunks.
  ##   appendMode: string
  ##             : Indicates the concurrent append call should create the file if it doesn't exist or just open the existing file for append
  var path_568202 = newJObject()
  var query_568203 = newJObject()
  var body_568204 = newJObject()
  add(query_568203, "api-version", newJString(apiVersion))
  add(path_568202, "filePath", newJString(filePath))
  add(query_568203, "op", newJString(op))
  if streamContents != nil:
    body_568204 = streamContents
  add(query_568203, "appendMode", newJString(appendMode))
  result = call_568201.call(path_568202, query_568203, nil, nil, body_568204)

var fileSystemConcurrentAppend* = Call_FileSystemConcurrentAppend_568191(
    name: "fileSystemConcurrentAppend", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/WebHdfsExt/{filePath}",
    validator: validate_FileSystemConcurrentAppend_568192, base: "",
    url: url_FileSystemConcurrentAppend_568193, schemes: {Scheme.Https})
type
  Call_FileSystemMkdirs_568216 = ref object of OpenApiRestCall_567641
proc url_FileSystemMkdirs_568218(protocol: Scheme; host: string; base: string;
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

proc validate_FileSystemMkdirs_568217(path: JsonNode; query: JsonNode;
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
  var valid_568219 = path.getOrDefault("path")
  valid_568219 = validateParameter(valid_568219, JString, required = true,
                                 default = nil)
  if valid_568219 != nil:
    section.add "path", valid_568219
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   op: JString (required)
  ##     : The constant value for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568220 = query.getOrDefault("api-version")
  valid_568220 = validateParameter(valid_568220, JString, required = true,
                                 default = nil)
  if valid_568220 != nil:
    section.add "api-version", valid_568220
  var valid_568221 = query.getOrDefault("op")
  valid_568221 = validateParameter(valid_568221, JString, required = true,
                                 default = newJString("MKDIRS"))
  if valid_568221 != nil:
    section.add "op", valid_568221
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568222: Call_FileSystemMkdirs_568216; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a directory.
  ## 
  let valid = call_568222.validator(path, query, header, formData, body)
  let scheme = call_568222.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568222.url(scheme.get, call_568222.host, call_568222.base,
                         call_568222.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568222, url, valid)

proc call*(call_568223: Call_FileSystemMkdirs_568216; apiVersion: string;
          path: string; op: string = "MKDIRS"): Recallable =
  ## fileSystemMkdirs
  ## Creates a directory.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   path: string (required)
  ##       : The Data Lake Store path (starting with '/') of the directory to create.
  ##   op: string (required)
  ##     : The constant value for the operation.
  var path_568224 = newJObject()
  var query_568225 = newJObject()
  add(query_568225, "api-version", newJString(apiVersion))
  add(path_568224, "path", newJString(path))
  add(query_568225, "op", newJString(op))
  result = call_568223.call(path_568224, query_568225, nil, nil, nil)

var fileSystemMkdirs* = Call_FileSystemMkdirs_568216(name: "fileSystemMkdirs",
    meth: HttpMethod.HttpPut, host: "azure.local", route: "/webhdfs/v1/{path}",
    validator: validate_FileSystemMkdirs_568217, base: "",
    url: url_FileSystemMkdirs_568218, schemes: {Scheme.Https})
type
  Call_FileSystemCheckAccess_568205 = ref object of OpenApiRestCall_567641
proc url_FileSystemCheckAccess_568207(protocol: Scheme; host: string; base: string;
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

proc validate_FileSystemCheckAccess_568206(path: JsonNode; query: JsonNode;
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
  var valid_568208 = path.getOrDefault("path")
  valid_568208 = validateParameter(valid_568208, JString, required = true,
                                 default = nil)
  if valid_568208 != nil:
    section.add "path", valid_568208
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
  var valid_568209 = query.getOrDefault("api-version")
  valid_568209 = validateParameter(valid_568209, JString, required = true,
                                 default = nil)
  if valid_568209 != nil:
    section.add "api-version", valid_568209
  var valid_568210 = query.getOrDefault("op")
  valid_568210 = validateParameter(valid_568210, JString, required = true,
                                 default = newJString("CHECKACCESS"))
  if valid_568210 != nil:
    section.add "op", valid_568210
  var valid_568211 = query.getOrDefault("fsaction")
  valid_568211 = validateParameter(valid_568211, JString, required = false,
                                 default = nil)
  if valid_568211 != nil:
    section.add "fsaction", valid_568211
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568212: Call_FileSystemCheckAccess_568205; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks if the specified access is available at the given path.
  ## 
  let valid = call_568212.validator(path, query, header, formData, body)
  let scheme = call_568212.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568212.url(scheme.get, call_568212.host, call_568212.base,
                         call_568212.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568212, url, valid)

proc call*(call_568213: Call_FileSystemCheckAccess_568205; apiVersion: string;
          path: string; op: string = "CHECKACCESS"; fsaction: string = ""): Recallable =
  ## fileSystemCheckAccess
  ## Checks if the specified access is available at the given path.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   path: string (required)
  ##       : The Data Lake Store path (starting with '/') of the file or directory for which to check access.
  ##   op: string (required)
  ##     : The constant value for the operation.
  ##   fsaction: string
  ##           : File system operation read/write/execute in string form, matching regex pattern '[rwx-]{3}'
  var path_568214 = newJObject()
  var query_568215 = newJObject()
  add(query_568215, "api-version", newJString(apiVersion))
  add(path_568214, "path", newJString(path))
  add(query_568215, "op", newJString(op))
  add(query_568215, "fsaction", newJString(fsaction))
  result = call_568213.call(path_568214, query_568215, nil, nil, nil)

var fileSystemCheckAccess* = Call_FileSystemCheckAccess_568205(
    name: "fileSystemCheckAccess", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/webhdfs/v1/{path}", validator: validate_FileSystemCheckAccess_568206,
    base: "", url: url_FileSystemCheckAccess_568207, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
