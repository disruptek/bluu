
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: StorageManagementClient
## version: 2019-04-01
## termsOfService: (not provided)
## license: (not provided)
## 
## The Azure Storage Management API.
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
  macServiceName = "storage-blob"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_BlobServicesList_567880 = ref object of OpenApiRestCall_567658
proc url_BlobServicesList_567882(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Storage/storageAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/blobServices")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BlobServicesList_567881(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## List blob services of storage account. It returns a collection of one object named default.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   accountName: JString (required)
  ##              : The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568042 = path.getOrDefault("resourceGroupName")
  valid_568042 = validateParameter(valid_568042, JString, required = true,
                                 default = nil)
  if valid_568042 != nil:
    section.add "resourceGroupName", valid_568042
  var valid_568043 = path.getOrDefault("subscriptionId")
  valid_568043 = validateParameter(valid_568043, JString, required = true,
                                 default = nil)
  if valid_568043 != nil:
    section.add "subscriptionId", valid_568043
  var valid_568044 = path.getOrDefault("accountName")
  valid_568044 = validateParameter(valid_568044, JString, required = true,
                                 default = nil)
  if valid_568044 != nil:
    section.add "accountName", valid_568044
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568045 = query.getOrDefault("api-version")
  valid_568045 = validateParameter(valid_568045, JString, required = true,
                                 default = nil)
  if valid_568045 != nil:
    section.add "api-version", valid_568045
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568072: Call_BlobServicesList_567880; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List blob services of storage account. It returns a collection of one object named default.
  ## 
  let valid = call_568072.validator(path, query, header, formData, body)
  let scheme = call_568072.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568072.url(scheme.get, call_568072.host, call_568072.base,
                         call_568072.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568072, url, valid)

proc call*(call_568143: Call_BlobServicesList_567880; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; accountName: string): Recallable =
  ## blobServicesList
  ## List blob services of storage account. It returns a collection of one object named default.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   accountName: string (required)
  ##              : The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
  var path_568144 = newJObject()
  var query_568146 = newJObject()
  add(path_568144, "resourceGroupName", newJString(resourceGroupName))
  add(query_568146, "api-version", newJString(apiVersion))
  add(path_568144, "subscriptionId", newJString(subscriptionId))
  add(path_568144, "accountName", newJString(accountName))
  result = call_568143.call(path_568144, query_568146, nil, nil, nil)

var blobServicesList* = Call_BlobServicesList_567880(name: "blobServicesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{accountName}/blobServices",
    validator: validate_BlobServicesList_567881, base: "",
    url: url_BlobServicesList_567882, schemes: {Scheme.Https})
type
  Call_BlobContainersList_568185 = ref object of OpenApiRestCall_567658
proc url_BlobContainersList_568187(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Storage/storageAccounts/"),
               (kind: VariableSegment, value: "accountName"), (
        kind: ConstantSegment, value: "/blobServices/default/containers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BlobContainersList_568186(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Lists all containers and does not support a prefix like data plane. Also SRP today does not return continuation token.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   accountName: JString (required)
  ##              : The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568189 = path.getOrDefault("resourceGroupName")
  valid_568189 = validateParameter(valid_568189, JString, required = true,
                                 default = nil)
  if valid_568189 != nil:
    section.add "resourceGroupName", valid_568189
  var valid_568190 = path.getOrDefault("subscriptionId")
  valid_568190 = validateParameter(valid_568190, JString, required = true,
                                 default = nil)
  if valid_568190 != nil:
    section.add "subscriptionId", valid_568190
  var valid_568191 = path.getOrDefault("accountName")
  valid_568191 = validateParameter(valid_568191, JString, required = true,
                                 default = nil)
  if valid_568191 != nil:
    section.add "accountName", valid_568191
  result.add "path", section
  ## parameters in `query` object:
  ##   $maxpagesize: JString
  ##               : Optional. Specified maximum number of containers that can be included in the list.
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   $skipToken: JString
  ##             : Optional. Continuation token for the list operation.
  ##   $filter: JString
  ##          : Optional. When specified, only container names starting with the filter will be listed.
  section = newJObject()
  var valid_568192 = query.getOrDefault("$maxpagesize")
  valid_568192 = validateParameter(valid_568192, JString, required = false,
                                 default = nil)
  if valid_568192 != nil:
    section.add "$maxpagesize", valid_568192
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568193 = query.getOrDefault("api-version")
  valid_568193 = validateParameter(valid_568193, JString, required = true,
                                 default = nil)
  if valid_568193 != nil:
    section.add "api-version", valid_568193
  var valid_568194 = query.getOrDefault("$skipToken")
  valid_568194 = validateParameter(valid_568194, JString, required = false,
                                 default = nil)
  if valid_568194 != nil:
    section.add "$skipToken", valid_568194
  var valid_568195 = query.getOrDefault("$filter")
  valid_568195 = validateParameter(valid_568195, JString, required = false,
                                 default = nil)
  if valid_568195 != nil:
    section.add "$filter", valid_568195
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568196: Call_BlobContainersList_568185; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all containers and does not support a prefix like data plane. Also SRP today does not return continuation token.
  ## 
  let valid = call_568196.validator(path, query, header, formData, body)
  let scheme = call_568196.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568196.url(scheme.get, call_568196.host, call_568196.base,
                         call_568196.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568196, url, valid)

proc call*(call_568197: Call_BlobContainersList_568185; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; accountName: string;
          Maxpagesize: string = ""; SkipToken: string = ""; Filter: string = ""): Recallable =
  ## blobContainersList
  ## Lists all containers and does not support a prefix like data plane. Also SRP today does not return continuation token.
  ##   Maxpagesize: string
  ##              : Optional. Specified maximum number of containers that can be included in the list.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   SkipToken: string
  ##            : Optional. Continuation token for the list operation.
  ##   accountName: string (required)
  ##              : The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
  ##   Filter: string
  ##         : Optional. When specified, only container names starting with the filter will be listed.
  var path_568198 = newJObject()
  var query_568199 = newJObject()
  add(query_568199, "$maxpagesize", newJString(Maxpagesize))
  add(path_568198, "resourceGroupName", newJString(resourceGroupName))
  add(query_568199, "api-version", newJString(apiVersion))
  add(path_568198, "subscriptionId", newJString(subscriptionId))
  add(query_568199, "$skipToken", newJString(SkipToken))
  add(path_568198, "accountName", newJString(accountName))
  add(query_568199, "$filter", newJString(Filter))
  result = call_568197.call(path_568198, query_568199, nil, nil, nil)

var blobContainersList* = Call_BlobContainersList_568185(
    name: "blobContainersList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{accountName}/blobServices/default/containers",
    validator: validate_BlobContainersList_568186, base: "",
    url: url_BlobContainersList_568187, schemes: {Scheme.Https})
type
  Call_BlobContainersCreate_568221 = ref object of OpenApiRestCall_567658
proc url_BlobContainersCreate_568223(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "containerName" in path, "`containerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Storage/storageAccounts/"),
               (kind: VariableSegment, value: "accountName"), (
        kind: ConstantSegment, value: "/blobServices/default/containers/"),
               (kind: VariableSegment, value: "containerName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BlobContainersCreate_568222(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new container under the specified account as described by request body. The container resource includes metadata and properties for that container. It does not include a list of the blobs contained by the container. 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   containerName: JString (required)
  ##                : The name of the blob container within the specified storage account. Blob container names must be between 3 and 63 characters in length and use numbers, lower-case letters and dash (-) only. Every dash (-) character must be immediately preceded and followed by a letter or number.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   accountName: JString (required)
  ##              : The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568241 = path.getOrDefault("resourceGroupName")
  valid_568241 = validateParameter(valid_568241, JString, required = true,
                                 default = nil)
  if valid_568241 != nil:
    section.add "resourceGroupName", valid_568241
  var valid_568242 = path.getOrDefault("containerName")
  valid_568242 = validateParameter(valid_568242, JString, required = true,
                                 default = nil)
  if valid_568242 != nil:
    section.add "containerName", valid_568242
  var valid_568243 = path.getOrDefault("subscriptionId")
  valid_568243 = validateParameter(valid_568243, JString, required = true,
                                 default = nil)
  if valid_568243 != nil:
    section.add "subscriptionId", valid_568243
  var valid_568244 = path.getOrDefault("accountName")
  valid_568244 = validateParameter(valid_568244, JString, required = true,
                                 default = nil)
  if valid_568244 != nil:
    section.add "accountName", valid_568244
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568245 = query.getOrDefault("api-version")
  valid_568245 = validateParameter(valid_568245, JString, required = true,
                                 default = nil)
  if valid_568245 != nil:
    section.add "api-version", valid_568245
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   blobContainer: JObject (required)
  ##                : Properties of the blob container to create.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568247: Call_BlobContainersCreate_568221; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new container under the specified account as described by request body. The container resource includes metadata and properties for that container. It does not include a list of the blobs contained by the container. 
  ## 
  let valid = call_568247.validator(path, query, header, formData, body)
  let scheme = call_568247.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568247.url(scheme.get, call_568247.host, call_568247.base,
                         call_568247.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568247, url, valid)

proc call*(call_568248: Call_BlobContainersCreate_568221;
          resourceGroupName: string; apiVersion: string; blobContainer: JsonNode;
          containerName: string; subscriptionId: string; accountName: string): Recallable =
  ## blobContainersCreate
  ## Creates a new container under the specified account as described by request body. The container resource includes metadata and properties for that container. It does not include a list of the blobs contained by the container. 
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   blobContainer: JObject (required)
  ##                : Properties of the blob container to create.
  ##   containerName: string (required)
  ##                : The name of the blob container within the specified storage account. Blob container names must be between 3 and 63 characters in length and use numbers, lower-case letters and dash (-) only. Every dash (-) character must be immediately preceded and followed by a letter or number.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   accountName: string (required)
  ##              : The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
  var path_568249 = newJObject()
  var query_568250 = newJObject()
  var body_568251 = newJObject()
  add(path_568249, "resourceGroupName", newJString(resourceGroupName))
  add(query_568250, "api-version", newJString(apiVersion))
  if blobContainer != nil:
    body_568251 = blobContainer
  add(path_568249, "containerName", newJString(containerName))
  add(path_568249, "subscriptionId", newJString(subscriptionId))
  add(path_568249, "accountName", newJString(accountName))
  result = call_568248.call(path_568249, query_568250, nil, nil, body_568251)

var blobContainersCreate* = Call_BlobContainersCreate_568221(
    name: "blobContainersCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{accountName}/blobServices/default/containers/{containerName}",
    validator: validate_BlobContainersCreate_568222, base: "",
    url: url_BlobContainersCreate_568223, schemes: {Scheme.Https})
type
  Call_BlobContainersGet_568200 = ref object of OpenApiRestCall_567658
proc url_BlobContainersGet_568202(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "containerName" in path, "`containerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Storage/storageAccounts/"),
               (kind: VariableSegment, value: "accountName"), (
        kind: ConstantSegment, value: "/blobServices/default/containers/"),
               (kind: VariableSegment, value: "containerName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BlobContainersGet_568201(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Gets properties of a specified container. 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   containerName: JString (required)
  ##                : The name of the blob container within the specified storage account. Blob container names must be between 3 and 63 characters in length and use numbers, lower-case letters and dash (-) only. Every dash (-) character must be immediately preceded and followed by a letter or number.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   accountName: JString (required)
  ##              : The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568212 = path.getOrDefault("resourceGroupName")
  valid_568212 = validateParameter(valid_568212, JString, required = true,
                                 default = nil)
  if valid_568212 != nil:
    section.add "resourceGroupName", valid_568212
  var valid_568213 = path.getOrDefault("containerName")
  valid_568213 = validateParameter(valid_568213, JString, required = true,
                                 default = nil)
  if valid_568213 != nil:
    section.add "containerName", valid_568213
  var valid_568214 = path.getOrDefault("subscriptionId")
  valid_568214 = validateParameter(valid_568214, JString, required = true,
                                 default = nil)
  if valid_568214 != nil:
    section.add "subscriptionId", valid_568214
  var valid_568215 = path.getOrDefault("accountName")
  valid_568215 = validateParameter(valid_568215, JString, required = true,
                                 default = nil)
  if valid_568215 != nil:
    section.add "accountName", valid_568215
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568216 = query.getOrDefault("api-version")
  valid_568216 = validateParameter(valid_568216, JString, required = true,
                                 default = nil)
  if valid_568216 != nil:
    section.add "api-version", valid_568216
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568217: Call_BlobContainersGet_568200; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets properties of a specified container. 
  ## 
  let valid = call_568217.validator(path, query, header, formData, body)
  let scheme = call_568217.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568217.url(scheme.get, call_568217.host, call_568217.base,
                         call_568217.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568217, url, valid)

proc call*(call_568218: Call_BlobContainersGet_568200; resourceGroupName: string;
          apiVersion: string; containerName: string; subscriptionId: string;
          accountName: string): Recallable =
  ## blobContainersGet
  ## Gets properties of a specified container. 
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   containerName: string (required)
  ##                : The name of the blob container within the specified storage account. Blob container names must be between 3 and 63 characters in length and use numbers, lower-case letters and dash (-) only. Every dash (-) character must be immediately preceded and followed by a letter or number.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   accountName: string (required)
  ##              : The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
  var path_568219 = newJObject()
  var query_568220 = newJObject()
  add(path_568219, "resourceGroupName", newJString(resourceGroupName))
  add(query_568220, "api-version", newJString(apiVersion))
  add(path_568219, "containerName", newJString(containerName))
  add(path_568219, "subscriptionId", newJString(subscriptionId))
  add(path_568219, "accountName", newJString(accountName))
  result = call_568218.call(path_568219, query_568220, nil, nil, nil)

var blobContainersGet* = Call_BlobContainersGet_568200(name: "blobContainersGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{accountName}/blobServices/default/containers/{containerName}",
    validator: validate_BlobContainersGet_568201, base: "",
    url: url_BlobContainersGet_568202, schemes: {Scheme.Https})
type
  Call_BlobContainersUpdate_568264 = ref object of OpenApiRestCall_567658
proc url_BlobContainersUpdate_568266(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "containerName" in path, "`containerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Storage/storageAccounts/"),
               (kind: VariableSegment, value: "accountName"), (
        kind: ConstantSegment, value: "/blobServices/default/containers/"),
               (kind: VariableSegment, value: "containerName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BlobContainersUpdate_568265(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates container properties as specified in request body. Properties not mentioned in the request will be unchanged. Update fails if the specified container doesn't already exist. 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   containerName: JString (required)
  ##                : The name of the blob container within the specified storage account. Blob container names must be between 3 and 63 characters in length and use numbers, lower-case letters and dash (-) only. Every dash (-) character must be immediately preceded and followed by a letter or number.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   accountName: JString (required)
  ##              : The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568267 = path.getOrDefault("resourceGroupName")
  valid_568267 = validateParameter(valid_568267, JString, required = true,
                                 default = nil)
  if valid_568267 != nil:
    section.add "resourceGroupName", valid_568267
  var valid_568268 = path.getOrDefault("containerName")
  valid_568268 = validateParameter(valid_568268, JString, required = true,
                                 default = nil)
  if valid_568268 != nil:
    section.add "containerName", valid_568268
  var valid_568269 = path.getOrDefault("subscriptionId")
  valid_568269 = validateParameter(valid_568269, JString, required = true,
                                 default = nil)
  if valid_568269 != nil:
    section.add "subscriptionId", valid_568269
  var valid_568270 = path.getOrDefault("accountName")
  valid_568270 = validateParameter(valid_568270, JString, required = true,
                                 default = nil)
  if valid_568270 != nil:
    section.add "accountName", valid_568270
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568271 = query.getOrDefault("api-version")
  valid_568271 = validateParameter(valid_568271, JString, required = true,
                                 default = nil)
  if valid_568271 != nil:
    section.add "api-version", valid_568271
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   blobContainer: JObject (required)
  ##                : Properties to update for the blob container.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568273: Call_BlobContainersUpdate_568264; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates container properties as specified in request body. Properties not mentioned in the request will be unchanged. Update fails if the specified container doesn't already exist. 
  ## 
  let valid = call_568273.validator(path, query, header, formData, body)
  let scheme = call_568273.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568273.url(scheme.get, call_568273.host, call_568273.base,
                         call_568273.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568273, url, valid)

proc call*(call_568274: Call_BlobContainersUpdate_568264;
          resourceGroupName: string; apiVersion: string; blobContainer: JsonNode;
          containerName: string; subscriptionId: string; accountName: string): Recallable =
  ## blobContainersUpdate
  ## Updates container properties as specified in request body. Properties not mentioned in the request will be unchanged. Update fails if the specified container doesn't already exist. 
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   blobContainer: JObject (required)
  ##                : Properties to update for the blob container.
  ##   containerName: string (required)
  ##                : The name of the blob container within the specified storage account. Blob container names must be between 3 and 63 characters in length and use numbers, lower-case letters and dash (-) only. Every dash (-) character must be immediately preceded and followed by a letter or number.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   accountName: string (required)
  ##              : The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
  var path_568275 = newJObject()
  var query_568276 = newJObject()
  var body_568277 = newJObject()
  add(path_568275, "resourceGroupName", newJString(resourceGroupName))
  add(query_568276, "api-version", newJString(apiVersion))
  if blobContainer != nil:
    body_568277 = blobContainer
  add(path_568275, "containerName", newJString(containerName))
  add(path_568275, "subscriptionId", newJString(subscriptionId))
  add(path_568275, "accountName", newJString(accountName))
  result = call_568274.call(path_568275, query_568276, nil, nil, body_568277)

var blobContainersUpdate* = Call_BlobContainersUpdate_568264(
    name: "blobContainersUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{accountName}/blobServices/default/containers/{containerName}",
    validator: validate_BlobContainersUpdate_568265, base: "",
    url: url_BlobContainersUpdate_568266, schemes: {Scheme.Https})
type
  Call_BlobContainersDelete_568252 = ref object of OpenApiRestCall_567658
proc url_BlobContainersDelete_568254(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "containerName" in path, "`containerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Storage/storageAccounts/"),
               (kind: VariableSegment, value: "accountName"), (
        kind: ConstantSegment, value: "/blobServices/default/containers/"),
               (kind: VariableSegment, value: "containerName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BlobContainersDelete_568253(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes specified container under its account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   containerName: JString (required)
  ##                : The name of the blob container within the specified storage account. Blob container names must be between 3 and 63 characters in length and use numbers, lower-case letters and dash (-) only. Every dash (-) character must be immediately preceded and followed by a letter or number.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   accountName: JString (required)
  ##              : The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568255 = path.getOrDefault("resourceGroupName")
  valid_568255 = validateParameter(valid_568255, JString, required = true,
                                 default = nil)
  if valid_568255 != nil:
    section.add "resourceGroupName", valid_568255
  var valid_568256 = path.getOrDefault("containerName")
  valid_568256 = validateParameter(valid_568256, JString, required = true,
                                 default = nil)
  if valid_568256 != nil:
    section.add "containerName", valid_568256
  var valid_568257 = path.getOrDefault("subscriptionId")
  valid_568257 = validateParameter(valid_568257, JString, required = true,
                                 default = nil)
  if valid_568257 != nil:
    section.add "subscriptionId", valid_568257
  var valid_568258 = path.getOrDefault("accountName")
  valid_568258 = validateParameter(valid_568258, JString, required = true,
                                 default = nil)
  if valid_568258 != nil:
    section.add "accountName", valid_568258
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568259 = query.getOrDefault("api-version")
  valid_568259 = validateParameter(valid_568259, JString, required = true,
                                 default = nil)
  if valid_568259 != nil:
    section.add "api-version", valid_568259
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568260: Call_BlobContainersDelete_568252; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes specified container under its account.
  ## 
  let valid = call_568260.validator(path, query, header, formData, body)
  let scheme = call_568260.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568260.url(scheme.get, call_568260.host, call_568260.base,
                         call_568260.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568260, url, valid)

proc call*(call_568261: Call_BlobContainersDelete_568252;
          resourceGroupName: string; apiVersion: string; containerName: string;
          subscriptionId: string; accountName: string): Recallable =
  ## blobContainersDelete
  ## Deletes specified container under its account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   containerName: string (required)
  ##                : The name of the blob container within the specified storage account. Blob container names must be between 3 and 63 characters in length and use numbers, lower-case letters and dash (-) only. Every dash (-) character must be immediately preceded and followed by a letter or number.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   accountName: string (required)
  ##              : The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
  var path_568262 = newJObject()
  var query_568263 = newJObject()
  add(path_568262, "resourceGroupName", newJString(resourceGroupName))
  add(query_568263, "api-version", newJString(apiVersion))
  add(path_568262, "containerName", newJString(containerName))
  add(path_568262, "subscriptionId", newJString(subscriptionId))
  add(path_568262, "accountName", newJString(accountName))
  result = call_568261.call(path_568262, query_568263, nil, nil, nil)

var blobContainersDelete* = Call_BlobContainersDelete_568252(
    name: "blobContainersDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{accountName}/blobServices/default/containers/{containerName}",
    validator: validate_BlobContainersDelete_568253, base: "",
    url: url_BlobContainersDelete_568254, schemes: {Scheme.Https})
type
  Call_BlobContainersClearLegalHold_568278 = ref object of OpenApiRestCall_567658
proc url_BlobContainersClearLegalHold_568280(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "containerName" in path, "`containerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Storage/storageAccounts/"),
               (kind: VariableSegment, value: "accountName"), (
        kind: ConstantSegment, value: "/blobServices/default/containers/"),
               (kind: VariableSegment, value: "containerName"),
               (kind: ConstantSegment, value: "/clearLegalHold")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BlobContainersClearLegalHold_568279(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Clears legal hold tags. Clearing the same or non-existent tag results in an idempotent operation. ClearLegalHold clears out only the specified tags in the request.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   containerName: JString (required)
  ##                : The name of the blob container within the specified storage account. Blob container names must be between 3 and 63 characters in length and use numbers, lower-case letters and dash (-) only. Every dash (-) character must be immediately preceded and followed by a letter or number.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   accountName: JString (required)
  ##              : The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568291 = path.getOrDefault("resourceGroupName")
  valid_568291 = validateParameter(valid_568291, JString, required = true,
                                 default = nil)
  if valid_568291 != nil:
    section.add "resourceGroupName", valid_568291
  var valid_568292 = path.getOrDefault("containerName")
  valid_568292 = validateParameter(valid_568292, JString, required = true,
                                 default = nil)
  if valid_568292 != nil:
    section.add "containerName", valid_568292
  var valid_568293 = path.getOrDefault("subscriptionId")
  valid_568293 = validateParameter(valid_568293, JString, required = true,
                                 default = nil)
  if valid_568293 != nil:
    section.add "subscriptionId", valid_568293
  var valid_568294 = path.getOrDefault("accountName")
  valid_568294 = validateParameter(valid_568294, JString, required = true,
                                 default = nil)
  if valid_568294 != nil:
    section.add "accountName", valid_568294
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568295 = query.getOrDefault("api-version")
  valid_568295 = validateParameter(valid_568295, JString, required = true,
                                 default = nil)
  if valid_568295 != nil:
    section.add "api-version", valid_568295
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   LegalHold: JObject (required)
  ##            : The LegalHold property that will be clear from a blob container.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568297: Call_BlobContainersClearLegalHold_568278; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Clears legal hold tags. Clearing the same or non-existent tag results in an idempotent operation. ClearLegalHold clears out only the specified tags in the request.
  ## 
  let valid = call_568297.validator(path, query, header, formData, body)
  let scheme = call_568297.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568297.url(scheme.get, call_568297.host, call_568297.base,
                         call_568297.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568297, url, valid)

proc call*(call_568298: Call_BlobContainersClearLegalHold_568278;
          resourceGroupName: string; apiVersion: string; containerName: string;
          LegalHold: JsonNode; subscriptionId: string; accountName: string): Recallable =
  ## blobContainersClearLegalHold
  ## Clears legal hold tags. Clearing the same or non-existent tag results in an idempotent operation. ClearLegalHold clears out only the specified tags in the request.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   containerName: string (required)
  ##                : The name of the blob container within the specified storage account. Blob container names must be between 3 and 63 characters in length and use numbers, lower-case letters and dash (-) only. Every dash (-) character must be immediately preceded and followed by a letter or number.
  ##   LegalHold: JObject (required)
  ##            : The LegalHold property that will be clear from a blob container.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   accountName: string (required)
  ##              : The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
  var path_568299 = newJObject()
  var query_568300 = newJObject()
  var body_568301 = newJObject()
  add(path_568299, "resourceGroupName", newJString(resourceGroupName))
  add(query_568300, "api-version", newJString(apiVersion))
  add(path_568299, "containerName", newJString(containerName))
  if LegalHold != nil:
    body_568301 = LegalHold
  add(path_568299, "subscriptionId", newJString(subscriptionId))
  add(path_568299, "accountName", newJString(accountName))
  result = call_568298.call(path_568299, query_568300, nil, nil, body_568301)

var blobContainersClearLegalHold* = Call_BlobContainersClearLegalHold_568278(
    name: "blobContainersClearLegalHold", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{accountName}/blobServices/default/containers/{containerName}/clearLegalHold",
    validator: validate_BlobContainersClearLegalHold_568279, base: "",
    url: url_BlobContainersClearLegalHold_568280, schemes: {Scheme.Https})
type
  Call_BlobContainersExtendImmutabilityPolicy_568302 = ref object of OpenApiRestCall_567658
proc url_BlobContainersExtendImmutabilityPolicy_568304(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "containerName" in path, "`containerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Storage/storageAccounts/"),
               (kind: VariableSegment, value: "accountName"), (
        kind: ConstantSegment, value: "/blobServices/default/containers/"),
               (kind: VariableSegment, value: "containerName"), (
        kind: ConstantSegment, value: "/immutabilityPolicies/default/extend")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BlobContainersExtendImmutabilityPolicy_568303(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Extends the immutabilityPeriodSinceCreationInDays of a locked immutabilityPolicy. The only action allowed on a Locked policy will be this action. ETag in If-Match is required for this operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   containerName: JString (required)
  ##                : The name of the blob container within the specified storage account. Blob container names must be between 3 and 63 characters in length and use numbers, lower-case letters and dash (-) only. Every dash (-) character must be immediately preceded and followed by a letter or number.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   accountName: JString (required)
  ##              : The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568305 = path.getOrDefault("resourceGroupName")
  valid_568305 = validateParameter(valid_568305, JString, required = true,
                                 default = nil)
  if valid_568305 != nil:
    section.add "resourceGroupName", valid_568305
  var valid_568306 = path.getOrDefault("containerName")
  valid_568306 = validateParameter(valid_568306, JString, required = true,
                                 default = nil)
  if valid_568306 != nil:
    section.add "containerName", valid_568306
  var valid_568307 = path.getOrDefault("subscriptionId")
  valid_568307 = validateParameter(valid_568307, JString, required = true,
                                 default = nil)
  if valid_568307 != nil:
    section.add "subscriptionId", valid_568307
  var valid_568308 = path.getOrDefault("accountName")
  valid_568308 = validateParameter(valid_568308, JString, required = true,
                                 default = nil)
  if valid_568308 != nil:
    section.add "accountName", valid_568308
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568309 = query.getOrDefault("api-version")
  valid_568309 = validateParameter(valid_568309, JString, required = true,
                                 default = nil)
  if valid_568309 != nil:
    section.add "api-version", valid_568309
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : The entity state (ETag) version of the immutability policy to update. A value of "*" can be used to apply the operation only if the immutability policy already exists. If omitted, this operation will always be applied.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_568310 = header.getOrDefault("If-Match")
  valid_568310 = validateParameter(valid_568310, JString, required = true,
                                 default = nil)
  if valid_568310 != nil:
    section.add "If-Match", valid_568310
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject
  ##             : The ImmutabilityPolicy Properties that will be extended for a blob container.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568312: Call_BlobContainersExtendImmutabilityPolicy_568302;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Extends the immutabilityPeriodSinceCreationInDays of a locked immutabilityPolicy. The only action allowed on a Locked policy will be this action. ETag in If-Match is required for this operation.
  ## 
  let valid = call_568312.validator(path, query, header, formData, body)
  let scheme = call_568312.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568312.url(scheme.get, call_568312.host, call_568312.base,
                         call_568312.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568312, url, valid)

proc call*(call_568313: Call_BlobContainersExtendImmutabilityPolicy_568302;
          resourceGroupName: string; apiVersion: string; containerName: string;
          subscriptionId: string; accountName: string; parameters: JsonNode = nil): Recallable =
  ## blobContainersExtendImmutabilityPolicy
  ## Extends the immutabilityPeriodSinceCreationInDays of a locked immutabilityPolicy. The only action allowed on a Locked policy will be this action. ETag in If-Match is required for this operation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   containerName: string (required)
  ##                : The name of the blob container within the specified storage account. Blob container names must be between 3 and 63 characters in length and use numbers, lower-case letters and dash (-) only. Every dash (-) character must be immediately preceded and followed by a letter or number.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   parameters: JObject
  ##             : The ImmutabilityPolicy Properties that will be extended for a blob container.
  ##   accountName: string (required)
  ##              : The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
  var path_568314 = newJObject()
  var query_568315 = newJObject()
  var body_568316 = newJObject()
  add(path_568314, "resourceGroupName", newJString(resourceGroupName))
  add(query_568315, "api-version", newJString(apiVersion))
  add(path_568314, "containerName", newJString(containerName))
  add(path_568314, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568316 = parameters
  add(path_568314, "accountName", newJString(accountName))
  result = call_568313.call(path_568314, query_568315, nil, nil, body_568316)

var blobContainersExtendImmutabilityPolicy* = Call_BlobContainersExtendImmutabilityPolicy_568302(
    name: "blobContainersExtendImmutabilityPolicy", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{accountName}/blobServices/default/containers/{containerName}/immutabilityPolicies/default/extend",
    validator: validate_BlobContainersExtendImmutabilityPolicy_568303, base: "",
    url: url_BlobContainersExtendImmutabilityPolicy_568304,
    schemes: {Scheme.Https})
type
  Call_BlobContainersLockImmutabilityPolicy_568317 = ref object of OpenApiRestCall_567658
proc url_BlobContainersLockImmutabilityPolicy_568319(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "containerName" in path, "`containerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Storage/storageAccounts/"),
               (kind: VariableSegment, value: "accountName"), (
        kind: ConstantSegment, value: "/blobServices/default/containers/"),
               (kind: VariableSegment, value: "containerName"), (
        kind: ConstantSegment, value: "/immutabilityPolicies/default/lock")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BlobContainersLockImmutabilityPolicy_568318(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets the ImmutabilityPolicy to Locked state. The only action allowed on a Locked policy is ExtendImmutabilityPolicy action. ETag in If-Match is required for this operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   containerName: JString (required)
  ##                : The name of the blob container within the specified storage account. Blob container names must be between 3 and 63 characters in length and use numbers, lower-case letters and dash (-) only. Every dash (-) character must be immediately preceded and followed by a letter or number.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   accountName: JString (required)
  ##              : The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568320 = path.getOrDefault("resourceGroupName")
  valid_568320 = validateParameter(valid_568320, JString, required = true,
                                 default = nil)
  if valid_568320 != nil:
    section.add "resourceGroupName", valid_568320
  var valid_568321 = path.getOrDefault("containerName")
  valid_568321 = validateParameter(valid_568321, JString, required = true,
                                 default = nil)
  if valid_568321 != nil:
    section.add "containerName", valid_568321
  var valid_568322 = path.getOrDefault("subscriptionId")
  valid_568322 = validateParameter(valid_568322, JString, required = true,
                                 default = nil)
  if valid_568322 != nil:
    section.add "subscriptionId", valid_568322
  var valid_568323 = path.getOrDefault("accountName")
  valid_568323 = validateParameter(valid_568323, JString, required = true,
                                 default = nil)
  if valid_568323 != nil:
    section.add "accountName", valid_568323
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568324 = query.getOrDefault("api-version")
  valid_568324 = validateParameter(valid_568324, JString, required = true,
                                 default = nil)
  if valid_568324 != nil:
    section.add "api-version", valid_568324
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : The entity state (ETag) version of the immutability policy to update. A value of "*" can be used to apply the operation only if the immutability policy already exists. If omitted, this operation will always be applied.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_568325 = header.getOrDefault("If-Match")
  valid_568325 = validateParameter(valid_568325, JString, required = true,
                                 default = nil)
  if valid_568325 != nil:
    section.add "If-Match", valid_568325
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568326: Call_BlobContainersLockImmutabilityPolicy_568317;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the ImmutabilityPolicy to Locked state. The only action allowed on a Locked policy is ExtendImmutabilityPolicy action. ETag in If-Match is required for this operation.
  ## 
  let valid = call_568326.validator(path, query, header, formData, body)
  let scheme = call_568326.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568326.url(scheme.get, call_568326.host, call_568326.base,
                         call_568326.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568326, url, valid)

proc call*(call_568327: Call_BlobContainersLockImmutabilityPolicy_568317;
          resourceGroupName: string; apiVersion: string; containerName: string;
          subscriptionId: string; accountName: string): Recallable =
  ## blobContainersLockImmutabilityPolicy
  ## Sets the ImmutabilityPolicy to Locked state. The only action allowed on a Locked policy is ExtendImmutabilityPolicy action. ETag in If-Match is required for this operation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   containerName: string (required)
  ##                : The name of the blob container within the specified storage account. Blob container names must be between 3 and 63 characters in length and use numbers, lower-case letters and dash (-) only. Every dash (-) character must be immediately preceded and followed by a letter or number.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   accountName: string (required)
  ##              : The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
  var path_568328 = newJObject()
  var query_568329 = newJObject()
  add(path_568328, "resourceGroupName", newJString(resourceGroupName))
  add(query_568329, "api-version", newJString(apiVersion))
  add(path_568328, "containerName", newJString(containerName))
  add(path_568328, "subscriptionId", newJString(subscriptionId))
  add(path_568328, "accountName", newJString(accountName))
  result = call_568327.call(path_568328, query_568329, nil, nil, nil)

var blobContainersLockImmutabilityPolicy* = Call_BlobContainersLockImmutabilityPolicy_568317(
    name: "blobContainersLockImmutabilityPolicy", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{accountName}/blobServices/default/containers/{containerName}/immutabilityPolicies/default/lock",
    validator: validate_BlobContainersLockImmutabilityPolicy_568318, base: "",
    url: url_BlobContainersLockImmutabilityPolicy_568319, schemes: {Scheme.Https})
type
  Call_BlobContainersCreateOrUpdateImmutabilityPolicy_568357 = ref object of OpenApiRestCall_567658
proc url_BlobContainersCreateOrUpdateImmutabilityPolicy_568359(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "containerName" in path, "`containerName` is a required path parameter"
  assert "immutabilityPolicyName" in path,
        "`immutabilityPolicyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Storage/storageAccounts/"),
               (kind: VariableSegment, value: "accountName"), (
        kind: ConstantSegment, value: "/blobServices/default/containers/"),
               (kind: VariableSegment, value: "containerName"),
               (kind: ConstantSegment, value: "/immutabilityPolicies/"),
               (kind: VariableSegment, value: "immutabilityPolicyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BlobContainersCreateOrUpdateImmutabilityPolicy_568358(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates or updates an unlocked immutability policy. ETag in If-Match is honored if given but not required for this operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   containerName: JString (required)
  ##                : The name of the blob container within the specified storage account. Blob container names must be between 3 and 63 characters in length and use numbers, lower-case letters and dash (-) only. Every dash (-) character must be immediately preceded and followed by a letter or number.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   immutabilityPolicyName: JString (required)
  ##                         : The name of the blob container immutabilityPolicy within the specified storage account. ImmutabilityPolicy Name must be 'default'
  ##   accountName: JString (required)
  ##              : The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568360 = path.getOrDefault("resourceGroupName")
  valid_568360 = validateParameter(valid_568360, JString, required = true,
                                 default = nil)
  if valid_568360 != nil:
    section.add "resourceGroupName", valid_568360
  var valid_568361 = path.getOrDefault("containerName")
  valid_568361 = validateParameter(valid_568361, JString, required = true,
                                 default = nil)
  if valid_568361 != nil:
    section.add "containerName", valid_568361
  var valid_568362 = path.getOrDefault("subscriptionId")
  valid_568362 = validateParameter(valid_568362, JString, required = true,
                                 default = nil)
  if valid_568362 != nil:
    section.add "subscriptionId", valid_568362
  var valid_568363 = path.getOrDefault("immutabilityPolicyName")
  valid_568363 = validateParameter(valid_568363, JString, required = true,
                                 default = newJString("default"))
  if valid_568363 != nil:
    section.add "immutabilityPolicyName", valid_568363
  var valid_568364 = path.getOrDefault("accountName")
  valid_568364 = validateParameter(valid_568364, JString, required = true,
                                 default = nil)
  if valid_568364 != nil:
    section.add "accountName", valid_568364
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568365 = query.getOrDefault("api-version")
  valid_568365 = validateParameter(valid_568365, JString, required = true,
                                 default = nil)
  if valid_568365 != nil:
    section.add "api-version", valid_568365
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : The entity state (ETag) version of the immutability policy to update. A value of "*" can be used to apply the operation only if the immutability policy already exists. If omitted, this operation will always be applied.
  section = newJObject()
  var valid_568366 = header.getOrDefault("If-Match")
  valid_568366 = validateParameter(valid_568366, JString, required = false,
                                 default = nil)
  if valid_568366 != nil:
    section.add "If-Match", valid_568366
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject
  ##             : The ImmutabilityPolicy Properties that will be created or updated to a blob container.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568368: Call_BlobContainersCreateOrUpdateImmutabilityPolicy_568357;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates an unlocked immutability policy. ETag in If-Match is honored if given but not required for this operation.
  ## 
  let valid = call_568368.validator(path, query, header, formData, body)
  let scheme = call_568368.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568368.url(scheme.get, call_568368.host, call_568368.base,
                         call_568368.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568368, url, valid)

proc call*(call_568369: Call_BlobContainersCreateOrUpdateImmutabilityPolicy_568357;
          resourceGroupName: string; apiVersion: string; containerName: string;
          subscriptionId: string; accountName: string;
          immutabilityPolicyName: string = "default"; parameters: JsonNode = nil): Recallable =
  ## blobContainersCreateOrUpdateImmutabilityPolicy
  ## Creates or updates an unlocked immutability policy. ETag in If-Match is honored if given but not required for this operation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   containerName: string (required)
  ##                : The name of the blob container within the specified storage account. Blob container names must be between 3 and 63 characters in length and use numbers, lower-case letters and dash (-) only. Every dash (-) character must be immediately preceded and followed by a letter or number.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   immutabilityPolicyName: string (required)
  ##                         : The name of the blob container immutabilityPolicy within the specified storage account. ImmutabilityPolicy Name must be 'default'
  ##   parameters: JObject
  ##             : The ImmutabilityPolicy Properties that will be created or updated to a blob container.
  ##   accountName: string (required)
  ##              : The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
  var path_568370 = newJObject()
  var query_568371 = newJObject()
  var body_568372 = newJObject()
  add(path_568370, "resourceGroupName", newJString(resourceGroupName))
  add(query_568371, "api-version", newJString(apiVersion))
  add(path_568370, "containerName", newJString(containerName))
  add(path_568370, "subscriptionId", newJString(subscriptionId))
  add(path_568370, "immutabilityPolicyName", newJString(immutabilityPolicyName))
  if parameters != nil:
    body_568372 = parameters
  add(path_568370, "accountName", newJString(accountName))
  result = call_568369.call(path_568370, query_568371, nil, nil, body_568372)

var blobContainersCreateOrUpdateImmutabilityPolicy* = Call_BlobContainersCreateOrUpdateImmutabilityPolicy_568357(
    name: "blobContainersCreateOrUpdateImmutabilityPolicy",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{accountName}/blobServices/default/containers/{containerName}/immutabilityPolicies/{immutabilityPolicyName}",
    validator: validate_BlobContainersCreateOrUpdateImmutabilityPolicy_568358,
    base: "", url: url_BlobContainersCreateOrUpdateImmutabilityPolicy_568359,
    schemes: {Scheme.Https})
type
  Call_BlobContainersGetImmutabilityPolicy_568330 = ref object of OpenApiRestCall_567658
proc url_BlobContainersGetImmutabilityPolicy_568332(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "containerName" in path, "`containerName` is a required path parameter"
  assert "immutabilityPolicyName" in path,
        "`immutabilityPolicyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Storage/storageAccounts/"),
               (kind: VariableSegment, value: "accountName"), (
        kind: ConstantSegment, value: "/blobServices/default/containers/"),
               (kind: VariableSegment, value: "containerName"),
               (kind: ConstantSegment, value: "/immutabilityPolicies/"),
               (kind: VariableSegment, value: "immutabilityPolicyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BlobContainersGetImmutabilityPolicy_568331(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the existing immutability policy along with the corresponding ETag in response headers and body.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   containerName: JString (required)
  ##                : The name of the blob container within the specified storage account. Blob container names must be between 3 and 63 characters in length and use numbers, lower-case letters and dash (-) only. Every dash (-) character must be immediately preceded and followed by a letter or number.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   immutabilityPolicyName: JString (required)
  ##                         : The name of the blob container immutabilityPolicy within the specified storage account. ImmutabilityPolicy Name must be 'default'
  ##   accountName: JString (required)
  ##              : The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568333 = path.getOrDefault("resourceGroupName")
  valid_568333 = validateParameter(valid_568333, JString, required = true,
                                 default = nil)
  if valid_568333 != nil:
    section.add "resourceGroupName", valid_568333
  var valid_568334 = path.getOrDefault("containerName")
  valid_568334 = validateParameter(valid_568334, JString, required = true,
                                 default = nil)
  if valid_568334 != nil:
    section.add "containerName", valid_568334
  var valid_568335 = path.getOrDefault("subscriptionId")
  valid_568335 = validateParameter(valid_568335, JString, required = true,
                                 default = nil)
  if valid_568335 != nil:
    section.add "subscriptionId", valid_568335
  var valid_568349 = path.getOrDefault("immutabilityPolicyName")
  valid_568349 = validateParameter(valid_568349, JString, required = true,
                                 default = newJString("default"))
  if valid_568349 != nil:
    section.add "immutabilityPolicyName", valid_568349
  var valid_568350 = path.getOrDefault("accountName")
  valid_568350 = validateParameter(valid_568350, JString, required = true,
                                 default = nil)
  if valid_568350 != nil:
    section.add "accountName", valid_568350
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568351 = query.getOrDefault("api-version")
  valid_568351 = validateParameter(valid_568351, JString, required = true,
                                 default = nil)
  if valid_568351 != nil:
    section.add "api-version", valid_568351
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : The entity state (ETag) version of the immutability policy to update. A value of "*" can be used to apply the operation only if the immutability policy already exists. If omitted, this operation will always be applied.
  section = newJObject()
  var valid_568352 = header.getOrDefault("If-Match")
  valid_568352 = validateParameter(valid_568352, JString, required = false,
                                 default = nil)
  if valid_568352 != nil:
    section.add "If-Match", valid_568352
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568353: Call_BlobContainersGetImmutabilityPolicy_568330;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the existing immutability policy along with the corresponding ETag in response headers and body.
  ## 
  let valid = call_568353.validator(path, query, header, formData, body)
  let scheme = call_568353.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568353.url(scheme.get, call_568353.host, call_568353.base,
                         call_568353.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568353, url, valid)

proc call*(call_568354: Call_BlobContainersGetImmutabilityPolicy_568330;
          resourceGroupName: string; apiVersion: string; containerName: string;
          subscriptionId: string; accountName: string;
          immutabilityPolicyName: string = "default"): Recallable =
  ## blobContainersGetImmutabilityPolicy
  ## Gets the existing immutability policy along with the corresponding ETag in response headers and body.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   containerName: string (required)
  ##                : The name of the blob container within the specified storage account. Blob container names must be between 3 and 63 characters in length and use numbers, lower-case letters and dash (-) only. Every dash (-) character must be immediately preceded and followed by a letter or number.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   immutabilityPolicyName: string (required)
  ##                         : The name of the blob container immutabilityPolicy within the specified storage account. ImmutabilityPolicy Name must be 'default'
  ##   accountName: string (required)
  ##              : The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
  var path_568355 = newJObject()
  var query_568356 = newJObject()
  add(path_568355, "resourceGroupName", newJString(resourceGroupName))
  add(query_568356, "api-version", newJString(apiVersion))
  add(path_568355, "containerName", newJString(containerName))
  add(path_568355, "subscriptionId", newJString(subscriptionId))
  add(path_568355, "immutabilityPolicyName", newJString(immutabilityPolicyName))
  add(path_568355, "accountName", newJString(accountName))
  result = call_568354.call(path_568355, query_568356, nil, nil, nil)

var blobContainersGetImmutabilityPolicy* = Call_BlobContainersGetImmutabilityPolicy_568330(
    name: "blobContainersGetImmutabilityPolicy", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{accountName}/blobServices/default/containers/{containerName}/immutabilityPolicies/{immutabilityPolicyName}",
    validator: validate_BlobContainersGetImmutabilityPolicy_568331, base: "",
    url: url_BlobContainersGetImmutabilityPolicy_568332, schemes: {Scheme.Https})
type
  Call_BlobContainersDeleteImmutabilityPolicy_568373 = ref object of OpenApiRestCall_567658
proc url_BlobContainersDeleteImmutabilityPolicy_568375(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "containerName" in path, "`containerName` is a required path parameter"
  assert "immutabilityPolicyName" in path,
        "`immutabilityPolicyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Storage/storageAccounts/"),
               (kind: VariableSegment, value: "accountName"), (
        kind: ConstantSegment, value: "/blobServices/default/containers/"),
               (kind: VariableSegment, value: "containerName"),
               (kind: ConstantSegment, value: "/immutabilityPolicies/"),
               (kind: VariableSegment, value: "immutabilityPolicyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BlobContainersDeleteImmutabilityPolicy_568374(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Aborts an unlocked immutability policy. The response of delete has immutabilityPeriodSinceCreationInDays set to 0. ETag in If-Match is required for this operation. Deleting a locked immutability policy is not allowed, only way is to delete the container after deleting all blobs inside the container.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   containerName: JString (required)
  ##                : The name of the blob container within the specified storage account. Blob container names must be between 3 and 63 characters in length and use numbers, lower-case letters and dash (-) only. Every dash (-) character must be immediately preceded and followed by a letter or number.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   immutabilityPolicyName: JString (required)
  ##                         : The name of the blob container immutabilityPolicy within the specified storage account. ImmutabilityPolicy Name must be 'default'
  ##   accountName: JString (required)
  ##              : The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568376 = path.getOrDefault("resourceGroupName")
  valid_568376 = validateParameter(valid_568376, JString, required = true,
                                 default = nil)
  if valid_568376 != nil:
    section.add "resourceGroupName", valid_568376
  var valid_568377 = path.getOrDefault("containerName")
  valid_568377 = validateParameter(valid_568377, JString, required = true,
                                 default = nil)
  if valid_568377 != nil:
    section.add "containerName", valid_568377
  var valid_568378 = path.getOrDefault("subscriptionId")
  valid_568378 = validateParameter(valid_568378, JString, required = true,
                                 default = nil)
  if valid_568378 != nil:
    section.add "subscriptionId", valid_568378
  var valid_568379 = path.getOrDefault("immutabilityPolicyName")
  valid_568379 = validateParameter(valid_568379, JString, required = true,
                                 default = newJString("default"))
  if valid_568379 != nil:
    section.add "immutabilityPolicyName", valid_568379
  var valid_568380 = path.getOrDefault("accountName")
  valid_568380 = validateParameter(valid_568380, JString, required = true,
                                 default = nil)
  if valid_568380 != nil:
    section.add "accountName", valid_568380
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568381 = query.getOrDefault("api-version")
  valid_568381 = validateParameter(valid_568381, JString, required = true,
                                 default = nil)
  if valid_568381 != nil:
    section.add "api-version", valid_568381
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : The entity state (ETag) version of the immutability policy to update. A value of "*" can be used to apply the operation only if the immutability policy already exists. If omitted, this operation will always be applied.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_568382 = header.getOrDefault("If-Match")
  valid_568382 = validateParameter(valid_568382, JString, required = true,
                                 default = nil)
  if valid_568382 != nil:
    section.add "If-Match", valid_568382
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568383: Call_BlobContainersDeleteImmutabilityPolicy_568373;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Aborts an unlocked immutability policy. The response of delete has immutabilityPeriodSinceCreationInDays set to 0. ETag in If-Match is required for this operation. Deleting a locked immutability policy is not allowed, only way is to delete the container after deleting all blobs inside the container.
  ## 
  let valid = call_568383.validator(path, query, header, formData, body)
  let scheme = call_568383.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568383.url(scheme.get, call_568383.host, call_568383.base,
                         call_568383.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568383, url, valid)

proc call*(call_568384: Call_BlobContainersDeleteImmutabilityPolicy_568373;
          resourceGroupName: string; apiVersion: string; containerName: string;
          subscriptionId: string; accountName: string;
          immutabilityPolicyName: string = "default"): Recallable =
  ## blobContainersDeleteImmutabilityPolicy
  ## Aborts an unlocked immutability policy. The response of delete has immutabilityPeriodSinceCreationInDays set to 0. ETag in If-Match is required for this operation. Deleting a locked immutability policy is not allowed, only way is to delete the container after deleting all blobs inside the container.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   containerName: string (required)
  ##                : The name of the blob container within the specified storage account. Blob container names must be between 3 and 63 characters in length and use numbers, lower-case letters and dash (-) only. Every dash (-) character must be immediately preceded and followed by a letter or number.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   immutabilityPolicyName: string (required)
  ##                         : The name of the blob container immutabilityPolicy within the specified storage account. ImmutabilityPolicy Name must be 'default'
  ##   accountName: string (required)
  ##              : The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
  var path_568385 = newJObject()
  var query_568386 = newJObject()
  add(path_568385, "resourceGroupName", newJString(resourceGroupName))
  add(query_568386, "api-version", newJString(apiVersion))
  add(path_568385, "containerName", newJString(containerName))
  add(path_568385, "subscriptionId", newJString(subscriptionId))
  add(path_568385, "immutabilityPolicyName", newJString(immutabilityPolicyName))
  add(path_568385, "accountName", newJString(accountName))
  result = call_568384.call(path_568385, query_568386, nil, nil, nil)

var blobContainersDeleteImmutabilityPolicy* = Call_BlobContainersDeleteImmutabilityPolicy_568373(
    name: "blobContainersDeleteImmutabilityPolicy", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{accountName}/blobServices/default/containers/{containerName}/immutabilityPolicies/{immutabilityPolicyName}",
    validator: validate_BlobContainersDeleteImmutabilityPolicy_568374, base: "",
    url: url_BlobContainersDeleteImmutabilityPolicy_568375,
    schemes: {Scheme.Https})
type
  Call_BlobContainersLease_568387 = ref object of OpenApiRestCall_567658
proc url_BlobContainersLease_568389(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "containerName" in path, "`containerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Storage/storageAccounts/"),
               (kind: VariableSegment, value: "accountName"), (
        kind: ConstantSegment, value: "/blobServices/default/containers/"),
               (kind: VariableSegment, value: "containerName"),
               (kind: ConstantSegment, value: "/lease")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BlobContainersLease_568388(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## The Lease Container operation establishes and manages a lock on a container for delete operations. The lock duration can be 15 to 60 seconds, or can be infinite.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   containerName: JString (required)
  ##                : The name of the blob container within the specified storage account. Blob container names must be between 3 and 63 characters in length and use numbers, lower-case letters and dash (-) only. Every dash (-) character must be immediately preceded and followed by a letter or number.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   accountName: JString (required)
  ##              : The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568390 = path.getOrDefault("resourceGroupName")
  valid_568390 = validateParameter(valid_568390, JString, required = true,
                                 default = nil)
  if valid_568390 != nil:
    section.add "resourceGroupName", valid_568390
  var valid_568391 = path.getOrDefault("containerName")
  valid_568391 = validateParameter(valid_568391, JString, required = true,
                                 default = nil)
  if valid_568391 != nil:
    section.add "containerName", valid_568391
  var valid_568392 = path.getOrDefault("subscriptionId")
  valid_568392 = validateParameter(valid_568392, JString, required = true,
                                 default = nil)
  if valid_568392 != nil:
    section.add "subscriptionId", valid_568392
  var valid_568393 = path.getOrDefault("accountName")
  valid_568393 = validateParameter(valid_568393, JString, required = true,
                                 default = nil)
  if valid_568393 != nil:
    section.add "accountName", valid_568393
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568394 = query.getOrDefault("api-version")
  valid_568394 = validateParameter(valid_568394, JString, required = true,
                                 default = nil)
  if valid_568394 != nil:
    section.add "api-version", valid_568394
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject
  ##             : Lease Container request body.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568396: Call_BlobContainersLease_568387; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Lease Container operation establishes and manages a lock on a container for delete operations. The lock duration can be 15 to 60 seconds, or can be infinite.
  ## 
  let valid = call_568396.validator(path, query, header, formData, body)
  let scheme = call_568396.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568396.url(scheme.get, call_568396.host, call_568396.base,
                         call_568396.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568396, url, valid)

proc call*(call_568397: Call_BlobContainersLease_568387; resourceGroupName: string;
          apiVersion: string; containerName: string; subscriptionId: string;
          accountName: string; parameters: JsonNode = nil): Recallable =
  ## blobContainersLease
  ## The Lease Container operation establishes and manages a lock on a container for delete operations. The lock duration can be 15 to 60 seconds, or can be infinite.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   containerName: string (required)
  ##                : The name of the blob container within the specified storage account. Blob container names must be between 3 and 63 characters in length and use numbers, lower-case letters and dash (-) only. Every dash (-) character must be immediately preceded and followed by a letter or number.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   parameters: JObject
  ##             : Lease Container request body.
  ##   accountName: string (required)
  ##              : The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
  var path_568398 = newJObject()
  var query_568399 = newJObject()
  var body_568400 = newJObject()
  add(path_568398, "resourceGroupName", newJString(resourceGroupName))
  add(query_568399, "api-version", newJString(apiVersion))
  add(path_568398, "containerName", newJString(containerName))
  add(path_568398, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568400 = parameters
  add(path_568398, "accountName", newJString(accountName))
  result = call_568397.call(path_568398, query_568399, nil, nil, body_568400)

var blobContainersLease* = Call_BlobContainersLease_568387(
    name: "blobContainersLease", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{accountName}/blobServices/default/containers/{containerName}/lease",
    validator: validate_BlobContainersLease_568388, base: "",
    url: url_BlobContainersLease_568389, schemes: {Scheme.Https})
type
  Call_BlobContainersSetLegalHold_568401 = ref object of OpenApiRestCall_567658
proc url_BlobContainersSetLegalHold_568403(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "containerName" in path, "`containerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Storage/storageAccounts/"),
               (kind: VariableSegment, value: "accountName"), (
        kind: ConstantSegment, value: "/blobServices/default/containers/"),
               (kind: VariableSegment, value: "containerName"),
               (kind: ConstantSegment, value: "/setLegalHold")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BlobContainersSetLegalHold_568402(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets legal hold tags. Setting the same tag results in an idempotent operation. SetLegalHold follows an append pattern and does not clear out the existing tags that are not specified in the request.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   containerName: JString (required)
  ##                : The name of the blob container within the specified storage account. Blob container names must be between 3 and 63 characters in length and use numbers, lower-case letters and dash (-) only. Every dash (-) character must be immediately preceded and followed by a letter or number.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   accountName: JString (required)
  ##              : The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568404 = path.getOrDefault("resourceGroupName")
  valid_568404 = validateParameter(valid_568404, JString, required = true,
                                 default = nil)
  if valid_568404 != nil:
    section.add "resourceGroupName", valid_568404
  var valid_568405 = path.getOrDefault("containerName")
  valid_568405 = validateParameter(valid_568405, JString, required = true,
                                 default = nil)
  if valid_568405 != nil:
    section.add "containerName", valid_568405
  var valid_568406 = path.getOrDefault("subscriptionId")
  valid_568406 = validateParameter(valid_568406, JString, required = true,
                                 default = nil)
  if valid_568406 != nil:
    section.add "subscriptionId", valid_568406
  var valid_568407 = path.getOrDefault("accountName")
  valid_568407 = validateParameter(valid_568407, JString, required = true,
                                 default = nil)
  if valid_568407 != nil:
    section.add "accountName", valid_568407
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568408 = query.getOrDefault("api-version")
  valid_568408 = validateParameter(valid_568408, JString, required = true,
                                 default = nil)
  if valid_568408 != nil:
    section.add "api-version", valid_568408
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   LegalHold: JObject (required)
  ##            : The LegalHold property that will be set to a blob container.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568410: Call_BlobContainersSetLegalHold_568401; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sets legal hold tags. Setting the same tag results in an idempotent operation. SetLegalHold follows an append pattern and does not clear out the existing tags that are not specified in the request.
  ## 
  let valid = call_568410.validator(path, query, header, formData, body)
  let scheme = call_568410.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568410.url(scheme.get, call_568410.host, call_568410.base,
                         call_568410.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568410, url, valid)

proc call*(call_568411: Call_BlobContainersSetLegalHold_568401;
          resourceGroupName: string; apiVersion: string; containerName: string;
          LegalHold: JsonNode; subscriptionId: string; accountName: string): Recallable =
  ## blobContainersSetLegalHold
  ## Sets legal hold tags. Setting the same tag results in an idempotent operation. SetLegalHold follows an append pattern and does not clear out the existing tags that are not specified in the request.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   containerName: string (required)
  ##                : The name of the blob container within the specified storage account. Blob container names must be between 3 and 63 characters in length and use numbers, lower-case letters and dash (-) only. Every dash (-) character must be immediately preceded and followed by a letter or number.
  ##   LegalHold: JObject (required)
  ##            : The LegalHold property that will be set to a blob container.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   accountName: string (required)
  ##              : The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
  var path_568412 = newJObject()
  var query_568413 = newJObject()
  var body_568414 = newJObject()
  add(path_568412, "resourceGroupName", newJString(resourceGroupName))
  add(query_568413, "api-version", newJString(apiVersion))
  add(path_568412, "containerName", newJString(containerName))
  if LegalHold != nil:
    body_568414 = LegalHold
  add(path_568412, "subscriptionId", newJString(subscriptionId))
  add(path_568412, "accountName", newJString(accountName))
  result = call_568411.call(path_568412, query_568413, nil, nil, body_568414)

var blobContainersSetLegalHold* = Call_BlobContainersSetLegalHold_568401(
    name: "blobContainersSetLegalHold", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{accountName}/blobServices/default/containers/{containerName}/setLegalHold",
    validator: validate_BlobContainersSetLegalHold_568402, base: "",
    url: url_BlobContainersSetLegalHold_568403, schemes: {Scheme.Https})
type
  Call_BlobServicesSetServiceProperties_568427 = ref object of OpenApiRestCall_567658
proc url_BlobServicesSetServiceProperties_568429(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "BlobServicesName" in path,
        "`BlobServicesName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Storage/storageAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/blobServices/"),
               (kind: VariableSegment, value: "BlobServicesName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BlobServicesSetServiceProperties_568428(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets the properties of a storage account’s Blob service, including properties for Storage Analytics and CORS (Cross-Origin Resource Sharing) rules. 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   BlobServicesName: JString (required)
  ##                   : The name of the blob Service within the specified storage account. Blob Service Name must be 'default'
  ##   accountName: JString (required)
  ##              : The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568430 = path.getOrDefault("resourceGroupName")
  valid_568430 = validateParameter(valid_568430, JString, required = true,
                                 default = nil)
  if valid_568430 != nil:
    section.add "resourceGroupName", valid_568430
  var valid_568431 = path.getOrDefault("subscriptionId")
  valid_568431 = validateParameter(valid_568431, JString, required = true,
                                 default = nil)
  if valid_568431 != nil:
    section.add "subscriptionId", valid_568431
  var valid_568432 = path.getOrDefault("BlobServicesName")
  valid_568432 = validateParameter(valid_568432, JString, required = true,
                                 default = newJString("default"))
  if valid_568432 != nil:
    section.add "BlobServicesName", valid_568432
  var valid_568433 = path.getOrDefault("accountName")
  valid_568433 = validateParameter(valid_568433, JString, required = true,
                                 default = nil)
  if valid_568433 != nil:
    section.add "accountName", valid_568433
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568434 = query.getOrDefault("api-version")
  valid_568434 = validateParameter(valid_568434, JString, required = true,
                                 default = nil)
  if valid_568434 != nil:
    section.add "api-version", valid_568434
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The properties of a storage account’s Blob service, including properties for Storage Analytics and CORS (Cross-Origin Resource Sharing) rules.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568436: Call_BlobServicesSetServiceProperties_568427;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the properties of a storage account’s Blob service, including properties for Storage Analytics and CORS (Cross-Origin Resource Sharing) rules. 
  ## 
  let valid = call_568436.validator(path, query, header, formData, body)
  let scheme = call_568436.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568436.url(scheme.get, call_568436.host, call_568436.base,
                         call_568436.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568436, url, valid)

proc call*(call_568437: Call_BlobServicesSetServiceProperties_568427;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode; accountName: string;
          BlobServicesName: string = "default"): Recallable =
  ## blobServicesSetServiceProperties
  ## Sets the properties of a storage account’s Blob service, including properties for Storage Analytics and CORS (Cross-Origin Resource Sharing) rules. 
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   BlobServicesName: string (required)
  ##                   : The name of the blob Service within the specified storage account. Blob Service Name must be 'default'
  ##   parameters: JObject (required)
  ##             : The properties of a storage account’s Blob service, including properties for Storage Analytics and CORS (Cross-Origin Resource Sharing) rules.
  ##   accountName: string (required)
  ##              : The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
  var path_568438 = newJObject()
  var query_568439 = newJObject()
  var body_568440 = newJObject()
  add(path_568438, "resourceGroupName", newJString(resourceGroupName))
  add(query_568439, "api-version", newJString(apiVersion))
  add(path_568438, "subscriptionId", newJString(subscriptionId))
  add(path_568438, "BlobServicesName", newJString(BlobServicesName))
  if parameters != nil:
    body_568440 = parameters
  add(path_568438, "accountName", newJString(accountName))
  result = call_568437.call(path_568438, query_568439, nil, nil, body_568440)

var blobServicesSetServiceProperties* = Call_BlobServicesSetServiceProperties_568427(
    name: "blobServicesSetServiceProperties", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{accountName}/blobServices/{BlobServicesName}",
    validator: validate_BlobServicesSetServiceProperties_568428, base: "",
    url: url_BlobServicesSetServiceProperties_568429, schemes: {Scheme.Https})
type
  Call_BlobServicesGetServiceProperties_568415 = ref object of OpenApiRestCall_567658
proc url_BlobServicesGetServiceProperties_568417(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "BlobServicesName" in path,
        "`BlobServicesName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Storage/storageAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/blobServices/"),
               (kind: VariableSegment, value: "BlobServicesName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BlobServicesGetServiceProperties_568416(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the properties of a storage account’s Blob service, including properties for Storage Analytics and CORS (Cross-Origin Resource Sharing) rules.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   BlobServicesName: JString (required)
  ##                   : The name of the blob Service within the specified storage account. Blob Service Name must be 'default'
  ##   accountName: JString (required)
  ##              : The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568418 = path.getOrDefault("resourceGroupName")
  valid_568418 = validateParameter(valid_568418, JString, required = true,
                                 default = nil)
  if valid_568418 != nil:
    section.add "resourceGroupName", valid_568418
  var valid_568419 = path.getOrDefault("subscriptionId")
  valid_568419 = validateParameter(valid_568419, JString, required = true,
                                 default = nil)
  if valid_568419 != nil:
    section.add "subscriptionId", valid_568419
  var valid_568420 = path.getOrDefault("BlobServicesName")
  valid_568420 = validateParameter(valid_568420, JString, required = true,
                                 default = newJString("default"))
  if valid_568420 != nil:
    section.add "BlobServicesName", valid_568420
  var valid_568421 = path.getOrDefault("accountName")
  valid_568421 = validateParameter(valid_568421, JString, required = true,
                                 default = nil)
  if valid_568421 != nil:
    section.add "accountName", valid_568421
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568422 = query.getOrDefault("api-version")
  valid_568422 = validateParameter(valid_568422, JString, required = true,
                                 default = nil)
  if valid_568422 != nil:
    section.add "api-version", valid_568422
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568423: Call_BlobServicesGetServiceProperties_568415;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the properties of a storage account’s Blob service, including properties for Storage Analytics and CORS (Cross-Origin Resource Sharing) rules.
  ## 
  let valid = call_568423.validator(path, query, header, formData, body)
  let scheme = call_568423.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568423.url(scheme.get, call_568423.host, call_568423.base,
                         call_568423.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568423, url, valid)

proc call*(call_568424: Call_BlobServicesGetServiceProperties_568415;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          accountName: string; BlobServicesName: string = "default"): Recallable =
  ## blobServicesGetServiceProperties
  ## Gets the properties of a storage account’s Blob service, including properties for Storage Analytics and CORS (Cross-Origin Resource Sharing) rules.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   BlobServicesName: string (required)
  ##                   : The name of the blob Service within the specified storage account. Blob Service Name must be 'default'
  ##   accountName: string (required)
  ##              : The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
  var path_568425 = newJObject()
  var query_568426 = newJObject()
  add(path_568425, "resourceGroupName", newJString(resourceGroupName))
  add(query_568426, "api-version", newJString(apiVersion))
  add(path_568425, "subscriptionId", newJString(subscriptionId))
  add(path_568425, "BlobServicesName", newJString(BlobServicesName))
  add(path_568425, "accountName", newJString(accountName))
  result = call_568424.call(path_568425, query_568426, nil, nil, nil)

var blobServicesGetServiceProperties* = Call_BlobServicesGetServiceProperties_568415(
    name: "blobServicesGetServiceProperties", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{accountName}/blobServices/{BlobServicesName}",
    validator: validate_BlobServicesGetServiceProperties_568416, base: "",
    url: url_BlobServicesGetServiceProperties_568417, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
