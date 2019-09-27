
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_593424 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593424](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593424): Option[Scheme] {.used.} =
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
  macServiceName = "datalake-store-filesystem"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_FileSystemSetFileExpiry_593646 = ref object of OpenApiRestCall_593424
proc url_FileSystemSetFileExpiry_593648(protocol: Scheme; host: string; base: string;
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

proc validate_FileSystemSetFileExpiry_593647(path: JsonNode; query: JsonNode;
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
  var valid_593821 = path.getOrDefault("path")
  valid_593821 = validateParameter(valid_593821, JString, required = true,
                                 default = nil)
  if valid_593821 != nil:
    section.add "path", valid_593821
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
  var valid_593822 = query.getOrDefault("api-version")
  valid_593822 = validateParameter(valid_593822, JString, required = true,
                                 default = nil)
  if valid_593822 != nil:
    section.add "api-version", valid_593822
  var valid_593836 = query.getOrDefault("op")
  valid_593836 = validateParameter(valid_593836, JString, required = true,
                                 default = newJString("SETEXPIRY"))
  if valid_593836 != nil:
    section.add "op", valid_593836
  var valid_593837 = query.getOrDefault("expiryOption")
  valid_593837 = validateParameter(valid_593837, JString, required = true,
                                 default = newJString("NeverExpire"))
  if valid_593837 != nil:
    section.add "expiryOption", valid_593837
  var valid_593838 = query.getOrDefault("expireTime")
  valid_593838 = validateParameter(valid_593838, JInt, required = false, default = nil)
  if valid_593838 != nil:
    section.add "expireTime", valid_593838
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593861: Call_FileSystemSetFileExpiry_593646; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sets or removes the expiration time on the specified file. This operation can only be executed against files. Folders are not supported.
  ## 
  let valid = call_593861.validator(path, query, header, formData, body)
  let scheme = call_593861.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593861.url(scheme.get, call_593861.host, call_593861.base,
                         call_593861.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593861, url, valid)

proc call*(call_593932: Call_FileSystemSetFileExpiry_593646; apiVersion: string;
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
  var path_593933 = newJObject()
  var query_593935 = newJObject()
  add(query_593935, "api-version", newJString(apiVersion))
  add(path_593933, "path", newJString(path))
  add(query_593935, "op", newJString(op))
  add(query_593935, "expiryOption", newJString(expiryOption))
  add(query_593935, "expireTime", newJInt(expireTime))
  result = call_593932.call(path_593933, query_593935, nil, nil, nil)

var fileSystemSetFileExpiry* = Call_FileSystemSetFileExpiry_593646(
    name: "fileSystemSetFileExpiry", meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/WebHdfsExt/{path}", validator: validate_FileSystemSetFileExpiry_593647,
    base: "", url: url_FileSystemSetFileExpiry_593648, schemes: {Scheme.Https})
type
  Call_FileSystemConcurrentAppend_593974 = ref object of OpenApiRestCall_593424
proc url_FileSystemConcurrentAppend_593976(protocol: Scheme; host: string;
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

proc validate_FileSystemConcurrentAppend_593975(path: JsonNode; query: JsonNode;
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
  var valid_593977 = path.getOrDefault("path")
  valid_593977 = validateParameter(valid_593977, JString, required = true,
                                 default = nil)
  if valid_593977 != nil:
    section.add "path", valid_593977
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
  var valid_593978 = query.getOrDefault("api-version")
  valid_593978 = validateParameter(valid_593978, JString, required = true,
                                 default = nil)
  if valid_593978 != nil:
    section.add "api-version", valid_593978
  var valid_593979 = query.getOrDefault("syncFlag")
  valid_593979 = validateParameter(valid_593979, JString, required = false,
                                 default = newJString("DATA"))
  if valid_593979 != nil:
    section.add "syncFlag", valid_593979
  var valid_593980 = query.getOrDefault("op")
  valid_593980 = validateParameter(valid_593980, JString, required = true,
                                 default = newJString("CONCURRENTAPPEND"))
  if valid_593980 != nil:
    section.add "op", valid_593980
  var valid_593981 = query.getOrDefault("appendMode")
  valid_593981 = validateParameter(valid_593981, JString, required = false,
                                 default = newJString("autocreate"))
  if valid_593981 != nil:
    section.add "appendMode", valid_593981
  result.add "query", section
  ## parameters in `header` object:
  ##   Transfer-Encoding: JString (required)
  ##                    : Indicates the data being sent to the server is being streamed in chunks.
  section = newJObject()
  assert header != nil, "header argument is necessary due to required `Transfer-Encoding` field"
  var valid_593982 = header.getOrDefault("Transfer-Encoding")
  valid_593982 = validateParameter(valid_593982, JString, required = true,
                                 default = newJString("chunked"))
  if valid_593982 != nil:
    section.add "Transfer-Encoding", valid_593982
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

proc call*(call_593984: Call_FileSystemConcurrentAppend_593974; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Appends to the specified file, optionally first creating the file if it does not yet exist. This method supports multiple concurrent appends to the file. NOTE: The target must not contain data added by Create or normal (serial) Append. ConcurrentAppend and Append cannot be used interchangeably; once a target file has been modified using either of these append options, the other append option cannot be used on the target file. ConcurrentAppend does not guarantee order and can result in duplicated data landing in the target file.
  ## 
  let valid = call_593984.validator(path, query, header, formData, body)
  let scheme = call_593984.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593984.url(scheme.get, call_593984.host, call_593984.base,
                         call_593984.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593984, url, valid)

proc call*(call_593985: Call_FileSystemConcurrentAppend_593974; apiVersion: string;
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
  var path_593986 = newJObject()
  var query_593987 = newJObject()
  var body_593988 = newJObject()
  add(query_593987, "api-version", newJString(apiVersion))
  add(path_593986, "path", newJString(path))
  add(query_593987, "syncFlag", newJString(syncFlag))
  add(query_593987, "op", newJString(op))
  if streamContents != nil:
    body_593988 = streamContents
  add(query_593987, "appendMode", newJString(appendMode))
  result = call_593985.call(path_593986, query_593987, nil, nil, body_593988)

var fileSystemConcurrentAppend* = Call_FileSystemConcurrentAppend_593974(
    name: "fileSystemConcurrentAppend", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/WebHdfsExt/{path}",
    validator: validate_FileSystemConcurrentAppend_593975, base: "",
    url: url_FileSystemConcurrentAppend_593976, schemes: {Scheme.Https})
type
  Call_FileSystemCheckAccess_593989 = ref object of OpenApiRestCall_593424
proc url_FileSystemCheckAccess_593991(protocol: Scheme; host: string; base: string;
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

proc validate_FileSystemCheckAccess_593990(path: JsonNode; query: JsonNode;
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
  var valid_593992 = path.getOrDefault("path")
  valid_593992 = validateParameter(valid_593992, JString, required = true,
                                 default = nil)
  if valid_593992 != nil:
    section.add "path", valid_593992
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
  var valid_593993 = query.getOrDefault("api-version")
  valid_593993 = validateParameter(valid_593993, JString, required = true,
                                 default = nil)
  if valid_593993 != nil:
    section.add "api-version", valid_593993
  var valid_593994 = query.getOrDefault("op")
  valid_593994 = validateParameter(valid_593994, JString, required = true,
                                 default = newJString("CHECKACCESS"))
  if valid_593994 != nil:
    section.add "op", valid_593994
  var valid_593995 = query.getOrDefault("fsaction")
  valid_593995 = validateParameter(valid_593995, JString, required = true,
                                 default = nil)
  if valid_593995 != nil:
    section.add "fsaction", valid_593995
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593996: Call_FileSystemCheckAccess_593989; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks if the specified access is available at the given path.
  ## 
  let valid = call_593996.validator(path, query, header, formData, body)
  let scheme = call_593996.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593996.url(scheme.get, call_593996.host, call_593996.base,
                         call_593996.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593996, url, valid)

proc call*(call_593997: Call_FileSystemCheckAccess_593989; apiVersion: string;
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
  var path_593998 = newJObject()
  var query_593999 = newJObject()
  add(query_593999, "api-version", newJString(apiVersion))
  add(path_593998, "path", newJString(path))
  add(query_593999, "op", newJString(op))
  add(query_593999, "fsaction", newJString(fsaction))
  result = call_593997.call(path_593998, query_593999, nil, nil, nil)

var fileSystemCheckAccess* = Call_FileSystemCheckAccess_593989(
    name: "fileSystemCheckAccess", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/webhdfs/v1/{path}", validator: validate_FileSystemCheckAccess_593990,
    base: "", url: url_FileSystemCheckAccess_593991, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
