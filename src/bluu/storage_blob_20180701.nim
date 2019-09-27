
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: StorageManagementClient
## version: 2018-07-01
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
  macServiceName = "storage-blob"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_BlobContainersList_593647 = ref object of OpenApiRestCall_593425
proc url_BlobContainersList_593649(protocol: Scheme; host: string; base: string;
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

proc validate_BlobContainersList_593648(path: JsonNode; query: JsonNode;
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
  var valid_593809 = path.getOrDefault("resourceGroupName")
  valid_593809 = validateParameter(valid_593809, JString, required = true,
                                 default = nil)
  if valid_593809 != nil:
    section.add "resourceGroupName", valid_593809
  var valid_593810 = path.getOrDefault("subscriptionId")
  valid_593810 = validateParameter(valid_593810, JString, required = true,
                                 default = nil)
  if valid_593810 != nil:
    section.add "subscriptionId", valid_593810
  var valid_593811 = path.getOrDefault("accountName")
  valid_593811 = validateParameter(valid_593811, JString, required = true,
                                 default = nil)
  if valid_593811 != nil:
    section.add "accountName", valid_593811
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593812 = query.getOrDefault("api-version")
  valid_593812 = validateParameter(valid_593812, JString, required = true,
                                 default = nil)
  if valid_593812 != nil:
    section.add "api-version", valid_593812
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593839: Call_BlobContainersList_593647; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all containers and does not support a prefix like data plane. Also SRP today does not return continuation token.
  ## 
  let valid = call_593839.validator(path, query, header, formData, body)
  let scheme = call_593839.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593839.url(scheme.get, call_593839.host, call_593839.base,
                         call_593839.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593839, url, valid)

proc call*(call_593910: Call_BlobContainersList_593647; resourceGroupName: string;
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
  var path_593911 = newJObject()
  var query_593913 = newJObject()
  add(path_593911, "resourceGroupName", newJString(resourceGroupName))
  add(query_593913, "api-version", newJString(apiVersion))
  add(path_593911, "subscriptionId", newJString(subscriptionId))
  add(path_593911, "accountName", newJString(accountName))
  result = call_593910.call(path_593911, query_593913, nil, nil, nil)

var blobContainersList* = Call_BlobContainersList_593647(
    name: "blobContainersList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{accountName}/blobServices/default/containers",
    validator: validate_BlobContainersList_593648, base: "",
    url: url_BlobContainersList_593649, schemes: {Scheme.Https})
type
  Call_BlobContainersCreate_593973 = ref object of OpenApiRestCall_593425
proc url_BlobContainersCreate_593975(protocol: Scheme; host: string; base: string;
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

proc validate_BlobContainersCreate_593974(path: JsonNode; query: JsonNode;
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
  var valid_593993 = path.getOrDefault("resourceGroupName")
  valid_593993 = validateParameter(valid_593993, JString, required = true,
                                 default = nil)
  if valid_593993 != nil:
    section.add "resourceGroupName", valid_593993
  var valid_593994 = path.getOrDefault("containerName")
  valid_593994 = validateParameter(valid_593994, JString, required = true,
                                 default = nil)
  if valid_593994 != nil:
    section.add "containerName", valid_593994
  var valid_593995 = path.getOrDefault("subscriptionId")
  valid_593995 = validateParameter(valid_593995, JString, required = true,
                                 default = nil)
  if valid_593995 != nil:
    section.add "subscriptionId", valid_593995
  var valid_593996 = path.getOrDefault("accountName")
  valid_593996 = validateParameter(valid_593996, JString, required = true,
                                 default = nil)
  if valid_593996 != nil:
    section.add "accountName", valid_593996
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593997 = query.getOrDefault("api-version")
  valid_593997 = validateParameter(valid_593997, JString, required = true,
                                 default = nil)
  if valid_593997 != nil:
    section.add "api-version", valid_593997
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

proc call*(call_593999: Call_BlobContainersCreate_593973; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new container under the specified account as described by request body. The container resource includes metadata and properties for that container. It does not include a list of the blobs contained by the container. 
  ## 
  let valid = call_593999.validator(path, query, header, formData, body)
  let scheme = call_593999.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593999.url(scheme.get, call_593999.host, call_593999.base,
                         call_593999.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593999, url, valid)

proc call*(call_594000: Call_BlobContainersCreate_593973;
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
  var path_594001 = newJObject()
  var query_594002 = newJObject()
  var body_594003 = newJObject()
  add(path_594001, "resourceGroupName", newJString(resourceGroupName))
  add(query_594002, "api-version", newJString(apiVersion))
  if blobContainer != nil:
    body_594003 = blobContainer
  add(path_594001, "containerName", newJString(containerName))
  add(path_594001, "subscriptionId", newJString(subscriptionId))
  add(path_594001, "accountName", newJString(accountName))
  result = call_594000.call(path_594001, query_594002, nil, nil, body_594003)

var blobContainersCreate* = Call_BlobContainersCreate_593973(
    name: "blobContainersCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{accountName}/blobServices/default/containers/{containerName}",
    validator: validate_BlobContainersCreate_593974, base: "",
    url: url_BlobContainersCreate_593975, schemes: {Scheme.Https})
type
  Call_BlobContainersGet_593952 = ref object of OpenApiRestCall_593425
proc url_BlobContainersGet_593954(protocol: Scheme; host: string; base: string;
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

proc validate_BlobContainersGet_593953(path: JsonNode; query: JsonNode;
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
  var valid_593964 = path.getOrDefault("resourceGroupName")
  valid_593964 = validateParameter(valid_593964, JString, required = true,
                                 default = nil)
  if valid_593964 != nil:
    section.add "resourceGroupName", valid_593964
  var valid_593965 = path.getOrDefault("containerName")
  valid_593965 = validateParameter(valid_593965, JString, required = true,
                                 default = nil)
  if valid_593965 != nil:
    section.add "containerName", valid_593965
  var valid_593966 = path.getOrDefault("subscriptionId")
  valid_593966 = validateParameter(valid_593966, JString, required = true,
                                 default = nil)
  if valid_593966 != nil:
    section.add "subscriptionId", valid_593966
  var valid_593967 = path.getOrDefault("accountName")
  valid_593967 = validateParameter(valid_593967, JString, required = true,
                                 default = nil)
  if valid_593967 != nil:
    section.add "accountName", valid_593967
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593968 = query.getOrDefault("api-version")
  valid_593968 = validateParameter(valid_593968, JString, required = true,
                                 default = nil)
  if valid_593968 != nil:
    section.add "api-version", valid_593968
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593969: Call_BlobContainersGet_593952; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets properties of a specified container. 
  ## 
  let valid = call_593969.validator(path, query, header, formData, body)
  let scheme = call_593969.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593969.url(scheme.get, call_593969.host, call_593969.base,
                         call_593969.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593969, url, valid)

proc call*(call_593970: Call_BlobContainersGet_593952; resourceGroupName: string;
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
  var path_593971 = newJObject()
  var query_593972 = newJObject()
  add(path_593971, "resourceGroupName", newJString(resourceGroupName))
  add(query_593972, "api-version", newJString(apiVersion))
  add(path_593971, "containerName", newJString(containerName))
  add(path_593971, "subscriptionId", newJString(subscriptionId))
  add(path_593971, "accountName", newJString(accountName))
  result = call_593970.call(path_593971, query_593972, nil, nil, nil)

var blobContainersGet* = Call_BlobContainersGet_593952(name: "blobContainersGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{accountName}/blobServices/default/containers/{containerName}",
    validator: validate_BlobContainersGet_593953, base: "",
    url: url_BlobContainersGet_593954, schemes: {Scheme.Https})
type
  Call_BlobContainersUpdate_594016 = ref object of OpenApiRestCall_593425
proc url_BlobContainersUpdate_594018(protocol: Scheme; host: string; base: string;
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

proc validate_BlobContainersUpdate_594017(path: JsonNode; query: JsonNode;
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
  var valid_594019 = path.getOrDefault("resourceGroupName")
  valid_594019 = validateParameter(valid_594019, JString, required = true,
                                 default = nil)
  if valid_594019 != nil:
    section.add "resourceGroupName", valid_594019
  var valid_594020 = path.getOrDefault("containerName")
  valid_594020 = validateParameter(valid_594020, JString, required = true,
                                 default = nil)
  if valid_594020 != nil:
    section.add "containerName", valid_594020
  var valid_594021 = path.getOrDefault("subscriptionId")
  valid_594021 = validateParameter(valid_594021, JString, required = true,
                                 default = nil)
  if valid_594021 != nil:
    section.add "subscriptionId", valid_594021
  var valid_594022 = path.getOrDefault("accountName")
  valid_594022 = validateParameter(valid_594022, JString, required = true,
                                 default = nil)
  if valid_594022 != nil:
    section.add "accountName", valid_594022
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594023 = query.getOrDefault("api-version")
  valid_594023 = validateParameter(valid_594023, JString, required = true,
                                 default = nil)
  if valid_594023 != nil:
    section.add "api-version", valid_594023
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

proc call*(call_594025: Call_BlobContainersUpdate_594016; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates container properties as specified in request body. Properties not mentioned in the request will be unchanged. Update fails if the specified container doesn't already exist. 
  ## 
  let valid = call_594025.validator(path, query, header, formData, body)
  let scheme = call_594025.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594025.url(scheme.get, call_594025.host, call_594025.base,
                         call_594025.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594025, url, valid)

proc call*(call_594026: Call_BlobContainersUpdate_594016;
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
  var path_594027 = newJObject()
  var query_594028 = newJObject()
  var body_594029 = newJObject()
  add(path_594027, "resourceGroupName", newJString(resourceGroupName))
  add(query_594028, "api-version", newJString(apiVersion))
  if blobContainer != nil:
    body_594029 = blobContainer
  add(path_594027, "containerName", newJString(containerName))
  add(path_594027, "subscriptionId", newJString(subscriptionId))
  add(path_594027, "accountName", newJString(accountName))
  result = call_594026.call(path_594027, query_594028, nil, nil, body_594029)

var blobContainersUpdate* = Call_BlobContainersUpdate_594016(
    name: "blobContainersUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{accountName}/blobServices/default/containers/{containerName}",
    validator: validate_BlobContainersUpdate_594017, base: "",
    url: url_BlobContainersUpdate_594018, schemes: {Scheme.Https})
type
  Call_BlobContainersDelete_594004 = ref object of OpenApiRestCall_593425
proc url_BlobContainersDelete_594006(protocol: Scheme; host: string; base: string;
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

proc validate_BlobContainersDelete_594005(path: JsonNode; query: JsonNode;
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
  var valid_594007 = path.getOrDefault("resourceGroupName")
  valid_594007 = validateParameter(valid_594007, JString, required = true,
                                 default = nil)
  if valid_594007 != nil:
    section.add "resourceGroupName", valid_594007
  var valid_594008 = path.getOrDefault("containerName")
  valid_594008 = validateParameter(valid_594008, JString, required = true,
                                 default = nil)
  if valid_594008 != nil:
    section.add "containerName", valid_594008
  var valid_594009 = path.getOrDefault("subscriptionId")
  valid_594009 = validateParameter(valid_594009, JString, required = true,
                                 default = nil)
  if valid_594009 != nil:
    section.add "subscriptionId", valid_594009
  var valid_594010 = path.getOrDefault("accountName")
  valid_594010 = validateParameter(valid_594010, JString, required = true,
                                 default = nil)
  if valid_594010 != nil:
    section.add "accountName", valid_594010
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594011 = query.getOrDefault("api-version")
  valid_594011 = validateParameter(valid_594011, JString, required = true,
                                 default = nil)
  if valid_594011 != nil:
    section.add "api-version", valid_594011
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594012: Call_BlobContainersDelete_594004; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes specified container under its account.
  ## 
  let valid = call_594012.validator(path, query, header, formData, body)
  let scheme = call_594012.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594012.url(scheme.get, call_594012.host, call_594012.base,
                         call_594012.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594012, url, valid)

proc call*(call_594013: Call_BlobContainersDelete_594004;
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
  var path_594014 = newJObject()
  var query_594015 = newJObject()
  add(path_594014, "resourceGroupName", newJString(resourceGroupName))
  add(query_594015, "api-version", newJString(apiVersion))
  add(path_594014, "containerName", newJString(containerName))
  add(path_594014, "subscriptionId", newJString(subscriptionId))
  add(path_594014, "accountName", newJString(accountName))
  result = call_594013.call(path_594014, query_594015, nil, nil, nil)

var blobContainersDelete* = Call_BlobContainersDelete_594004(
    name: "blobContainersDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{accountName}/blobServices/default/containers/{containerName}",
    validator: validate_BlobContainersDelete_594005, base: "",
    url: url_BlobContainersDelete_594006, schemes: {Scheme.Https})
type
  Call_BlobContainersClearLegalHold_594030 = ref object of OpenApiRestCall_593425
proc url_BlobContainersClearLegalHold_594032(protocol: Scheme; host: string;
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

proc validate_BlobContainersClearLegalHold_594031(path: JsonNode; query: JsonNode;
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
  var valid_594043 = path.getOrDefault("resourceGroupName")
  valid_594043 = validateParameter(valid_594043, JString, required = true,
                                 default = nil)
  if valid_594043 != nil:
    section.add "resourceGroupName", valid_594043
  var valid_594044 = path.getOrDefault("containerName")
  valid_594044 = validateParameter(valid_594044, JString, required = true,
                                 default = nil)
  if valid_594044 != nil:
    section.add "containerName", valid_594044
  var valid_594045 = path.getOrDefault("subscriptionId")
  valid_594045 = validateParameter(valid_594045, JString, required = true,
                                 default = nil)
  if valid_594045 != nil:
    section.add "subscriptionId", valid_594045
  var valid_594046 = path.getOrDefault("accountName")
  valid_594046 = validateParameter(valid_594046, JString, required = true,
                                 default = nil)
  if valid_594046 != nil:
    section.add "accountName", valid_594046
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594047 = query.getOrDefault("api-version")
  valid_594047 = validateParameter(valid_594047, JString, required = true,
                                 default = nil)
  if valid_594047 != nil:
    section.add "api-version", valid_594047
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

proc call*(call_594049: Call_BlobContainersClearLegalHold_594030; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Clears legal hold tags. Clearing the same or non-existent tag results in an idempotent operation. ClearLegalHold clears out only the specified tags in the request.
  ## 
  let valid = call_594049.validator(path, query, header, formData, body)
  let scheme = call_594049.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594049.url(scheme.get, call_594049.host, call_594049.base,
                         call_594049.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594049, url, valid)

proc call*(call_594050: Call_BlobContainersClearLegalHold_594030;
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
  var path_594051 = newJObject()
  var query_594052 = newJObject()
  var body_594053 = newJObject()
  add(path_594051, "resourceGroupName", newJString(resourceGroupName))
  add(query_594052, "api-version", newJString(apiVersion))
  add(path_594051, "containerName", newJString(containerName))
  if LegalHold != nil:
    body_594053 = LegalHold
  add(path_594051, "subscriptionId", newJString(subscriptionId))
  add(path_594051, "accountName", newJString(accountName))
  result = call_594050.call(path_594051, query_594052, nil, nil, body_594053)

var blobContainersClearLegalHold* = Call_BlobContainersClearLegalHold_594030(
    name: "blobContainersClearLegalHold", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{accountName}/blobServices/default/containers/{containerName}/clearLegalHold",
    validator: validate_BlobContainersClearLegalHold_594031, base: "",
    url: url_BlobContainersClearLegalHold_594032, schemes: {Scheme.Https})
type
  Call_BlobContainersExtendImmutabilityPolicy_594054 = ref object of OpenApiRestCall_593425
proc url_BlobContainersExtendImmutabilityPolicy_594056(protocol: Scheme;
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

proc validate_BlobContainersExtendImmutabilityPolicy_594055(path: JsonNode;
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
  var valid_594057 = path.getOrDefault("resourceGroupName")
  valid_594057 = validateParameter(valid_594057, JString, required = true,
                                 default = nil)
  if valid_594057 != nil:
    section.add "resourceGroupName", valid_594057
  var valid_594058 = path.getOrDefault("containerName")
  valid_594058 = validateParameter(valid_594058, JString, required = true,
                                 default = nil)
  if valid_594058 != nil:
    section.add "containerName", valid_594058
  var valid_594059 = path.getOrDefault("subscriptionId")
  valid_594059 = validateParameter(valid_594059, JString, required = true,
                                 default = nil)
  if valid_594059 != nil:
    section.add "subscriptionId", valid_594059
  var valid_594060 = path.getOrDefault("accountName")
  valid_594060 = validateParameter(valid_594060, JString, required = true,
                                 default = nil)
  if valid_594060 != nil:
    section.add "accountName", valid_594060
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594061 = query.getOrDefault("api-version")
  valid_594061 = validateParameter(valid_594061, JString, required = true,
                                 default = nil)
  if valid_594061 != nil:
    section.add "api-version", valid_594061
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : The entity state (ETag) version of the immutability policy to update. A value of "*" can be used to apply the operation only if the immutability policy already exists. If omitted, this operation will always be applied.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_594062 = header.getOrDefault("If-Match")
  valid_594062 = validateParameter(valid_594062, JString, required = true,
                                 default = nil)
  if valid_594062 != nil:
    section.add "If-Match", valid_594062
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject
  ##             : The ImmutabilityPolicy Properties that will be extended for a blob container.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594064: Call_BlobContainersExtendImmutabilityPolicy_594054;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Extends the immutabilityPeriodSinceCreationInDays of a locked immutabilityPolicy. The only action allowed on a Locked policy will be this action. ETag in If-Match is required for this operation.
  ## 
  let valid = call_594064.validator(path, query, header, formData, body)
  let scheme = call_594064.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594064.url(scheme.get, call_594064.host, call_594064.base,
                         call_594064.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594064, url, valid)

proc call*(call_594065: Call_BlobContainersExtendImmutabilityPolicy_594054;
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
  var path_594066 = newJObject()
  var query_594067 = newJObject()
  var body_594068 = newJObject()
  add(path_594066, "resourceGroupName", newJString(resourceGroupName))
  add(query_594067, "api-version", newJString(apiVersion))
  add(path_594066, "containerName", newJString(containerName))
  add(path_594066, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594068 = parameters
  add(path_594066, "accountName", newJString(accountName))
  result = call_594065.call(path_594066, query_594067, nil, nil, body_594068)

var blobContainersExtendImmutabilityPolicy* = Call_BlobContainersExtendImmutabilityPolicy_594054(
    name: "blobContainersExtendImmutabilityPolicy", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{accountName}/blobServices/default/containers/{containerName}/immutabilityPolicies/default/extend",
    validator: validate_BlobContainersExtendImmutabilityPolicy_594055, base: "",
    url: url_BlobContainersExtendImmutabilityPolicy_594056,
    schemes: {Scheme.Https})
type
  Call_BlobContainersLockImmutabilityPolicy_594069 = ref object of OpenApiRestCall_593425
proc url_BlobContainersLockImmutabilityPolicy_594071(protocol: Scheme;
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

proc validate_BlobContainersLockImmutabilityPolicy_594070(path: JsonNode;
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
  var valid_594072 = path.getOrDefault("resourceGroupName")
  valid_594072 = validateParameter(valid_594072, JString, required = true,
                                 default = nil)
  if valid_594072 != nil:
    section.add "resourceGroupName", valid_594072
  var valid_594073 = path.getOrDefault("containerName")
  valid_594073 = validateParameter(valid_594073, JString, required = true,
                                 default = nil)
  if valid_594073 != nil:
    section.add "containerName", valid_594073
  var valid_594074 = path.getOrDefault("subscriptionId")
  valid_594074 = validateParameter(valid_594074, JString, required = true,
                                 default = nil)
  if valid_594074 != nil:
    section.add "subscriptionId", valid_594074
  var valid_594075 = path.getOrDefault("accountName")
  valid_594075 = validateParameter(valid_594075, JString, required = true,
                                 default = nil)
  if valid_594075 != nil:
    section.add "accountName", valid_594075
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594076 = query.getOrDefault("api-version")
  valid_594076 = validateParameter(valid_594076, JString, required = true,
                                 default = nil)
  if valid_594076 != nil:
    section.add "api-version", valid_594076
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : The entity state (ETag) version of the immutability policy to update. A value of "*" can be used to apply the operation only if the immutability policy already exists. If omitted, this operation will always be applied.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_594077 = header.getOrDefault("If-Match")
  valid_594077 = validateParameter(valid_594077, JString, required = true,
                                 default = nil)
  if valid_594077 != nil:
    section.add "If-Match", valid_594077
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594078: Call_BlobContainersLockImmutabilityPolicy_594069;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the ImmutabilityPolicy to Locked state. The only action allowed on a Locked policy is ExtendImmutabilityPolicy action. ETag in If-Match is required for this operation.
  ## 
  let valid = call_594078.validator(path, query, header, formData, body)
  let scheme = call_594078.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594078.url(scheme.get, call_594078.host, call_594078.base,
                         call_594078.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594078, url, valid)

proc call*(call_594079: Call_BlobContainersLockImmutabilityPolicy_594069;
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
  var path_594080 = newJObject()
  var query_594081 = newJObject()
  add(path_594080, "resourceGroupName", newJString(resourceGroupName))
  add(query_594081, "api-version", newJString(apiVersion))
  add(path_594080, "containerName", newJString(containerName))
  add(path_594080, "subscriptionId", newJString(subscriptionId))
  add(path_594080, "accountName", newJString(accountName))
  result = call_594079.call(path_594080, query_594081, nil, nil, nil)

var blobContainersLockImmutabilityPolicy* = Call_BlobContainersLockImmutabilityPolicy_594069(
    name: "blobContainersLockImmutabilityPolicy", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{accountName}/blobServices/default/containers/{containerName}/immutabilityPolicies/default/lock",
    validator: validate_BlobContainersLockImmutabilityPolicy_594070, base: "",
    url: url_BlobContainersLockImmutabilityPolicy_594071, schemes: {Scheme.Https})
type
  Call_BlobContainersCreateOrUpdateImmutabilityPolicy_594109 = ref object of OpenApiRestCall_593425
proc url_BlobContainersCreateOrUpdateImmutabilityPolicy_594111(protocol: Scheme;
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

proc validate_BlobContainersCreateOrUpdateImmutabilityPolicy_594110(
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
  var valid_594112 = path.getOrDefault("resourceGroupName")
  valid_594112 = validateParameter(valid_594112, JString, required = true,
                                 default = nil)
  if valid_594112 != nil:
    section.add "resourceGroupName", valid_594112
  var valid_594113 = path.getOrDefault("containerName")
  valid_594113 = validateParameter(valid_594113, JString, required = true,
                                 default = nil)
  if valid_594113 != nil:
    section.add "containerName", valid_594113
  var valid_594114 = path.getOrDefault("subscriptionId")
  valid_594114 = validateParameter(valid_594114, JString, required = true,
                                 default = nil)
  if valid_594114 != nil:
    section.add "subscriptionId", valid_594114
  var valid_594115 = path.getOrDefault("immutabilityPolicyName")
  valid_594115 = validateParameter(valid_594115, JString, required = true,
                                 default = newJString("default"))
  if valid_594115 != nil:
    section.add "immutabilityPolicyName", valid_594115
  var valid_594116 = path.getOrDefault("accountName")
  valid_594116 = validateParameter(valid_594116, JString, required = true,
                                 default = nil)
  if valid_594116 != nil:
    section.add "accountName", valid_594116
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594117 = query.getOrDefault("api-version")
  valid_594117 = validateParameter(valid_594117, JString, required = true,
                                 default = nil)
  if valid_594117 != nil:
    section.add "api-version", valid_594117
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : The entity state (ETag) version of the immutability policy to update. A value of "*" can be used to apply the operation only if the immutability policy already exists. If omitted, this operation will always be applied.
  section = newJObject()
  var valid_594118 = header.getOrDefault("If-Match")
  valid_594118 = validateParameter(valid_594118, JString, required = false,
                                 default = nil)
  if valid_594118 != nil:
    section.add "If-Match", valid_594118
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject
  ##             : The ImmutabilityPolicy Properties that will be created or updated to a blob container.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594120: Call_BlobContainersCreateOrUpdateImmutabilityPolicy_594109;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates an unlocked immutability policy. ETag in If-Match is honored if given but not required for this operation.
  ## 
  let valid = call_594120.validator(path, query, header, formData, body)
  let scheme = call_594120.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594120.url(scheme.get, call_594120.host, call_594120.base,
                         call_594120.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594120, url, valid)

proc call*(call_594121: Call_BlobContainersCreateOrUpdateImmutabilityPolicy_594109;
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
  var path_594122 = newJObject()
  var query_594123 = newJObject()
  var body_594124 = newJObject()
  add(path_594122, "resourceGroupName", newJString(resourceGroupName))
  add(query_594123, "api-version", newJString(apiVersion))
  add(path_594122, "containerName", newJString(containerName))
  add(path_594122, "subscriptionId", newJString(subscriptionId))
  add(path_594122, "immutabilityPolicyName", newJString(immutabilityPolicyName))
  if parameters != nil:
    body_594124 = parameters
  add(path_594122, "accountName", newJString(accountName))
  result = call_594121.call(path_594122, query_594123, nil, nil, body_594124)

var blobContainersCreateOrUpdateImmutabilityPolicy* = Call_BlobContainersCreateOrUpdateImmutabilityPolicy_594109(
    name: "blobContainersCreateOrUpdateImmutabilityPolicy",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{accountName}/blobServices/default/containers/{containerName}/immutabilityPolicies/{immutabilityPolicyName}",
    validator: validate_BlobContainersCreateOrUpdateImmutabilityPolicy_594110,
    base: "", url: url_BlobContainersCreateOrUpdateImmutabilityPolicy_594111,
    schemes: {Scheme.Https})
type
  Call_BlobContainersGetImmutabilityPolicy_594082 = ref object of OpenApiRestCall_593425
proc url_BlobContainersGetImmutabilityPolicy_594084(protocol: Scheme; host: string;
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

proc validate_BlobContainersGetImmutabilityPolicy_594083(path: JsonNode;
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
  var valid_594085 = path.getOrDefault("resourceGroupName")
  valid_594085 = validateParameter(valid_594085, JString, required = true,
                                 default = nil)
  if valid_594085 != nil:
    section.add "resourceGroupName", valid_594085
  var valid_594086 = path.getOrDefault("containerName")
  valid_594086 = validateParameter(valid_594086, JString, required = true,
                                 default = nil)
  if valid_594086 != nil:
    section.add "containerName", valid_594086
  var valid_594087 = path.getOrDefault("subscriptionId")
  valid_594087 = validateParameter(valid_594087, JString, required = true,
                                 default = nil)
  if valid_594087 != nil:
    section.add "subscriptionId", valid_594087
  var valid_594101 = path.getOrDefault("immutabilityPolicyName")
  valid_594101 = validateParameter(valid_594101, JString, required = true,
                                 default = newJString("default"))
  if valid_594101 != nil:
    section.add "immutabilityPolicyName", valid_594101
  var valid_594102 = path.getOrDefault("accountName")
  valid_594102 = validateParameter(valid_594102, JString, required = true,
                                 default = nil)
  if valid_594102 != nil:
    section.add "accountName", valid_594102
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594103 = query.getOrDefault("api-version")
  valid_594103 = validateParameter(valid_594103, JString, required = true,
                                 default = nil)
  if valid_594103 != nil:
    section.add "api-version", valid_594103
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : The entity state (ETag) version of the immutability policy to update. A value of "*" can be used to apply the operation only if the immutability policy already exists. If omitted, this operation will always be applied.
  section = newJObject()
  var valid_594104 = header.getOrDefault("If-Match")
  valid_594104 = validateParameter(valid_594104, JString, required = false,
                                 default = nil)
  if valid_594104 != nil:
    section.add "If-Match", valid_594104
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594105: Call_BlobContainersGetImmutabilityPolicy_594082;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the existing immutability policy along with the corresponding ETag in response headers and body.
  ## 
  let valid = call_594105.validator(path, query, header, formData, body)
  let scheme = call_594105.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594105.url(scheme.get, call_594105.host, call_594105.base,
                         call_594105.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594105, url, valid)

proc call*(call_594106: Call_BlobContainersGetImmutabilityPolicy_594082;
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
  var path_594107 = newJObject()
  var query_594108 = newJObject()
  add(path_594107, "resourceGroupName", newJString(resourceGroupName))
  add(query_594108, "api-version", newJString(apiVersion))
  add(path_594107, "containerName", newJString(containerName))
  add(path_594107, "subscriptionId", newJString(subscriptionId))
  add(path_594107, "immutabilityPolicyName", newJString(immutabilityPolicyName))
  add(path_594107, "accountName", newJString(accountName))
  result = call_594106.call(path_594107, query_594108, nil, nil, nil)

var blobContainersGetImmutabilityPolicy* = Call_BlobContainersGetImmutabilityPolicy_594082(
    name: "blobContainersGetImmutabilityPolicy", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{accountName}/blobServices/default/containers/{containerName}/immutabilityPolicies/{immutabilityPolicyName}",
    validator: validate_BlobContainersGetImmutabilityPolicy_594083, base: "",
    url: url_BlobContainersGetImmutabilityPolicy_594084, schemes: {Scheme.Https})
type
  Call_BlobContainersDeleteImmutabilityPolicy_594125 = ref object of OpenApiRestCall_593425
proc url_BlobContainersDeleteImmutabilityPolicy_594127(protocol: Scheme;
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

proc validate_BlobContainersDeleteImmutabilityPolicy_594126(path: JsonNode;
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
  var valid_594128 = path.getOrDefault("resourceGroupName")
  valid_594128 = validateParameter(valid_594128, JString, required = true,
                                 default = nil)
  if valid_594128 != nil:
    section.add "resourceGroupName", valid_594128
  var valid_594129 = path.getOrDefault("containerName")
  valid_594129 = validateParameter(valid_594129, JString, required = true,
                                 default = nil)
  if valid_594129 != nil:
    section.add "containerName", valid_594129
  var valid_594130 = path.getOrDefault("subscriptionId")
  valid_594130 = validateParameter(valid_594130, JString, required = true,
                                 default = nil)
  if valid_594130 != nil:
    section.add "subscriptionId", valid_594130
  var valid_594131 = path.getOrDefault("immutabilityPolicyName")
  valid_594131 = validateParameter(valid_594131, JString, required = true,
                                 default = newJString("default"))
  if valid_594131 != nil:
    section.add "immutabilityPolicyName", valid_594131
  var valid_594132 = path.getOrDefault("accountName")
  valid_594132 = validateParameter(valid_594132, JString, required = true,
                                 default = nil)
  if valid_594132 != nil:
    section.add "accountName", valid_594132
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594133 = query.getOrDefault("api-version")
  valid_594133 = validateParameter(valid_594133, JString, required = true,
                                 default = nil)
  if valid_594133 != nil:
    section.add "api-version", valid_594133
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : The entity state (ETag) version of the immutability policy to update. A value of "*" can be used to apply the operation only if the immutability policy already exists. If omitted, this operation will always be applied.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_594134 = header.getOrDefault("If-Match")
  valid_594134 = validateParameter(valid_594134, JString, required = true,
                                 default = nil)
  if valid_594134 != nil:
    section.add "If-Match", valid_594134
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594135: Call_BlobContainersDeleteImmutabilityPolicy_594125;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Aborts an unlocked immutability policy. The response of delete has immutabilityPeriodSinceCreationInDays set to 0. ETag in If-Match is required for this operation. Deleting a locked immutability policy is not allowed, only way is to delete the container after deleting all blobs inside the container.
  ## 
  let valid = call_594135.validator(path, query, header, formData, body)
  let scheme = call_594135.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594135.url(scheme.get, call_594135.host, call_594135.base,
                         call_594135.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594135, url, valid)

proc call*(call_594136: Call_BlobContainersDeleteImmutabilityPolicy_594125;
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
  var path_594137 = newJObject()
  var query_594138 = newJObject()
  add(path_594137, "resourceGroupName", newJString(resourceGroupName))
  add(query_594138, "api-version", newJString(apiVersion))
  add(path_594137, "containerName", newJString(containerName))
  add(path_594137, "subscriptionId", newJString(subscriptionId))
  add(path_594137, "immutabilityPolicyName", newJString(immutabilityPolicyName))
  add(path_594137, "accountName", newJString(accountName))
  result = call_594136.call(path_594137, query_594138, nil, nil, nil)

var blobContainersDeleteImmutabilityPolicy* = Call_BlobContainersDeleteImmutabilityPolicy_594125(
    name: "blobContainersDeleteImmutabilityPolicy", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{accountName}/blobServices/default/containers/{containerName}/immutabilityPolicies/{immutabilityPolicyName}",
    validator: validate_BlobContainersDeleteImmutabilityPolicy_594126, base: "",
    url: url_BlobContainersDeleteImmutabilityPolicy_594127,
    schemes: {Scheme.Https})
type
  Call_BlobContainersSetLegalHold_594139 = ref object of OpenApiRestCall_593425
proc url_BlobContainersSetLegalHold_594141(protocol: Scheme; host: string;
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

proc validate_BlobContainersSetLegalHold_594140(path: JsonNode; query: JsonNode;
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
  var valid_594142 = path.getOrDefault("resourceGroupName")
  valid_594142 = validateParameter(valid_594142, JString, required = true,
                                 default = nil)
  if valid_594142 != nil:
    section.add "resourceGroupName", valid_594142
  var valid_594143 = path.getOrDefault("containerName")
  valid_594143 = validateParameter(valid_594143, JString, required = true,
                                 default = nil)
  if valid_594143 != nil:
    section.add "containerName", valid_594143
  var valid_594144 = path.getOrDefault("subscriptionId")
  valid_594144 = validateParameter(valid_594144, JString, required = true,
                                 default = nil)
  if valid_594144 != nil:
    section.add "subscriptionId", valid_594144
  var valid_594145 = path.getOrDefault("accountName")
  valid_594145 = validateParameter(valid_594145, JString, required = true,
                                 default = nil)
  if valid_594145 != nil:
    section.add "accountName", valid_594145
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594146 = query.getOrDefault("api-version")
  valid_594146 = validateParameter(valid_594146, JString, required = true,
                                 default = nil)
  if valid_594146 != nil:
    section.add "api-version", valid_594146
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

proc call*(call_594148: Call_BlobContainersSetLegalHold_594139; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sets legal hold tags. Setting the same tag results in an idempotent operation. SetLegalHold follows an append pattern and does not clear out the existing tags that are not specified in the request.
  ## 
  let valid = call_594148.validator(path, query, header, formData, body)
  let scheme = call_594148.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594148.url(scheme.get, call_594148.host, call_594148.base,
                         call_594148.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594148, url, valid)

proc call*(call_594149: Call_BlobContainersSetLegalHold_594139;
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
  var path_594150 = newJObject()
  var query_594151 = newJObject()
  var body_594152 = newJObject()
  add(path_594150, "resourceGroupName", newJString(resourceGroupName))
  add(query_594151, "api-version", newJString(apiVersion))
  add(path_594150, "containerName", newJString(containerName))
  if LegalHold != nil:
    body_594152 = LegalHold
  add(path_594150, "subscriptionId", newJString(subscriptionId))
  add(path_594150, "accountName", newJString(accountName))
  result = call_594149.call(path_594150, query_594151, nil, nil, body_594152)

var blobContainersSetLegalHold* = Call_BlobContainersSetLegalHold_594139(
    name: "blobContainersSetLegalHold", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{accountName}/blobServices/default/containers/{containerName}/setLegalHold",
    validator: validate_BlobContainersSetLegalHold_594140, base: "",
    url: url_BlobContainersSetLegalHold_594141, schemes: {Scheme.Https})
type
  Call_BlobServicesSetServiceProperties_594165 = ref object of OpenApiRestCall_593425
proc url_BlobServicesSetServiceProperties_594167(protocol: Scheme; host: string;
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

proc validate_BlobServicesSetServiceProperties_594166(path: JsonNode;
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
  var valid_594168 = path.getOrDefault("resourceGroupName")
  valid_594168 = validateParameter(valid_594168, JString, required = true,
                                 default = nil)
  if valid_594168 != nil:
    section.add "resourceGroupName", valid_594168
  var valid_594169 = path.getOrDefault("subscriptionId")
  valid_594169 = validateParameter(valid_594169, JString, required = true,
                                 default = nil)
  if valid_594169 != nil:
    section.add "subscriptionId", valid_594169
  var valid_594170 = path.getOrDefault("BlobServicesName")
  valid_594170 = validateParameter(valid_594170, JString, required = true,
                                 default = newJString("default"))
  if valid_594170 != nil:
    section.add "BlobServicesName", valid_594170
  var valid_594171 = path.getOrDefault("accountName")
  valid_594171 = validateParameter(valid_594171, JString, required = true,
                                 default = nil)
  if valid_594171 != nil:
    section.add "accountName", valid_594171
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594172 = query.getOrDefault("api-version")
  valid_594172 = validateParameter(valid_594172, JString, required = true,
                                 default = nil)
  if valid_594172 != nil:
    section.add "api-version", valid_594172
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

proc call*(call_594174: Call_BlobServicesSetServiceProperties_594165;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the properties of a storage account’s Blob service, including properties for Storage Analytics and CORS (Cross-Origin Resource Sharing) rules. 
  ## 
  let valid = call_594174.validator(path, query, header, formData, body)
  let scheme = call_594174.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594174.url(scheme.get, call_594174.host, call_594174.base,
                         call_594174.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594174, url, valid)

proc call*(call_594175: Call_BlobServicesSetServiceProperties_594165;
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
  var path_594176 = newJObject()
  var query_594177 = newJObject()
  var body_594178 = newJObject()
  add(path_594176, "resourceGroupName", newJString(resourceGroupName))
  add(query_594177, "api-version", newJString(apiVersion))
  add(path_594176, "subscriptionId", newJString(subscriptionId))
  add(path_594176, "BlobServicesName", newJString(BlobServicesName))
  if parameters != nil:
    body_594178 = parameters
  add(path_594176, "accountName", newJString(accountName))
  result = call_594175.call(path_594176, query_594177, nil, nil, body_594178)

var blobServicesSetServiceProperties* = Call_BlobServicesSetServiceProperties_594165(
    name: "blobServicesSetServiceProperties", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{accountName}/blobServices/{BlobServicesName}",
    validator: validate_BlobServicesSetServiceProperties_594166, base: "",
    url: url_BlobServicesSetServiceProperties_594167, schemes: {Scheme.Https})
type
  Call_BlobServicesGetServiceProperties_594153 = ref object of OpenApiRestCall_593425
proc url_BlobServicesGetServiceProperties_594155(protocol: Scheme; host: string;
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

proc validate_BlobServicesGetServiceProperties_594154(path: JsonNode;
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
  var valid_594156 = path.getOrDefault("resourceGroupName")
  valid_594156 = validateParameter(valid_594156, JString, required = true,
                                 default = nil)
  if valid_594156 != nil:
    section.add "resourceGroupName", valid_594156
  var valid_594157 = path.getOrDefault("subscriptionId")
  valid_594157 = validateParameter(valid_594157, JString, required = true,
                                 default = nil)
  if valid_594157 != nil:
    section.add "subscriptionId", valid_594157
  var valid_594158 = path.getOrDefault("BlobServicesName")
  valid_594158 = validateParameter(valid_594158, JString, required = true,
                                 default = newJString("default"))
  if valid_594158 != nil:
    section.add "BlobServicesName", valid_594158
  var valid_594159 = path.getOrDefault("accountName")
  valid_594159 = validateParameter(valid_594159, JString, required = true,
                                 default = nil)
  if valid_594159 != nil:
    section.add "accountName", valid_594159
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594160 = query.getOrDefault("api-version")
  valid_594160 = validateParameter(valid_594160, JString, required = true,
                                 default = nil)
  if valid_594160 != nil:
    section.add "api-version", valid_594160
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594161: Call_BlobServicesGetServiceProperties_594153;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the properties of a storage account’s Blob service, including properties for Storage Analytics and CORS (Cross-Origin Resource Sharing) rules.
  ## 
  let valid = call_594161.validator(path, query, header, formData, body)
  let scheme = call_594161.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594161.url(scheme.get, call_594161.host, call_594161.base,
                         call_594161.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594161, url, valid)

proc call*(call_594162: Call_BlobServicesGetServiceProperties_594153;
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
  var path_594163 = newJObject()
  var query_594164 = newJObject()
  add(path_594163, "resourceGroupName", newJString(resourceGroupName))
  add(query_594164, "api-version", newJString(apiVersion))
  add(path_594163, "subscriptionId", newJString(subscriptionId))
  add(path_594163, "BlobServicesName", newJString(BlobServicesName))
  add(path_594163, "accountName", newJString(accountName))
  result = call_594162.call(path_594163, query_594164, nil, nil, nil)

var blobServicesGetServiceProperties* = Call_BlobServicesGetServiceProperties_594153(
    name: "blobServicesGetServiceProperties", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{accountName}/blobServices/{BlobServicesName}",
    validator: validate_BlobServicesGetServiceProperties_594154, base: "",
    url: url_BlobServicesGetServiceProperties_594155, schemes: {Scheme.Https})
type
  Call_BlobContainersLease_594179 = ref object of OpenApiRestCall_593425
proc url_BlobContainersLease_594181(protocol: Scheme; host: string; base: string;
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

proc validate_BlobContainersLease_594180(path: JsonNode; query: JsonNode;
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
  var valid_594182 = path.getOrDefault("resourceGroupName")
  valid_594182 = validateParameter(valid_594182, JString, required = true,
                                 default = nil)
  if valid_594182 != nil:
    section.add "resourceGroupName", valid_594182
  var valid_594183 = path.getOrDefault("containerName")
  valid_594183 = validateParameter(valid_594183, JString, required = true,
                                 default = nil)
  if valid_594183 != nil:
    section.add "containerName", valid_594183
  var valid_594184 = path.getOrDefault("subscriptionId")
  valid_594184 = validateParameter(valid_594184, JString, required = true,
                                 default = nil)
  if valid_594184 != nil:
    section.add "subscriptionId", valid_594184
  var valid_594185 = path.getOrDefault("accountName")
  valid_594185 = validateParameter(valid_594185, JString, required = true,
                                 default = nil)
  if valid_594185 != nil:
    section.add "accountName", valid_594185
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594186 = query.getOrDefault("api-version")
  valid_594186 = validateParameter(valid_594186, JString, required = true,
                                 default = nil)
  if valid_594186 != nil:
    section.add "api-version", valid_594186
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

proc call*(call_594188: Call_BlobContainersLease_594179; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Lease Container operation establishes and manages a lock on a container for delete operations. The lock duration can be 15 to 60 seconds, or can be infinite.
  ## 
  let valid = call_594188.validator(path, query, header, formData, body)
  let scheme = call_594188.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594188.url(scheme.get, call_594188.host, call_594188.base,
                         call_594188.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594188, url, valid)

proc call*(call_594189: Call_BlobContainersLease_594179; resourceGroupName: string;
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
  var path_594190 = newJObject()
  var query_594191 = newJObject()
  var body_594192 = newJObject()
  add(path_594190, "resourceGroupName", newJString(resourceGroupName))
  add(query_594191, "api-version", newJString(apiVersion))
  add(path_594190, "containerName", newJString(containerName))
  add(path_594190, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594192 = parameters
  add(path_594190, "accountName", newJString(accountName))
  result = call_594189.call(path_594190, query_594191, nil, nil, body_594192)

var blobContainersLease* = Call_BlobContainersLease_594179(
    name: "blobContainersLease", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{accountName}/blobServices/default/containers/{containerName}/lease",
    validator: validate_BlobContainersLease_594180, base: "",
    url: url_BlobContainersLease_594181, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
