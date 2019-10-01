
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: StorageManagementClient
## version: 2018-11-01
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
  Call_BlobContainersList_567880 = ref object of OpenApiRestCall_567658
proc url_BlobContainersList_567882(protocol: Scheme; host: string; base: string;
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

proc validate_BlobContainersList_567881(path: JsonNode; query: JsonNode;
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

proc call*(call_568072: Call_BlobContainersList_567880; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all containers and does not support a prefix like data plane. Also SRP today does not return continuation token.
  ## 
  let valid = call_568072.validator(path, query, header, formData, body)
  let scheme = call_568072.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568072.url(scheme.get, call_568072.host, call_568072.base,
                         call_568072.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568072, url, valid)

proc call*(call_568143: Call_BlobContainersList_567880; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; accountName: string): Recallable =
  ## blobContainersList
  ## Lists all containers and does not support a prefix like data plane. Also SRP today does not return continuation token.
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

var blobContainersList* = Call_BlobContainersList_567880(
    name: "blobContainersList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{accountName}/blobServices/default/containers",
    validator: validate_BlobContainersList_567881, base: "",
    url: url_BlobContainersList_567882, schemes: {Scheme.Https})
type
  Call_BlobContainersCreate_568206 = ref object of OpenApiRestCall_567658
proc url_BlobContainersCreate_568208(protocol: Scheme; host: string; base: string;
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

proc validate_BlobContainersCreate_568207(path: JsonNode; query: JsonNode;
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
  var valid_568226 = path.getOrDefault("resourceGroupName")
  valid_568226 = validateParameter(valid_568226, JString, required = true,
                                 default = nil)
  if valid_568226 != nil:
    section.add "resourceGroupName", valid_568226
  var valid_568227 = path.getOrDefault("containerName")
  valid_568227 = validateParameter(valid_568227, JString, required = true,
                                 default = nil)
  if valid_568227 != nil:
    section.add "containerName", valid_568227
  var valid_568228 = path.getOrDefault("subscriptionId")
  valid_568228 = validateParameter(valid_568228, JString, required = true,
                                 default = nil)
  if valid_568228 != nil:
    section.add "subscriptionId", valid_568228
  var valid_568229 = path.getOrDefault("accountName")
  valid_568229 = validateParameter(valid_568229, JString, required = true,
                                 default = nil)
  if valid_568229 != nil:
    section.add "accountName", valid_568229
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568230 = query.getOrDefault("api-version")
  valid_568230 = validateParameter(valid_568230, JString, required = true,
                                 default = nil)
  if valid_568230 != nil:
    section.add "api-version", valid_568230
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

proc call*(call_568232: Call_BlobContainersCreate_568206; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new container under the specified account as described by request body. The container resource includes metadata and properties for that container. It does not include a list of the blobs contained by the container. 
  ## 
  let valid = call_568232.validator(path, query, header, formData, body)
  let scheme = call_568232.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568232.url(scheme.get, call_568232.host, call_568232.base,
                         call_568232.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568232, url, valid)

proc call*(call_568233: Call_BlobContainersCreate_568206;
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
  var path_568234 = newJObject()
  var query_568235 = newJObject()
  var body_568236 = newJObject()
  add(path_568234, "resourceGroupName", newJString(resourceGroupName))
  add(query_568235, "api-version", newJString(apiVersion))
  if blobContainer != nil:
    body_568236 = blobContainer
  add(path_568234, "containerName", newJString(containerName))
  add(path_568234, "subscriptionId", newJString(subscriptionId))
  add(path_568234, "accountName", newJString(accountName))
  result = call_568233.call(path_568234, query_568235, nil, nil, body_568236)

var blobContainersCreate* = Call_BlobContainersCreate_568206(
    name: "blobContainersCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{accountName}/blobServices/default/containers/{containerName}",
    validator: validate_BlobContainersCreate_568207, base: "",
    url: url_BlobContainersCreate_568208, schemes: {Scheme.Https})
type
  Call_BlobContainersGet_568185 = ref object of OpenApiRestCall_567658
proc url_BlobContainersGet_568187(protocol: Scheme; host: string; base: string;
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

proc validate_BlobContainersGet_568186(path: JsonNode; query: JsonNode;
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
  var valid_568197 = path.getOrDefault("resourceGroupName")
  valid_568197 = validateParameter(valid_568197, JString, required = true,
                                 default = nil)
  if valid_568197 != nil:
    section.add "resourceGroupName", valid_568197
  var valid_568198 = path.getOrDefault("containerName")
  valid_568198 = validateParameter(valid_568198, JString, required = true,
                                 default = nil)
  if valid_568198 != nil:
    section.add "containerName", valid_568198
  var valid_568199 = path.getOrDefault("subscriptionId")
  valid_568199 = validateParameter(valid_568199, JString, required = true,
                                 default = nil)
  if valid_568199 != nil:
    section.add "subscriptionId", valid_568199
  var valid_568200 = path.getOrDefault("accountName")
  valid_568200 = validateParameter(valid_568200, JString, required = true,
                                 default = nil)
  if valid_568200 != nil:
    section.add "accountName", valid_568200
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568201 = query.getOrDefault("api-version")
  valid_568201 = validateParameter(valid_568201, JString, required = true,
                                 default = nil)
  if valid_568201 != nil:
    section.add "api-version", valid_568201
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568202: Call_BlobContainersGet_568185; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets properties of a specified container. 
  ## 
  let valid = call_568202.validator(path, query, header, formData, body)
  let scheme = call_568202.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568202.url(scheme.get, call_568202.host, call_568202.base,
                         call_568202.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568202, url, valid)

proc call*(call_568203: Call_BlobContainersGet_568185; resourceGroupName: string;
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
  var path_568204 = newJObject()
  var query_568205 = newJObject()
  add(path_568204, "resourceGroupName", newJString(resourceGroupName))
  add(query_568205, "api-version", newJString(apiVersion))
  add(path_568204, "containerName", newJString(containerName))
  add(path_568204, "subscriptionId", newJString(subscriptionId))
  add(path_568204, "accountName", newJString(accountName))
  result = call_568203.call(path_568204, query_568205, nil, nil, nil)

var blobContainersGet* = Call_BlobContainersGet_568185(name: "blobContainersGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{accountName}/blobServices/default/containers/{containerName}",
    validator: validate_BlobContainersGet_568186, base: "",
    url: url_BlobContainersGet_568187, schemes: {Scheme.Https})
type
  Call_BlobContainersUpdate_568249 = ref object of OpenApiRestCall_567658
proc url_BlobContainersUpdate_568251(protocol: Scheme; host: string; base: string;
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

proc validate_BlobContainersUpdate_568250(path: JsonNode; query: JsonNode;
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
  var valid_568252 = path.getOrDefault("resourceGroupName")
  valid_568252 = validateParameter(valid_568252, JString, required = true,
                                 default = nil)
  if valid_568252 != nil:
    section.add "resourceGroupName", valid_568252
  var valid_568253 = path.getOrDefault("containerName")
  valid_568253 = validateParameter(valid_568253, JString, required = true,
                                 default = nil)
  if valid_568253 != nil:
    section.add "containerName", valid_568253
  var valid_568254 = path.getOrDefault("subscriptionId")
  valid_568254 = validateParameter(valid_568254, JString, required = true,
                                 default = nil)
  if valid_568254 != nil:
    section.add "subscriptionId", valid_568254
  var valid_568255 = path.getOrDefault("accountName")
  valid_568255 = validateParameter(valid_568255, JString, required = true,
                                 default = nil)
  if valid_568255 != nil:
    section.add "accountName", valid_568255
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568256 = query.getOrDefault("api-version")
  valid_568256 = validateParameter(valid_568256, JString, required = true,
                                 default = nil)
  if valid_568256 != nil:
    section.add "api-version", valid_568256
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

proc call*(call_568258: Call_BlobContainersUpdate_568249; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates container properties as specified in request body. Properties not mentioned in the request will be unchanged. Update fails if the specified container doesn't already exist. 
  ## 
  let valid = call_568258.validator(path, query, header, formData, body)
  let scheme = call_568258.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568258.url(scheme.get, call_568258.host, call_568258.base,
                         call_568258.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568258, url, valid)

proc call*(call_568259: Call_BlobContainersUpdate_568249;
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
  var path_568260 = newJObject()
  var query_568261 = newJObject()
  var body_568262 = newJObject()
  add(path_568260, "resourceGroupName", newJString(resourceGroupName))
  add(query_568261, "api-version", newJString(apiVersion))
  if blobContainer != nil:
    body_568262 = blobContainer
  add(path_568260, "containerName", newJString(containerName))
  add(path_568260, "subscriptionId", newJString(subscriptionId))
  add(path_568260, "accountName", newJString(accountName))
  result = call_568259.call(path_568260, query_568261, nil, nil, body_568262)

var blobContainersUpdate* = Call_BlobContainersUpdate_568249(
    name: "blobContainersUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{accountName}/blobServices/default/containers/{containerName}",
    validator: validate_BlobContainersUpdate_568250, base: "",
    url: url_BlobContainersUpdate_568251, schemes: {Scheme.Https})
type
  Call_BlobContainersDelete_568237 = ref object of OpenApiRestCall_567658
proc url_BlobContainersDelete_568239(protocol: Scheme; host: string; base: string;
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

proc validate_BlobContainersDelete_568238(path: JsonNode; query: JsonNode;
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
  var valid_568240 = path.getOrDefault("resourceGroupName")
  valid_568240 = validateParameter(valid_568240, JString, required = true,
                                 default = nil)
  if valid_568240 != nil:
    section.add "resourceGroupName", valid_568240
  var valid_568241 = path.getOrDefault("containerName")
  valid_568241 = validateParameter(valid_568241, JString, required = true,
                                 default = nil)
  if valid_568241 != nil:
    section.add "containerName", valid_568241
  var valid_568242 = path.getOrDefault("subscriptionId")
  valid_568242 = validateParameter(valid_568242, JString, required = true,
                                 default = nil)
  if valid_568242 != nil:
    section.add "subscriptionId", valid_568242
  var valid_568243 = path.getOrDefault("accountName")
  valid_568243 = validateParameter(valid_568243, JString, required = true,
                                 default = nil)
  if valid_568243 != nil:
    section.add "accountName", valid_568243
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568244 = query.getOrDefault("api-version")
  valid_568244 = validateParameter(valid_568244, JString, required = true,
                                 default = nil)
  if valid_568244 != nil:
    section.add "api-version", valid_568244
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568245: Call_BlobContainersDelete_568237; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes specified container under its account.
  ## 
  let valid = call_568245.validator(path, query, header, formData, body)
  let scheme = call_568245.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568245.url(scheme.get, call_568245.host, call_568245.base,
                         call_568245.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568245, url, valid)

proc call*(call_568246: Call_BlobContainersDelete_568237;
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
  var path_568247 = newJObject()
  var query_568248 = newJObject()
  add(path_568247, "resourceGroupName", newJString(resourceGroupName))
  add(query_568248, "api-version", newJString(apiVersion))
  add(path_568247, "containerName", newJString(containerName))
  add(path_568247, "subscriptionId", newJString(subscriptionId))
  add(path_568247, "accountName", newJString(accountName))
  result = call_568246.call(path_568247, query_568248, nil, nil, nil)

var blobContainersDelete* = Call_BlobContainersDelete_568237(
    name: "blobContainersDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{accountName}/blobServices/default/containers/{containerName}",
    validator: validate_BlobContainersDelete_568238, base: "",
    url: url_BlobContainersDelete_568239, schemes: {Scheme.Https})
type
  Call_BlobContainersClearLegalHold_568263 = ref object of OpenApiRestCall_567658
proc url_BlobContainersClearLegalHold_568265(protocol: Scheme; host: string;
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

proc validate_BlobContainersClearLegalHold_568264(path: JsonNode; query: JsonNode;
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
  var valid_568276 = path.getOrDefault("resourceGroupName")
  valid_568276 = validateParameter(valid_568276, JString, required = true,
                                 default = nil)
  if valid_568276 != nil:
    section.add "resourceGroupName", valid_568276
  var valid_568277 = path.getOrDefault("containerName")
  valid_568277 = validateParameter(valid_568277, JString, required = true,
                                 default = nil)
  if valid_568277 != nil:
    section.add "containerName", valid_568277
  var valid_568278 = path.getOrDefault("subscriptionId")
  valid_568278 = validateParameter(valid_568278, JString, required = true,
                                 default = nil)
  if valid_568278 != nil:
    section.add "subscriptionId", valid_568278
  var valid_568279 = path.getOrDefault("accountName")
  valid_568279 = validateParameter(valid_568279, JString, required = true,
                                 default = nil)
  if valid_568279 != nil:
    section.add "accountName", valid_568279
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568280 = query.getOrDefault("api-version")
  valid_568280 = validateParameter(valid_568280, JString, required = true,
                                 default = nil)
  if valid_568280 != nil:
    section.add "api-version", valid_568280
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

proc call*(call_568282: Call_BlobContainersClearLegalHold_568263; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Clears legal hold tags. Clearing the same or non-existent tag results in an idempotent operation. ClearLegalHold clears out only the specified tags in the request.
  ## 
  let valid = call_568282.validator(path, query, header, formData, body)
  let scheme = call_568282.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568282.url(scheme.get, call_568282.host, call_568282.base,
                         call_568282.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568282, url, valid)

proc call*(call_568283: Call_BlobContainersClearLegalHold_568263;
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
  var path_568284 = newJObject()
  var query_568285 = newJObject()
  var body_568286 = newJObject()
  add(path_568284, "resourceGroupName", newJString(resourceGroupName))
  add(query_568285, "api-version", newJString(apiVersion))
  add(path_568284, "containerName", newJString(containerName))
  if LegalHold != nil:
    body_568286 = LegalHold
  add(path_568284, "subscriptionId", newJString(subscriptionId))
  add(path_568284, "accountName", newJString(accountName))
  result = call_568283.call(path_568284, query_568285, nil, nil, body_568286)

var blobContainersClearLegalHold* = Call_BlobContainersClearLegalHold_568263(
    name: "blobContainersClearLegalHold", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{accountName}/blobServices/default/containers/{containerName}/clearLegalHold",
    validator: validate_BlobContainersClearLegalHold_568264, base: "",
    url: url_BlobContainersClearLegalHold_568265, schemes: {Scheme.Https})
type
  Call_BlobContainersExtendImmutabilityPolicy_568287 = ref object of OpenApiRestCall_567658
proc url_BlobContainersExtendImmutabilityPolicy_568289(protocol: Scheme;
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

proc validate_BlobContainersExtendImmutabilityPolicy_568288(path: JsonNode;
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
  var valid_568290 = path.getOrDefault("resourceGroupName")
  valid_568290 = validateParameter(valid_568290, JString, required = true,
                                 default = nil)
  if valid_568290 != nil:
    section.add "resourceGroupName", valid_568290
  var valid_568291 = path.getOrDefault("containerName")
  valid_568291 = validateParameter(valid_568291, JString, required = true,
                                 default = nil)
  if valid_568291 != nil:
    section.add "containerName", valid_568291
  var valid_568292 = path.getOrDefault("subscriptionId")
  valid_568292 = validateParameter(valid_568292, JString, required = true,
                                 default = nil)
  if valid_568292 != nil:
    section.add "subscriptionId", valid_568292
  var valid_568293 = path.getOrDefault("accountName")
  valid_568293 = validateParameter(valid_568293, JString, required = true,
                                 default = nil)
  if valid_568293 != nil:
    section.add "accountName", valid_568293
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568294 = query.getOrDefault("api-version")
  valid_568294 = validateParameter(valid_568294, JString, required = true,
                                 default = nil)
  if valid_568294 != nil:
    section.add "api-version", valid_568294
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : The entity state (ETag) version of the immutability policy to update. A value of "*" can be used to apply the operation only if the immutability policy already exists. If omitted, this operation will always be applied.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_568295 = header.getOrDefault("If-Match")
  valid_568295 = validateParameter(valid_568295, JString, required = true,
                                 default = nil)
  if valid_568295 != nil:
    section.add "If-Match", valid_568295
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject
  ##             : The ImmutabilityPolicy Properties that will be extended for a blob container.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568297: Call_BlobContainersExtendImmutabilityPolicy_568287;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Extends the immutabilityPeriodSinceCreationInDays of a locked immutabilityPolicy. The only action allowed on a Locked policy will be this action. ETag in If-Match is required for this operation.
  ## 
  let valid = call_568297.validator(path, query, header, formData, body)
  let scheme = call_568297.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568297.url(scheme.get, call_568297.host, call_568297.base,
                         call_568297.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568297, url, valid)

proc call*(call_568298: Call_BlobContainersExtendImmutabilityPolicy_568287;
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
  var path_568299 = newJObject()
  var query_568300 = newJObject()
  var body_568301 = newJObject()
  add(path_568299, "resourceGroupName", newJString(resourceGroupName))
  add(query_568300, "api-version", newJString(apiVersion))
  add(path_568299, "containerName", newJString(containerName))
  add(path_568299, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568301 = parameters
  add(path_568299, "accountName", newJString(accountName))
  result = call_568298.call(path_568299, query_568300, nil, nil, body_568301)

var blobContainersExtendImmutabilityPolicy* = Call_BlobContainersExtendImmutabilityPolicy_568287(
    name: "blobContainersExtendImmutabilityPolicy", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{accountName}/blobServices/default/containers/{containerName}/immutabilityPolicies/default/extend",
    validator: validate_BlobContainersExtendImmutabilityPolicy_568288, base: "",
    url: url_BlobContainersExtendImmutabilityPolicy_568289,
    schemes: {Scheme.Https})
type
  Call_BlobContainersLockImmutabilityPolicy_568302 = ref object of OpenApiRestCall_567658
proc url_BlobContainersLockImmutabilityPolicy_568304(protocol: Scheme;
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

proc validate_BlobContainersLockImmutabilityPolicy_568303(path: JsonNode;
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
  if body != nil:
    result.add "body", body

proc call*(call_568311: Call_BlobContainersLockImmutabilityPolicy_568302;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the ImmutabilityPolicy to Locked state. The only action allowed on a Locked policy is ExtendImmutabilityPolicy action. ETag in If-Match is required for this operation.
  ## 
  let valid = call_568311.validator(path, query, header, formData, body)
  let scheme = call_568311.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568311.url(scheme.get, call_568311.host, call_568311.base,
                         call_568311.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568311, url, valid)

proc call*(call_568312: Call_BlobContainersLockImmutabilityPolicy_568302;
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
  var path_568313 = newJObject()
  var query_568314 = newJObject()
  add(path_568313, "resourceGroupName", newJString(resourceGroupName))
  add(query_568314, "api-version", newJString(apiVersion))
  add(path_568313, "containerName", newJString(containerName))
  add(path_568313, "subscriptionId", newJString(subscriptionId))
  add(path_568313, "accountName", newJString(accountName))
  result = call_568312.call(path_568313, query_568314, nil, nil, nil)

var blobContainersLockImmutabilityPolicy* = Call_BlobContainersLockImmutabilityPolicy_568302(
    name: "blobContainersLockImmutabilityPolicy", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{accountName}/blobServices/default/containers/{containerName}/immutabilityPolicies/default/lock",
    validator: validate_BlobContainersLockImmutabilityPolicy_568303, base: "",
    url: url_BlobContainersLockImmutabilityPolicy_568304, schemes: {Scheme.Https})
type
  Call_BlobContainersCreateOrUpdateImmutabilityPolicy_568342 = ref object of OpenApiRestCall_567658
proc url_BlobContainersCreateOrUpdateImmutabilityPolicy_568344(protocol: Scheme;
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

proc validate_BlobContainersCreateOrUpdateImmutabilityPolicy_568343(
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
  var valid_568345 = path.getOrDefault("resourceGroupName")
  valid_568345 = validateParameter(valid_568345, JString, required = true,
                                 default = nil)
  if valid_568345 != nil:
    section.add "resourceGroupName", valid_568345
  var valid_568346 = path.getOrDefault("containerName")
  valid_568346 = validateParameter(valid_568346, JString, required = true,
                                 default = nil)
  if valid_568346 != nil:
    section.add "containerName", valid_568346
  var valid_568347 = path.getOrDefault("subscriptionId")
  valid_568347 = validateParameter(valid_568347, JString, required = true,
                                 default = nil)
  if valid_568347 != nil:
    section.add "subscriptionId", valid_568347
  var valid_568348 = path.getOrDefault("immutabilityPolicyName")
  valid_568348 = validateParameter(valid_568348, JString, required = true,
                                 default = newJString("default"))
  if valid_568348 != nil:
    section.add "immutabilityPolicyName", valid_568348
  var valid_568349 = path.getOrDefault("accountName")
  valid_568349 = validateParameter(valid_568349, JString, required = true,
                                 default = nil)
  if valid_568349 != nil:
    section.add "accountName", valid_568349
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568350 = query.getOrDefault("api-version")
  valid_568350 = validateParameter(valid_568350, JString, required = true,
                                 default = nil)
  if valid_568350 != nil:
    section.add "api-version", valid_568350
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : The entity state (ETag) version of the immutability policy to update. A value of "*" can be used to apply the operation only if the immutability policy already exists. If omitted, this operation will always be applied.
  section = newJObject()
  var valid_568351 = header.getOrDefault("If-Match")
  valid_568351 = validateParameter(valid_568351, JString, required = false,
                                 default = nil)
  if valid_568351 != nil:
    section.add "If-Match", valid_568351
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject
  ##             : The ImmutabilityPolicy Properties that will be created or updated to a blob container.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568353: Call_BlobContainersCreateOrUpdateImmutabilityPolicy_568342;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates an unlocked immutability policy. ETag in If-Match is honored if given but not required for this operation.
  ## 
  let valid = call_568353.validator(path, query, header, formData, body)
  let scheme = call_568353.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568353.url(scheme.get, call_568353.host, call_568353.base,
                         call_568353.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568353, url, valid)

proc call*(call_568354: Call_BlobContainersCreateOrUpdateImmutabilityPolicy_568342;
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
  var path_568355 = newJObject()
  var query_568356 = newJObject()
  var body_568357 = newJObject()
  add(path_568355, "resourceGroupName", newJString(resourceGroupName))
  add(query_568356, "api-version", newJString(apiVersion))
  add(path_568355, "containerName", newJString(containerName))
  add(path_568355, "subscriptionId", newJString(subscriptionId))
  add(path_568355, "immutabilityPolicyName", newJString(immutabilityPolicyName))
  if parameters != nil:
    body_568357 = parameters
  add(path_568355, "accountName", newJString(accountName))
  result = call_568354.call(path_568355, query_568356, nil, nil, body_568357)

var blobContainersCreateOrUpdateImmutabilityPolicy* = Call_BlobContainersCreateOrUpdateImmutabilityPolicy_568342(
    name: "blobContainersCreateOrUpdateImmutabilityPolicy",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{accountName}/blobServices/default/containers/{containerName}/immutabilityPolicies/{immutabilityPolicyName}",
    validator: validate_BlobContainersCreateOrUpdateImmutabilityPolicy_568343,
    base: "", url: url_BlobContainersCreateOrUpdateImmutabilityPolicy_568344,
    schemes: {Scheme.Https})
type
  Call_BlobContainersGetImmutabilityPolicy_568315 = ref object of OpenApiRestCall_567658
proc url_BlobContainersGetImmutabilityPolicy_568317(protocol: Scheme; host: string;
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

proc validate_BlobContainersGetImmutabilityPolicy_568316(path: JsonNode;
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
  var valid_568318 = path.getOrDefault("resourceGroupName")
  valid_568318 = validateParameter(valid_568318, JString, required = true,
                                 default = nil)
  if valid_568318 != nil:
    section.add "resourceGroupName", valid_568318
  var valid_568319 = path.getOrDefault("containerName")
  valid_568319 = validateParameter(valid_568319, JString, required = true,
                                 default = nil)
  if valid_568319 != nil:
    section.add "containerName", valid_568319
  var valid_568320 = path.getOrDefault("subscriptionId")
  valid_568320 = validateParameter(valid_568320, JString, required = true,
                                 default = nil)
  if valid_568320 != nil:
    section.add "subscriptionId", valid_568320
  var valid_568334 = path.getOrDefault("immutabilityPolicyName")
  valid_568334 = validateParameter(valid_568334, JString, required = true,
                                 default = newJString("default"))
  if valid_568334 != nil:
    section.add "immutabilityPolicyName", valid_568334
  var valid_568335 = path.getOrDefault("accountName")
  valid_568335 = validateParameter(valid_568335, JString, required = true,
                                 default = nil)
  if valid_568335 != nil:
    section.add "accountName", valid_568335
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568336 = query.getOrDefault("api-version")
  valid_568336 = validateParameter(valid_568336, JString, required = true,
                                 default = nil)
  if valid_568336 != nil:
    section.add "api-version", valid_568336
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : The entity state (ETag) version of the immutability policy to update. A value of "*" can be used to apply the operation only if the immutability policy already exists. If omitted, this operation will always be applied.
  section = newJObject()
  var valid_568337 = header.getOrDefault("If-Match")
  valid_568337 = validateParameter(valid_568337, JString, required = false,
                                 default = nil)
  if valid_568337 != nil:
    section.add "If-Match", valid_568337
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568338: Call_BlobContainersGetImmutabilityPolicy_568315;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the existing immutability policy along with the corresponding ETag in response headers and body.
  ## 
  let valid = call_568338.validator(path, query, header, formData, body)
  let scheme = call_568338.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568338.url(scheme.get, call_568338.host, call_568338.base,
                         call_568338.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568338, url, valid)

proc call*(call_568339: Call_BlobContainersGetImmutabilityPolicy_568315;
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
  var path_568340 = newJObject()
  var query_568341 = newJObject()
  add(path_568340, "resourceGroupName", newJString(resourceGroupName))
  add(query_568341, "api-version", newJString(apiVersion))
  add(path_568340, "containerName", newJString(containerName))
  add(path_568340, "subscriptionId", newJString(subscriptionId))
  add(path_568340, "immutabilityPolicyName", newJString(immutabilityPolicyName))
  add(path_568340, "accountName", newJString(accountName))
  result = call_568339.call(path_568340, query_568341, nil, nil, nil)

var blobContainersGetImmutabilityPolicy* = Call_BlobContainersGetImmutabilityPolicy_568315(
    name: "blobContainersGetImmutabilityPolicy", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{accountName}/blobServices/default/containers/{containerName}/immutabilityPolicies/{immutabilityPolicyName}",
    validator: validate_BlobContainersGetImmutabilityPolicy_568316, base: "",
    url: url_BlobContainersGetImmutabilityPolicy_568317, schemes: {Scheme.Https})
type
  Call_BlobContainersDeleteImmutabilityPolicy_568358 = ref object of OpenApiRestCall_567658
proc url_BlobContainersDeleteImmutabilityPolicy_568360(protocol: Scheme;
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

proc validate_BlobContainersDeleteImmutabilityPolicy_568359(path: JsonNode;
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
  var valid_568361 = path.getOrDefault("resourceGroupName")
  valid_568361 = validateParameter(valid_568361, JString, required = true,
                                 default = nil)
  if valid_568361 != nil:
    section.add "resourceGroupName", valid_568361
  var valid_568362 = path.getOrDefault("containerName")
  valid_568362 = validateParameter(valid_568362, JString, required = true,
                                 default = nil)
  if valid_568362 != nil:
    section.add "containerName", valid_568362
  var valid_568363 = path.getOrDefault("subscriptionId")
  valid_568363 = validateParameter(valid_568363, JString, required = true,
                                 default = nil)
  if valid_568363 != nil:
    section.add "subscriptionId", valid_568363
  var valid_568364 = path.getOrDefault("immutabilityPolicyName")
  valid_568364 = validateParameter(valid_568364, JString, required = true,
                                 default = newJString("default"))
  if valid_568364 != nil:
    section.add "immutabilityPolicyName", valid_568364
  var valid_568365 = path.getOrDefault("accountName")
  valid_568365 = validateParameter(valid_568365, JString, required = true,
                                 default = nil)
  if valid_568365 != nil:
    section.add "accountName", valid_568365
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568366 = query.getOrDefault("api-version")
  valid_568366 = validateParameter(valid_568366, JString, required = true,
                                 default = nil)
  if valid_568366 != nil:
    section.add "api-version", valid_568366
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : The entity state (ETag) version of the immutability policy to update. A value of "*" can be used to apply the operation only if the immutability policy already exists. If omitted, this operation will always be applied.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_568367 = header.getOrDefault("If-Match")
  valid_568367 = validateParameter(valid_568367, JString, required = true,
                                 default = nil)
  if valid_568367 != nil:
    section.add "If-Match", valid_568367
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568368: Call_BlobContainersDeleteImmutabilityPolicy_568358;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Aborts an unlocked immutability policy. The response of delete has immutabilityPeriodSinceCreationInDays set to 0. ETag in If-Match is required for this operation. Deleting a locked immutability policy is not allowed, only way is to delete the container after deleting all blobs inside the container.
  ## 
  let valid = call_568368.validator(path, query, header, formData, body)
  let scheme = call_568368.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568368.url(scheme.get, call_568368.host, call_568368.base,
                         call_568368.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568368, url, valid)

proc call*(call_568369: Call_BlobContainersDeleteImmutabilityPolicy_568358;
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
  var path_568370 = newJObject()
  var query_568371 = newJObject()
  add(path_568370, "resourceGroupName", newJString(resourceGroupName))
  add(query_568371, "api-version", newJString(apiVersion))
  add(path_568370, "containerName", newJString(containerName))
  add(path_568370, "subscriptionId", newJString(subscriptionId))
  add(path_568370, "immutabilityPolicyName", newJString(immutabilityPolicyName))
  add(path_568370, "accountName", newJString(accountName))
  result = call_568369.call(path_568370, query_568371, nil, nil, nil)

var blobContainersDeleteImmutabilityPolicy* = Call_BlobContainersDeleteImmutabilityPolicy_568358(
    name: "blobContainersDeleteImmutabilityPolicy", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{accountName}/blobServices/default/containers/{containerName}/immutabilityPolicies/{immutabilityPolicyName}",
    validator: validate_BlobContainersDeleteImmutabilityPolicy_568359, base: "",
    url: url_BlobContainersDeleteImmutabilityPolicy_568360,
    schemes: {Scheme.Https})
type
  Call_BlobContainersSetLegalHold_568372 = ref object of OpenApiRestCall_567658
proc url_BlobContainersSetLegalHold_568374(protocol: Scheme; host: string;
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

proc validate_BlobContainersSetLegalHold_568373(path: JsonNode; query: JsonNode;
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
  var valid_568375 = path.getOrDefault("resourceGroupName")
  valid_568375 = validateParameter(valid_568375, JString, required = true,
                                 default = nil)
  if valid_568375 != nil:
    section.add "resourceGroupName", valid_568375
  var valid_568376 = path.getOrDefault("containerName")
  valid_568376 = validateParameter(valid_568376, JString, required = true,
                                 default = nil)
  if valid_568376 != nil:
    section.add "containerName", valid_568376
  var valid_568377 = path.getOrDefault("subscriptionId")
  valid_568377 = validateParameter(valid_568377, JString, required = true,
                                 default = nil)
  if valid_568377 != nil:
    section.add "subscriptionId", valid_568377
  var valid_568378 = path.getOrDefault("accountName")
  valid_568378 = validateParameter(valid_568378, JString, required = true,
                                 default = nil)
  if valid_568378 != nil:
    section.add "accountName", valid_568378
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568379 = query.getOrDefault("api-version")
  valid_568379 = validateParameter(valid_568379, JString, required = true,
                                 default = nil)
  if valid_568379 != nil:
    section.add "api-version", valid_568379
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

proc call*(call_568381: Call_BlobContainersSetLegalHold_568372; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sets legal hold tags. Setting the same tag results in an idempotent operation. SetLegalHold follows an append pattern and does not clear out the existing tags that are not specified in the request.
  ## 
  let valid = call_568381.validator(path, query, header, formData, body)
  let scheme = call_568381.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568381.url(scheme.get, call_568381.host, call_568381.base,
                         call_568381.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568381, url, valid)

proc call*(call_568382: Call_BlobContainersSetLegalHold_568372;
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
  var path_568383 = newJObject()
  var query_568384 = newJObject()
  var body_568385 = newJObject()
  add(path_568383, "resourceGroupName", newJString(resourceGroupName))
  add(query_568384, "api-version", newJString(apiVersion))
  add(path_568383, "containerName", newJString(containerName))
  if LegalHold != nil:
    body_568385 = LegalHold
  add(path_568383, "subscriptionId", newJString(subscriptionId))
  add(path_568383, "accountName", newJString(accountName))
  result = call_568382.call(path_568383, query_568384, nil, nil, body_568385)

var blobContainersSetLegalHold* = Call_BlobContainersSetLegalHold_568372(
    name: "blobContainersSetLegalHold", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{accountName}/blobServices/default/containers/{containerName}/setLegalHold",
    validator: validate_BlobContainersSetLegalHold_568373, base: "",
    url: url_BlobContainersSetLegalHold_568374, schemes: {Scheme.Https})
type
  Call_BlobServicesSetServiceProperties_568398 = ref object of OpenApiRestCall_567658
proc url_BlobServicesSetServiceProperties_568400(protocol: Scheme; host: string;
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

proc validate_BlobServicesSetServiceProperties_568399(path: JsonNode;
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
  var valid_568401 = path.getOrDefault("resourceGroupName")
  valid_568401 = validateParameter(valid_568401, JString, required = true,
                                 default = nil)
  if valid_568401 != nil:
    section.add "resourceGroupName", valid_568401
  var valid_568402 = path.getOrDefault("subscriptionId")
  valid_568402 = validateParameter(valid_568402, JString, required = true,
                                 default = nil)
  if valid_568402 != nil:
    section.add "subscriptionId", valid_568402
  var valid_568403 = path.getOrDefault("BlobServicesName")
  valid_568403 = validateParameter(valid_568403, JString, required = true,
                                 default = newJString("default"))
  if valid_568403 != nil:
    section.add "BlobServicesName", valid_568403
  var valid_568404 = path.getOrDefault("accountName")
  valid_568404 = validateParameter(valid_568404, JString, required = true,
                                 default = nil)
  if valid_568404 != nil:
    section.add "accountName", valid_568404
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568405 = query.getOrDefault("api-version")
  valid_568405 = validateParameter(valid_568405, JString, required = true,
                                 default = nil)
  if valid_568405 != nil:
    section.add "api-version", valid_568405
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

proc call*(call_568407: Call_BlobServicesSetServiceProperties_568398;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the properties of a storage account’s Blob service, including properties for Storage Analytics and CORS (Cross-Origin Resource Sharing) rules. 
  ## 
  let valid = call_568407.validator(path, query, header, formData, body)
  let scheme = call_568407.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568407.url(scheme.get, call_568407.host, call_568407.base,
                         call_568407.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568407, url, valid)

proc call*(call_568408: Call_BlobServicesSetServiceProperties_568398;
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
  var path_568409 = newJObject()
  var query_568410 = newJObject()
  var body_568411 = newJObject()
  add(path_568409, "resourceGroupName", newJString(resourceGroupName))
  add(query_568410, "api-version", newJString(apiVersion))
  add(path_568409, "subscriptionId", newJString(subscriptionId))
  add(path_568409, "BlobServicesName", newJString(BlobServicesName))
  if parameters != nil:
    body_568411 = parameters
  add(path_568409, "accountName", newJString(accountName))
  result = call_568408.call(path_568409, query_568410, nil, nil, body_568411)

var blobServicesSetServiceProperties* = Call_BlobServicesSetServiceProperties_568398(
    name: "blobServicesSetServiceProperties", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{accountName}/blobServices/{BlobServicesName}",
    validator: validate_BlobServicesSetServiceProperties_568399, base: "",
    url: url_BlobServicesSetServiceProperties_568400, schemes: {Scheme.Https})
type
  Call_BlobServicesGetServiceProperties_568386 = ref object of OpenApiRestCall_567658
proc url_BlobServicesGetServiceProperties_568388(protocol: Scheme; host: string;
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

proc validate_BlobServicesGetServiceProperties_568387(path: JsonNode;
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
  var valid_568389 = path.getOrDefault("resourceGroupName")
  valid_568389 = validateParameter(valid_568389, JString, required = true,
                                 default = nil)
  if valid_568389 != nil:
    section.add "resourceGroupName", valid_568389
  var valid_568390 = path.getOrDefault("subscriptionId")
  valid_568390 = validateParameter(valid_568390, JString, required = true,
                                 default = nil)
  if valid_568390 != nil:
    section.add "subscriptionId", valid_568390
  var valid_568391 = path.getOrDefault("BlobServicesName")
  valid_568391 = validateParameter(valid_568391, JString, required = true,
                                 default = newJString("default"))
  if valid_568391 != nil:
    section.add "BlobServicesName", valid_568391
  var valid_568392 = path.getOrDefault("accountName")
  valid_568392 = validateParameter(valid_568392, JString, required = true,
                                 default = nil)
  if valid_568392 != nil:
    section.add "accountName", valid_568392
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568393 = query.getOrDefault("api-version")
  valid_568393 = validateParameter(valid_568393, JString, required = true,
                                 default = nil)
  if valid_568393 != nil:
    section.add "api-version", valid_568393
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568394: Call_BlobServicesGetServiceProperties_568386;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the properties of a storage account’s Blob service, including properties for Storage Analytics and CORS (Cross-Origin Resource Sharing) rules.
  ## 
  let valid = call_568394.validator(path, query, header, formData, body)
  let scheme = call_568394.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568394.url(scheme.get, call_568394.host, call_568394.base,
                         call_568394.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568394, url, valid)

proc call*(call_568395: Call_BlobServicesGetServiceProperties_568386;
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
  var path_568396 = newJObject()
  var query_568397 = newJObject()
  add(path_568396, "resourceGroupName", newJString(resourceGroupName))
  add(query_568397, "api-version", newJString(apiVersion))
  add(path_568396, "subscriptionId", newJString(subscriptionId))
  add(path_568396, "BlobServicesName", newJString(BlobServicesName))
  add(path_568396, "accountName", newJString(accountName))
  result = call_568395.call(path_568396, query_568397, nil, nil, nil)

var blobServicesGetServiceProperties* = Call_BlobServicesGetServiceProperties_568386(
    name: "blobServicesGetServiceProperties", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{accountName}/blobServices/{BlobServicesName}",
    validator: validate_BlobServicesGetServiceProperties_568387, base: "",
    url: url_BlobServicesGetServiceProperties_568388, schemes: {Scheme.Https})
type
  Call_BlobContainersLease_568412 = ref object of OpenApiRestCall_567658
proc url_BlobContainersLease_568414(protocol: Scheme; host: string; base: string;
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
               (kind: ConstantSegment, value: "/resourcegroups/"),
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

proc validate_BlobContainersLease_568413(path: JsonNode; query: JsonNode;
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
  var valid_568415 = path.getOrDefault("resourceGroupName")
  valid_568415 = validateParameter(valid_568415, JString, required = true,
                                 default = nil)
  if valid_568415 != nil:
    section.add "resourceGroupName", valid_568415
  var valid_568416 = path.getOrDefault("containerName")
  valid_568416 = validateParameter(valid_568416, JString, required = true,
                                 default = nil)
  if valid_568416 != nil:
    section.add "containerName", valid_568416
  var valid_568417 = path.getOrDefault("subscriptionId")
  valid_568417 = validateParameter(valid_568417, JString, required = true,
                                 default = nil)
  if valid_568417 != nil:
    section.add "subscriptionId", valid_568417
  var valid_568418 = path.getOrDefault("accountName")
  valid_568418 = validateParameter(valid_568418, JString, required = true,
                                 default = nil)
  if valid_568418 != nil:
    section.add "accountName", valid_568418
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568419 = query.getOrDefault("api-version")
  valid_568419 = validateParameter(valid_568419, JString, required = true,
                                 default = nil)
  if valid_568419 != nil:
    section.add "api-version", valid_568419
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

proc call*(call_568421: Call_BlobContainersLease_568412; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Lease Container operation establishes and manages a lock on a container for delete operations. The lock duration can be 15 to 60 seconds, or can be infinite.
  ## 
  let valid = call_568421.validator(path, query, header, formData, body)
  let scheme = call_568421.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568421.url(scheme.get, call_568421.host, call_568421.base,
                         call_568421.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568421, url, valid)

proc call*(call_568422: Call_BlobContainersLease_568412; resourceGroupName: string;
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
  var path_568423 = newJObject()
  var query_568424 = newJObject()
  var body_568425 = newJObject()
  add(path_568423, "resourceGroupName", newJString(resourceGroupName))
  add(query_568424, "api-version", newJString(apiVersion))
  add(path_568423, "containerName", newJString(containerName))
  add(path_568423, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568425 = parameters
  add(path_568423, "accountName", newJString(accountName))
  result = call_568422.call(path_568423, query_568424, nil, nil, body_568425)

var blobContainersLease* = Call_BlobContainersLease_568412(
    name: "blobContainersLease", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{accountName}/blobServices/default/containers/{containerName}/lease",
    validator: validate_BlobContainersLease_568413, base: "",
    url: url_BlobContainersLease_568414, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
