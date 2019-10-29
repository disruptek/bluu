
import
  json, options, hashes, uri, rest, os, uri, httpcore

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

  OpenApiRestCall_563565 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563565](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563565): Option[Scheme] {.used.} =
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
  macServiceName = "storage"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_563787 = ref object of OpenApiRestCall_563565
proc url_OperationsList_563789(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_563788(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists all of the available Storage Rest API operations.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563937 = query.getOrDefault("api-version")
  valid_563937 = validateParameter(valid_563937, JString, required = true,
                                 default = nil)
  if valid_563937 != nil:
    section.add "api-version", valid_563937
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563964: Call_OperationsList_563787; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available Storage Rest API operations.
  ## 
  let valid = call_563964.validator(path, query, header, formData, body)
  let scheme = call_563964.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563964.url(scheme.get, call_563964.host, call_563964.base,
                         call_563964.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563964, url, valid)

proc call*(call_564035: Call_OperationsList_563787; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available Storage Rest API operations.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  var query_564036 = newJObject()
  add(query_564036, "api-version", newJString(apiVersion))
  result = call_564035.call(nil, query_564036, nil, nil, nil)

var operationsList* = Call_OperationsList_563787(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Storage/operations",
    validator: validate_OperationsList_563788, base: "", url: url_OperationsList_563789,
    schemes: {Scheme.Https})
type
  Call_StorageAccountsCheckNameAvailability_564076 = ref object of OpenApiRestCall_563565
proc url_StorageAccountsCheckNameAvailability_564078(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Storage/checkNameAvailability")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageAccountsCheckNameAvailability_564077(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Checks that the storage account name is valid and is not already in use.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564119 = path.getOrDefault("subscriptionId")
  valid_564119 = validateParameter(valid_564119, JString, required = true,
                                 default = nil)
  if valid_564119 != nil:
    section.add "subscriptionId", valid_564119
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564120 = query.getOrDefault("api-version")
  valid_564120 = validateParameter(valid_564120, JString, required = true,
                                 default = nil)
  if valid_564120 != nil:
    section.add "api-version", valid_564120
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   accountName: JObject (required)
  ##              : The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564122: Call_StorageAccountsCheckNameAvailability_564076;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Checks that the storage account name is valid and is not already in use.
  ## 
  let valid = call_564122.validator(path, query, header, formData, body)
  let scheme = call_564122.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564122.url(scheme.get, call_564122.host, call_564122.base,
                         call_564122.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564122, url, valid)

proc call*(call_564123: Call_StorageAccountsCheckNameAvailability_564076;
          apiVersion: string; subscriptionId: string; accountName: JsonNode): Recallable =
  ## storageAccountsCheckNameAvailability
  ## Checks that the storage account name is valid and is not already in use.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   accountName: JObject (required)
  ##              : The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
  var path_564124 = newJObject()
  var query_564125 = newJObject()
  var body_564126 = newJObject()
  add(query_564125, "api-version", newJString(apiVersion))
  add(path_564124, "subscriptionId", newJString(subscriptionId))
  if accountName != nil:
    body_564126 = accountName
  result = call_564123.call(path_564124, query_564125, nil, nil, body_564126)

var storageAccountsCheckNameAvailability* = Call_StorageAccountsCheckNameAvailability_564076(
    name: "storageAccountsCheckNameAvailability", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Storage/checkNameAvailability",
    validator: validate_StorageAccountsCheckNameAvailability_564077, base: "",
    url: url_StorageAccountsCheckNameAvailability_564078, schemes: {Scheme.Https})
type
  Call_UsagesListByLocation_564127 = ref object of OpenApiRestCall_563565
proc url_UsagesListByLocation_564129(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Storage/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/usages")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UsagesListByLocation_564128(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the current usage count and the limit for the resources of the location under the subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   location: JString (required)
  ##           : The location of the Azure Storage resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564130 = path.getOrDefault("subscriptionId")
  valid_564130 = validateParameter(valid_564130, JString, required = true,
                                 default = nil)
  if valid_564130 != nil:
    section.add "subscriptionId", valid_564130
  var valid_564131 = path.getOrDefault("location")
  valid_564131 = validateParameter(valid_564131, JString, required = true,
                                 default = nil)
  if valid_564131 != nil:
    section.add "location", valid_564131
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564132 = query.getOrDefault("api-version")
  valid_564132 = validateParameter(valid_564132, JString, required = true,
                                 default = nil)
  if valid_564132 != nil:
    section.add "api-version", valid_564132
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564133: Call_UsagesListByLocation_564127; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the current usage count and the limit for the resources of the location under the subscription.
  ## 
  let valid = call_564133.validator(path, query, header, formData, body)
  let scheme = call_564133.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564133.url(scheme.get, call_564133.host, call_564133.base,
                         call_564133.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564133, url, valid)

proc call*(call_564134: Call_UsagesListByLocation_564127; apiVersion: string;
          subscriptionId: string; location: string): Recallable =
  ## usagesListByLocation
  ## Gets the current usage count and the limit for the resources of the location under the subscription.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   location: string (required)
  ##           : The location of the Azure Storage resource.
  var path_564135 = newJObject()
  var query_564136 = newJObject()
  add(query_564136, "api-version", newJString(apiVersion))
  add(path_564135, "subscriptionId", newJString(subscriptionId))
  add(path_564135, "location", newJString(location))
  result = call_564134.call(path_564135, query_564136, nil, nil, nil)

var usagesListByLocation* = Call_UsagesListByLocation_564127(
    name: "usagesListByLocation", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Storage/locations/{location}/usages",
    validator: validate_UsagesListByLocation_564128, base: "",
    url: url_UsagesListByLocation_564129, schemes: {Scheme.Https})
type
  Call_SkusList_564137 = ref object of OpenApiRestCall_563565
proc url_SkusList_564139(protocol: Scheme; host: string; base: string; route: string;
                        path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Storage/skus")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SkusList_564138(path: JsonNode; query: JsonNode; header: JsonNode;
                             formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the available SKUs supported by Microsoft.Storage for given subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564140 = path.getOrDefault("subscriptionId")
  valid_564140 = validateParameter(valid_564140, JString, required = true,
                                 default = nil)
  if valid_564140 != nil:
    section.add "subscriptionId", valid_564140
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564141 = query.getOrDefault("api-version")
  valid_564141 = validateParameter(valid_564141, JString, required = true,
                                 default = nil)
  if valid_564141 != nil:
    section.add "api-version", valid_564141
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564142: Call_SkusList_564137; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the available SKUs supported by Microsoft.Storage for given subscription.
  ## 
  let valid = call_564142.validator(path, query, header, formData, body)
  let scheme = call_564142.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564142.url(scheme.get, call_564142.host, call_564142.base,
                         call_564142.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564142, url, valid)

proc call*(call_564143: Call_SkusList_564137; apiVersion: string;
          subscriptionId: string): Recallable =
  ## skusList
  ## Lists the available SKUs supported by Microsoft.Storage for given subscription.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_564144 = newJObject()
  var query_564145 = newJObject()
  add(query_564145, "api-version", newJString(apiVersion))
  add(path_564144, "subscriptionId", newJString(subscriptionId))
  result = call_564143.call(path_564144, query_564145, nil, nil, nil)

var skusList* = Call_SkusList_564137(name: "skusList", meth: HttpMethod.HttpGet,
                                  host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Storage/skus",
                                  validator: validate_SkusList_564138, base: "",
                                  url: url_SkusList_564139,
                                  schemes: {Scheme.Https})
type
  Call_StorageAccountsList_564146 = ref object of OpenApiRestCall_563565
proc url_StorageAccountsList_564148(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Storage/storageAccounts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageAccountsList_564147(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Lists all the storage accounts available under the subscription. Note that storage keys are not returned; use the ListKeys operation for this.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564149 = path.getOrDefault("subscriptionId")
  valid_564149 = validateParameter(valid_564149, JString, required = true,
                                 default = nil)
  if valid_564149 != nil:
    section.add "subscriptionId", valid_564149
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564150 = query.getOrDefault("api-version")
  valid_564150 = validateParameter(valid_564150, JString, required = true,
                                 default = nil)
  if valid_564150 != nil:
    section.add "api-version", valid_564150
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564151: Call_StorageAccountsList_564146; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the storage accounts available under the subscription. Note that storage keys are not returned; use the ListKeys operation for this.
  ## 
  let valid = call_564151.validator(path, query, header, formData, body)
  let scheme = call_564151.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564151.url(scheme.get, call_564151.host, call_564151.base,
                         call_564151.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564151, url, valid)

proc call*(call_564152: Call_StorageAccountsList_564146; apiVersion: string;
          subscriptionId: string): Recallable =
  ## storageAccountsList
  ## Lists all the storage accounts available under the subscription. Note that storage keys are not returned; use the ListKeys operation for this.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_564153 = newJObject()
  var query_564154 = newJObject()
  add(query_564154, "api-version", newJString(apiVersion))
  add(path_564153, "subscriptionId", newJString(subscriptionId))
  result = call_564152.call(path_564153, query_564154, nil, nil, nil)

var storageAccountsList* = Call_StorageAccountsList_564146(
    name: "storageAccountsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Storage/storageAccounts",
    validator: validate_StorageAccountsList_564147, base: "",
    url: url_StorageAccountsList_564148, schemes: {Scheme.Https})
type
  Call_StorageAccountsListByResourceGroup_564155 = ref object of OpenApiRestCall_563565
proc url_StorageAccountsListByResourceGroup_564157(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Storage/storageAccounts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageAccountsListByResourceGroup_564156(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all the storage accounts available under the given resource group. Note that storage keys are not returned; use the ListKeys operation for this.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564158 = path.getOrDefault("subscriptionId")
  valid_564158 = validateParameter(valid_564158, JString, required = true,
                                 default = nil)
  if valid_564158 != nil:
    section.add "subscriptionId", valid_564158
  var valid_564159 = path.getOrDefault("resourceGroupName")
  valid_564159 = validateParameter(valid_564159, JString, required = true,
                                 default = nil)
  if valid_564159 != nil:
    section.add "resourceGroupName", valid_564159
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564160 = query.getOrDefault("api-version")
  valid_564160 = validateParameter(valid_564160, JString, required = true,
                                 default = nil)
  if valid_564160 != nil:
    section.add "api-version", valid_564160
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564161: Call_StorageAccountsListByResourceGroup_564155;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the storage accounts available under the given resource group. Note that storage keys are not returned; use the ListKeys operation for this.
  ## 
  let valid = call_564161.validator(path, query, header, formData, body)
  let scheme = call_564161.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564161.url(scheme.get, call_564161.host, call_564161.base,
                         call_564161.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564161, url, valid)

proc call*(call_564162: Call_StorageAccountsListByResourceGroup_564155;
          apiVersion: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## storageAccountsListByResourceGroup
  ## Lists all the storage accounts available under the given resource group. Note that storage keys are not returned; use the ListKeys operation for this.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  var path_564163 = newJObject()
  var query_564164 = newJObject()
  add(query_564164, "api-version", newJString(apiVersion))
  add(path_564163, "subscriptionId", newJString(subscriptionId))
  add(path_564163, "resourceGroupName", newJString(resourceGroupName))
  result = call_564162.call(path_564163, query_564164, nil, nil, nil)

var storageAccountsListByResourceGroup* = Call_StorageAccountsListByResourceGroup_564155(
    name: "storageAccountsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts",
    validator: validate_StorageAccountsListByResourceGroup_564156, base: "",
    url: url_StorageAccountsListByResourceGroup_564157, schemes: {Scheme.Https})
type
  Call_StorageAccountsCreate_564191 = ref object of OpenApiRestCall_563565
proc url_StorageAccountsCreate_564193(protocol: Scheme; host: string; base: string;
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
               (kind: VariableSegment, value: "accountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageAccountsCreate_564192(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Asynchronously creates a new storage account with the specified parameters. If an account is already created and a subsequent create request is issued with different properties, the account properties will be updated. If an account is already created and a subsequent create or update request is issued with the exact same set of properties, the request will succeed.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   accountName: JString (required)
  ##              : The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564194 = path.getOrDefault("subscriptionId")
  valid_564194 = validateParameter(valid_564194, JString, required = true,
                                 default = nil)
  if valid_564194 != nil:
    section.add "subscriptionId", valid_564194
  var valid_564195 = path.getOrDefault("resourceGroupName")
  valid_564195 = validateParameter(valid_564195, JString, required = true,
                                 default = nil)
  if valid_564195 != nil:
    section.add "resourceGroupName", valid_564195
  var valid_564196 = path.getOrDefault("accountName")
  valid_564196 = validateParameter(valid_564196, JString, required = true,
                                 default = nil)
  if valid_564196 != nil:
    section.add "accountName", valid_564196
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564197 = query.getOrDefault("api-version")
  valid_564197 = validateParameter(valid_564197, JString, required = true,
                                 default = nil)
  if valid_564197 != nil:
    section.add "api-version", valid_564197
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters to provide for the created account.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564199: Call_StorageAccountsCreate_564191; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Asynchronously creates a new storage account with the specified parameters. If an account is already created and a subsequent create request is issued with different properties, the account properties will be updated. If an account is already created and a subsequent create or update request is issued with the exact same set of properties, the request will succeed.
  ## 
  let valid = call_564199.validator(path, query, header, formData, body)
  let scheme = call_564199.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564199.url(scheme.get, call_564199.host, call_564199.base,
                         call_564199.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564199, url, valid)

proc call*(call_564200: Call_StorageAccountsCreate_564191; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; parameters: JsonNode;
          accountName: string): Recallable =
  ## storageAccountsCreate
  ## Asynchronously creates a new storage account with the specified parameters. If an account is already created and a subsequent create request is issued with different properties, the account properties will be updated. If an account is already created and a subsequent create or update request is issued with the exact same set of properties, the request will succeed.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   parameters: JObject (required)
  ##             : The parameters to provide for the created account.
  ##   accountName: string (required)
  ##              : The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
  var path_564201 = newJObject()
  var query_564202 = newJObject()
  var body_564203 = newJObject()
  add(query_564202, "api-version", newJString(apiVersion))
  add(path_564201, "subscriptionId", newJString(subscriptionId))
  add(path_564201, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564203 = parameters
  add(path_564201, "accountName", newJString(accountName))
  result = call_564200.call(path_564201, query_564202, nil, nil, body_564203)

var storageAccountsCreate* = Call_StorageAccountsCreate_564191(
    name: "storageAccountsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{accountName}",
    validator: validate_StorageAccountsCreate_564192, base: "",
    url: url_StorageAccountsCreate_564193, schemes: {Scheme.Https})
type
  Call_StorageAccountsGetProperties_564165 = ref object of OpenApiRestCall_563565
proc url_StorageAccountsGetProperties_564167(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
               (kind: VariableSegment, value: "accountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageAccountsGetProperties_564166(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the properties for the specified storage account including but not limited to name, SKU name, location, and account status. The ListKeys operation should be used to retrieve storage keys.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   accountName: JString (required)
  ##              : The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564169 = path.getOrDefault("subscriptionId")
  valid_564169 = validateParameter(valid_564169, JString, required = true,
                                 default = nil)
  if valid_564169 != nil:
    section.add "subscriptionId", valid_564169
  var valid_564170 = path.getOrDefault("resourceGroupName")
  valid_564170 = validateParameter(valid_564170, JString, required = true,
                                 default = nil)
  if valid_564170 != nil:
    section.add "resourceGroupName", valid_564170
  var valid_564171 = path.getOrDefault("accountName")
  valid_564171 = validateParameter(valid_564171, JString, required = true,
                                 default = nil)
  if valid_564171 != nil:
    section.add "accountName", valid_564171
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   $expand: JString
  ##          : May be used to expand the properties within account's properties. By default, data is not included when fetching properties. Currently we only support geoReplicationStats.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564172 = query.getOrDefault("api-version")
  valid_564172 = validateParameter(valid_564172, JString, required = true,
                                 default = nil)
  if valid_564172 != nil:
    section.add "api-version", valid_564172
  var valid_564186 = query.getOrDefault("$expand")
  valid_564186 = validateParameter(valid_564186, JString, required = false,
                                 default = newJString("geoReplicationStats"))
  if valid_564186 != nil:
    section.add "$expand", valid_564186
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564187: Call_StorageAccountsGetProperties_564165; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the properties for the specified storage account including but not limited to name, SKU name, location, and account status. The ListKeys operation should be used to retrieve storage keys.
  ## 
  let valid = call_564187.validator(path, query, header, formData, body)
  let scheme = call_564187.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564187.url(scheme.get, call_564187.host, call_564187.base,
                         call_564187.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564187, url, valid)

proc call*(call_564188: Call_StorageAccountsGetProperties_564165;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          accountName: string; Expand: string = "geoReplicationStats"): Recallable =
  ## storageAccountsGetProperties
  ## Returns the properties for the specified storage account including but not limited to name, SKU name, location, and account status. The ListKeys operation should be used to retrieve storage keys.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   Expand: string
  ##         : May be used to expand the properties within account's properties. By default, data is not included when fetching properties. Currently we only support geoReplicationStats.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   accountName: string (required)
  ##              : The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
  var path_564189 = newJObject()
  var query_564190 = newJObject()
  add(query_564190, "api-version", newJString(apiVersion))
  add(query_564190, "$expand", newJString(Expand))
  add(path_564189, "subscriptionId", newJString(subscriptionId))
  add(path_564189, "resourceGroupName", newJString(resourceGroupName))
  add(path_564189, "accountName", newJString(accountName))
  result = call_564188.call(path_564189, query_564190, nil, nil, nil)

var storageAccountsGetProperties* = Call_StorageAccountsGetProperties_564165(
    name: "storageAccountsGetProperties", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{accountName}",
    validator: validate_StorageAccountsGetProperties_564166, base: "",
    url: url_StorageAccountsGetProperties_564167, schemes: {Scheme.Https})
type
  Call_StorageAccountsUpdate_564215 = ref object of OpenApiRestCall_563565
proc url_StorageAccountsUpdate_564217(protocol: Scheme; host: string; base: string;
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
               (kind: VariableSegment, value: "accountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageAccountsUpdate_564216(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The update operation can be used to update the SKU, encryption, access tier, or tags for a storage account. It can also be used to map the account to a custom domain. Only one custom domain is supported per storage account; the replacement/change of custom domain is not supported. In order to replace an old custom domain, the old value must be cleared/unregistered before a new value can be set. The update of multiple properties is supported. This call does not change the storage keys for the account. If you want to change the storage account keys, use the regenerate keys operation. The location and name of the storage account cannot be changed after creation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   accountName: JString (required)
  ##              : The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564218 = path.getOrDefault("subscriptionId")
  valid_564218 = validateParameter(valid_564218, JString, required = true,
                                 default = nil)
  if valid_564218 != nil:
    section.add "subscriptionId", valid_564218
  var valid_564219 = path.getOrDefault("resourceGroupName")
  valid_564219 = validateParameter(valid_564219, JString, required = true,
                                 default = nil)
  if valid_564219 != nil:
    section.add "resourceGroupName", valid_564219
  var valid_564220 = path.getOrDefault("accountName")
  valid_564220 = validateParameter(valid_564220, JString, required = true,
                                 default = nil)
  if valid_564220 != nil:
    section.add "accountName", valid_564220
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564221 = query.getOrDefault("api-version")
  valid_564221 = validateParameter(valid_564221, JString, required = true,
                                 default = nil)
  if valid_564221 != nil:
    section.add "api-version", valid_564221
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters to provide for the updated account.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564223: Call_StorageAccountsUpdate_564215; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The update operation can be used to update the SKU, encryption, access tier, or tags for a storage account. It can also be used to map the account to a custom domain. Only one custom domain is supported per storage account; the replacement/change of custom domain is not supported. In order to replace an old custom domain, the old value must be cleared/unregistered before a new value can be set. The update of multiple properties is supported. This call does not change the storage keys for the account. If you want to change the storage account keys, use the regenerate keys operation. The location and name of the storage account cannot be changed after creation.
  ## 
  let valid = call_564223.validator(path, query, header, formData, body)
  let scheme = call_564223.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564223.url(scheme.get, call_564223.host, call_564223.base,
                         call_564223.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564223, url, valid)

proc call*(call_564224: Call_StorageAccountsUpdate_564215; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; parameters: JsonNode;
          accountName: string): Recallable =
  ## storageAccountsUpdate
  ## The update operation can be used to update the SKU, encryption, access tier, or tags for a storage account. It can also be used to map the account to a custom domain. Only one custom domain is supported per storage account; the replacement/change of custom domain is not supported. In order to replace an old custom domain, the old value must be cleared/unregistered before a new value can be set. The update of multiple properties is supported. This call does not change the storage keys for the account. If you want to change the storage account keys, use the regenerate keys operation. The location and name of the storage account cannot be changed after creation.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   parameters: JObject (required)
  ##             : The parameters to provide for the updated account.
  ##   accountName: string (required)
  ##              : The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
  var path_564225 = newJObject()
  var query_564226 = newJObject()
  var body_564227 = newJObject()
  add(query_564226, "api-version", newJString(apiVersion))
  add(path_564225, "subscriptionId", newJString(subscriptionId))
  add(path_564225, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564227 = parameters
  add(path_564225, "accountName", newJString(accountName))
  result = call_564224.call(path_564225, query_564226, nil, nil, body_564227)

var storageAccountsUpdate* = Call_StorageAccountsUpdate_564215(
    name: "storageAccountsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{accountName}",
    validator: validate_StorageAccountsUpdate_564216, base: "",
    url: url_StorageAccountsUpdate_564217, schemes: {Scheme.Https})
type
  Call_StorageAccountsDelete_564204 = ref object of OpenApiRestCall_563565
proc url_StorageAccountsDelete_564206(protocol: Scheme; host: string; base: string;
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
               (kind: VariableSegment, value: "accountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageAccountsDelete_564205(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a storage account in Microsoft Azure.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   accountName: JString (required)
  ##              : The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564207 = path.getOrDefault("subscriptionId")
  valid_564207 = validateParameter(valid_564207, JString, required = true,
                                 default = nil)
  if valid_564207 != nil:
    section.add "subscriptionId", valid_564207
  var valid_564208 = path.getOrDefault("resourceGroupName")
  valid_564208 = validateParameter(valid_564208, JString, required = true,
                                 default = nil)
  if valid_564208 != nil:
    section.add "resourceGroupName", valid_564208
  var valid_564209 = path.getOrDefault("accountName")
  valid_564209 = validateParameter(valid_564209, JString, required = true,
                                 default = nil)
  if valid_564209 != nil:
    section.add "accountName", valid_564209
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564210 = query.getOrDefault("api-version")
  valid_564210 = validateParameter(valid_564210, JString, required = true,
                                 default = nil)
  if valid_564210 != nil:
    section.add "api-version", valid_564210
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564211: Call_StorageAccountsDelete_564204; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a storage account in Microsoft Azure.
  ## 
  let valid = call_564211.validator(path, query, header, formData, body)
  let scheme = call_564211.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564211.url(scheme.get, call_564211.host, call_564211.base,
                         call_564211.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564211, url, valid)

proc call*(call_564212: Call_StorageAccountsDelete_564204; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; accountName: string): Recallable =
  ## storageAccountsDelete
  ## Deletes a storage account in Microsoft Azure.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   accountName: string (required)
  ##              : The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
  var path_564213 = newJObject()
  var query_564214 = newJObject()
  add(query_564214, "api-version", newJString(apiVersion))
  add(path_564213, "subscriptionId", newJString(subscriptionId))
  add(path_564213, "resourceGroupName", newJString(resourceGroupName))
  add(path_564213, "accountName", newJString(accountName))
  result = call_564212.call(path_564213, query_564214, nil, nil, nil)

var storageAccountsDelete* = Call_StorageAccountsDelete_564204(
    name: "storageAccountsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{accountName}",
    validator: validate_StorageAccountsDelete_564205, base: "",
    url: url_StorageAccountsDelete_564206, schemes: {Scheme.Https})
type
  Call_StorageAccountsListAccountSAS_564228 = ref object of OpenApiRestCall_563565
proc url_StorageAccountsListAccountSAS_564230(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
               (kind: ConstantSegment, value: "/ListAccountSas")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageAccountsListAccountSAS_564229(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List SAS credentials of a storage account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   accountName: JString (required)
  ##              : The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564231 = path.getOrDefault("subscriptionId")
  valid_564231 = validateParameter(valid_564231, JString, required = true,
                                 default = nil)
  if valid_564231 != nil:
    section.add "subscriptionId", valid_564231
  var valid_564232 = path.getOrDefault("resourceGroupName")
  valid_564232 = validateParameter(valid_564232, JString, required = true,
                                 default = nil)
  if valid_564232 != nil:
    section.add "resourceGroupName", valid_564232
  var valid_564233 = path.getOrDefault("accountName")
  valid_564233 = validateParameter(valid_564233, JString, required = true,
                                 default = nil)
  if valid_564233 != nil:
    section.add "accountName", valid_564233
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564234 = query.getOrDefault("api-version")
  valid_564234 = validateParameter(valid_564234, JString, required = true,
                                 default = nil)
  if valid_564234 != nil:
    section.add "api-version", valid_564234
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters to provide to list SAS credentials for the storage account.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564236: Call_StorageAccountsListAccountSAS_564228; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List SAS credentials of a storage account.
  ## 
  let valid = call_564236.validator(path, query, header, formData, body)
  let scheme = call_564236.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564236.url(scheme.get, call_564236.host, call_564236.base,
                         call_564236.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564236, url, valid)

proc call*(call_564237: Call_StorageAccountsListAccountSAS_564228;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          parameters: JsonNode; accountName: string): Recallable =
  ## storageAccountsListAccountSAS
  ## List SAS credentials of a storage account.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   parameters: JObject (required)
  ##             : The parameters to provide to list SAS credentials for the storage account.
  ##   accountName: string (required)
  ##              : The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
  var path_564238 = newJObject()
  var query_564239 = newJObject()
  var body_564240 = newJObject()
  add(query_564239, "api-version", newJString(apiVersion))
  add(path_564238, "subscriptionId", newJString(subscriptionId))
  add(path_564238, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564240 = parameters
  add(path_564238, "accountName", newJString(accountName))
  result = call_564237.call(path_564238, query_564239, nil, nil, body_564240)

var storageAccountsListAccountSAS* = Call_StorageAccountsListAccountSAS_564228(
    name: "storageAccountsListAccountSAS", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{accountName}/ListAccountSas",
    validator: validate_StorageAccountsListAccountSAS_564229, base: "",
    url: url_StorageAccountsListAccountSAS_564230, schemes: {Scheme.Https})
type
  Call_StorageAccountsListServiceSAS_564241 = ref object of OpenApiRestCall_563565
proc url_StorageAccountsListServiceSAS_564243(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
               (kind: ConstantSegment, value: "/ListServiceSas")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageAccountsListServiceSAS_564242(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List service SAS credentials of a specific resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   accountName: JString (required)
  ##              : The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564254 = path.getOrDefault("subscriptionId")
  valid_564254 = validateParameter(valid_564254, JString, required = true,
                                 default = nil)
  if valid_564254 != nil:
    section.add "subscriptionId", valid_564254
  var valid_564255 = path.getOrDefault("resourceGroupName")
  valid_564255 = validateParameter(valid_564255, JString, required = true,
                                 default = nil)
  if valid_564255 != nil:
    section.add "resourceGroupName", valid_564255
  var valid_564256 = path.getOrDefault("accountName")
  valid_564256 = validateParameter(valid_564256, JString, required = true,
                                 default = nil)
  if valid_564256 != nil:
    section.add "accountName", valid_564256
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564257 = query.getOrDefault("api-version")
  valid_564257 = validateParameter(valid_564257, JString, required = true,
                                 default = nil)
  if valid_564257 != nil:
    section.add "api-version", valid_564257
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters to provide to list service SAS credentials.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564259: Call_StorageAccountsListServiceSAS_564241; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List service SAS credentials of a specific resource.
  ## 
  let valid = call_564259.validator(path, query, header, formData, body)
  let scheme = call_564259.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564259.url(scheme.get, call_564259.host, call_564259.base,
                         call_564259.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564259, url, valid)

proc call*(call_564260: Call_StorageAccountsListServiceSAS_564241;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          parameters: JsonNode; accountName: string): Recallable =
  ## storageAccountsListServiceSAS
  ## List service SAS credentials of a specific resource.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   parameters: JObject (required)
  ##             : The parameters to provide to list service SAS credentials.
  ##   accountName: string (required)
  ##              : The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
  var path_564261 = newJObject()
  var query_564262 = newJObject()
  var body_564263 = newJObject()
  add(query_564262, "api-version", newJString(apiVersion))
  add(path_564261, "subscriptionId", newJString(subscriptionId))
  add(path_564261, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564263 = parameters
  add(path_564261, "accountName", newJString(accountName))
  result = call_564260.call(path_564261, query_564262, nil, nil, body_564263)

var storageAccountsListServiceSAS* = Call_StorageAccountsListServiceSAS_564241(
    name: "storageAccountsListServiceSAS", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{accountName}/ListServiceSas",
    validator: validate_StorageAccountsListServiceSAS_564242, base: "",
    url: url_StorageAccountsListServiceSAS_564243, schemes: {Scheme.Https})
type
  Call_StorageAccountsFailover_564264 = ref object of OpenApiRestCall_563565
proc url_StorageAccountsFailover_564266(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
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
               (kind: ConstantSegment, value: "/failover")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageAccountsFailover_564265(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Failover request can be triggered for a storage account in case of availability issues. The failover occurs from the storage account's primary cluster to secondary cluster for RA-GRS accounts. The secondary cluster will become primary after failover.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   accountName: JString (required)
  ##              : The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564267 = path.getOrDefault("subscriptionId")
  valid_564267 = validateParameter(valid_564267, JString, required = true,
                                 default = nil)
  if valid_564267 != nil:
    section.add "subscriptionId", valid_564267
  var valid_564268 = path.getOrDefault("resourceGroupName")
  valid_564268 = validateParameter(valid_564268, JString, required = true,
                                 default = nil)
  if valid_564268 != nil:
    section.add "resourceGroupName", valid_564268
  var valid_564269 = path.getOrDefault("accountName")
  valid_564269 = validateParameter(valid_564269, JString, required = true,
                                 default = nil)
  if valid_564269 != nil:
    section.add "accountName", valid_564269
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564270 = query.getOrDefault("api-version")
  valid_564270 = validateParameter(valid_564270, JString, required = true,
                                 default = nil)
  if valid_564270 != nil:
    section.add "api-version", valid_564270
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564271: Call_StorageAccountsFailover_564264; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Failover request can be triggered for a storage account in case of availability issues. The failover occurs from the storage account's primary cluster to secondary cluster for RA-GRS accounts. The secondary cluster will become primary after failover.
  ## 
  let valid = call_564271.validator(path, query, header, formData, body)
  let scheme = call_564271.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564271.url(scheme.get, call_564271.host, call_564271.base,
                         call_564271.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564271, url, valid)

proc call*(call_564272: Call_StorageAccountsFailover_564264; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; accountName: string): Recallable =
  ## storageAccountsFailover
  ## Failover request can be triggered for a storage account in case of availability issues. The failover occurs from the storage account's primary cluster to secondary cluster for RA-GRS accounts. The secondary cluster will become primary after failover.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   accountName: string (required)
  ##              : The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
  var path_564273 = newJObject()
  var query_564274 = newJObject()
  add(query_564274, "api-version", newJString(apiVersion))
  add(path_564273, "subscriptionId", newJString(subscriptionId))
  add(path_564273, "resourceGroupName", newJString(resourceGroupName))
  add(path_564273, "accountName", newJString(accountName))
  result = call_564272.call(path_564273, query_564274, nil, nil, nil)

var storageAccountsFailover* = Call_StorageAccountsFailover_564264(
    name: "storageAccountsFailover", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{accountName}/failover",
    validator: validate_StorageAccountsFailover_564265, base: "",
    url: url_StorageAccountsFailover_564266, schemes: {Scheme.Https})
type
  Call_StorageAccountsListKeys_564275 = ref object of OpenApiRestCall_563565
proc url_StorageAccountsListKeys_564277(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
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
               (kind: ConstantSegment, value: "/listKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageAccountsListKeys_564276(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the access keys for the specified storage account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   accountName: JString (required)
  ##              : The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564278 = path.getOrDefault("subscriptionId")
  valid_564278 = validateParameter(valid_564278, JString, required = true,
                                 default = nil)
  if valid_564278 != nil:
    section.add "subscriptionId", valid_564278
  var valid_564279 = path.getOrDefault("resourceGroupName")
  valid_564279 = validateParameter(valid_564279, JString, required = true,
                                 default = nil)
  if valid_564279 != nil:
    section.add "resourceGroupName", valid_564279
  var valid_564280 = path.getOrDefault("accountName")
  valid_564280 = validateParameter(valid_564280, JString, required = true,
                                 default = nil)
  if valid_564280 != nil:
    section.add "accountName", valid_564280
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564281 = query.getOrDefault("api-version")
  valid_564281 = validateParameter(valid_564281, JString, required = true,
                                 default = nil)
  if valid_564281 != nil:
    section.add "api-version", valid_564281
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564282: Call_StorageAccountsListKeys_564275; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the access keys for the specified storage account.
  ## 
  let valid = call_564282.validator(path, query, header, formData, body)
  let scheme = call_564282.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564282.url(scheme.get, call_564282.host, call_564282.base,
                         call_564282.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564282, url, valid)

proc call*(call_564283: Call_StorageAccountsListKeys_564275; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; accountName: string): Recallable =
  ## storageAccountsListKeys
  ## Lists the access keys for the specified storage account.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   accountName: string (required)
  ##              : The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
  var path_564284 = newJObject()
  var query_564285 = newJObject()
  add(query_564285, "api-version", newJString(apiVersion))
  add(path_564284, "subscriptionId", newJString(subscriptionId))
  add(path_564284, "resourceGroupName", newJString(resourceGroupName))
  add(path_564284, "accountName", newJString(accountName))
  result = call_564283.call(path_564284, query_564285, nil, nil, nil)

var storageAccountsListKeys* = Call_StorageAccountsListKeys_564275(
    name: "storageAccountsListKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{accountName}/listKeys",
    validator: validate_StorageAccountsListKeys_564276, base: "",
    url: url_StorageAccountsListKeys_564277, schemes: {Scheme.Https})
type
  Call_ManagementPoliciesCreateOrUpdate_564298 = ref object of OpenApiRestCall_563565
proc url_ManagementPoliciesCreateOrUpdate_564300(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "managementPolicyName" in path,
        "`managementPolicyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Storage/storageAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/managementPolicies/"),
               (kind: VariableSegment, value: "managementPolicyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagementPoliciesCreateOrUpdate_564299(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets the managementpolicy to the specified storage account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   managementPolicyName: JString (required)
  ##                       : The name of the Storage Account Management Policy. It should always be 'default'
  ##   accountName: JString (required)
  ##              : The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564301 = path.getOrDefault("subscriptionId")
  valid_564301 = validateParameter(valid_564301, JString, required = true,
                                 default = nil)
  if valid_564301 != nil:
    section.add "subscriptionId", valid_564301
  var valid_564302 = path.getOrDefault("resourceGroupName")
  valid_564302 = validateParameter(valid_564302, JString, required = true,
                                 default = nil)
  if valid_564302 != nil:
    section.add "resourceGroupName", valid_564302
  var valid_564303 = path.getOrDefault("managementPolicyName")
  valid_564303 = validateParameter(valid_564303, JString, required = true,
                                 default = newJString("default"))
  if valid_564303 != nil:
    section.add "managementPolicyName", valid_564303
  var valid_564304 = path.getOrDefault("accountName")
  valid_564304 = validateParameter(valid_564304, JString, required = true,
                                 default = nil)
  if valid_564304 != nil:
    section.add "accountName", valid_564304
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564305 = query.getOrDefault("api-version")
  valid_564305 = validateParameter(valid_564305, JString, required = true,
                                 default = nil)
  if valid_564305 != nil:
    section.add "api-version", valid_564305
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   properties: JObject (required)
  ##             : The ManagementPolicy set to a storage account.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564307: Call_ManagementPoliciesCreateOrUpdate_564298;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the managementpolicy to the specified storage account.
  ## 
  let valid = call_564307.validator(path, query, header, formData, body)
  let scheme = call_564307.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564307.url(scheme.get, call_564307.host, call_564307.base,
                         call_564307.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564307, url, valid)

proc call*(call_564308: Call_ManagementPoliciesCreateOrUpdate_564298;
          properties: JsonNode; apiVersion: string; subscriptionId: string;
          resourceGroupName: string; accountName: string;
          managementPolicyName: string = "default"): Recallable =
  ## managementPoliciesCreateOrUpdate
  ## Sets the managementpolicy to the specified storage account.
  ##   properties: JObject (required)
  ##             : The ManagementPolicy set to a storage account.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   managementPolicyName: string (required)
  ##                       : The name of the Storage Account Management Policy. It should always be 'default'
  ##   accountName: string (required)
  ##              : The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
  var path_564309 = newJObject()
  var query_564310 = newJObject()
  var body_564311 = newJObject()
  if properties != nil:
    body_564311 = properties
  add(query_564310, "api-version", newJString(apiVersion))
  add(path_564309, "subscriptionId", newJString(subscriptionId))
  add(path_564309, "resourceGroupName", newJString(resourceGroupName))
  add(path_564309, "managementPolicyName", newJString(managementPolicyName))
  add(path_564309, "accountName", newJString(accountName))
  result = call_564308.call(path_564309, query_564310, nil, nil, body_564311)

var managementPoliciesCreateOrUpdate* = Call_ManagementPoliciesCreateOrUpdate_564298(
    name: "managementPoliciesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{accountName}/managementPolicies/{managementPolicyName}",
    validator: validate_ManagementPoliciesCreateOrUpdate_564299, base: "",
    url: url_ManagementPoliciesCreateOrUpdate_564300, schemes: {Scheme.Https})
type
  Call_ManagementPoliciesGet_564286 = ref object of OpenApiRestCall_563565
proc url_ManagementPoliciesGet_564288(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "managementPolicyName" in path,
        "`managementPolicyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Storage/storageAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/managementPolicies/"),
               (kind: VariableSegment, value: "managementPolicyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagementPoliciesGet_564287(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the managementpolicy associated with the specified storage account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   managementPolicyName: JString (required)
  ##                       : The name of the Storage Account Management Policy. It should always be 'default'
  ##   accountName: JString (required)
  ##              : The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564289 = path.getOrDefault("subscriptionId")
  valid_564289 = validateParameter(valid_564289, JString, required = true,
                                 default = nil)
  if valid_564289 != nil:
    section.add "subscriptionId", valid_564289
  var valid_564290 = path.getOrDefault("resourceGroupName")
  valid_564290 = validateParameter(valid_564290, JString, required = true,
                                 default = nil)
  if valid_564290 != nil:
    section.add "resourceGroupName", valid_564290
  var valid_564291 = path.getOrDefault("managementPolicyName")
  valid_564291 = validateParameter(valid_564291, JString, required = true,
                                 default = newJString("default"))
  if valid_564291 != nil:
    section.add "managementPolicyName", valid_564291
  var valid_564292 = path.getOrDefault("accountName")
  valid_564292 = validateParameter(valid_564292, JString, required = true,
                                 default = nil)
  if valid_564292 != nil:
    section.add "accountName", valid_564292
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564293 = query.getOrDefault("api-version")
  valid_564293 = validateParameter(valid_564293, JString, required = true,
                                 default = nil)
  if valid_564293 != nil:
    section.add "api-version", valid_564293
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564294: Call_ManagementPoliciesGet_564286; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the managementpolicy associated with the specified storage account.
  ## 
  let valid = call_564294.validator(path, query, header, formData, body)
  let scheme = call_564294.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564294.url(scheme.get, call_564294.host, call_564294.base,
                         call_564294.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564294, url, valid)

proc call*(call_564295: Call_ManagementPoliciesGet_564286; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; accountName: string;
          managementPolicyName: string = "default"): Recallable =
  ## managementPoliciesGet
  ## Gets the managementpolicy associated with the specified storage account.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   managementPolicyName: string (required)
  ##                       : The name of the Storage Account Management Policy. It should always be 'default'
  ##   accountName: string (required)
  ##              : The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
  var path_564296 = newJObject()
  var query_564297 = newJObject()
  add(query_564297, "api-version", newJString(apiVersion))
  add(path_564296, "subscriptionId", newJString(subscriptionId))
  add(path_564296, "resourceGroupName", newJString(resourceGroupName))
  add(path_564296, "managementPolicyName", newJString(managementPolicyName))
  add(path_564296, "accountName", newJString(accountName))
  result = call_564295.call(path_564296, query_564297, nil, nil, nil)

var managementPoliciesGet* = Call_ManagementPoliciesGet_564286(
    name: "managementPoliciesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{accountName}/managementPolicies/{managementPolicyName}",
    validator: validate_ManagementPoliciesGet_564287, base: "",
    url: url_ManagementPoliciesGet_564288, schemes: {Scheme.Https})
type
  Call_ManagementPoliciesDelete_564312 = ref object of OpenApiRestCall_563565
proc url_ManagementPoliciesDelete_564314(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "managementPolicyName" in path,
        "`managementPolicyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Storage/storageAccounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/managementPolicies/"),
               (kind: VariableSegment, value: "managementPolicyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagementPoliciesDelete_564313(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the managementpolicy associated with the specified storage account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   managementPolicyName: JString (required)
  ##                       : The name of the Storage Account Management Policy. It should always be 'default'
  ##   accountName: JString (required)
  ##              : The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564315 = path.getOrDefault("subscriptionId")
  valid_564315 = validateParameter(valid_564315, JString, required = true,
                                 default = nil)
  if valid_564315 != nil:
    section.add "subscriptionId", valid_564315
  var valid_564316 = path.getOrDefault("resourceGroupName")
  valid_564316 = validateParameter(valid_564316, JString, required = true,
                                 default = nil)
  if valid_564316 != nil:
    section.add "resourceGroupName", valid_564316
  var valid_564317 = path.getOrDefault("managementPolicyName")
  valid_564317 = validateParameter(valid_564317, JString, required = true,
                                 default = newJString("default"))
  if valid_564317 != nil:
    section.add "managementPolicyName", valid_564317
  var valid_564318 = path.getOrDefault("accountName")
  valid_564318 = validateParameter(valid_564318, JString, required = true,
                                 default = nil)
  if valid_564318 != nil:
    section.add "accountName", valid_564318
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564319 = query.getOrDefault("api-version")
  valid_564319 = validateParameter(valid_564319, JString, required = true,
                                 default = nil)
  if valid_564319 != nil:
    section.add "api-version", valid_564319
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564320: Call_ManagementPoliciesDelete_564312; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the managementpolicy associated with the specified storage account.
  ## 
  let valid = call_564320.validator(path, query, header, formData, body)
  let scheme = call_564320.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564320.url(scheme.get, call_564320.host, call_564320.base,
                         call_564320.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564320, url, valid)

proc call*(call_564321: Call_ManagementPoliciesDelete_564312; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; accountName: string;
          managementPolicyName: string = "default"): Recallable =
  ## managementPoliciesDelete
  ## Deletes the managementpolicy associated with the specified storage account.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   managementPolicyName: string (required)
  ##                       : The name of the Storage Account Management Policy. It should always be 'default'
  ##   accountName: string (required)
  ##              : The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
  var path_564322 = newJObject()
  var query_564323 = newJObject()
  add(query_564323, "api-version", newJString(apiVersion))
  add(path_564322, "subscriptionId", newJString(subscriptionId))
  add(path_564322, "resourceGroupName", newJString(resourceGroupName))
  add(path_564322, "managementPolicyName", newJString(managementPolicyName))
  add(path_564322, "accountName", newJString(accountName))
  result = call_564321.call(path_564322, query_564323, nil, nil, nil)

var managementPoliciesDelete* = Call_ManagementPoliciesDelete_564312(
    name: "managementPoliciesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{accountName}/managementPolicies/{managementPolicyName}",
    validator: validate_ManagementPoliciesDelete_564313, base: "",
    url: url_ManagementPoliciesDelete_564314, schemes: {Scheme.Https})
type
  Call_StorageAccountsRegenerateKey_564324 = ref object of OpenApiRestCall_563565
proc url_StorageAccountsRegenerateKey_564326(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
               (kind: ConstantSegment, value: "/regenerateKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageAccountsRegenerateKey_564325(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Regenerates one of the access keys for the specified storage account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   accountName: JString (required)
  ##              : The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564327 = path.getOrDefault("subscriptionId")
  valid_564327 = validateParameter(valid_564327, JString, required = true,
                                 default = nil)
  if valid_564327 != nil:
    section.add "subscriptionId", valid_564327
  var valid_564328 = path.getOrDefault("resourceGroupName")
  valid_564328 = validateParameter(valid_564328, JString, required = true,
                                 default = nil)
  if valid_564328 != nil:
    section.add "resourceGroupName", valid_564328
  var valid_564329 = path.getOrDefault("accountName")
  valid_564329 = validateParameter(valid_564329, JString, required = true,
                                 default = nil)
  if valid_564329 != nil:
    section.add "accountName", valid_564329
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564330 = query.getOrDefault("api-version")
  valid_564330 = validateParameter(valid_564330, JString, required = true,
                                 default = nil)
  if valid_564330 != nil:
    section.add "api-version", valid_564330
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   regenerateKey: JObject (required)
  ##                : Specifies name of the key which should be regenerated -- key1 or key2.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564332: Call_StorageAccountsRegenerateKey_564324; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Regenerates one of the access keys for the specified storage account.
  ## 
  let valid = call_564332.validator(path, query, header, formData, body)
  let scheme = call_564332.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564332.url(scheme.get, call_564332.host, call_564332.base,
                         call_564332.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564332, url, valid)

proc call*(call_564333: Call_StorageAccountsRegenerateKey_564324;
          regenerateKey: JsonNode; apiVersion: string; subscriptionId: string;
          resourceGroupName: string; accountName: string): Recallable =
  ## storageAccountsRegenerateKey
  ## Regenerates one of the access keys for the specified storage account.
  ##   regenerateKey: JObject (required)
  ##                : Specifies name of the key which should be regenerated -- key1 or key2.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   accountName: string (required)
  ##              : The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
  var path_564334 = newJObject()
  var query_564335 = newJObject()
  var body_564336 = newJObject()
  if regenerateKey != nil:
    body_564336 = regenerateKey
  add(query_564335, "api-version", newJString(apiVersion))
  add(path_564334, "subscriptionId", newJString(subscriptionId))
  add(path_564334, "resourceGroupName", newJString(resourceGroupName))
  add(path_564334, "accountName", newJString(accountName))
  result = call_564333.call(path_564334, query_564335, nil, nil, body_564336)

var storageAccountsRegenerateKey* = Call_StorageAccountsRegenerateKey_564324(
    name: "storageAccountsRegenerateKey", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{accountName}/regenerateKey",
    validator: validate_StorageAccountsRegenerateKey_564325, base: "",
    url: url_StorageAccountsRegenerateKey_564326, schemes: {Scheme.Https})
type
  Call_StorageAccountsRevokeUserDelegationKeys_564337 = ref object of OpenApiRestCall_563565
proc url_StorageAccountsRevokeUserDelegationKeys_564339(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
               (kind: ConstantSegment, value: "/revokeUserDelegationKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageAccountsRevokeUserDelegationKeys_564338(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Revoke user delegation keys.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   accountName: JString (required)
  ##              : The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564340 = path.getOrDefault("subscriptionId")
  valid_564340 = validateParameter(valid_564340, JString, required = true,
                                 default = nil)
  if valid_564340 != nil:
    section.add "subscriptionId", valid_564340
  var valid_564341 = path.getOrDefault("resourceGroupName")
  valid_564341 = validateParameter(valid_564341, JString, required = true,
                                 default = nil)
  if valid_564341 != nil:
    section.add "resourceGroupName", valid_564341
  var valid_564342 = path.getOrDefault("accountName")
  valid_564342 = validateParameter(valid_564342, JString, required = true,
                                 default = nil)
  if valid_564342 != nil:
    section.add "accountName", valid_564342
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564343 = query.getOrDefault("api-version")
  valid_564343 = validateParameter(valid_564343, JString, required = true,
                                 default = nil)
  if valid_564343 != nil:
    section.add "api-version", valid_564343
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564344: Call_StorageAccountsRevokeUserDelegationKeys_564337;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Revoke user delegation keys.
  ## 
  let valid = call_564344.validator(path, query, header, formData, body)
  let scheme = call_564344.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564344.url(scheme.get, call_564344.host, call_564344.base,
                         call_564344.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564344, url, valid)

proc call*(call_564345: Call_StorageAccountsRevokeUserDelegationKeys_564337;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          accountName: string): Recallable =
  ## storageAccountsRevokeUserDelegationKeys
  ## Revoke user delegation keys.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   accountName: string (required)
  ##              : The name of the storage account within the specified resource group. Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
  var path_564346 = newJObject()
  var query_564347 = newJObject()
  add(query_564347, "api-version", newJString(apiVersion))
  add(path_564346, "subscriptionId", newJString(subscriptionId))
  add(path_564346, "resourceGroupName", newJString(resourceGroupName))
  add(path_564346, "accountName", newJString(accountName))
  result = call_564345.call(path_564346, query_564347, nil, nil, nil)

var storageAccountsRevokeUserDelegationKeys* = Call_StorageAccountsRevokeUserDelegationKeys_564337(
    name: "storageAccountsRevokeUserDelegationKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{accountName}/revokeUserDelegationKeys",
    validator: validate_StorageAccountsRevokeUserDelegationKeys_564338, base: "",
    url: url_StorageAccountsRevokeUserDelegationKeys_564339,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
