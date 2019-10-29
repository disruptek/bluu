
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: AppConfigurationManagementClient
## version: 2019-02-01-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## 
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

  OpenApiRestCall_563556 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563556](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563556): Option[Scheme] {.used.} =
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
  macServiceName = "appconfiguration"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_563778 = ref object of OpenApiRestCall_563556
proc url_OperationsList_563780(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_563779(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists the operations available from this provider.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   $skipToken: JString
  ##             : A skip token is used to continue retrieving items after an operation returns a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skipToken parameter that specifies a starting point to use for subsequent calls.
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  var valid_563942 = query.getOrDefault("$skipToken")
  valid_563942 = validateParameter(valid_563942, JString, required = false,
                                 default = nil)
  if valid_563942 != nil:
    section.add "$skipToken", valid_563942
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563943 = query.getOrDefault("api-version")
  valid_563943 = validateParameter(valid_563943, JString, required = true,
                                 default = nil)
  if valid_563943 != nil:
    section.add "api-version", valid_563943
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563966: Call_OperationsList_563778; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the operations available from this provider.
  ## 
  let valid = call_563966.validator(path, query, header, formData, body)
  let scheme = call_563966.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563966.url(scheme.get, call_563966.host, call_563966.base,
                         call_563966.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563966, url, valid)

proc call*(call_564037: Call_OperationsList_563778; apiVersion: string;
          SkipToken: string = ""): Recallable =
  ## operationsList
  ## Lists the operations available from this provider.
  ##   SkipToken: string
  ##            : A skip token is used to continue retrieving items after an operation returns a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skipToken parameter that specifies a starting point to use for subsequent calls.
  ##   apiVersion: string (required)
  ##             : The client API version.
  var query_564038 = newJObject()
  add(query_564038, "$skipToken", newJString(SkipToken))
  add(query_564038, "api-version", newJString(apiVersion))
  result = call_564037.call(nil, query_564038, nil, nil, nil)

var operationsList* = Call_OperationsList_563778(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.AppConfiguration/operations",
    validator: validate_OperationsList_563779, base: "", url: url_OperationsList_563780,
    schemes: {Scheme.Https})
type
  Call_OperationsCheckNameAvailability_564078 = ref object of OpenApiRestCall_563556
proc url_OperationsCheckNameAvailability_564080(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.AppConfiguration/checkNameAvailability")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_OperationsCheckNameAvailability_564079(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Checks whether the configuration store name is available for use.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Microsoft Azure subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564095 = path.getOrDefault("subscriptionId")
  valid_564095 = validateParameter(valid_564095, JString, required = true,
                                 default = nil)
  if valid_564095 != nil:
    section.add "subscriptionId", valid_564095
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564096 = query.getOrDefault("api-version")
  valid_564096 = validateParameter(valid_564096, JString, required = true,
                                 default = nil)
  if valid_564096 != nil:
    section.add "api-version", valid_564096
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   checkNameAvailabilityParameters: JObject (required)
  ##                                  : The object containing information for the availability request.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564098: Call_OperationsCheckNameAvailability_564078;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Checks whether the configuration store name is available for use.
  ## 
  let valid = call_564098.validator(path, query, header, formData, body)
  let scheme = call_564098.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564098.url(scheme.get, call_564098.host, call_564098.base,
                         call_564098.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564098, url, valid)

proc call*(call_564099: Call_OperationsCheckNameAvailability_564078;
          apiVersion: string; subscriptionId: string;
          checkNameAvailabilityParameters: JsonNode): Recallable =
  ## operationsCheckNameAvailability
  ## Checks whether the configuration store name is available for use.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   checkNameAvailabilityParameters: JObject (required)
  ##                                  : The object containing information for the availability request.
  var path_564100 = newJObject()
  var query_564101 = newJObject()
  var body_564102 = newJObject()
  add(query_564101, "api-version", newJString(apiVersion))
  add(path_564100, "subscriptionId", newJString(subscriptionId))
  if checkNameAvailabilityParameters != nil:
    body_564102 = checkNameAvailabilityParameters
  result = call_564099.call(path_564100, query_564101, nil, nil, body_564102)

var operationsCheckNameAvailability* = Call_OperationsCheckNameAvailability_564078(
    name: "operationsCheckNameAvailability", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.AppConfiguration/checkNameAvailability",
    validator: validate_OperationsCheckNameAvailability_564079, base: "",
    url: url_OperationsCheckNameAvailability_564080, schemes: {Scheme.Https})
type
  Call_ConfigurationStoresList_564103 = ref object of OpenApiRestCall_563556
proc url_ConfigurationStoresList_564105(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.AppConfiguration/configurationStores")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ConfigurationStoresList_564104(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the configuration stores for a given subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Microsoft Azure subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564106 = path.getOrDefault("subscriptionId")
  valid_564106 = validateParameter(valid_564106, JString, required = true,
                                 default = nil)
  if valid_564106 != nil:
    section.add "subscriptionId", valid_564106
  result.add "path", section
  ## parameters in `query` object:
  ##   $skipToken: JString
  ##             : A skip token is used to continue retrieving items after an operation returns a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skipToken parameter that specifies a starting point to use for subsequent calls.
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  var valid_564107 = query.getOrDefault("$skipToken")
  valid_564107 = validateParameter(valid_564107, JString, required = false,
                                 default = nil)
  if valid_564107 != nil:
    section.add "$skipToken", valid_564107
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564108 = query.getOrDefault("api-version")
  valid_564108 = validateParameter(valid_564108, JString, required = true,
                                 default = nil)
  if valid_564108 != nil:
    section.add "api-version", valid_564108
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564109: Call_ConfigurationStoresList_564103; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the configuration stores for a given subscription.
  ## 
  let valid = call_564109.validator(path, query, header, formData, body)
  let scheme = call_564109.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564109.url(scheme.get, call_564109.host, call_564109.base,
                         call_564109.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564109, url, valid)

proc call*(call_564110: Call_ConfigurationStoresList_564103; apiVersion: string;
          subscriptionId: string; SkipToken: string = ""): Recallable =
  ## configurationStoresList
  ## Lists the configuration stores for a given subscription.
  ##   SkipToken: string
  ##            : A skip token is used to continue retrieving items after an operation returns a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skipToken parameter that specifies a starting point to use for subsequent calls.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  var path_564111 = newJObject()
  var query_564112 = newJObject()
  add(query_564112, "$skipToken", newJString(SkipToken))
  add(query_564112, "api-version", newJString(apiVersion))
  add(path_564111, "subscriptionId", newJString(subscriptionId))
  result = call_564110.call(path_564111, query_564112, nil, nil, nil)

var configurationStoresList* = Call_ConfigurationStoresList_564103(
    name: "configurationStoresList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.AppConfiguration/configurationStores",
    validator: validate_ConfigurationStoresList_564104, base: "",
    url: url_ConfigurationStoresList_564105, schemes: {Scheme.Https})
type
  Call_ConfigurationStoresListByResourceGroup_564113 = ref object of OpenApiRestCall_563556
proc url_ConfigurationStoresListByResourceGroup_564115(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
        value: "/providers/Microsoft.AppConfiguration/configurationStores")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ConfigurationStoresListByResourceGroup_564114(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the configuration stores for a given resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to which the container registry belongs.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564116 = path.getOrDefault("subscriptionId")
  valid_564116 = validateParameter(valid_564116, JString, required = true,
                                 default = nil)
  if valid_564116 != nil:
    section.add "subscriptionId", valid_564116
  var valid_564117 = path.getOrDefault("resourceGroupName")
  valid_564117 = validateParameter(valid_564117, JString, required = true,
                                 default = nil)
  if valid_564117 != nil:
    section.add "resourceGroupName", valid_564117
  result.add "path", section
  ## parameters in `query` object:
  ##   $skipToken: JString
  ##             : A skip token is used to continue retrieving items after an operation returns a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skipToken parameter that specifies a starting point to use for subsequent calls.
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  var valid_564118 = query.getOrDefault("$skipToken")
  valid_564118 = validateParameter(valid_564118, JString, required = false,
                                 default = nil)
  if valid_564118 != nil:
    section.add "$skipToken", valid_564118
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564119 = query.getOrDefault("api-version")
  valid_564119 = validateParameter(valid_564119, JString, required = true,
                                 default = nil)
  if valid_564119 != nil:
    section.add "api-version", valid_564119
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564120: Call_ConfigurationStoresListByResourceGroup_564113;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the configuration stores for a given resource group.
  ## 
  let valid = call_564120.validator(path, query, header, formData, body)
  let scheme = call_564120.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564120.url(scheme.get, call_564120.host, call_564120.base,
                         call_564120.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564120, url, valid)

proc call*(call_564121: Call_ConfigurationStoresListByResourceGroup_564113;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          SkipToken: string = ""): Recallable =
  ## configurationStoresListByResourceGroup
  ## Lists the configuration stores for a given resource group.
  ##   SkipToken: string
  ##            : A skip token is used to continue retrieving items after an operation returns a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skipToken parameter that specifies a starting point to use for subsequent calls.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the container registry belongs.
  var path_564122 = newJObject()
  var query_564123 = newJObject()
  add(query_564123, "$skipToken", newJString(SkipToken))
  add(query_564123, "api-version", newJString(apiVersion))
  add(path_564122, "subscriptionId", newJString(subscriptionId))
  add(path_564122, "resourceGroupName", newJString(resourceGroupName))
  result = call_564121.call(path_564122, query_564123, nil, nil, nil)

var configurationStoresListByResourceGroup* = Call_ConfigurationStoresListByResourceGroup_564113(
    name: "configurationStoresListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AppConfiguration/configurationStores",
    validator: validate_ConfigurationStoresListByResourceGroup_564114, base: "",
    url: url_ConfigurationStoresListByResourceGroup_564115,
    schemes: {Scheme.Https})
type
  Call_ConfigurationStoresCreate_564135 = ref object of OpenApiRestCall_563556
proc url_ConfigurationStoresCreate_564137(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "configStoreName" in path, "`configStoreName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.AppConfiguration/configurationStores/"),
               (kind: VariableSegment, value: "configStoreName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ConfigurationStoresCreate_564136(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a configuration store with the specified parameters.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   configStoreName: JString (required)
  ##                  : The name of the configuration store.
  ##   subscriptionId: JString (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to which the container registry belongs.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `configStoreName` field"
  var valid_564138 = path.getOrDefault("configStoreName")
  valid_564138 = validateParameter(valid_564138, JString, required = true,
                                 default = nil)
  if valid_564138 != nil:
    section.add "configStoreName", valid_564138
  var valid_564139 = path.getOrDefault("subscriptionId")
  valid_564139 = validateParameter(valid_564139, JString, required = true,
                                 default = nil)
  if valid_564139 != nil:
    section.add "subscriptionId", valid_564139
  var valid_564140 = path.getOrDefault("resourceGroupName")
  valid_564140 = validateParameter(valid_564140, JString, required = true,
                                 default = nil)
  if valid_564140 != nil:
    section.add "resourceGroupName", valid_564140
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
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
  ## parameters in `body` object:
  ##   configStoreCreationParameters: JObject (required)
  ##                                : The parameters for creating a configuration store.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564143: Call_ConfigurationStoresCreate_564135; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a configuration store with the specified parameters.
  ## 
  let valid = call_564143.validator(path, query, header, formData, body)
  let scheme = call_564143.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564143.url(scheme.get, call_564143.host, call_564143.base,
                         call_564143.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564143, url, valid)

proc call*(call_564144: Call_ConfigurationStoresCreate_564135;
          configStoreName: string; apiVersion: string;
          configStoreCreationParameters: JsonNode; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## configurationStoresCreate
  ## Creates a configuration store with the specified parameters.
  ##   configStoreName: string (required)
  ##                  : The name of the configuration store.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   configStoreCreationParameters: JObject (required)
  ##                                : The parameters for creating a configuration store.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the container registry belongs.
  var path_564145 = newJObject()
  var query_564146 = newJObject()
  var body_564147 = newJObject()
  add(path_564145, "configStoreName", newJString(configStoreName))
  add(query_564146, "api-version", newJString(apiVersion))
  if configStoreCreationParameters != nil:
    body_564147 = configStoreCreationParameters
  add(path_564145, "subscriptionId", newJString(subscriptionId))
  add(path_564145, "resourceGroupName", newJString(resourceGroupName))
  result = call_564144.call(path_564145, query_564146, nil, nil, body_564147)

var configurationStoresCreate* = Call_ConfigurationStoresCreate_564135(
    name: "configurationStoresCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AppConfiguration/configurationStores/{configStoreName}",
    validator: validate_ConfigurationStoresCreate_564136, base: "",
    url: url_ConfigurationStoresCreate_564137, schemes: {Scheme.Https})
type
  Call_ConfigurationStoresGet_564124 = ref object of OpenApiRestCall_563556
proc url_ConfigurationStoresGet_564126(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "configStoreName" in path, "`configStoreName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.AppConfiguration/configurationStores/"),
               (kind: VariableSegment, value: "configStoreName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ConfigurationStoresGet_564125(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the properties of the specified configuration store.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   configStoreName: JString (required)
  ##                  : The name of the configuration store.
  ##   subscriptionId: JString (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to which the container registry belongs.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `configStoreName` field"
  var valid_564127 = path.getOrDefault("configStoreName")
  valid_564127 = validateParameter(valid_564127, JString, required = true,
                                 default = nil)
  if valid_564127 != nil:
    section.add "configStoreName", valid_564127
  var valid_564128 = path.getOrDefault("subscriptionId")
  valid_564128 = validateParameter(valid_564128, JString, required = true,
                                 default = nil)
  if valid_564128 != nil:
    section.add "subscriptionId", valid_564128
  var valid_564129 = path.getOrDefault("resourceGroupName")
  valid_564129 = validateParameter(valid_564129, JString, required = true,
                                 default = nil)
  if valid_564129 != nil:
    section.add "resourceGroupName", valid_564129
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564130 = query.getOrDefault("api-version")
  valid_564130 = validateParameter(valid_564130, JString, required = true,
                                 default = nil)
  if valid_564130 != nil:
    section.add "api-version", valid_564130
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564131: Call_ConfigurationStoresGet_564124; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the properties of the specified configuration store.
  ## 
  let valid = call_564131.validator(path, query, header, formData, body)
  let scheme = call_564131.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564131.url(scheme.get, call_564131.host, call_564131.base,
                         call_564131.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564131, url, valid)

proc call*(call_564132: Call_ConfigurationStoresGet_564124;
          configStoreName: string; apiVersion: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## configurationStoresGet
  ## Gets the properties of the specified configuration store.
  ##   configStoreName: string (required)
  ##                  : The name of the configuration store.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the container registry belongs.
  var path_564133 = newJObject()
  var query_564134 = newJObject()
  add(path_564133, "configStoreName", newJString(configStoreName))
  add(query_564134, "api-version", newJString(apiVersion))
  add(path_564133, "subscriptionId", newJString(subscriptionId))
  add(path_564133, "resourceGroupName", newJString(resourceGroupName))
  result = call_564132.call(path_564133, query_564134, nil, nil, nil)

var configurationStoresGet* = Call_ConfigurationStoresGet_564124(
    name: "configurationStoresGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AppConfiguration/configurationStores/{configStoreName}",
    validator: validate_ConfigurationStoresGet_564125, base: "",
    url: url_ConfigurationStoresGet_564126, schemes: {Scheme.Https})
type
  Call_ConfigurationStoresUpdate_564159 = ref object of OpenApiRestCall_563556
proc url_ConfigurationStoresUpdate_564161(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "configStoreName" in path, "`configStoreName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.AppConfiguration/configurationStores/"),
               (kind: VariableSegment, value: "configStoreName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ConfigurationStoresUpdate_564160(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a configuration store with the specified parameters.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   configStoreName: JString (required)
  ##                  : The name of the configuration store.
  ##   subscriptionId: JString (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to which the container registry belongs.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `configStoreName` field"
  var valid_564162 = path.getOrDefault("configStoreName")
  valid_564162 = validateParameter(valid_564162, JString, required = true,
                                 default = nil)
  if valid_564162 != nil:
    section.add "configStoreName", valid_564162
  var valid_564163 = path.getOrDefault("subscriptionId")
  valid_564163 = validateParameter(valid_564163, JString, required = true,
                                 default = nil)
  if valid_564163 != nil:
    section.add "subscriptionId", valid_564163
  var valid_564164 = path.getOrDefault("resourceGroupName")
  valid_564164 = validateParameter(valid_564164, JString, required = true,
                                 default = nil)
  if valid_564164 != nil:
    section.add "resourceGroupName", valid_564164
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564165 = query.getOrDefault("api-version")
  valid_564165 = validateParameter(valid_564165, JString, required = true,
                                 default = nil)
  if valid_564165 != nil:
    section.add "api-version", valid_564165
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   configStoreUpdateParameters: JObject (required)
  ##                              : The parameters for updating a configuration store.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564167: Call_ConfigurationStoresUpdate_564159; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a configuration store with the specified parameters.
  ## 
  let valid = call_564167.validator(path, query, header, formData, body)
  let scheme = call_564167.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564167.url(scheme.get, call_564167.host, call_564167.base,
                         call_564167.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564167, url, valid)

proc call*(call_564168: Call_ConfigurationStoresUpdate_564159;
          configStoreUpdateParameters: JsonNode; configStoreName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## configurationStoresUpdate
  ## Updates a configuration store with the specified parameters.
  ##   configStoreUpdateParameters: JObject (required)
  ##                              : The parameters for updating a configuration store.
  ##   configStoreName: string (required)
  ##                  : The name of the configuration store.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the container registry belongs.
  var path_564169 = newJObject()
  var query_564170 = newJObject()
  var body_564171 = newJObject()
  if configStoreUpdateParameters != nil:
    body_564171 = configStoreUpdateParameters
  add(path_564169, "configStoreName", newJString(configStoreName))
  add(query_564170, "api-version", newJString(apiVersion))
  add(path_564169, "subscriptionId", newJString(subscriptionId))
  add(path_564169, "resourceGroupName", newJString(resourceGroupName))
  result = call_564168.call(path_564169, query_564170, nil, nil, body_564171)

var configurationStoresUpdate* = Call_ConfigurationStoresUpdate_564159(
    name: "configurationStoresUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AppConfiguration/configurationStores/{configStoreName}",
    validator: validate_ConfigurationStoresUpdate_564160, base: "",
    url: url_ConfigurationStoresUpdate_564161, schemes: {Scheme.Https})
type
  Call_ConfigurationStoresDelete_564148 = ref object of OpenApiRestCall_563556
proc url_ConfigurationStoresDelete_564150(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "configStoreName" in path, "`configStoreName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.AppConfiguration/configurationStores/"),
               (kind: VariableSegment, value: "configStoreName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ConfigurationStoresDelete_564149(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a configuration store.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   configStoreName: JString (required)
  ##                  : The name of the configuration store.
  ##   subscriptionId: JString (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to which the container registry belongs.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `configStoreName` field"
  var valid_564151 = path.getOrDefault("configStoreName")
  valid_564151 = validateParameter(valid_564151, JString, required = true,
                                 default = nil)
  if valid_564151 != nil:
    section.add "configStoreName", valid_564151
  var valid_564152 = path.getOrDefault("subscriptionId")
  valid_564152 = validateParameter(valid_564152, JString, required = true,
                                 default = nil)
  if valid_564152 != nil:
    section.add "subscriptionId", valid_564152
  var valid_564153 = path.getOrDefault("resourceGroupName")
  valid_564153 = validateParameter(valid_564153, JString, required = true,
                                 default = nil)
  if valid_564153 != nil:
    section.add "resourceGroupName", valid_564153
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564154 = query.getOrDefault("api-version")
  valid_564154 = validateParameter(valid_564154, JString, required = true,
                                 default = nil)
  if valid_564154 != nil:
    section.add "api-version", valid_564154
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564155: Call_ConfigurationStoresDelete_564148; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a configuration store.
  ## 
  let valid = call_564155.validator(path, query, header, formData, body)
  let scheme = call_564155.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564155.url(scheme.get, call_564155.host, call_564155.base,
                         call_564155.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564155, url, valid)

proc call*(call_564156: Call_ConfigurationStoresDelete_564148;
          configStoreName: string; apiVersion: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## configurationStoresDelete
  ## Deletes a configuration store.
  ##   configStoreName: string (required)
  ##                  : The name of the configuration store.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the container registry belongs.
  var path_564157 = newJObject()
  var query_564158 = newJObject()
  add(path_564157, "configStoreName", newJString(configStoreName))
  add(query_564158, "api-version", newJString(apiVersion))
  add(path_564157, "subscriptionId", newJString(subscriptionId))
  add(path_564157, "resourceGroupName", newJString(resourceGroupName))
  result = call_564156.call(path_564157, query_564158, nil, nil, nil)

var configurationStoresDelete* = Call_ConfigurationStoresDelete_564148(
    name: "configurationStoresDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AppConfiguration/configurationStores/{configStoreName}",
    validator: validate_ConfigurationStoresDelete_564149, base: "",
    url: url_ConfigurationStoresDelete_564150, schemes: {Scheme.Https})
type
  Call_ConfigurationStoresListKeys_564172 = ref object of OpenApiRestCall_563556
proc url_ConfigurationStoresListKeys_564174(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "configStoreName" in path, "`configStoreName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.AppConfiguration/configurationStores/"),
               (kind: VariableSegment, value: "configStoreName"),
               (kind: ConstantSegment, value: "/ListKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ConfigurationStoresListKeys_564173(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the access key for the specified configuration store.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   configStoreName: JString (required)
  ##                  : The name of the configuration store.
  ##   subscriptionId: JString (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to which the container registry belongs.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `configStoreName` field"
  var valid_564175 = path.getOrDefault("configStoreName")
  valid_564175 = validateParameter(valid_564175, JString, required = true,
                                 default = nil)
  if valid_564175 != nil:
    section.add "configStoreName", valid_564175
  var valid_564176 = path.getOrDefault("subscriptionId")
  valid_564176 = validateParameter(valid_564176, JString, required = true,
                                 default = nil)
  if valid_564176 != nil:
    section.add "subscriptionId", valid_564176
  var valid_564177 = path.getOrDefault("resourceGroupName")
  valid_564177 = validateParameter(valid_564177, JString, required = true,
                                 default = nil)
  if valid_564177 != nil:
    section.add "resourceGroupName", valid_564177
  result.add "path", section
  ## parameters in `query` object:
  ##   $skipToken: JString
  ##             : A skip token is used to continue retrieving items after an operation returns a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skipToken parameter that specifies a starting point to use for subsequent calls.
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  var valid_564178 = query.getOrDefault("$skipToken")
  valid_564178 = validateParameter(valid_564178, JString, required = false,
                                 default = nil)
  if valid_564178 != nil:
    section.add "$skipToken", valid_564178
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564179 = query.getOrDefault("api-version")
  valid_564179 = validateParameter(valid_564179, JString, required = true,
                                 default = nil)
  if valid_564179 != nil:
    section.add "api-version", valid_564179
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564180: Call_ConfigurationStoresListKeys_564172; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the access key for the specified configuration store.
  ## 
  let valid = call_564180.validator(path, query, header, formData, body)
  let scheme = call_564180.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564180.url(scheme.get, call_564180.host, call_564180.base,
                         call_564180.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564180, url, valid)

proc call*(call_564181: Call_ConfigurationStoresListKeys_564172;
          configStoreName: string; apiVersion: string; subscriptionId: string;
          resourceGroupName: string; SkipToken: string = ""): Recallable =
  ## configurationStoresListKeys
  ## Lists the access key for the specified configuration store.
  ##   SkipToken: string
  ##            : A skip token is used to continue retrieving items after an operation returns a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skipToken parameter that specifies a starting point to use for subsequent calls.
  ##   configStoreName: string (required)
  ##                  : The name of the configuration store.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the container registry belongs.
  var path_564182 = newJObject()
  var query_564183 = newJObject()
  add(query_564183, "$skipToken", newJString(SkipToken))
  add(path_564182, "configStoreName", newJString(configStoreName))
  add(query_564183, "api-version", newJString(apiVersion))
  add(path_564182, "subscriptionId", newJString(subscriptionId))
  add(path_564182, "resourceGroupName", newJString(resourceGroupName))
  result = call_564181.call(path_564182, query_564183, nil, nil, nil)

var configurationStoresListKeys* = Call_ConfigurationStoresListKeys_564172(
    name: "configurationStoresListKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AppConfiguration/configurationStores/{configStoreName}/ListKeys",
    validator: validate_ConfigurationStoresListKeys_564173, base: "",
    url: url_ConfigurationStoresListKeys_564174, schemes: {Scheme.Https})
type
  Call_ConfigurationStoresRegenerateKey_564184 = ref object of OpenApiRestCall_563556
proc url_ConfigurationStoresRegenerateKey_564186(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "configStoreName" in path, "`configStoreName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.AppConfiguration/configurationStores/"),
               (kind: VariableSegment, value: "configStoreName"),
               (kind: ConstantSegment, value: "/RegenerateKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ConfigurationStoresRegenerateKey_564185(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Regenerates an access key for the specified configuration store.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   configStoreName: JString (required)
  ##                  : The name of the configuration store.
  ##   subscriptionId: JString (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to which the container registry belongs.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `configStoreName` field"
  var valid_564187 = path.getOrDefault("configStoreName")
  valid_564187 = validateParameter(valid_564187, JString, required = true,
                                 default = nil)
  if valid_564187 != nil:
    section.add "configStoreName", valid_564187
  var valid_564188 = path.getOrDefault("subscriptionId")
  valid_564188 = validateParameter(valid_564188, JString, required = true,
                                 default = nil)
  if valid_564188 != nil:
    section.add "subscriptionId", valid_564188
  var valid_564189 = path.getOrDefault("resourceGroupName")
  valid_564189 = validateParameter(valid_564189, JString, required = true,
                                 default = nil)
  if valid_564189 != nil:
    section.add "resourceGroupName", valid_564189
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564190 = query.getOrDefault("api-version")
  valid_564190 = validateParameter(valid_564190, JString, required = true,
                                 default = nil)
  if valid_564190 != nil:
    section.add "api-version", valid_564190
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   regenerateKeyParameters: JObject (required)
  ##                          : The parameters for regenerating an access key.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564192: Call_ConfigurationStoresRegenerateKey_564184;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Regenerates an access key for the specified configuration store.
  ## 
  let valid = call_564192.validator(path, query, header, formData, body)
  let scheme = call_564192.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564192.url(scheme.get, call_564192.host, call_564192.base,
                         call_564192.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564192, url, valid)

proc call*(call_564193: Call_ConfigurationStoresRegenerateKey_564184;
          configStoreName: string; apiVersion: string; subscriptionId: string;
          regenerateKeyParameters: JsonNode; resourceGroupName: string): Recallable =
  ## configurationStoresRegenerateKey
  ## Regenerates an access key for the specified configuration store.
  ##   configStoreName: string (required)
  ##                  : The name of the configuration store.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   regenerateKeyParameters: JObject (required)
  ##                          : The parameters for regenerating an access key.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the container registry belongs.
  var path_564194 = newJObject()
  var query_564195 = newJObject()
  var body_564196 = newJObject()
  add(path_564194, "configStoreName", newJString(configStoreName))
  add(query_564195, "api-version", newJString(apiVersion))
  add(path_564194, "subscriptionId", newJString(subscriptionId))
  if regenerateKeyParameters != nil:
    body_564196 = regenerateKeyParameters
  add(path_564194, "resourceGroupName", newJString(resourceGroupName))
  result = call_564193.call(path_564194, query_564195, nil, nil, body_564196)

var configurationStoresRegenerateKey* = Call_ConfigurationStoresRegenerateKey_564184(
    name: "configurationStoresRegenerateKey", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AppConfiguration/configurationStores/{configStoreName}/RegenerateKey",
    validator: validate_ConfigurationStoresRegenerateKey_564185, base: "",
    url: url_ConfigurationStoresRegenerateKey_564186, schemes: {Scheme.Https})
type
  Call_ConfigurationStoresListKeyValue_564197 = ref object of OpenApiRestCall_563556
proc url_ConfigurationStoresListKeyValue_564199(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "configStoreName" in path, "`configStoreName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.AppConfiguration/configurationStores/"),
               (kind: VariableSegment, value: "configStoreName"),
               (kind: ConstantSegment, value: "/listKeyValue")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ConfigurationStoresListKeyValue_564198(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists a configuration store key-value.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   configStoreName: JString (required)
  ##                  : The name of the configuration store.
  ##   subscriptionId: JString (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to which the container registry belongs.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `configStoreName` field"
  var valid_564200 = path.getOrDefault("configStoreName")
  valid_564200 = validateParameter(valid_564200, JString, required = true,
                                 default = nil)
  if valid_564200 != nil:
    section.add "configStoreName", valid_564200
  var valid_564201 = path.getOrDefault("subscriptionId")
  valid_564201 = validateParameter(valid_564201, JString, required = true,
                                 default = nil)
  if valid_564201 != nil:
    section.add "subscriptionId", valid_564201
  var valid_564202 = path.getOrDefault("resourceGroupName")
  valid_564202 = validateParameter(valid_564202, JString, required = true,
                                 default = nil)
  if valid_564202 != nil:
    section.add "resourceGroupName", valid_564202
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564203 = query.getOrDefault("api-version")
  valid_564203 = validateParameter(valid_564203, JString, required = true,
                                 default = nil)
  if valid_564203 != nil:
    section.add "api-version", valid_564203
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   listKeyValueParameters: JObject (required)
  ##                         : The parameters for retrieving a key-value.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564205: Call_ConfigurationStoresListKeyValue_564197;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists a configuration store key-value.
  ## 
  let valid = call_564205.validator(path, query, header, formData, body)
  let scheme = call_564205.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564205.url(scheme.get, call_564205.host, call_564205.base,
                         call_564205.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564205, url, valid)

proc call*(call_564206: Call_ConfigurationStoresListKeyValue_564197;
          configStoreName: string; apiVersion: string; subscriptionId: string;
          resourceGroupName: string; listKeyValueParameters: JsonNode): Recallable =
  ## configurationStoresListKeyValue
  ## Lists a configuration store key-value.
  ##   configStoreName: string (required)
  ##                  : The name of the configuration store.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the container registry belongs.
  ##   listKeyValueParameters: JObject (required)
  ##                         : The parameters for retrieving a key-value.
  var path_564207 = newJObject()
  var query_564208 = newJObject()
  var body_564209 = newJObject()
  add(path_564207, "configStoreName", newJString(configStoreName))
  add(query_564208, "api-version", newJString(apiVersion))
  add(path_564207, "subscriptionId", newJString(subscriptionId))
  add(path_564207, "resourceGroupName", newJString(resourceGroupName))
  if listKeyValueParameters != nil:
    body_564209 = listKeyValueParameters
  result = call_564206.call(path_564207, query_564208, nil, nil, body_564209)

var configurationStoresListKeyValue* = Call_ConfigurationStoresListKeyValue_564197(
    name: "configurationStoresListKeyValue", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AppConfiguration/configurationStores/{configStoreName}/listKeyValue",
    validator: validate_ConfigurationStoresListKeyValue_564198, base: "",
    url: url_ConfigurationStoresListKeyValue_564199, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
