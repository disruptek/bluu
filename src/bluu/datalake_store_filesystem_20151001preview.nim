
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_593408 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593408](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593408): Option[Scheme] {.used.} =
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
  Call_FileSystemSetFileExpiry_593630 = ref object of OpenApiRestCall_593408
proc url_FileSystemSetFileExpiry_593632(protocol: Scheme; host: string; base: string;
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

proc validate_FileSystemSetFileExpiry_593631(path: JsonNode; query: JsonNode;
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
  var valid_593805 = path.getOrDefault("filePath")
  valid_593805 = validateParameter(valid_593805, JString, required = true,
                                 default = nil)
  if valid_593805 != nil:
    section.add "filePath", valid_593805
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
  var valid_593806 = query.getOrDefault("api-version")
  valid_593806 = validateParameter(valid_593806, JString, required = true,
                                 default = nil)
  if valid_593806 != nil:
    section.add "api-version", valid_593806
  var valid_593820 = query.getOrDefault("op")
  valid_593820 = validateParameter(valid_593820, JString, required = true,
                                 default = newJString("SETEXPIRY"))
  if valid_593820 != nil:
    section.add "op", valid_593820
  var valid_593821 = query.getOrDefault("expiryOption")
  valid_593821 = validateParameter(valid_593821, JString, required = true,
                                 default = newJString("NeverExpire"))
  if valid_593821 != nil:
    section.add "expiryOption", valid_593821
  var valid_593822 = query.getOrDefault("expireTime")
  valid_593822 = validateParameter(valid_593822, JInt, required = false, default = nil)
  if valid_593822 != nil:
    section.add "expireTime", valid_593822
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593845: Call_FileSystemSetFileExpiry_593630; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sets or removes the expiration time on the specified file. This operation can only be executed against files. Folders are not supported.
  ## 
  let valid = call_593845.validator(path, query, header, formData, body)
  let scheme = call_593845.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593845.url(scheme.get, call_593845.host, call_593845.base,
                         call_593845.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593845, url, valid)

proc call*(call_593916: Call_FileSystemSetFileExpiry_593630; apiVersion: string;
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
  var path_593917 = newJObject()
  var query_593919 = newJObject()
  add(query_593919, "api-version", newJString(apiVersion))
  add(path_593917, "filePath", newJString(filePath))
  add(query_593919, "op", newJString(op))
  add(query_593919, "expiryOption", newJString(expiryOption))
  add(query_593919, "expireTime", newJInt(expireTime))
  result = call_593916.call(path_593917, query_593919, nil, nil, nil)

var fileSystemSetFileExpiry* = Call_FileSystemSetFileExpiry_593630(
    name: "fileSystemSetFileExpiry", meth: HttpMethod.HttpPut, host: "azure.local",
    route: "/WebHdfsExt/{filePath}", validator: validate_FileSystemSetFileExpiry_593631,
    base: "", url: url_FileSystemSetFileExpiry_593632, schemes: {Scheme.Https})
type
  Call_FileSystemConcurrentAppend_593958 = ref object of OpenApiRestCall_593408
proc url_FileSystemConcurrentAppend_593960(protocol: Scheme; host: string;
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

proc validate_FileSystemConcurrentAppend_593959(path: JsonNode; query: JsonNode;
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
  var valid_593961 = path.getOrDefault("filePath")
  valid_593961 = validateParameter(valid_593961, JString, required = true,
                                 default = nil)
  if valid_593961 != nil:
    section.add "filePath", valid_593961
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
  var valid_593962 = query.getOrDefault("api-version")
  valid_593962 = validateParameter(valid_593962, JString, required = true,
                                 default = nil)
  if valid_593962 != nil:
    section.add "api-version", valid_593962
  var valid_593963 = query.getOrDefault("op")
  valid_593963 = validateParameter(valid_593963, JString, required = true,
                                 default = newJString("CONCURRENTAPPEND"))
  if valid_593963 != nil:
    section.add "op", valid_593963
  var valid_593964 = query.getOrDefault("appendMode")
  valid_593964 = validateParameter(valid_593964, JString, required = false,
                                 default = newJString("autocreate"))
  if valid_593964 != nil:
    section.add "appendMode", valid_593964
  result.add "query", section
  ## parameters in `header` object:
  ##   Transfer-Encoding: JString (required)
  ##                    : Indicates the data being sent to the server is being streamed in chunks.
  section = newJObject()
  assert header != nil, "header argument is necessary due to required `Transfer-Encoding` field"
  var valid_593965 = header.getOrDefault("Transfer-Encoding")
  valid_593965 = validateParameter(valid_593965, JString, required = true,
                                 default = newJString("chunked"))
  if valid_593965 != nil:
    section.add "Transfer-Encoding", valid_593965
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

proc call*(call_593967: Call_FileSystemConcurrentAppend_593958; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Appends to the specified file. This method supports multiple concurrent appends to the file. NOTE: ConcurrentAppend and normal (serial) Append CANNOT be used interchangeably; once a file has been appended to using either of these append options, it can only be appended to using that append option. ConcurrentAppend DOES NOT guarantee order and can result in duplicated data landing in the target file. In order to close a file after using ConcurrentAppend, call the Flush method.
  ## 
  let valid = call_593967.validator(path, query, header, formData, body)
  let scheme = call_593967.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593967.url(scheme.get, call_593967.host, call_593967.base,
                         call_593967.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593967, url, valid)

proc call*(call_593968: Call_FileSystemConcurrentAppend_593958; apiVersion: string;
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
  var path_593969 = newJObject()
  var query_593970 = newJObject()
  var body_593971 = newJObject()
  add(query_593970, "api-version", newJString(apiVersion))
  add(path_593969, "filePath", newJString(filePath))
  add(query_593970, "op", newJString(op))
  if streamContents != nil:
    body_593971 = streamContents
  add(query_593970, "appendMode", newJString(appendMode))
  result = call_593968.call(path_593969, query_593970, nil, nil, body_593971)

var fileSystemConcurrentAppend* = Call_FileSystemConcurrentAppend_593958(
    name: "fileSystemConcurrentAppend", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/WebHdfsExt/{filePath}",
    validator: validate_FileSystemConcurrentAppend_593959, base: "",
    url: url_FileSystemConcurrentAppend_593960, schemes: {Scheme.Https})
type
  Call_FileSystemMkdirs_593983 = ref object of OpenApiRestCall_593408
proc url_FileSystemMkdirs_593985(protocol: Scheme; host: string; base: string;
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

proc validate_FileSystemMkdirs_593984(path: JsonNode; query: JsonNode;
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
  var valid_593986 = path.getOrDefault("path")
  valid_593986 = validateParameter(valid_593986, JString, required = true,
                                 default = nil)
  if valid_593986 != nil:
    section.add "path", valid_593986
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   op: JString (required)
  ##     : The constant value for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593987 = query.getOrDefault("api-version")
  valid_593987 = validateParameter(valid_593987, JString, required = true,
                                 default = nil)
  if valid_593987 != nil:
    section.add "api-version", valid_593987
  var valid_593988 = query.getOrDefault("op")
  valid_593988 = validateParameter(valid_593988, JString, required = true,
                                 default = newJString("MKDIRS"))
  if valid_593988 != nil:
    section.add "op", valid_593988
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593989: Call_FileSystemMkdirs_593983; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a directory.
  ## 
  let valid = call_593989.validator(path, query, header, formData, body)
  let scheme = call_593989.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593989.url(scheme.get, call_593989.host, call_593989.base,
                         call_593989.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593989, url, valid)

proc call*(call_593990: Call_FileSystemMkdirs_593983; apiVersion: string;
          path: string; op: string = "MKDIRS"): Recallable =
  ## fileSystemMkdirs
  ## Creates a directory.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   path: string (required)
  ##       : The Data Lake Store path (starting with '/') of the directory to create.
  ##   op: string (required)
  ##     : The constant value for the operation.
  var path_593991 = newJObject()
  var query_593992 = newJObject()
  add(query_593992, "api-version", newJString(apiVersion))
  add(path_593991, "path", newJString(path))
  add(query_593992, "op", newJString(op))
  result = call_593990.call(path_593991, query_593992, nil, nil, nil)

var fileSystemMkdirs* = Call_FileSystemMkdirs_593983(name: "fileSystemMkdirs",
    meth: HttpMethod.HttpPut, host: "azure.local", route: "/webhdfs/v1/{path}",
    validator: validate_FileSystemMkdirs_593984, base: "",
    url: url_FileSystemMkdirs_593985, schemes: {Scheme.Https})
type
  Call_FileSystemCheckAccess_593972 = ref object of OpenApiRestCall_593408
proc url_FileSystemCheckAccess_593974(protocol: Scheme; host: string; base: string;
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

proc validate_FileSystemCheckAccess_593973(path: JsonNode; query: JsonNode;
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
  var valid_593975 = path.getOrDefault("path")
  valid_593975 = validateParameter(valid_593975, JString, required = true,
                                 default = nil)
  if valid_593975 != nil:
    section.add "path", valid_593975
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
  var valid_593976 = query.getOrDefault("api-version")
  valid_593976 = validateParameter(valid_593976, JString, required = true,
                                 default = nil)
  if valid_593976 != nil:
    section.add "api-version", valid_593976
  var valid_593977 = query.getOrDefault("op")
  valid_593977 = validateParameter(valid_593977, JString, required = true,
                                 default = newJString("CHECKACCESS"))
  if valid_593977 != nil:
    section.add "op", valid_593977
  var valid_593978 = query.getOrDefault("fsaction")
  valid_593978 = validateParameter(valid_593978, JString, required = false,
                                 default = nil)
  if valid_593978 != nil:
    section.add "fsaction", valid_593978
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593979: Call_FileSystemCheckAccess_593972; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks if the specified access is available at the given path.
  ## 
  let valid = call_593979.validator(path, query, header, formData, body)
  let scheme = call_593979.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593979.url(scheme.get, call_593979.host, call_593979.base,
                         call_593979.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593979, url, valid)

proc call*(call_593980: Call_FileSystemCheckAccess_593972; apiVersion: string;
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
  var path_593981 = newJObject()
  var query_593982 = newJObject()
  add(query_593982, "api-version", newJString(apiVersion))
  add(path_593981, "path", newJString(path))
  add(query_593982, "op", newJString(op))
  add(query_593982, "fsaction", newJString(fsaction))
  result = call_593980.call(path_593981, query_593982, nil, nil, nil)

var fileSystemCheckAccess* = Call_FileSystemCheckAccess_593972(
    name: "fileSystemCheckAccess", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/webhdfs/v1/{path}", validator: validate_FileSystemCheckAccess_593973,
    base: "", url: url_FileSystemCheckAccess_593974, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
