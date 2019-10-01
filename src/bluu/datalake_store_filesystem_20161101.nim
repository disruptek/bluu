
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: DataLakeStoreFileSystemManagementClient
## version: 2016-11-01
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

  OpenApiRestCall_567657 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567657](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567657): Option[Scheme] {.used.} =
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
  Call_FileSystemSetFileExpiry_567879 = ref object of OpenApiRestCall_567657
proc url_FileSystemSetFileExpiry_567881(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "path" in path, "`path` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/WebHdfsExt/"),
               (kind: VariableSegment, value: "path")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FileSystemSetFileExpiry_567880(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets or removes the expiration time on the specified file. This operation can only be executed against files. Folders are not supported.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   path: JString (required)
  ##       : The Data Lake Store path (starting with '/') of the file on which to set or remove the expiration time.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `path` field"
  var valid_568054 = path.getOrDefault("path")
  valid_568054 = validateParameter(valid_568054, JString, required = true,
                                 default = nil)
  if valid_568054 != nil:
    section.add "path", valid_568054
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
  var valid_568055 = query.getOrDefault("api-version")
  valid_568055 = validateParameter(valid_568055, JString, required = true,
                                 default = nil)
  if valid_568055 != nil:
    section.add "api-version", valid_568055
  var valid_568069 = query.getOrDefault("op")
  valid_568069 = validateParameter(valid_568069, JString, required = true,
                                 default = newJString("SETEXPIRY"))
  if valid_568069 != nil:
    section.add "op", valid_568069
  var valid_568070 = query.getOrDefault("expiryOption")
  valid_568070 = validateParameter(valid_568070, JString, required = true,
                                 default = newJString("NeverExpire"))
  if valid_568070 != nil:
    section.add "expiryOption", valid_568070
  var valid_568071 = query.getOrDefault("expireTime")
  valid_568071 = validateParameter(valid_568071, JInt, required = false, default = nil)
  if valid_568071 != nil:
    section.add "expireTime", valid_568071
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568094: Call_FileSystemSetFileExpiry_567879; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sets or removes the expiration time on the specified file. This operation can only be executed against files. Folders are not supported.
  ## 
  let valid = call_568094.validator(path, query, header, formData, body)
  let scheme = call_568094.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568094.url(scheme.get, call_568094.host, call_568094.base,
                         call_568094.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568094, url, valid)

proc call*(call_568165: Call_FileSystemSetFileExpiry_567879; apiVersion: string;
          path: string; op: string = "SETEXPIRY";
          expiryOption: string = "NeverExpire"; expireTime: int = 0): Recallable =
  ## fileSystemSetFileExpiry
  ## Sets or removes the expiration time on the specified file. This operation can only be executed against files. Folders are not supported.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   path: string (required)
  ##       : The Data Lake Store path (starting with '/') of the file on which to set or remove the expiration time.
  ##   op: string (required)
  ##     : The constant value for the operation.
  ##   expiryOption: string (required)
  ##               : Indicates the type of expiration to use for the file: 1. NeverExpire: ExpireTime is ignored. 2. RelativeToNow: ExpireTime is an integer in milliseconds representing the expiration date relative to when file expiration is updated. 3. RelativeToCreationDate: ExpireTime is an integer in milliseconds representing the expiration date relative to file creation. 4. Absolute: ExpireTime is an integer in milliseconds, as a Unix timestamp relative to 1/1/1970 00:00:00.
  ##   expireTime: int
  ##             : The time that the file will expire, corresponding to the ExpiryOption that was set.
  var path_568166 = newJObject()
  var query_568168 = newJObject()
  add(query_568168, "api-version", newJString(apiVersion))
  add(path_568166, "path", newJString(path))
  add(query_568168, "op", newJString(op))
  add(query_568168, "expiryOption", newJString(expiryOption))
  add(query_568168, "expireTime", newJInt(expireTime))
  result = call_568165.call(path_568166, query_568168, nil, nil, nil)

var fileSystemSetFileExpiry* = Call_FileSystemSetFileExpiry_567879(
    name: "fileSystemSetFileExpiry", meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/WebHdfsExt/{path}", validator: validate_FileSystemSetFileExpiry_567880,
    base: "", url: url_FileSystemSetFileExpiry_567881, schemes: {Scheme.Https})
type
  Call_FileSystemConcurrentAppend_568207 = ref object of OpenApiRestCall_567657
proc url_FileSystemConcurrentAppend_568209(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "path" in path, "`path` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/WebHdfsExt/"),
               (kind: VariableSegment, value: "path")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FileSystemConcurrentAppend_568208(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Appends to the specified file, optionally first creating the file if it does not yet exist. This method supports multiple concurrent appends to the file. NOTE: The target must not contain data added by Create or normal (serial) Append. ConcurrentAppend and Append cannot be used interchangeably; once a target file has been modified using either of these append options, the other append option cannot be used on the target file. ConcurrentAppend does not guarantee order and can result in duplicated data landing in the target file.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   path: JString (required)
  ##       : The Data Lake Store path (starting with '/') of the file to which to append using concurrent append.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `path` field"
  var valid_568210 = path.getOrDefault("path")
  valid_568210 = validateParameter(valid_568210, JString, required = true,
                                 default = nil)
  if valid_568210 != nil:
    section.add "path", valid_568210
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   syncFlag: JString
  ##           : Optionally indicates what to do after completion of the concurrent append. DATA indicates that more data will be sent immediately by the client, the file handle should remain open/locked, and file metadata (including file length, last modified time) should NOT get updated. METADATA indicates that more data will be sent immediately by the client, the file handle should remain open/locked, and file metadata should get updated. CLOSE indicates that the client is done sending data, the file handle should be closed/unlocked, and file metadata should get updated.
  ##   op: JString (required)
  ##     : The constant value for the operation.
  ##   appendMode: JString
  ##             : Indicates the concurrent append call should create the file if it doesn't exist or just open the existing file for append
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568211 = query.getOrDefault("api-version")
  valid_568211 = validateParameter(valid_568211, JString, required = true,
                                 default = nil)
  if valid_568211 != nil:
    section.add "api-version", valid_568211
  var valid_568212 = query.getOrDefault("syncFlag")
  valid_568212 = validateParameter(valid_568212, JString, required = false,
                                 default = newJString("DATA"))
  if valid_568212 != nil:
    section.add "syncFlag", valid_568212
  var valid_568213 = query.getOrDefault("op")
  valid_568213 = validateParameter(valid_568213, JString, required = true,
                                 default = newJString("CONCURRENTAPPEND"))
  if valid_568213 != nil:
    section.add "op", valid_568213
  var valid_568214 = query.getOrDefault("appendMode")
  valid_568214 = validateParameter(valid_568214, JString, required = false,
                                 default = newJString("autocreate"))
  if valid_568214 != nil:
    section.add "appendMode", valid_568214
  result.add "query", section
  ## parameters in `header` object:
  ##   Transfer-Encoding: JString (required)
  ##                    : Indicates the data being sent to the server is being streamed in chunks.
  section = newJObject()
  assert header != nil, "header argument is necessary due to required `Transfer-Encoding` field"
  var valid_568215 = header.getOrDefault("Transfer-Encoding")
  valid_568215 = validateParameter(valid_568215, JString, required = true,
                                 default = newJString("chunked"))
  if valid_568215 != nil:
    section.add "Transfer-Encoding", valid_568215
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

proc call*(call_568217: Call_FileSystemConcurrentAppend_568207; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Appends to the specified file, optionally first creating the file if it does not yet exist. This method supports multiple concurrent appends to the file. NOTE: The target must not contain data added by Create or normal (serial) Append. ConcurrentAppend and Append cannot be used interchangeably; once a target file has been modified using either of these append options, the other append option cannot be used on the target file. ConcurrentAppend does not guarantee order and can result in duplicated data landing in the target file.
  ## 
  let valid = call_568217.validator(path, query, header, formData, body)
  let scheme = call_568217.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568217.url(scheme.get, call_568217.host, call_568217.base,
                         call_568217.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568217, url, valid)

proc call*(call_568218: Call_FileSystemConcurrentAppend_568207; apiVersion: string;
          path: string; streamContents: JsonNode; syncFlag: string = "DATA";
          op: string = "CONCURRENTAPPEND"; appendMode: string = "autocreate"): Recallable =
  ## fileSystemConcurrentAppend
  ## Appends to the specified file, optionally first creating the file if it does not yet exist. This method supports multiple concurrent appends to the file. NOTE: The target must not contain data added by Create or normal (serial) Append. ConcurrentAppend and Append cannot be used interchangeably; once a target file has been modified using either of these append options, the other append option cannot be used on the target file. ConcurrentAppend does not guarantee order and can result in duplicated data landing in the target file.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   path: string (required)
  ##       : The Data Lake Store path (starting with '/') of the file to which to append using concurrent append.
  ##   syncFlag: string
  ##           : Optionally indicates what to do after completion of the concurrent append. DATA indicates that more data will be sent immediately by the client, the file handle should remain open/locked, and file metadata (including file length, last modified time) should NOT get updated. METADATA indicates that more data will be sent immediately by the client, the file handle should remain open/locked, and file metadata should get updated. CLOSE indicates that the client is done sending data, the file handle should be closed/unlocked, and file metadata should get updated.
  ##   op: string (required)
  ##     : The constant value for the operation.
  ##   streamContents: JObject (required)
  ##                 : The file contents to include when appending to the file.  The maximum content size is 4MB.  For content larger than 4MB you must append the content in 4MB chunks.
  ##   appendMode: string
  ##             : Indicates the concurrent append call should create the file if it doesn't exist or just open the existing file for append
  var path_568219 = newJObject()
  var query_568220 = newJObject()
  var body_568221 = newJObject()
  add(query_568220, "api-version", newJString(apiVersion))
  add(path_568219, "path", newJString(path))
  add(query_568220, "syncFlag", newJString(syncFlag))
  add(query_568220, "op", newJString(op))
  if streamContents != nil:
    body_568221 = streamContents
  add(query_568220, "appendMode", newJString(appendMode))
  result = call_568218.call(path_568219, query_568220, nil, nil, body_568221)

var fileSystemConcurrentAppend* = Call_FileSystemConcurrentAppend_568207(
    name: "fileSystemConcurrentAppend", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/WebHdfsExt/{path}",
    validator: validate_FileSystemConcurrentAppend_568208, base: "",
    url: url_FileSystemConcurrentAppend_568209, schemes: {Scheme.Https})
type
  Call_FileSystemCheckAccess_568222 = ref object of OpenApiRestCall_567657
proc url_FileSystemCheckAccess_568224(protocol: Scheme; host: string; base: string;
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

proc validate_FileSystemCheckAccess_568223(path: JsonNode; query: JsonNode;
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
  var valid_568225 = path.getOrDefault("path")
  valid_568225 = validateParameter(valid_568225, JString, required = true,
                                 default = nil)
  if valid_568225 != nil:
    section.add "path", valid_568225
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   op: JString (required)
  ##     : The constant value for the operation.
  ##   fsaction: JString (required)
  ##           : File system operation read/write/execute in string form, matching regex pattern '[rwx-]{3}'
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568226 = query.getOrDefault("api-version")
  valid_568226 = validateParameter(valid_568226, JString, required = true,
                                 default = nil)
  if valid_568226 != nil:
    section.add "api-version", valid_568226
  var valid_568227 = query.getOrDefault("op")
  valid_568227 = validateParameter(valid_568227, JString, required = true,
                                 default = newJString("CHECKACCESS"))
  if valid_568227 != nil:
    section.add "op", valid_568227
  var valid_568228 = query.getOrDefault("fsaction")
  valid_568228 = validateParameter(valid_568228, JString, required = true,
                                 default = nil)
  if valid_568228 != nil:
    section.add "fsaction", valid_568228
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568229: Call_FileSystemCheckAccess_568222; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks if the specified access is available at the given path.
  ## 
  let valid = call_568229.validator(path, query, header, formData, body)
  let scheme = call_568229.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568229.url(scheme.get, call_568229.host, call_568229.base,
                         call_568229.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568229, url, valid)

proc call*(call_568230: Call_FileSystemCheckAccess_568222; apiVersion: string;
          path: string; fsaction: string; op: string = "CHECKACCESS"): Recallable =
  ## fileSystemCheckAccess
  ## Checks if the specified access is available at the given path.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   path: string (required)
  ##       : The Data Lake Store path (starting with '/') of the file or directory for which to check access.
  ##   op: string (required)
  ##     : The constant value for the operation.
  ##   fsaction: string (required)
  ##           : File system operation read/write/execute in string form, matching regex pattern '[rwx-]{3}'
  var path_568231 = newJObject()
  var query_568232 = newJObject()
  add(query_568232, "api-version", newJString(apiVersion))
  add(path_568231, "path", newJString(path))
  add(query_568232, "op", newJString(op))
  add(query_568232, "fsaction", newJString(fsaction))
  result = call_568230.call(path_568231, query_568232, nil, nil, nil)

var fileSystemCheckAccess* = Call_FileSystemCheckAccess_568222(
    name: "fileSystemCheckAccess", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/webhdfs/v1/{path}", validator: validate_FileSystemCheckAccess_568223,
    base: "", url: url_FileSystemCheckAccess_568224, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
