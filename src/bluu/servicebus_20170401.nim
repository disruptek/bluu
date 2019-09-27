
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: ServiceBusManagementClient
## version: 2017-04-01
## termsOfService: (not provided)
## license: (not provided)
## 
## Azure Service Bus client
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

  OpenApiRestCall_593437 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593437](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593437): Option[Scheme] {.used.} =
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
  macServiceName = "servicebus"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_593659 = ref object of OpenApiRestCall_593437
proc url_OperationsList_593661(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_593660(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists all of the available ServiceBus REST API operations.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593820 = query.getOrDefault("api-version")
  valid_593820 = validateParameter(valid_593820, JString, required = true,
                                 default = nil)
  if valid_593820 != nil:
    section.add "api-version", valid_593820
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593843: Call_OperationsList_593659; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available ServiceBus REST API operations.
  ## 
  let valid = call_593843.validator(path, query, header, formData, body)
  let scheme = call_593843.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593843.url(scheme.get, call_593843.host, call_593843.base,
                         call_593843.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593843, url, valid)

proc call*(call_593914: Call_OperationsList_593659; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available ServiceBus REST API operations.
  ##   apiVersion: string (required)
  ##             : Client API version.
  var query_593915 = newJObject()
  add(query_593915, "api-version", newJString(apiVersion))
  result = call_593914.call(nil, query_593915, nil, nil, nil)

var operationsList* = Call_OperationsList_593659(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.ServiceBus/operations",
    validator: validate_OperationsList_593660, base: "", url: url_OperationsList_593661,
    schemes: {Scheme.Https})
type
  Call_NamespacesCheckNameAvailability_593955 = ref object of OpenApiRestCall_593437
proc url_NamespacesCheckNameAvailability_593957(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.ServiceBus/CheckNameAvailability")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesCheckNameAvailability_593956(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Check the give namespace name availability.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_593989 = path.getOrDefault("subscriptionId")
  valid_593989 = validateParameter(valid_593989, JString, required = true,
                                 default = nil)
  if valid_593989 != nil:
    section.add "subscriptionId", valid_593989
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593990 = query.getOrDefault("api-version")
  valid_593990 = validateParameter(valid_593990, JString, required = true,
                                 default = nil)
  if valid_593990 != nil:
    section.add "api-version", valid_593990
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters to check availability of the given namespace name
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_593992: Call_NamespacesCheckNameAvailability_593955;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Check the give namespace name availability.
  ## 
  let valid = call_593992.validator(path, query, header, formData, body)
  let scheme = call_593992.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593992.url(scheme.get, call_593992.host, call_593992.base,
                         call_593992.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593992, url, valid)

proc call*(call_593993: Call_NamespacesCheckNameAvailability_593955;
          apiVersion: string; subscriptionId: string; parameters: JsonNode): Recallable =
  ## namespacesCheckNameAvailability
  ## Check the give namespace name availability.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters to check availability of the given namespace name
  var path_593994 = newJObject()
  var query_593995 = newJObject()
  var body_593996 = newJObject()
  add(query_593995, "api-version", newJString(apiVersion))
  add(path_593994, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_593996 = parameters
  result = call_593993.call(path_593994, query_593995, nil, nil, body_593996)

var namespacesCheckNameAvailability* = Call_NamespacesCheckNameAvailability_593955(
    name: "namespacesCheckNameAvailability", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.ServiceBus/CheckNameAvailability",
    validator: validate_NamespacesCheckNameAvailability_593956, base: "",
    url: url_NamespacesCheckNameAvailability_593957, schemes: {Scheme.Https})
type
  Call_NamespacesList_593997 = ref object of OpenApiRestCall_593437
proc url_NamespacesList_593999(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.ServiceBus/namespaces")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesList_593998(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Gets all the available namespaces within the subscription, irrespective of the resource groups.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639412.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_594000 = path.getOrDefault("subscriptionId")
  valid_594000 = validateParameter(valid_594000, JString, required = true,
                                 default = nil)
  if valid_594000 != nil:
    section.add "subscriptionId", valid_594000
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594001 = query.getOrDefault("api-version")
  valid_594001 = validateParameter(valid_594001, JString, required = true,
                                 default = nil)
  if valid_594001 != nil:
    section.add "api-version", valid_594001
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594002: Call_NamespacesList_593997; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the available namespaces within the subscription, irrespective of the resource groups.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639412.aspx
  let valid = call_594002.validator(path, query, header, formData, body)
  let scheme = call_594002.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594002.url(scheme.get, call_594002.host, call_594002.base,
                         call_594002.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594002, url, valid)

proc call*(call_594003: Call_NamespacesList_593997; apiVersion: string;
          subscriptionId: string): Recallable =
  ## namespacesList
  ## Gets all the available namespaces within the subscription, irrespective of the resource groups.
  ## https://msdn.microsoft.com/en-us/library/azure/mt639412.aspx
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594004 = newJObject()
  var query_594005 = newJObject()
  add(query_594005, "api-version", newJString(apiVersion))
  add(path_594004, "subscriptionId", newJString(subscriptionId))
  result = call_594003.call(path_594004, query_594005, nil, nil, nil)

var namespacesList* = Call_NamespacesList_593997(name: "namespacesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.ServiceBus/namespaces",
    validator: validate_NamespacesList_593998, base: "", url: url_NamespacesList_593999,
    schemes: {Scheme.Https})
type
  Call_PremiumMessagingRegionsList_594006 = ref object of OpenApiRestCall_593437
proc url_PremiumMessagingRegionsList_594008(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.ServiceBus/premiumMessagingRegions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PremiumMessagingRegionsList_594007(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the available premium messaging regions for servicebus 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_594009 = path.getOrDefault("subscriptionId")
  valid_594009 = validateParameter(valid_594009, JString, required = true,
                                 default = nil)
  if valid_594009 != nil:
    section.add "subscriptionId", valid_594009
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594010 = query.getOrDefault("api-version")
  valid_594010 = validateParameter(valid_594010, JString, required = true,
                                 default = nil)
  if valid_594010 != nil:
    section.add "api-version", valid_594010
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594011: Call_PremiumMessagingRegionsList_594006; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the available premium messaging regions for servicebus 
  ## 
  let valid = call_594011.validator(path, query, header, formData, body)
  let scheme = call_594011.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594011.url(scheme.get, call_594011.host, call_594011.base,
                         call_594011.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594011, url, valid)

proc call*(call_594012: Call_PremiumMessagingRegionsList_594006;
          apiVersion: string; subscriptionId: string): Recallable =
  ## premiumMessagingRegionsList
  ## Gets the available premium messaging regions for servicebus 
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594013 = newJObject()
  var query_594014 = newJObject()
  add(query_594014, "api-version", newJString(apiVersion))
  add(path_594013, "subscriptionId", newJString(subscriptionId))
  result = call_594012.call(path_594013, query_594014, nil, nil, nil)

var premiumMessagingRegionsList* = Call_PremiumMessagingRegionsList_594006(
    name: "premiumMessagingRegionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.ServiceBus/premiumMessagingRegions",
    validator: validate_PremiumMessagingRegionsList_594007, base: "",
    url: url_PremiumMessagingRegionsList_594008, schemes: {Scheme.Https})
type
  Call_RegionsListBySku_594015 = ref object of OpenApiRestCall_593437
proc url_RegionsListBySku_594017(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "sku" in path, "`sku` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.ServiceBus/sku/"),
               (kind: VariableSegment, value: "sku"),
               (kind: ConstantSegment, value: "/regions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RegionsListBySku_594016(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Gets the available Regions for a given sku
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   sku: JString (required)
  ##      : The sku type.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_594018 = path.getOrDefault("subscriptionId")
  valid_594018 = validateParameter(valid_594018, JString, required = true,
                                 default = nil)
  if valid_594018 != nil:
    section.add "subscriptionId", valid_594018
  var valid_594019 = path.getOrDefault("sku")
  valid_594019 = validateParameter(valid_594019, JString, required = true,
                                 default = nil)
  if valid_594019 != nil:
    section.add "sku", valid_594019
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594020 = query.getOrDefault("api-version")
  valid_594020 = validateParameter(valid_594020, JString, required = true,
                                 default = nil)
  if valid_594020 != nil:
    section.add "api-version", valid_594020
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594021: Call_RegionsListBySku_594015; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the available Regions for a given sku
  ## 
  let valid = call_594021.validator(path, query, header, formData, body)
  let scheme = call_594021.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594021.url(scheme.get, call_594021.host, call_594021.base,
                         call_594021.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594021, url, valid)

proc call*(call_594022: Call_RegionsListBySku_594015; apiVersion: string;
          subscriptionId: string; sku: string): Recallable =
  ## regionsListBySku
  ## Gets the available Regions for a given sku
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   sku: string (required)
  ##      : The sku type.
  var path_594023 = newJObject()
  var query_594024 = newJObject()
  add(query_594024, "api-version", newJString(apiVersion))
  add(path_594023, "subscriptionId", newJString(subscriptionId))
  add(path_594023, "sku", newJString(sku))
  result = call_594022.call(path_594023, query_594024, nil, nil, nil)

var regionsListBySku* = Call_RegionsListBySku_594015(name: "regionsListBySku",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.ServiceBus/sku/{sku}/regions",
    validator: validate_RegionsListBySku_594016, base: "",
    url: url_RegionsListBySku_594017, schemes: {Scheme.Https})
type
  Call_NamespacesListByResourceGroup_594025 = ref object of OpenApiRestCall_593437
proc url_NamespacesListByResourceGroup_594027(protocol: Scheme; host: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.ServiceBus/namespaces")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesListByResourceGroup_594026(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the available namespaces within a resource group.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639412.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594028 = path.getOrDefault("resourceGroupName")
  valid_594028 = validateParameter(valid_594028, JString, required = true,
                                 default = nil)
  if valid_594028 != nil:
    section.add "resourceGroupName", valid_594028
  var valid_594029 = path.getOrDefault("subscriptionId")
  valid_594029 = validateParameter(valid_594029, JString, required = true,
                                 default = nil)
  if valid_594029 != nil:
    section.add "subscriptionId", valid_594029
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594030 = query.getOrDefault("api-version")
  valid_594030 = validateParameter(valid_594030, JString, required = true,
                                 default = nil)
  if valid_594030 != nil:
    section.add "api-version", valid_594030
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594031: Call_NamespacesListByResourceGroup_594025; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the available namespaces within a resource group.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639412.aspx
  let valid = call_594031.validator(path, query, header, formData, body)
  let scheme = call_594031.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594031.url(scheme.get, call_594031.host, call_594031.base,
                         call_594031.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594031, url, valid)

proc call*(call_594032: Call_NamespacesListByResourceGroup_594025;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## namespacesListByResourceGroup
  ## Gets the available namespaces within a resource group.
  ## https://msdn.microsoft.com/en-us/library/azure/mt639412.aspx
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594033 = newJObject()
  var query_594034 = newJObject()
  add(path_594033, "resourceGroupName", newJString(resourceGroupName))
  add(query_594034, "api-version", newJString(apiVersion))
  add(path_594033, "subscriptionId", newJString(subscriptionId))
  result = call_594032.call(path_594033, query_594034, nil, nil, nil)

var namespacesListByResourceGroup* = Call_NamespacesListByResourceGroup_594025(
    name: "namespacesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces",
    validator: validate_NamespacesListByResourceGroup_594026, base: "",
    url: url_NamespacesListByResourceGroup_594027, schemes: {Scheme.Https})
type
  Call_NamespacesCreateOrUpdate_594046 = ref object of OpenApiRestCall_593437
proc url_NamespacesCreateOrUpdate_594048(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceBus/namespaces/"),
               (kind: VariableSegment, value: "namespaceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesCreateOrUpdate_594047(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a service namespace. Once created, this namespace's resource manifest is immutable. This operation is idempotent.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639408.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name.
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_594049 = path.getOrDefault("namespaceName")
  valid_594049 = validateParameter(valid_594049, JString, required = true,
                                 default = nil)
  if valid_594049 != nil:
    section.add "namespaceName", valid_594049
  var valid_594050 = path.getOrDefault("resourceGroupName")
  valid_594050 = validateParameter(valid_594050, JString, required = true,
                                 default = nil)
  if valid_594050 != nil:
    section.add "resourceGroupName", valid_594050
  var valid_594051 = path.getOrDefault("subscriptionId")
  valid_594051 = validateParameter(valid_594051, JString, required = true,
                                 default = nil)
  if valid_594051 != nil:
    section.add "subscriptionId", valid_594051
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594052 = query.getOrDefault("api-version")
  valid_594052 = validateParameter(valid_594052, JString, required = true,
                                 default = nil)
  if valid_594052 != nil:
    section.add "api-version", valid_594052
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to create a namespace resource.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594054: Call_NamespacesCreateOrUpdate_594046; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a service namespace. Once created, this namespace's resource manifest is immutable. This operation is idempotent.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639408.aspx
  let valid = call_594054.validator(path, query, header, formData, body)
  let scheme = call_594054.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594054.url(scheme.get, call_594054.host, call_594054.base,
                         call_594054.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594054, url, valid)

proc call*(call_594055: Call_NamespacesCreateOrUpdate_594046;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; parameters: JsonNode): Recallable =
  ## namespacesCreateOrUpdate
  ## Creates or updates a service namespace. Once created, this namespace's resource manifest is immutable. This operation is idempotent.
  ## https://msdn.microsoft.com/en-us/library/azure/mt639408.aspx
  ##   namespaceName: string (required)
  ##                : The namespace name.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to create a namespace resource.
  var path_594056 = newJObject()
  var query_594057 = newJObject()
  var body_594058 = newJObject()
  add(path_594056, "namespaceName", newJString(namespaceName))
  add(path_594056, "resourceGroupName", newJString(resourceGroupName))
  add(query_594057, "api-version", newJString(apiVersion))
  add(path_594056, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594058 = parameters
  result = call_594055.call(path_594056, query_594057, nil, nil, body_594058)

var namespacesCreateOrUpdate* = Call_NamespacesCreateOrUpdate_594046(
    name: "namespacesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}",
    validator: validate_NamespacesCreateOrUpdate_594047, base: "",
    url: url_NamespacesCreateOrUpdate_594048, schemes: {Scheme.Https})
type
  Call_NamespacesGet_594035 = ref object of OpenApiRestCall_593437
proc url_NamespacesGet_594037(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceBus/namespaces/"),
               (kind: VariableSegment, value: "namespaceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesGet_594036(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a description for the specified namespace.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639379.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_594038 = path.getOrDefault("namespaceName")
  valid_594038 = validateParameter(valid_594038, JString, required = true,
                                 default = nil)
  if valid_594038 != nil:
    section.add "namespaceName", valid_594038
  var valid_594039 = path.getOrDefault("resourceGroupName")
  valid_594039 = validateParameter(valid_594039, JString, required = true,
                                 default = nil)
  if valid_594039 != nil:
    section.add "resourceGroupName", valid_594039
  var valid_594040 = path.getOrDefault("subscriptionId")
  valid_594040 = validateParameter(valid_594040, JString, required = true,
                                 default = nil)
  if valid_594040 != nil:
    section.add "subscriptionId", valid_594040
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594041 = query.getOrDefault("api-version")
  valid_594041 = validateParameter(valid_594041, JString, required = true,
                                 default = nil)
  if valid_594041 != nil:
    section.add "api-version", valid_594041
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594042: Call_NamespacesGet_594035; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a description for the specified namespace.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639379.aspx
  let valid = call_594042.validator(path, query, header, formData, body)
  let scheme = call_594042.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594042.url(scheme.get, call_594042.host, call_594042.base,
                         call_594042.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594042, url, valid)

proc call*(call_594043: Call_NamespacesGet_594035; namespaceName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## namespacesGet
  ## Gets a description for the specified namespace.
  ## https://msdn.microsoft.com/en-us/library/azure/mt639379.aspx
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594044 = newJObject()
  var query_594045 = newJObject()
  add(path_594044, "namespaceName", newJString(namespaceName))
  add(path_594044, "resourceGroupName", newJString(resourceGroupName))
  add(query_594045, "api-version", newJString(apiVersion))
  add(path_594044, "subscriptionId", newJString(subscriptionId))
  result = call_594043.call(path_594044, query_594045, nil, nil, nil)

var namespacesGet* = Call_NamespacesGet_594035(name: "namespacesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}",
    validator: validate_NamespacesGet_594036, base: "", url: url_NamespacesGet_594037,
    schemes: {Scheme.Https})
type
  Call_NamespacesUpdate_594070 = ref object of OpenApiRestCall_593437
proc url_NamespacesUpdate_594072(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceBus/namespaces/"),
               (kind: VariableSegment, value: "namespaceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesUpdate_594071(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Updates a service namespace. Once created, this namespace's resource manifest is immutable. This operation is idempotent.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_594073 = path.getOrDefault("namespaceName")
  valid_594073 = validateParameter(valid_594073, JString, required = true,
                                 default = nil)
  if valid_594073 != nil:
    section.add "namespaceName", valid_594073
  var valid_594074 = path.getOrDefault("resourceGroupName")
  valid_594074 = validateParameter(valid_594074, JString, required = true,
                                 default = nil)
  if valid_594074 != nil:
    section.add "resourceGroupName", valid_594074
  var valid_594075 = path.getOrDefault("subscriptionId")
  valid_594075 = validateParameter(valid_594075, JString, required = true,
                                 default = nil)
  if valid_594075 != nil:
    section.add "subscriptionId", valid_594075
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594076 = query.getOrDefault("api-version")
  valid_594076 = validateParameter(valid_594076, JString, required = true,
                                 default = nil)
  if valid_594076 != nil:
    section.add "api-version", valid_594076
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to update a namespace resource.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594078: Call_NamespacesUpdate_594070; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a service namespace. Once created, this namespace's resource manifest is immutable. This operation is idempotent.
  ## 
  let valid = call_594078.validator(path, query, header, formData, body)
  let scheme = call_594078.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594078.url(scheme.get, call_594078.host, call_594078.base,
                         call_594078.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594078, url, valid)

proc call*(call_594079: Call_NamespacesUpdate_594070; namespaceName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode): Recallable =
  ## namespacesUpdate
  ## Updates a service namespace. Once created, this namespace's resource manifest is immutable. This operation is idempotent.
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to update a namespace resource.
  var path_594080 = newJObject()
  var query_594081 = newJObject()
  var body_594082 = newJObject()
  add(path_594080, "namespaceName", newJString(namespaceName))
  add(path_594080, "resourceGroupName", newJString(resourceGroupName))
  add(query_594081, "api-version", newJString(apiVersion))
  add(path_594080, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594082 = parameters
  result = call_594079.call(path_594080, query_594081, nil, nil, body_594082)

var namespacesUpdate* = Call_NamespacesUpdate_594070(name: "namespacesUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}",
    validator: validate_NamespacesUpdate_594071, base: "",
    url: url_NamespacesUpdate_594072, schemes: {Scheme.Https})
type
  Call_NamespacesDelete_594059 = ref object of OpenApiRestCall_593437
proc url_NamespacesDelete_594061(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceBus/namespaces/"),
               (kind: VariableSegment, value: "namespaceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesDelete_594060(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Deletes an existing namespace. This operation also removes all associated resources under the namespace.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639389.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_594062 = path.getOrDefault("namespaceName")
  valid_594062 = validateParameter(valid_594062, JString, required = true,
                                 default = nil)
  if valid_594062 != nil:
    section.add "namespaceName", valid_594062
  var valid_594063 = path.getOrDefault("resourceGroupName")
  valid_594063 = validateParameter(valid_594063, JString, required = true,
                                 default = nil)
  if valid_594063 != nil:
    section.add "resourceGroupName", valid_594063
  var valid_594064 = path.getOrDefault("subscriptionId")
  valid_594064 = validateParameter(valid_594064, JString, required = true,
                                 default = nil)
  if valid_594064 != nil:
    section.add "subscriptionId", valid_594064
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594065 = query.getOrDefault("api-version")
  valid_594065 = validateParameter(valid_594065, JString, required = true,
                                 default = nil)
  if valid_594065 != nil:
    section.add "api-version", valid_594065
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594066: Call_NamespacesDelete_594059; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an existing namespace. This operation also removes all associated resources under the namespace.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639389.aspx
  let valid = call_594066.validator(path, query, header, formData, body)
  let scheme = call_594066.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594066.url(scheme.get, call_594066.host, call_594066.base,
                         call_594066.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594066, url, valid)

proc call*(call_594067: Call_NamespacesDelete_594059; namespaceName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## namespacesDelete
  ## Deletes an existing namespace. This operation also removes all associated resources under the namespace.
  ## https://msdn.microsoft.com/en-us/library/azure/mt639389.aspx
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594068 = newJObject()
  var query_594069 = newJObject()
  add(path_594068, "namespaceName", newJString(namespaceName))
  add(path_594068, "resourceGroupName", newJString(resourceGroupName))
  add(query_594069, "api-version", newJString(apiVersion))
  add(path_594068, "subscriptionId", newJString(subscriptionId))
  result = call_594067.call(path_594068, query_594069, nil, nil, nil)

var namespacesDelete* = Call_NamespacesDelete_594059(name: "namespacesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}",
    validator: validate_NamespacesDelete_594060, base: "",
    url: url_NamespacesDelete_594061, schemes: {Scheme.Https})
type
  Call_NamespacesListAuthorizationRules_594083 = ref object of OpenApiRestCall_593437
proc url_NamespacesListAuthorizationRules_594085(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceBus/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/AuthorizationRules")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesListAuthorizationRules_594084(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the authorization rules for a namespace.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639376.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_594086 = path.getOrDefault("namespaceName")
  valid_594086 = validateParameter(valid_594086, JString, required = true,
                                 default = nil)
  if valid_594086 != nil:
    section.add "namespaceName", valid_594086
  var valid_594087 = path.getOrDefault("resourceGroupName")
  valid_594087 = validateParameter(valid_594087, JString, required = true,
                                 default = nil)
  if valid_594087 != nil:
    section.add "resourceGroupName", valid_594087
  var valid_594088 = path.getOrDefault("subscriptionId")
  valid_594088 = validateParameter(valid_594088, JString, required = true,
                                 default = nil)
  if valid_594088 != nil:
    section.add "subscriptionId", valid_594088
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594089 = query.getOrDefault("api-version")
  valid_594089 = validateParameter(valid_594089, JString, required = true,
                                 default = nil)
  if valid_594089 != nil:
    section.add "api-version", valid_594089
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594090: Call_NamespacesListAuthorizationRules_594083;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the authorization rules for a namespace.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639376.aspx
  let valid = call_594090.validator(path, query, header, formData, body)
  let scheme = call_594090.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594090.url(scheme.get, call_594090.host, call_594090.base,
                         call_594090.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594090, url, valid)

proc call*(call_594091: Call_NamespacesListAuthorizationRules_594083;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## namespacesListAuthorizationRules
  ## Gets the authorization rules for a namespace.
  ## https://msdn.microsoft.com/en-us/library/azure/mt639376.aspx
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594092 = newJObject()
  var query_594093 = newJObject()
  add(path_594092, "namespaceName", newJString(namespaceName))
  add(path_594092, "resourceGroupName", newJString(resourceGroupName))
  add(query_594093, "api-version", newJString(apiVersion))
  add(path_594092, "subscriptionId", newJString(subscriptionId))
  result = call_594091.call(path_594092, query_594093, nil, nil, nil)

var namespacesListAuthorizationRules* = Call_NamespacesListAuthorizationRules_594083(
    name: "namespacesListAuthorizationRules", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/AuthorizationRules",
    validator: validate_NamespacesListAuthorizationRules_594084, base: "",
    url: url_NamespacesListAuthorizationRules_594085, schemes: {Scheme.Https})
type
  Call_NamespacesCreateOrUpdateAuthorizationRule_594106 = ref object of OpenApiRestCall_593437
proc url_NamespacesCreateOrUpdateAuthorizationRule_594108(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "authorizationRuleName" in path,
        "`authorizationRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceBus/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/AuthorizationRules/"),
               (kind: VariableSegment, value: "authorizationRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesCreateOrUpdateAuthorizationRule_594107(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates an authorization rule for a namespace.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639410.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   authorizationRuleName: JString (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_594109 = path.getOrDefault("namespaceName")
  valid_594109 = validateParameter(valid_594109, JString, required = true,
                                 default = nil)
  if valid_594109 != nil:
    section.add "namespaceName", valid_594109
  var valid_594110 = path.getOrDefault("resourceGroupName")
  valid_594110 = validateParameter(valid_594110, JString, required = true,
                                 default = nil)
  if valid_594110 != nil:
    section.add "resourceGroupName", valid_594110
  var valid_594111 = path.getOrDefault("authorizationRuleName")
  valid_594111 = validateParameter(valid_594111, JString, required = true,
                                 default = nil)
  if valid_594111 != nil:
    section.add "authorizationRuleName", valid_594111
  var valid_594112 = path.getOrDefault("subscriptionId")
  valid_594112 = validateParameter(valid_594112, JString, required = true,
                                 default = nil)
  if valid_594112 != nil:
    section.add "subscriptionId", valid_594112
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594113 = query.getOrDefault("api-version")
  valid_594113 = validateParameter(valid_594113, JString, required = true,
                                 default = nil)
  if valid_594113 != nil:
    section.add "api-version", valid_594113
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The shared access authorization rule.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594115: Call_NamespacesCreateOrUpdateAuthorizationRule_594106;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates an authorization rule for a namespace.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639410.aspx
  let valid = call_594115.validator(path, query, header, formData, body)
  let scheme = call_594115.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594115.url(scheme.get, call_594115.host, call_594115.base,
                         call_594115.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594115, url, valid)

proc call*(call_594116: Call_NamespacesCreateOrUpdateAuthorizationRule_594106;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          authorizationRuleName: string; subscriptionId: string;
          parameters: JsonNode): Recallable =
  ## namespacesCreateOrUpdateAuthorizationRule
  ## Creates or updates an authorization rule for a namespace.
  ## https://msdn.microsoft.com/en-us/library/azure/mt639410.aspx
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   authorizationRuleName: string (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : The shared access authorization rule.
  var path_594117 = newJObject()
  var query_594118 = newJObject()
  var body_594119 = newJObject()
  add(path_594117, "namespaceName", newJString(namespaceName))
  add(path_594117, "resourceGroupName", newJString(resourceGroupName))
  add(query_594118, "api-version", newJString(apiVersion))
  add(path_594117, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_594117, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594119 = parameters
  result = call_594116.call(path_594117, query_594118, nil, nil, body_594119)

var namespacesCreateOrUpdateAuthorizationRule* = Call_NamespacesCreateOrUpdateAuthorizationRule_594106(
    name: "namespacesCreateOrUpdateAuthorizationRule", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/AuthorizationRules/{authorizationRuleName}",
    validator: validate_NamespacesCreateOrUpdateAuthorizationRule_594107,
    base: "", url: url_NamespacesCreateOrUpdateAuthorizationRule_594108,
    schemes: {Scheme.Https})
type
  Call_NamespacesGetAuthorizationRule_594094 = ref object of OpenApiRestCall_593437
proc url_NamespacesGetAuthorizationRule_594096(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "authorizationRuleName" in path,
        "`authorizationRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceBus/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/AuthorizationRules/"),
               (kind: VariableSegment, value: "authorizationRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesGetAuthorizationRule_594095(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets an authorization rule for a namespace by rule name.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639392.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   authorizationRuleName: JString (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_594097 = path.getOrDefault("namespaceName")
  valid_594097 = validateParameter(valid_594097, JString, required = true,
                                 default = nil)
  if valid_594097 != nil:
    section.add "namespaceName", valid_594097
  var valid_594098 = path.getOrDefault("resourceGroupName")
  valid_594098 = validateParameter(valid_594098, JString, required = true,
                                 default = nil)
  if valid_594098 != nil:
    section.add "resourceGroupName", valid_594098
  var valid_594099 = path.getOrDefault("authorizationRuleName")
  valid_594099 = validateParameter(valid_594099, JString, required = true,
                                 default = nil)
  if valid_594099 != nil:
    section.add "authorizationRuleName", valid_594099
  var valid_594100 = path.getOrDefault("subscriptionId")
  valid_594100 = validateParameter(valid_594100, JString, required = true,
                                 default = nil)
  if valid_594100 != nil:
    section.add "subscriptionId", valid_594100
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594101 = query.getOrDefault("api-version")
  valid_594101 = validateParameter(valid_594101, JString, required = true,
                                 default = nil)
  if valid_594101 != nil:
    section.add "api-version", valid_594101
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594102: Call_NamespacesGetAuthorizationRule_594094; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an authorization rule for a namespace by rule name.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639392.aspx
  let valid = call_594102.validator(path, query, header, formData, body)
  let scheme = call_594102.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594102.url(scheme.get, call_594102.host, call_594102.base,
                         call_594102.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594102, url, valid)

proc call*(call_594103: Call_NamespacesGetAuthorizationRule_594094;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          authorizationRuleName: string; subscriptionId: string): Recallable =
  ## namespacesGetAuthorizationRule
  ## Gets an authorization rule for a namespace by rule name.
  ## https://msdn.microsoft.com/en-us/library/azure/mt639392.aspx
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   authorizationRuleName: string (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594104 = newJObject()
  var query_594105 = newJObject()
  add(path_594104, "namespaceName", newJString(namespaceName))
  add(path_594104, "resourceGroupName", newJString(resourceGroupName))
  add(query_594105, "api-version", newJString(apiVersion))
  add(path_594104, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_594104, "subscriptionId", newJString(subscriptionId))
  result = call_594103.call(path_594104, query_594105, nil, nil, nil)

var namespacesGetAuthorizationRule* = Call_NamespacesGetAuthorizationRule_594094(
    name: "namespacesGetAuthorizationRule", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/AuthorizationRules/{authorizationRuleName}",
    validator: validate_NamespacesGetAuthorizationRule_594095, base: "",
    url: url_NamespacesGetAuthorizationRule_594096, schemes: {Scheme.Https})
type
  Call_NamespacesDeleteAuthorizationRule_594120 = ref object of OpenApiRestCall_593437
proc url_NamespacesDeleteAuthorizationRule_594122(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "authorizationRuleName" in path,
        "`authorizationRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceBus/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/AuthorizationRules/"),
               (kind: VariableSegment, value: "authorizationRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesDeleteAuthorizationRule_594121(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a namespace authorization rule.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639417.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   authorizationRuleName: JString (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_594123 = path.getOrDefault("namespaceName")
  valid_594123 = validateParameter(valid_594123, JString, required = true,
                                 default = nil)
  if valid_594123 != nil:
    section.add "namespaceName", valid_594123
  var valid_594124 = path.getOrDefault("resourceGroupName")
  valid_594124 = validateParameter(valid_594124, JString, required = true,
                                 default = nil)
  if valid_594124 != nil:
    section.add "resourceGroupName", valid_594124
  var valid_594125 = path.getOrDefault("authorizationRuleName")
  valid_594125 = validateParameter(valid_594125, JString, required = true,
                                 default = nil)
  if valid_594125 != nil:
    section.add "authorizationRuleName", valid_594125
  var valid_594126 = path.getOrDefault("subscriptionId")
  valid_594126 = validateParameter(valid_594126, JString, required = true,
                                 default = nil)
  if valid_594126 != nil:
    section.add "subscriptionId", valid_594126
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594127 = query.getOrDefault("api-version")
  valid_594127 = validateParameter(valid_594127, JString, required = true,
                                 default = nil)
  if valid_594127 != nil:
    section.add "api-version", valid_594127
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594128: Call_NamespacesDeleteAuthorizationRule_594120;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a namespace authorization rule.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639417.aspx
  let valid = call_594128.validator(path, query, header, formData, body)
  let scheme = call_594128.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594128.url(scheme.get, call_594128.host, call_594128.base,
                         call_594128.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594128, url, valid)

proc call*(call_594129: Call_NamespacesDeleteAuthorizationRule_594120;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          authorizationRuleName: string; subscriptionId: string): Recallable =
  ## namespacesDeleteAuthorizationRule
  ## Deletes a namespace authorization rule.
  ## https://msdn.microsoft.com/en-us/library/azure/mt639417.aspx
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   authorizationRuleName: string (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594130 = newJObject()
  var query_594131 = newJObject()
  add(path_594130, "namespaceName", newJString(namespaceName))
  add(path_594130, "resourceGroupName", newJString(resourceGroupName))
  add(query_594131, "api-version", newJString(apiVersion))
  add(path_594130, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_594130, "subscriptionId", newJString(subscriptionId))
  result = call_594129.call(path_594130, query_594131, nil, nil, nil)

var namespacesDeleteAuthorizationRule* = Call_NamespacesDeleteAuthorizationRule_594120(
    name: "namespacesDeleteAuthorizationRule", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/AuthorizationRules/{authorizationRuleName}",
    validator: validate_NamespacesDeleteAuthorizationRule_594121, base: "",
    url: url_NamespacesDeleteAuthorizationRule_594122, schemes: {Scheme.Https})
type
  Call_NamespacesListKeys_594132 = ref object of OpenApiRestCall_593437
proc url_NamespacesListKeys_594134(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "authorizationRuleName" in path,
        "`authorizationRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceBus/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/AuthorizationRules/"),
               (kind: VariableSegment, value: "authorizationRuleName"),
               (kind: ConstantSegment, value: "/listKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesListKeys_594133(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Gets the primary and secondary connection strings for the namespace.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639398.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   authorizationRuleName: JString (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_594135 = path.getOrDefault("namespaceName")
  valid_594135 = validateParameter(valid_594135, JString, required = true,
                                 default = nil)
  if valid_594135 != nil:
    section.add "namespaceName", valid_594135
  var valid_594136 = path.getOrDefault("resourceGroupName")
  valid_594136 = validateParameter(valid_594136, JString, required = true,
                                 default = nil)
  if valid_594136 != nil:
    section.add "resourceGroupName", valid_594136
  var valid_594137 = path.getOrDefault("authorizationRuleName")
  valid_594137 = validateParameter(valid_594137, JString, required = true,
                                 default = nil)
  if valid_594137 != nil:
    section.add "authorizationRuleName", valid_594137
  var valid_594138 = path.getOrDefault("subscriptionId")
  valid_594138 = validateParameter(valid_594138, JString, required = true,
                                 default = nil)
  if valid_594138 != nil:
    section.add "subscriptionId", valid_594138
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594139 = query.getOrDefault("api-version")
  valid_594139 = validateParameter(valid_594139, JString, required = true,
                                 default = nil)
  if valid_594139 != nil:
    section.add "api-version", valid_594139
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594140: Call_NamespacesListKeys_594132; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the primary and secondary connection strings for the namespace.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639398.aspx
  let valid = call_594140.validator(path, query, header, formData, body)
  let scheme = call_594140.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594140.url(scheme.get, call_594140.host, call_594140.base,
                         call_594140.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594140, url, valid)

proc call*(call_594141: Call_NamespacesListKeys_594132; namespaceName: string;
          resourceGroupName: string; apiVersion: string;
          authorizationRuleName: string; subscriptionId: string): Recallable =
  ## namespacesListKeys
  ## Gets the primary and secondary connection strings for the namespace.
  ## https://msdn.microsoft.com/en-us/library/azure/mt639398.aspx
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   authorizationRuleName: string (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594142 = newJObject()
  var query_594143 = newJObject()
  add(path_594142, "namespaceName", newJString(namespaceName))
  add(path_594142, "resourceGroupName", newJString(resourceGroupName))
  add(query_594143, "api-version", newJString(apiVersion))
  add(path_594142, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_594142, "subscriptionId", newJString(subscriptionId))
  result = call_594141.call(path_594142, query_594143, nil, nil, nil)

var namespacesListKeys* = Call_NamespacesListKeys_594132(
    name: "namespacesListKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/AuthorizationRules/{authorizationRuleName}/listKeys",
    validator: validate_NamespacesListKeys_594133, base: "",
    url: url_NamespacesListKeys_594134, schemes: {Scheme.Https})
type
  Call_NamespacesRegenerateKeys_594144 = ref object of OpenApiRestCall_593437
proc url_NamespacesRegenerateKeys_594146(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "authorizationRuleName" in path,
        "`authorizationRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceBus/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/AuthorizationRules/"),
               (kind: VariableSegment, value: "authorizationRuleName"),
               (kind: ConstantSegment, value: "/regenerateKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesRegenerateKeys_594145(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Regenerates the primary or secondary connection strings for the namespace.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt718977.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   authorizationRuleName: JString (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_594147 = path.getOrDefault("namespaceName")
  valid_594147 = validateParameter(valid_594147, JString, required = true,
                                 default = nil)
  if valid_594147 != nil:
    section.add "namespaceName", valid_594147
  var valid_594148 = path.getOrDefault("resourceGroupName")
  valid_594148 = validateParameter(valid_594148, JString, required = true,
                                 default = nil)
  if valid_594148 != nil:
    section.add "resourceGroupName", valid_594148
  var valid_594149 = path.getOrDefault("authorizationRuleName")
  valid_594149 = validateParameter(valid_594149, JString, required = true,
                                 default = nil)
  if valid_594149 != nil:
    section.add "authorizationRuleName", valid_594149
  var valid_594150 = path.getOrDefault("subscriptionId")
  valid_594150 = validateParameter(valid_594150, JString, required = true,
                                 default = nil)
  if valid_594150 != nil:
    section.add "subscriptionId", valid_594150
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594151 = query.getOrDefault("api-version")
  valid_594151 = validateParameter(valid_594151, JString, required = true,
                                 default = nil)
  if valid_594151 != nil:
    section.add "api-version", valid_594151
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to regenerate the authorization rule.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594153: Call_NamespacesRegenerateKeys_594144; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Regenerates the primary or secondary connection strings for the namespace.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt718977.aspx
  let valid = call_594153.validator(path, query, header, formData, body)
  let scheme = call_594153.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594153.url(scheme.get, call_594153.host, call_594153.base,
                         call_594153.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594153, url, valid)

proc call*(call_594154: Call_NamespacesRegenerateKeys_594144;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          authorizationRuleName: string; subscriptionId: string;
          parameters: JsonNode): Recallable =
  ## namespacesRegenerateKeys
  ## Regenerates the primary or secondary connection strings for the namespace.
  ## https://msdn.microsoft.com/en-us/library/azure/mt718977.aspx
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   authorizationRuleName: string (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to regenerate the authorization rule.
  var path_594155 = newJObject()
  var query_594156 = newJObject()
  var body_594157 = newJObject()
  add(path_594155, "namespaceName", newJString(namespaceName))
  add(path_594155, "resourceGroupName", newJString(resourceGroupName))
  add(query_594156, "api-version", newJString(apiVersion))
  add(path_594155, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_594155, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594157 = parameters
  result = call_594154.call(path_594155, query_594156, nil, nil, body_594157)

var namespacesRegenerateKeys* = Call_NamespacesRegenerateKeys_594144(
    name: "namespacesRegenerateKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/AuthorizationRules/{authorizationRuleName}/regenerateKeys",
    validator: validate_NamespacesRegenerateKeys_594145, base: "",
    url: url_NamespacesRegenerateKeys_594146, schemes: {Scheme.Https})
type
  Call_DisasterRecoveryConfigsList_594158 = ref object of OpenApiRestCall_593437
proc url_DisasterRecoveryConfigsList_594160(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceBus/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/disasterRecoveryConfigs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DisasterRecoveryConfigsList_594159(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all Alias(Disaster Recovery configurations)
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_594161 = path.getOrDefault("namespaceName")
  valid_594161 = validateParameter(valid_594161, JString, required = true,
                                 default = nil)
  if valid_594161 != nil:
    section.add "namespaceName", valid_594161
  var valid_594162 = path.getOrDefault("resourceGroupName")
  valid_594162 = validateParameter(valid_594162, JString, required = true,
                                 default = nil)
  if valid_594162 != nil:
    section.add "resourceGroupName", valid_594162
  var valid_594163 = path.getOrDefault("subscriptionId")
  valid_594163 = validateParameter(valid_594163, JString, required = true,
                                 default = nil)
  if valid_594163 != nil:
    section.add "subscriptionId", valid_594163
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594164 = query.getOrDefault("api-version")
  valid_594164 = validateParameter(valid_594164, JString, required = true,
                                 default = nil)
  if valid_594164 != nil:
    section.add "api-version", valid_594164
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594165: Call_DisasterRecoveryConfigsList_594158; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all Alias(Disaster Recovery configurations)
  ## 
  let valid = call_594165.validator(path, query, header, formData, body)
  let scheme = call_594165.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594165.url(scheme.get, call_594165.host, call_594165.base,
                         call_594165.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594165, url, valid)

proc call*(call_594166: Call_DisasterRecoveryConfigsList_594158;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## disasterRecoveryConfigsList
  ## Gets all Alias(Disaster Recovery configurations)
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594167 = newJObject()
  var query_594168 = newJObject()
  add(path_594167, "namespaceName", newJString(namespaceName))
  add(path_594167, "resourceGroupName", newJString(resourceGroupName))
  add(query_594168, "api-version", newJString(apiVersion))
  add(path_594167, "subscriptionId", newJString(subscriptionId))
  result = call_594166.call(path_594167, query_594168, nil, nil, nil)

var disasterRecoveryConfigsList* = Call_DisasterRecoveryConfigsList_594158(
    name: "disasterRecoveryConfigsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/disasterRecoveryConfigs",
    validator: validate_DisasterRecoveryConfigsList_594159, base: "",
    url: url_DisasterRecoveryConfigsList_594160, schemes: {Scheme.Https})
type
  Call_DisasterRecoveryConfigsCheckNameAvailability_594169 = ref object of OpenApiRestCall_593437
proc url_DisasterRecoveryConfigsCheckNameAvailability_594171(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceBus/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"), (
        kind: ConstantSegment,
        value: "/disasterRecoveryConfigs/CheckNameAvailability")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DisasterRecoveryConfigsCheckNameAvailability_594170(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Check the give namespace name availability.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_594172 = path.getOrDefault("namespaceName")
  valid_594172 = validateParameter(valid_594172, JString, required = true,
                                 default = nil)
  if valid_594172 != nil:
    section.add "namespaceName", valid_594172
  var valid_594173 = path.getOrDefault("resourceGroupName")
  valid_594173 = validateParameter(valid_594173, JString, required = true,
                                 default = nil)
  if valid_594173 != nil:
    section.add "resourceGroupName", valid_594173
  var valid_594174 = path.getOrDefault("subscriptionId")
  valid_594174 = validateParameter(valid_594174, JString, required = true,
                                 default = nil)
  if valid_594174 != nil:
    section.add "subscriptionId", valid_594174
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594175 = query.getOrDefault("api-version")
  valid_594175 = validateParameter(valid_594175, JString, required = true,
                                 default = nil)
  if valid_594175 != nil:
    section.add "api-version", valid_594175
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters to check availability of the given namespace name
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594177: Call_DisasterRecoveryConfigsCheckNameAvailability_594169;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Check the give namespace name availability.
  ## 
  let valid = call_594177.validator(path, query, header, formData, body)
  let scheme = call_594177.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594177.url(scheme.get, call_594177.host, call_594177.base,
                         call_594177.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594177, url, valid)

proc call*(call_594178: Call_DisasterRecoveryConfigsCheckNameAvailability_594169;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; parameters: JsonNode): Recallable =
  ## disasterRecoveryConfigsCheckNameAvailability
  ## Check the give namespace name availability.
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters to check availability of the given namespace name
  var path_594179 = newJObject()
  var query_594180 = newJObject()
  var body_594181 = newJObject()
  add(path_594179, "namespaceName", newJString(namespaceName))
  add(path_594179, "resourceGroupName", newJString(resourceGroupName))
  add(query_594180, "api-version", newJString(apiVersion))
  add(path_594179, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594181 = parameters
  result = call_594178.call(path_594179, query_594180, nil, nil, body_594181)

var disasterRecoveryConfigsCheckNameAvailability* = Call_DisasterRecoveryConfigsCheckNameAvailability_594169(
    name: "disasterRecoveryConfigsCheckNameAvailability",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/disasterRecoveryConfigs/CheckNameAvailability",
    validator: validate_DisasterRecoveryConfigsCheckNameAvailability_594170,
    base: "", url: url_DisasterRecoveryConfigsCheckNameAvailability_594171,
    schemes: {Scheme.Https})
type
  Call_DisasterRecoveryConfigsCreateOrUpdate_594194 = ref object of OpenApiRestCall_593437
proc url_DisasterRecoveryConfigsCreateOrUpdate_594196(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "alias" in path, "`alias` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceBus/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/disasterRecoveryConfigs/"),
               (kind: VariableSegment, value: "alias")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DisasterRecoveryConfigsCreateOrUpdate_594195(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a new Alias(Disaster Recovery configuration)
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   alias: JString (required)
  ##        : The Disaster Recovery configuration name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_594197 = path.getOrDefault("namespaceName")
  valid_594197 = validateParameter(valid_594197, JString, required = true,
                                 default = nil)
  if valid_594197 != nil:
    section.add "namespaceName", valid_594197
  var valid_594198 = path.getOrDefault("resourceGroupName")
  valid_594198 = validateParameter(valid_594198, JString, required = true,
                                 default = nil)
  if valid_594198 != nil:
    section.add "resourceGroupName", valid_594198
  var valid_594199 = path.getOrDefault("subscriptionId")
  valid_594199 = validateParameter(valid_594199, JString, required = true,
                                 default = nil)
  if valid_594199 != nil:
    section.add "subscriptionId", valid_594199
  var valid_594200 = path.getOrDefault("alias")
  valid_594200 = validateParameter(valid_594200, JString, required = true,
                                 default = nil)
  if valid_594200 != nil:
    section.add "alias", valid_594200
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594201 = query.getOrDefault("api-version")
  valid_594201 = validateParameter(valid_594201, JString, required = true,
                                 default = nil)
  if valid_594201 != nil:
    section.add "api-version", valid_594201
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters required to create an Alias(Disaster Recovery configuration)
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594203: Call_DisasterRecoveryConfigsCreateOrUpdate_594194;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates a new Alias(Disaster Recovery configuration)
  ## 
  let valid = call_594203.validator(path, query, header, formData, body)
  let scheme = call_594203.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594203.url(scheme.get, call_594203.host, call_594203.base,
                         call_594203.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594203, url, valid)

proc call*(call_594204: Call_DisasterRecoveryConfigsCreateOrUpdate_594194;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; parameters: JsonNode; alias: string): Recallable =
  ## disasterRecoveryConfigsCreateOrUpdate
  ## Creates or updates a new Alias(Disaster Recovery configuration)
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters required to create an Alias(Disaster Recovery configuration)
  ##   alias: string (required)
  ##        : The Disaster Recovery configuration name
  var path_594205 = newJObject()
  var query_594206 = newJObject()
  var body_594207 = newJObject()
  add(path_594205, "namespaceName", newJString(namespaceName))
  add(path_594205, "resourceGroupName", newJString(resourceGroupName))
  add(query_594206, "api-version", newJString(apiVersion))
  add(path_594205, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594207 = parameters
  add(path_594205, "alias", newJString(alias))
  result = call_594204.call(path_594205, query_594206, nil, nil, body_594207)

var disasterRecoveryConfigsCreateOrUpdate* = Call_DisasterRecoveryConfigsCreateOrUpdate_594194(
    name: "disasterRecoveryConfigsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/disasterRecoveryConfigs/{alias}",
    validator: validate_DisasterRecoveryConfigsCreateOrUpdate_594195, base: "",
    url: url_DisasterRecoveryConfigsCreateOrUpdate_594196, schemes: {Scheme.Https})
type
  Call_DisasterRecoveryConfigsGet_594182 = ref object of OpenApiRestCall_593437
proc url_DisasterRecoveryConfigsGet_594184(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "alias" in path, "`alias` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceBus/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/disasterRecoveryConfigs/"),
               (kind: VariableSegment, value: "alias")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DisasterRecoveryConfigsGet_594183(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves Alias(Disaster Recovery configuration) for primary or secondary namespace
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   alias: JString (required)
  ##        : The Disaster Recovery configuration name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_594185 = path.getOrDefault("namespaceName")
  valid_594185 = validateParameter(valid_594185, JString, required = true,
                                 default = nil)
  if valid_594185 != nil:
    section.add "namespaceName", valid_594185
  var valid_594186 = path.getOrDefault("resourceGroupName")
  valid_594186 = validateParameter(valid_594186, JString, required = true,
                                 default = nil)
  if valid_594186 != nil:
    section.add "resourceGroupName", valid_594186
  var valid_594187 = path.getOrDefault("subscriptionId")
  valid_594187 = validateParameter(valid_594187, JString, required = true,
                                 default = nil)
  if valid_594187 != nil:
    section.add "subscriptionId", valid_594187
  var valid_594188 = path.getOrDefault("alias")
  valid_594188 = validateParameter(valid_594188, JString, required = true,
                                 default = nil)
  if valid_594188 != nil:
    section.add "alias", valid_594188
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594189 = query.getOrDefault("api-version")
  valid_594189 = validateParameter(valid_594189, JString, required = true,
                                 default = nil)
  if valid_594189 != nil:
    section.add "api-version", valid_594189
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594190: Call_DisasterRecoveryConfigsGet_594182; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves Alias(Disaster Recovery configuration) for primary or secondary namespace
  ## 
  let valid = call_594190.validator(path, query, header, formData, body)
  let scheme = call_594190.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594190.url(scheme.get, call_594190.host, call_594190.base,
                         call_594190.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594190, url, valid)

proc call*(call_594191: Call_DisasterRecoveryConfigsGet_594182;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; alias: string): Recallable =
  ## disasterRecoveryConfigsGet
  ## Retrieves Alias(Disaster Recovery configuration) for primary or secondary namespace
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   alias: string (required)
  ##        : The Disaster Recovery configuration name
  var path_594192 = newJObject()
  var query_594193 = newJObject()
  add(path_594192, "namespaceName", newJString(namespaceName))
  add(path_594192, "resourceGroupName", newJString(resourceGroupName))
  add(query_594193, "api-version", newJString(apiVersion))
  add(path_594192, "subscriptionId", newJString(subscriptionId))
  add(path_594192, "alias", newJString(alias))
  result = call_594191.call(path_594192, query_594193, nil, nil, nil)

var disasterRecoveryConfigsGet* = Call_DisasterRecoveryConfigsGet_594182(
    name: "disasterRecoveryConfigsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/disasterRecoveryConfigs/{alias}",
    validator: validate_DisasterRecoveryConfigsGet_594183, base: "",
    url: url_DisasterRecoveryConfigsGet_594184, schemes: {Scheme.Https})
type
  Call_DisasterRecoveryConfigsDelete_594208 = ref object of OpenApiRestCall_593437
proc url_DisasterRecoveryConfigsDelete_594210(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "alias" in path, "`alias` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceBus/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/disasterRecoveryConfigs/"),
               (kind: VariableSegment, value: "alias")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DisasterRecoveryConfigsDelete_594209(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an Alias(Disaster Recovery configuration)
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   alias: JString (required)
  ##        : The Disaster Recovery configuration name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_594211 = path.getOrDefault("namespaceName")
  valid_594211 = validateParameter(valid_594211, JString, required = true,
                                 default = nil)
  if valid_594211 != nil:
    section.add "namespaceName", valid_594211
  var valid_594212 = path.getOrDefault("resourceGroupName")
  valid_594212 = validateParameter(valid_594212, JString, required = true,
                                 default = nil)
  if valid_594212 != nil:
    section.add "resourceGroupName", valid_594212
  var valid_594213 = path.getOrDefault("subscriptionId")
  valid_594213 = validateParameter(valid_594213, JString, required = true,
                                 default = nil)
  if valid_594213 != nil:
    section.add "subscriptionId", valid_594213
  var valid_594214 = path.getOrDefault("alias")
  valid_594214 = validateParameter(valid_594214, JString, required = true,
                                 default = nil)
  if valid_594214 != nil:
    section.add "alias", valid_594214
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594215 = query.getOrDefault("api-version")
  valid_594215 = validateParameter(valid_594215, JString, required = true,
                                 default = nil)
  if valid_594215 != nil:
    section.add "api-version", valid_594215
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594216: Call_DisasterRecoveryConfigsDelete_594208; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an Alias(Disaster Recovery configuration)
  ## 
  let valid = call_594216.validator(path, query, header, formData, body)
  let scheme = call_594216.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594216.url(scheme.get, call_594216.host, call_594216.base,
                         call_594216.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594216, url, valid)

proc call*(call_594217: Call_DisasterRecoveryConfigsDelete_594208;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; alias: string): Recallable =
  ## disasterRecoveryConfigsDelete
  ## Deletes an Alias(Disaster Recovery configuration)
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   alias: string (required)
  ##        : The Disaster Recovery configuration name
  var path_594218 = newJObject()
  var query_594219 = newJObject()
  add(path_594218, "namespaceName", newJString(namespaceName))
  add(path_594218, "resourceGroupName", newJString(resourceGroupName))
  add(query_594219, "api-version", newJString(apiVersion))
  add(path_594218, "subscriptionId", newJString(subscriptionId))
  add(path_594218, "alias", newJString(alias))
  result = call_594217.call(path_594218, query_594219, nil, nil, nil)

var disasterRecoveryConfigsDelete* = Call_DisasterRecoveryConfigsDelete_594208(
    name: "disasterRecoveryConfigsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/disasterRecoveryConfigs/{alias}",
    validator: validate_DisasterRecoveryConfigsDelete_594209, base: "",
    url: url_DisasterRecoveryConfigsDelete_594210, schemes: {Scheme.Https})
type
  Call_DisasterRecoveryConfigsListAuthorizationRules_594220 = ref object of OpenApiRestCall_593437
proc url_DisasterRecoveryConfigsListAuthorizationRules_594222(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "alias" in path, "`alias` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceBus/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/disasterRecoveryConfigs/"),
               (kind: VariableSegment, value: "alias"),
               (kind: ConstantSegment, value: "/AuthorizationRules")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DisasterRecoveryConfigsListAuthorizationRules_594221(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets the authorization rules for a namespace.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639376.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   alias: JString (required)
  ##        : The Disaster Recovery configuration name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_594223 = path.getOrDefault("namespaceName")
  valid_594223 = validateParameter(valid_594223, JString, required = true,
                                 default = nil)
  if valid_594223 != nil:
    section.add "namespaceName", valid_594223
  var valid_594224 = path.getOrDefault("resourceGroupName")
  valid_594224 = validateParameter(valid_594224, JString, required = true,
                                 default = nil)
  if valid_594224 != nil:
    section.add "resourceGroupName", valid_594224
  var valid_594225 = path.getOrDefault("subscriptionId")
  valid_594225 = validateParameter(valid_594225, JString, required = true,
                                 default = nil)
  if valid_594225 != nil:
    section.add "subscriptionId", valid_594225
  var valid_594226 = path.getOrDefault("alias")
  valid_594226 = validateParameter(valid_594226, JString, required = true,
                                 default = nil)
  if valid_594226 != nil:
    section.add "alias", valid_594226
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594227 = query.getOrDefault("api-version")
  valid_594227 = validateParameter(valid_594227, JString, required = true,
                                 default = nil)
  if valid_594227 != nil:
    section.add "api-version", valid_594227
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594228: Call_DisasterRecoveryConfigsListAuthorizationRules_594220;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the authorization rules for a namespace.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639376.aspx
  let valid = call_594228.validator(path, query, header, formData, body)
  let scheme = call_594228.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594228.url(scheme.get, call_594228.host, call_594228.base,
                         call_594228.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594228, url, valid)

proc call*(call_594229: Call_DisasterRecoveryConfigsListAuthorizationRules_594220;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; alias: string): Recallable =
  ## disasterRecoveryConfigsListAuthorizationRules
  ## Gets the authorization rules for a namespace.
  ## https://msdn.microsoft.com/en-us/library/azure/mt639376.aspx
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   alias: string (required)
  ##        : The Disaster Recovery configuration name
  var path_594230 = newJObject()
  var query_594231 = newJObject()
  add(path_594230, "namespaceName", newJString(namespaceName))
  add(path_594230, "resourceGroupName", newJString(resourceGroupName))
  add(query_594231, "api-version", newJString(apiVersion))
  add(path_594230, "subscriptionId", newJString(subscriptionId))
  add(path_594230, "alias", newJString(alias))
  result = call_594229.call(path_594230, query_594231, nil, nil, nil)

var disasterRecoveryConfigsListAuthorizationRules* = Call_DisasterRecoveryConfigsListAuthorizationRules_594220(
    name: "disasterRecoveryConfigsListAuthorizationRules",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/disasterRecoveryConfigs/{alias}/AuthorizationRules",
    validator: validate_DisasterRecoveryConfigsListAuthorizationRules_594221,
    base: "", url: url_DisasterRecoveryConfigsListAuthorizationRules_594222,
    schemes: {Scheme.Https})
type
  Call_DisasterRecoveryConfigsGetAuthorizationRule_594232 = ref object of OpenApiRestCall_593437
proc url_DisasterRecoveryConfigsGetAuthorizationRule_594234(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "alias" in path, "`alias` is a required path parameter"
  assert "authorizationRuleName" in path,
        "`authorizationRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceBus/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/disasterRecoveryConfigs/"),
               (kind: VariableSegment, value: "alias"),
               (kind: ConstantSegment, value: "/AuthorizationRules/"),
               (kind: VariableSegment, value: "authorizationRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DisasterRecoveryConfigsGetAuthorizationRule_594233(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets an authorization rule for a namespace by rule name.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639392.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   authorizationRuleName: JString (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   alias: JString (required)
  ##        : The Disaster Recovery configuration name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_594235 = path.getOrDefault("namespaceName")
  valid_594235 = validateParameter(valid_594235, JString, required = true,
                                 default = nil)
  if valid_594235 != nil:
    section.add "namespaceName", valid_594235
  var valid_594236 = path.getOrDefault("resourceGroupName")
  valid_594236 = validateParameter(valid_594236, JString, required = true,
                                 default = nil)
  if valid_594236 != nil:
    section.add "resourceGroupName", valid_594236
  var valid_594237 = path.getOrDefault("authorizationRuleName")
  valid_594237 = validateParameter(valid_594237, JString, required = true,
                                 default = nil)
  if valid_594237 != nil:
    section.add "authorizationRuleName", valid_594237
  var valid_594238 = path.getOrDefault("subscriptionId")
  valid_594238 = validateParameter(valid_594238, JString, required = true,
                                 default = nil)
  if valid_594238 != nil:
    section.add "subscriptionId", valid_594238
  var valid_594239 = path.getOrDefault("alias")
  valid_594239 = validateParameter(valid_594239, JString, required = true,
                                 default = nil)
  if valid_594239 != nil:
    section.add "alias", valid_594239
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594240 = query.getOrDefault("api-version")
  valid_594240 = validateParameter(valid_594240, JString, required = true,
                                 default = nil)
  if valid_594240 != nil:
    section.add "api-version", valid_594240
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594241: Call_DisasterRecoveryConfigsGetAuthorizationRule_594232;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets an authorization rule for a namespace by rule name.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639392.aspx
  let valid = call_594241.validator(path, query, header, formData, body)
  let scheme = call_594241.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594241.url(scheme.get, call_594241.host, call_594241.base,
                         call_594241.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594241, url, valid)

proc call*(call_594242: Call_DisasterRecoveryConfigsGetAuthorizationRule_594232;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          authorizationRuleName: string; subscriptionId: string; alias: string): Recallable =
  ## disasterRecoveryConfigsGetAuthorizationRule
  ## Gets an authorization rule for a namespace by rule name.
  ## https://msdn.microsoft.com/en-us/library/azure/mt639392.aspx
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   authorizationRuleName: string (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   alias: string (required)
  ##        : The Disaster Recovery configuration name
  var path_594243 = newJObject()
  var query_594244 = newJObject()
  add(path_594243, "namespaceName", newJString(namespaceName))
  add(path_594243, "resourceGroupName", newJString(resourceGroupName))
  add(query_594244, "api-version", newJString(apiVersion))
  add(path_594243, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_594243, "subscriptionId", newJString(subscriptionId))
  add(path_594243, "alias", newJString(alias))
  result = call_594242.call(path_594243, query_594244, nil, nil, nil)

var disasterRecoveryConfigsGetAuthorizationRule* = Call_DisasterRecoveryConfigsGetAuthorizationRule_594232(
    name: "disasterRecoveryConfigsGetAuthorizationRule", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/disasterRecoveryConfigs/{alias}/AuthorizationRules/{authorizationRuleName}",
    validator: validate_DisasterRecoveryConfigsGetAuthorizationRule_594233,
    base: "", url: url_DisasterRecoveryConfigsGetAuthorizationRule_594234,
    schemes: {Scheme.Https})
type
  Call_DisasterRecoveryConfigsListKeys_594245 = ref object of OpenApiRestCall_593437
proc url_DisasterRecoveryConfigsListKeys_594247(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "alias" in path, "`alias` is a required path parameter"
  assert "authorizationRuleName" in path,
        "`authorizationRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceBus/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/disasterRecoveryConfigs/"),
               (kind: VariableSegment, value: "alias"),
               (kind: ConstantSegment, value: "/AuthorizationRules/"),
               (kind: VariableSegment, value: "authorizationRuleName"),
               (kind: ConstantSegment, value: "/listKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DisasterRecoveryConfigsListKeys_594246(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the primary and secondary connection strings for the namespace.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639398.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   authorizationRuleName: JString (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   alias: JString (required)
  ##        : The Disaster Recovery configuration name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_594248 = path.getOrDefault("namespaceName")
  valid_594248 = validateParameter(valid_594248, JString, required = true,
                                 default = nil)
  if valid_594248 != nil:
    section.add "namespaceName", valid_594248
  var valid_594249 = path.getOrDefault("resourceGroupName")
  valid_594249 = validateParameter(valid_594249, JString, required = true,
                                 default = nil)
  if valid_594249 != nil:
    section.add "resourceGroupName", valid_594249
  var valid_594250 = path.getOrDefault("authorizationRuleName")
  valid_594250 = validateParameter(valid_594250, JString, required = true,
                                 default = nil)
  if valid_594250 != nil:
    section.add "authorizationRuleName", valid_594250
  var valid_594251 = path.getOrDefault("subscriptionId")
  valid_594251 = validateParameter(valid_594251, JString, required = true,
                                 default = nil)
  if valid_594251 != nil:
    section.add "subscriptionId", valid_594251
  var valid_594252 = path.getOrDefault("alias")
  valid_594252 = validateParameter(valid_594252, JString, required = true,
                                 default = nil)
  if valid_594252 != nil:
    section.add "alias", valid_594252
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594253 = query.getOrDefault("api-version")
  valid_594253 = validateParameter(valid_594253, JString, required = true,
                                 default = nil)
  if valid_594253 != nil:
    section.add "api-version", valid_594253
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594254: Call_DisasterRecoveryConfigsListKeys_594245;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the primary and secondary connection strings for the namespace.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639398.aspx
  let valid = call_594254.validator(path, query, header, formData, body)
  let scheme = call_594254.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594254.url(scheme.get, call_594254.host, call_594254.base,
                         call_594254.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594254, url, valid)

proc call*(call_594255: Call_DisasterRecoveryConfigsListKeys_594245;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          authorizationRuleName: string; subscriptionId: string; alias: string): Recallable =
  ## disasterRecoveryConfigsListKeys
  ## Gets the primary and secondary connection strings for the namespace.
  ## https://msdn.microsoft.com/en-us/library/azure/mt639398.aspx
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   authorizationRuleName: string (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   alias: string (required)
  ##        : The Disaster Recovery configuration name
  var path_594256 = newJObject()
  var query_594257 = newJObject()
  add(path_594256, "namespaceName", newJString(namespaceName))
  add(path_594256, "resourceGroupName", newJString(resourceGroupName))
  add(query_594257, "api-version", newJString(apiVersion))
  add(path_594256, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_594256, "subscriptionId", newJString(subscriptionId))
  add(path_594256, "alias", newJString(alias))
  result = call_594255.call(path_594256, query_594257, nil, nil, nil)

var disasterRecoveryConfigsListKeys* = Call_DisasterRecoveryConfigsListKeys_594245(
    name: "disasterRecoveryConfigsListKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/disasterRecoveryConfigs/{alias}/AuthorizationRules/{authorizationRuleName}/listKeys",
    validator: validate_DisasterRecoveryConfigsListKeys_594246, base: "",
    url: url_DisasterRecoveryConfigsListKeys_594247, schemes: {Scheme.Https})
type
  Call_DisasterRecoveryConfigsBreakPairing_594258 = ref object of OpenApiRestCall_593437
proc url_DisasterRecoveryConfigsBreakPairing_594260(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "alias" in path, "`alias` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceBus/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/disasterRecoveryConfigs/"),
               (kind: VariableSegment, value: "alias"),
               (kind: ConstantSegment, value: "/breakPairing")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DisasterRecoveryConfigsBreakPairing_594259(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This operation disables the Disaster Recovery and stops replicating changes from primary to secondary namespaces
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   alias: JString (required)
  ##        : The Disaster Recovery configuration name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_594261 = path.getOrDefault("namespaceName")
  valid_594261 = validateParameter(valid_594261, JString, required = true,
                                 default = nil)
  if valid_594261 != nil:
    section.add "namespaceName", valid_594261
  var valid_594262 = path.getOrDefault("resourceGroupName")
  valid_594262 = validateParameter(valid_594262, JString, required = true,
                                 default = nil)
  if valid_594262 != nil:
    section.add "resourceGroupName", valid_594262
  var valid_594263 = path.getOrDefault("subscriptionId")
  valid_594263 = validateParameter(valid_594263, JString, required = true,
                                 default = nil)
  if valid_594263 != nil:
    section.add "subscriptionId", valid_594263
  var valid_594264 = path.getOrDefault("alias")
  valid_594264 = validateParameter(valid_594264, JString, required = true,
                                 default = nil)
  if valid_594264 != nil:
    section.add "alias", valid_594264
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594265 = query.getOrDefault("api-version")
  valid_594265 = validateParameter(valid_594265, JString, required = true,
                                 default = nil)
  if valid_594265 != nil:
    section.add "api-version", valid_594265
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594266: Call_DisasterRecoveryConfigsBreakPairing_594258;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## This operation disables the Disaster Recovery and stops replicating changes from primary to secondary namespaces
  ## 
  let valid = call_594266.validator(path, query, header, formData, body)
  let scheme = call_594266.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594266.url(scheme.get, call_594266.host, call_594266.base,
                         call_594266.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594266, url, valid)

proc call*(call_594267: Call_DisasterRecoveryConfigsBreakPairing_594258;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; alias: string): Recallable =
  ## disasterRecoveryConfigsBreakPairing
  ## This operation disables the Disaster Recovery and stops replicating changes from primary to secondary namespaces
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   alias: string (required)
  ##        : The Disaster Recovery configuration name
  var path_594268 = newJObject()
  var query_594269 = newJObject()
  add(path_594268, "namespaceName", newJString(namespaceName))
  add(path_594268, "resourceGroupName", newJString(resourceGroupName))
  add(query_594269, "api-version", newJString(apiVersion))
  add(path_594268, "subscriptionId", newJString(subscriptionId))
  add(path_594268, "alias", newJString(alias))
  result = call_594267.call(path_594268, query_594269, nil, nil, nil)

var disasterRecoveryConfigsBreakPairing* = Call_DisasterRecoveryConfigsBreakPairing_594258(
    name: "disasterRecoveryConfigsBreakPairing", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/disasterRecoveryConfigs/{alias}/breakPairing",
    validator: validate_DisasterRecoveryConfigsBreakPairing_594259, base: "",
    url: url_DisasterRecoveryConfigsBreakPairing_594260, schemes: {Scheme.Https})
type
  Call_DisasterRecoveryConfigsFailOver_594270 = ref object of OpenApiRestCall_593437
proc url_DisasterRecoveryConfigsFailOver_594272(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "alias" in path, "`alias` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceBus/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/disasterRecoveryConfigs/"),
               (kind: VariableSegment, value: "alias"),
               (kind: ConstantSegment, value: "/failover")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DisasterRecoveryConfigsFailOver_594271(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Invokes GEO DR failover and reconfigure the alias to point to the secondary namespace
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   alias: JString (required)
  ##        : The Disaster Recovery configuration name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_594273 = path.getOrDefault("namespaceName")
  valid_594273 = validateParameter(valid_594273, JString, required = true,
                                 default = nil)
  if valid_594273 != nil:
    section.add "namespaceName", valid_594273
  var valid_594274 = path.getOrDefault("resourceGroupName")
  valid_594274 = validateParameter(valid_594274, JString, required = true,
                                 default = nil)
  if valid_594274 != nil:
    section.add "resourceGroupName", valid_594274
  var valid_594275 = path.getOrDefault("subscriptionId")
  valid_594275 = validateParameter(valid_594275, JString, required = true,
                                 default = nil)
  if valid_594275 != nil:
    section.add "subscriptionId", valid_594275
  var valid_594276 = path.getOrDefault("alias")
  valid_594276 = validateParameter(valid_594276, JString, required = true,
                                 default = nil)
  if valid_594276 != nil:
    section.add "alias", valid_594276
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594277 = query.getOrDefault("api-version")
  valid_594277 = validateParameter(valid_594277, JString, required = true,
                                 default = nil)
  if valid_594277 != nil:
    section.add "api-version", valid_594277
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594278: Call_DisasterRecoveryConfigsFailOver_594270;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Invokes GEO DR failover and reconfigure the alias to point to the secondary namespace
  ## 
  let valid = call_594278.validator(path, query, header, formData, body)
  let scheme = call_594278.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594278.url(scheme.get, call_594278.host, call_594278.base,
                         call_594278.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594278, url, valid)

proc call*(call_594279: Call_DisasterRecoveryConfigsFailOver_594270;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; alias: string): Recallable =
  ## disasterRecoveryConfigsFailOver
  ## Invokes GEO DR failover and reconfigure the alias to point to the secondary namespace
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   alias: string (required)
  ##        : The Disaster Recovery configuration name
  var path_594280 = newJObject()
  var query_594281 = newJObject()
  add(path_594280, "namespaceName", newJString(namespaceName))
  add(path_594280, "resourceGroupName", newJString(resourceGroupName))
  add(query_594281, "api-version", newJString(apiVersion))
  add(path_594280, "subscriptionId", newJString(subscriptionId))
  add(path_594280, "alias", newJString(alias))
  result = call_594279.call(path_594280, query_594281, nil, nil, nil)

var disasterRecoveryConfigsFailOver* = Call_DisasterRecoveryConfigsFailOver_594270(
    name: "disasterRecoveryConfigsFailOver", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/disasterRecoveryConfigs/{alias}/failover",
    validator: validate_DisasterRecoveryConfigsFailOver_594271, base: "",
    url: url_DisasterRecoveryConfigsFailOver_594272, schemes: {Scheme.Https})
type
  Call_EventHubsListByNamespace_594282 = ref object of OpenApiRestCall_593437
proc url_EventHubsListByNamespace_594284(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceBus/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/eventhubs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EventHubsListByNamespace_594283(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the Event Hubs in a service bus Namespace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_594285 = path.getOrDefault("namespaceName")
  valid_594285 = validateParameter(valid_594285, JString, required = true,
                                 default = nil)
  if valid_594285 != nil:
    section.add "namespaceName", valid_594285
  var valid_594286 = path.getOrDefault("resourceGroupName")
  valid_594286 = validateParameter(valid_594286, JString, required = true,
                                 default = nil)
  if valid_594286 != nil:
    section.add "resourceGroupName", valid_594286
  var valid_594287 = path.getOrDefault("subscriptionId")
  valid_594287 = validateParameter(valid_594287, JString, required = true,
                                 default = nil)
  if valid_594287 != nil:
    section.add "subscriptionId", valid_594287
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594288 = query.getOrDefault("api-version")
  valid_594288 = validateParameter(valid_594288, JString, required = true,
                                 default = nil)
  if valid_594288 != nil:
    section.add "api-version", valid_594288
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594289: Call_EventHubsListByNamespace_594282; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the Event Hubs in a service bus Namespace.
  ## 
  let valid = call_594289.validator(path, query, header, formData, body)
  let scheme = call_594289.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594289.url(scheme.get, call_594289.host, call_594289.base,
                         call_594289.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594289, url, valid)

proc call*(call_594290: Call_EventHubsListByNamespace_594282;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## eventHubsListByNamespace
  ## Gets all the Event Hubs in a service bus Namespace.
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594291 = newJObject()
  var query_594292 = newJObject()
  add(path_594291, "namespaceName", newJString(namespaceName))
  add(path_594291, "resourceGroupName", newJString(resourceGroupName))
  add(query_594292, "api-version", newJString(apiVersion))
  add(path_594291, "subscriptionId", newJString(subscriptionId))
  result = call_594290.call(path_594291, query_594292, nil, nil, nil)

var eventHubsListByNamespace* = Call_EventHubsListByNamespace_594282(
    name: "eventHubsListByNamespace", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/eventhubs",
    validator: validate_EventHubsListByNamespace_594283, base: "",
    url: url_EventHubsListByNamespace_594284, schemes: {Scheme.Https})
type
  Call_NamespacesMigrate_594293 = ref object of OpenApiRestCall_593437
proc url_NamespacesMigrate_594295(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceBus/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/migrate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesMigrate_594294(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## This operation Migrate the given namespace to provided name type
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_594296 = path.getOrDefault("namespaceName")
  valid_594296 = validateParameter(valid_594296, JString, required = true,
                                 default = nil)
  if valid_594296 != nil:
    section.add "namespaceName", valid_594296
  var valid_594297 = path.getOrDefault("resourceGroupName")
  valid_594297 = validateParameter(valid_594297, JString, required = true,
                                 default = nil)
  if valid_594297 != nil:
    section.add "resourceGroupName", valid_594297
  var valid_594298 = path.getOrDefault("subscriptionId")
  valid_594298 = validateParameter(valid_594298, JString, required = true,
                                 default = nil)
  if valid_594298 != nil:
    section.add "subscriptionId", valid_594298
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594299 = query.getOrDefault("api-version")
  valid_594299 = validateParameter(valid_594299, JString, required = true,
                                 default = nil)
  if valid_594299 != nil:
    section.add "api-version", valid_594299
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to migrate namespace type.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594301: Call_NamespacesMigrate_594293; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This operation Migrate the given namespace to provided name type
  ## 
  let valid = call_594301.validator(path, query, header, formData, body)
  let scheme = call_594301.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594301.url(scheme.get, call_594301.host, call_594301.base,
                         call_594301.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594301, url, valid)

proc call*(call_594302: Call_NamespacesMigrate_594293; namespaceName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode): Recallable =
  ## namespacesMigrate
  ## This operation Migrate the given namespace to provided name type
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to migrate namespace type.
  var path_594303 = newJObject()
  var query_594304 = newJObject()
  var body_594305 = newJObject()
  add(path_594303, "namespaceName", newJString(namespaceName))
  add(path_594303, "resourceGroupName", newJString(resourceGroupName))
  add(query_594304, "api-version", newJString(apiVersion))
  add(path_594303, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594305 = parameters
  result = call_594302.call(path_594303, query_594304, nil, nil, body_594305)

var namespacesMigrate* = Call_NamespacesMigrate_594293(name: "namespacesMigrate",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/migrate",
    validator: validate_NamespacesMigrate_594294, base: "",
    url: url_NamespacesMigrate_594295, schemes: {Scheme.Https})
type
  Call_MigrationConfigsList_594306 = ref object of OpenApiRestCall_593437
proc url_MigrationConfigsList_594308(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceBus/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/migrationConfigurations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MigrationConfigsList_594307(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all migrationConfigurations
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_594309 = path.getOrDefault("namespaceName")
  valid_594309 = validateParameter(valid_594309, JString, required = true,
                                 default = nil)
  if valid_594309 != nil:
    section.add "namespaceName", valid_594309
  var valid_594310 = path.getOrDefault("resourceGroupName")
  valid_594310 = validateParameter(valid_594310, JString, required = true,
                                 default = nil)
  if valid_594310 != nil:
    section.add "resourceGroupName", valid_594310
  var valid_594311 = path.getOrDefault("subscriptionId")
  valid_594311 = validateParameter(valid_594311, JString, required = true,
                                 default = nil)
  if valid_594311 != nil:
    section.add "subscriptionId", valid_594311
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594312 = query.getOrDefault("api-version")
  valid_594312 = validateParameter(valid_594312, JString, required = true,
                                 default = nil)
  if valid_594312 != nil:
    section.add "api-version", valid_594312
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594313: Call_MigrationConfigsList_594306; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all migrationConfigurations
  ## 
  let valid = call_594313.validator(path, query, header, formData, body)
  let scheme = call_594313.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594313.url(scheme.get, call_594313.host, call_594313.base,
                         call_594313.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594313, url, valid)

proc call*(call_594314: Call_MigrationConfigsList_594306; namespaceName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## migrationConfigsList
  ## Gets all migrationConfigurations
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594315 = newJObject()
  var query_594316 = newJObject()
  add(path_594315, "namespaceName", newJString(namespaceName))
  add(path_594315, "resourceGroupName", newJString(resourceGroupName))
  add(query_594316, "api-version", newJString(apiVersion))
  add(path_594315, "subscriptionId", newJString(subscriptionId))
  result = call_594314.call(path_594315, query_594316, nil, nil, nil)

var migrationConfigsList* = Call_MigrationConfigsList_594306(
    name: "migrationConfigsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/migrationConfigurations",
    validator: validate_MigrationConfigsList_594307, base: "",
    url: url_MigrationConfigsList_594308, schemes: {Scheme.Https})
type
  Call_MigrationConfigsCreateAndStartMigration_594342 = ref object of OpenApiRestCall_593437
proc url_MigrationConfigsCreateAndStartMigration_594344(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "configName" in path, "`configName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceBus/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/migrationConfigurations/"),
               (kind: VariableSegment, value: "configName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MigrationConfigsCreateAndStartMigration_594343(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates Migration configuration and starts migration of entities from Standard to Premium namespace
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   configName: JString (required)
  ##             : The configuration name. Should always be "$default".
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_594345 = path.getOrDefault("namespaceName")
  valid_594345 = validateParameter(valid_594345, JString, required = true,
                                 default = nil)
  if valid_594345 != nil:
    section.add "namespaceName", valid_594345
  var valid_594346 = path.getOrDefault("resourceGroupName")
  valid_594346 = validateParameter(valid_594346, JString, required = true,
                                 default = nil)
  if valid_594346 != nil:
    section.add "resourceGroupName", valid_594346
  var valid_594347 = path.getOrDefault("subscriptionId")
  valid_594347 = validateParameter(valid_594347, JString, required = true,
                                 default = nil)
  if valid_594347 != nil:
    section.add "subscriptionId", valid_594347
  var valid_594348 = path.getOrDefault("configName")
  valid_594348 = validateParameter(valid_594348, JString, required = true,
                                 default = newJString("$default"))
  if valid_594348 != nil:
    section.add "configName", valid_594348
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594349 = query.getOrDefault("api-version")
  valid_594349 = validateParameter(valid_594349, JString, required = true,
                                 default = nil)
  if valid_594349 != nil:
    section.add "api-version", valid_594349
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters required to create Migration Configuration
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594351: Call_MigrationConfigsCreateAndStartMigration_594342;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates Migration configuration and starts migration of entities from Standard to Premium namespace
  ## 
  let valid = call_594351.validator(path, query, header, formData, body)
  let scheme = call_594351.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594351.url(scheme.get, call_594351.host, call_594351.base,
                         call_594351.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594351, url, valid)

proc call*(call_594352: Call_MigrationConfigsCreateAndStartMigration_594342;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; parameters: JsonNode;
          configName: string = "$default"): Recallable =
  ## migrationConfigsCreateAndStartMigration
  ## Creates Migration configuration and starts migration of entities from Standard to Premium namespace
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters required to create Migration Configuration
  ##   configName: string (required)
  ##             : The configuration name. Should always be "$default".
  var path_594353 = newJObject()
  var query_594354 = newJObject()
  var body_594355 = newJObject()
  add(path_594353, "namespaceName", newJString(namespaceName))
  add(path_594353, "resourceGroupName", newJString(resourceGroupName))
  add(query_594354, "api-version", newJString(apiVersion))
  add(path_594353, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594355 = parameters
  add(path_594353, "configName", newJString(configName))
  result = call_594352.call(path_594353, query_594354, nil, nil, body_594355)

var migrationConfigsCreateAndStartMigration* = Call_MigrationConfigsCreateAndStartMigration_594342(
    name: "migrationConfigsCreateAndStartMigration", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/migrationConfigurations/{configName}",
    validator: validate_MigrationConfigsCreateAndStartMigration_594343, base: "",
    url: url_MigrationConfigsCreateAndStartMigration_594344,
    schemes: {Scheme.Https})
type
  Call_MigrationConfigsGet_594317 = ref object of OpenApiRestCall_593437
proc url_MigrationConfigsGet_594319(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "configName" in path, "`configName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceBus/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/migrationConfigurations/"),
               (kind: VariableSegment, value: "configName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MigrationConfigsGet_594318(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Retrieves Migration Config
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   configName: JString (required)
  ##             : The configuration name. Should always be "$default".
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_594320 = path.getOrDefault("namespaceName")
  valid_594320 = validateParameter(valid_594320, JString, required = true,
                                 default = nil)
  if valid_594320 != nil:
    section.add "namespaceName", valid_594320
  var valid_594321 = path.getOrDefault("resourceGroupName")
  valid_594321 = validateParameter(valid_594321, JString, required = true,
                                 default = nil)
  if valid_594321 != nil:
    section.add "resourceGroupName", valid_594321
  var valid_594322 = path.getOrDefault("subscriptionId")
  valid_594322 = validateParameter(valid_594322, JString, required = true,
                                 default = nil)
  if valid_594322 != nil:
    section.add "subscriptionId", valid_594322
  var valid_594336 = path.getOrDefault("configName")
  valid_594336 = validateParameter(valid_594336, JString, required = true,
                                 default = newJString("$default"))
  if valid_594336 != nil:
    section.add "configName", valid_594336
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594337 = query.getOrDefault("api-version")
  valid_594337 = validateParameter(valid_594337, JString, required = true,
                                 default = nil)
  if valid_594337 != nil:
    section.add "api-version", valid_594337
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594338: Call_MigrationConfigsGet_594317; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves Migration Config
  ## 
  let valid = call_594338.validator(path, query, header, formData, body)
  let scheme = call_594338.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594338.url(scheme.get, call_594338.host, call_594338.base,
                         call_594338.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594338, url, valid)

proc call*(call_594339: Call_MigrationConfigsGet_594317; namespaceName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          configName: string = "$default"): Recallable =
  ## migrationConfigsGet
  ## Retrieves Migration Config
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   configName: string (required)
  ##             : The configuration name. Should always be "$default".
  var path_594340 = newJObject()
  var query_594341 = newJObject()
  add(path_594340, "namespaceName", newJString(namespaceName))
  add(path_594340, "resourceGroupName", newJString(resourceGroupName))
  add(query_594341, "api-version", newJString(apiVersion))
  add(path_594340, "subscriptionId", newJString(subscriptionId))
  add(path_594340, "configName", newJString(configName))
  result = call_594339.call(path_594340, query_594341, nil, nil, nil)

var migrationConfigsGet* = Call_MigrationConfigsGet_594317(
    name: "migrationConfigsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/migrationConfigurations/{configName}",
    validator: validate_MigrationConfigsGet_594318, base: "",
    url: url_MigrationConfigsGet_594319, schemes: {Scheme.Https})
type
  Call_MigrationConfigsDelete_594356 = ref object of OpenApiRestCall_593437
proc url_MigrationConfigsDelete_594358(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "configName" in path, "`configName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceBus/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/migrationConfigurations/"),
               (kind: VariableSegment, value: "configName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MigrationConfigsDelete_594357(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a MigrationConfiguration
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   configName: JString (required)
  ##             : The configuration name. Should always be "$default".
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_594359 = path.getOrDefault("namespaceName")
  valid_594359 = validateParameter(valid_594359, JString, required = true,
                                 default = nil)
  if valid_594359 != nil:
    section.add "namespaceName", valid_594359
  var valid_594360 = path.getOrDefault("resourceGroupName")
  valid_594360 = validateParameter(valid_594360, JString, required = true,
                                 default = nil)
  if valid_594360 != nil:
    section.add "resourceGroupName", valid_594360
  var valid_594361 = path.getOrDefault("subscriptionId")
  valid_594361 = validateParameter(valid_594361, JString, required = true,
                                 default = nil)
  if valid_594361 != nil:
    section.add "subscriptionId", valid_594361
  var valid_594362 = path.getOrDefault("configName")
  valid_594362 = validateParameter(valid_594362, JString, required = true,
                                 default = newJString("$default"))
  if valid_594362 != nil:
    section.add "configName", valid_594362
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594363 = query.getOrDefault("api-version")
  valid_594363 = validateParameter(valid_594363, JString, required = true,
                                 default = nil)
  if valid_594363 != nil:
    section.add "api-version", valid_594363
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594364: Call_MigrationConfigsDelete_594356; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a MigrationConfiguration
  ## 
  let valid = call_594364.validator(path, query, header, formData, body)
  let scheme = call_594364.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594364.url(scheme.get, call_594364.host, call_594364.base,
                         call_594364.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594364, url, valid)

proc call*(call_594365: Call_MigrationConfigsDelete_594356; namespaceName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          configName: string = "$default"): Recallable =
  ## migrationConfigsDelete
  ## Deletes a MigrationConfiguration
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   configName: string (required)
  ##             : The configuration name. Should always be "$default".
  var path_594366 = newJObject()
  var query_594367 = newJObject()
  add(path_594366, "namespaceName", newJString(namespaceName))
  add(path_594366, "resourceGroupName", newJString(resourceGroupName))
  add(query_594367, "api-version", newJString(apiVersion))
  add(path_594366, "subscriptionId", newJString(subscriptionId))
  add(path_594366, "configName", newJString(configName))
  result = call_594365.call(path_594366, query_594367, nil, nil, nil)

var migrationConfigsDelete* = Call_MigrationConfigsDelete_594356(
    name: "migrationConfigsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/migrationConfigurations/{configName}",
    validator: validate_MigrationConfigsDelete_594357, base: "",
    url: url_MigrationConfigsDelete_594358, schemes: {Scheme.Https})
type
  Call_MigrationConfigsRevert_594368 = ref object of OpenApiRestCall_593437
proc url_MigrationConfigsRevert_594370(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "configName" in path, "`configName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceBus/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/migrationConfigurations/"),
               (kind: VariableSegment, value: "configName"),
               (kind: ConstantSegment, value: "/revert")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MigrationConfigsRevert_594369(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This operation reverts Migration
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   configName: JString (required)
  ##             : The configuration name. Should always be "$default".
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_594371 = path.getOrDefault("namespaceName")
  valid_594371 = validateParameter(valid_594371, JString, required = true,
                                 default = nil)
  if valid_594371 != nil:
    section.add "namespaceName", valid_594371
  var valid_594372 = path.getOrDefault("resourceGroupName")
  valid_594372 = validateParameter(valid_594372, JString, required = true,
                                 default = nil)
  if valid_594372 != nil:
    section.add "resourceGroupName", valid_594372
  var valid_594373 = path.getOrDefault("subscriptionId")
  valid_594373 = validateParameter(valid_594373, JString, required = true,
                                 default = nil)
  if valid_594373 != nil:
    section.add "subscriptionId", valid_594373
  var valid_594374 = path.getOrDefault("configName")
  valid_594374 = validateParameter(valid_594374, JString, required = true,
                                 default = newJString("$default"))
  if valid_594374 != nil:
    section.add "configName", valid_594374
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594375 = query.getOrDefault("api-version")
  valid_594375 = validateParameter(valid_594375, JString, required = true,
                                 default = nil)
  if valid_594375 != nil:
    section.add "api-version", valid_594375
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594376: Call_MigrationConfigsRevert_594368; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This operation reverts Migration
  ## 
  let valid = call_594376.validator(path, query, header, formData, body)
  let scheme = call_594376.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594376.url(scheme.get, call_594376.host, call_594376.base,
                         call_594376.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594376, url, valid)

proc call*(call_594377: Call_MigrationConfigsRevert_594368; namespaceName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          configName: string = "$default"): Recallable =
  ## migrationConfigsRevert
  ## This operation reverts Migration
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   configName: string (required)
  ##             : The configuration name. Should always be "$default".
  var path_594378 = newJObject()
  var query_594379 = newJObject()
  add(path_594378, "namespaceName", newJString(namespaceName))
  add(path_594378, "resourceGroupName", newJString(resourceGroupName))
  add(query_594379, "api-version", newJString(apiVersion))
  add(path_594378, "subscriptionId", newJString(subscriptionId))
  add(path_594378, "configName", newJString(configName))
  result = call_594377.call(path_594378, query_594379, nil, nil, nil)

var migrationConfigsRevert* = Call_MigrationConfigsRevert_594368(
    name: "migrationConfigsRevert", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/migrationConfigurations/{configName}/revert",
    validator: validate_MigrationConfigsRevert_594369, base: "",
    url: url_MigrationConfigsRevert_594370, schemes: {Scheme.Https})
type
  Call_MigrationConfigsCompleteMigration_594380 = ref object of OpenApiRestCall_593437
proc url_MigrationConfigsCompleteMigration_594382(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "configName" in path, "`configName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceBus/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/migrationConfigurations/"),
               (kind: VariableSegment, value: "configName"),
               (kind: ConstantSegment, value: "/upgrade")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MigrationConfigsCompleteMigration_594381(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This operation Completes Migration of entities by pointing the connection strings to Premium namespace and any entities created after the operation will be under Premium Namespace. CompleteMigration operation will fail when entity migration is in-progress.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   configName: JString (required)
  ##             : The configuration name. Should always be "$default".
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_594383 = path.getOrDefault("namespaceName")
  valid_594383 = validateParameter(valid_594383, JString, required = true,
                                 default = nil)
  if valid_594383 != nil:
    section.add "namespaceName", valid_594383
  var valid_594384 = path.getOrDefault("resourceGroupName")
  valid_594384 = validateParameter(valid_594384, JString, required = true,
                                 default = nil)
  if valid_594384 != nil:
    section.add "resourceGroupName", valid_594384
  var valid_594385 = path.getOrDefault("subscriptionId")
  valid_594385 = validateParameter(valid_594385, JString, required = true,
                                 default = nil)
  if valid_594385 != nil:
    section.add "subscriptionId", valid_594385
  var valid_594386 = path.getOrDefault("configName")
  valid_594386 = validateParameter(valid_594386, JString, required = true,
                                 default = newJString("$default"))
  if valid_594386 != nil:
    section.add "configName", valid_594386
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594387 = query.getOrDefault("api-version")
  valid_594387 = validateParameter(valid_594387, JString, required = true,
                                 default = nil)
  if valid_594387 != nil:
    section.add "api-version", valid_594387
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594388: Call_MigrationConfigsCompleteMigration_594380;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## This operation Completes Migration of entities by pointing the connection strings to Premium namespace and any entities created after the operation will be under Premium Namespace. CompleteMigration operation will fail when entity migration is in-progress.
  ## 
  let valid = call_594388.validator(path, query, header, formData, body)
  let scheme = call_594388.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594388.url(scheme.get, call_594388.host, call_594388.base,
                         call_594388.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594388, url, valid)

proc call*(call_594389: Call_MigrationConfigsCompleteMigration_594380;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; configName: string = "$default"): Recallable =
  ## migrationConfigsCompleteMigration
  ## This operation Completes Migration of entities by pointing the connection strings to Premium namespace and any entities created after the operation will be under Premium Namespace. CompleteMigration operation will fail when entity migration is in-progress.
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   configName: string (required)
  ##             : The configuration name. Should always be "$default".
  var path_594390 = newJObject()
  var query_594391 = newJObject()
  add(path_594390, "namespaceName", newJString(namespaceName))
  add(path_594390, "resourceGroupName", newJString(resourceGroupName))
  add(query_594391, "api-version", newJString(apiVersion))
  add(path_594390, "subscriptionId", newJString(subscriptionId))
  add(path_594390, "configName", newJString(configName))
  result = call_594389.call(path_594390, query_594391, nil, nil, nil)

var migrationConfigsCompleteMigration* = Call_MigrationConfigsCompleteMigration_594380(
    name: "migrationConfigsCompleteMigration", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/migrationConfigurations/{configName}/upgrade",
    validator: validate_MigrationConfigsCompleteMigration_594381, base: "",
    url: url_MigrationConfigsCompleteMigration_594382, schemes: {Scheme.Https})
type
  Call_NamespacesListNetworkRuleSets_594392 = ref object of OpenApiRestCall_593437
proc url_NamespacesListNetworkRuleSets_594394(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceBus/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/networkRuleSets")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesListNetworkRuleSets_594393(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets list of NetworkRuleSet for a Namespace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_594395 = path.getOrDefault("namespaceName")
  valid_594395 = validateParameter(valid_594395, JString, required = true,
                                 default = nil)
  if valid_594395 != nil:
    section.add "namespaceName", valid_594395
  var valid_594396 = path.getOrDefault("resourceGroupName")
  valid_594396 = validateParameter(valid_594396, JString, required = true,
                                 default = nil)
  if valid_594396 != nil:
    section.add "resourceGroupName", valid_594396
  var valid_594397 = path.getOrDefault("subscriptionId")
  valid_594397 = validateParameter(valid_594397, JString, required = true,
                                 default = nil)
  if valid_594397 != nil:
    section.add "subscriptionId", valid_594397
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594398 = query.getOrDefault("api-version")
  valid_594398 = validateParameter(valid_594398, JString, required = true,
                                 default = nil)
  if valid_594398 != nil:
    section.add "api-version", valid_594398
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594399: Call_NamespacesListNetworkRuleSets_594392; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets list of NetworkRuleSet for a Namespace.
  ## 
  let valid = call_594399.validator(path, query, header, formData, body)
  let scheme = call_594399.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594399.url(scheme.get, call_594399.host, call_594399.base,
                         call_594399.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594399, url, valid)

proc call*(call_594400: Call_NamespacesListNetworkRuleSets_594392;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## namespacesListNetworkRuleSets
  ## Gets list of NetworkRuleSet for a Namespace.
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594401 = newJObject()
  var query_594402 = newJObject()
  add(path_594401, "namespaceName", newJString(namespaceName))
  add(path_594401, "resourceGroupName", newJString(resourceGroupName))
  add(query_594402, "api-version", newJString(apiVersion))
  add(path_594401, "subscriptionId", newJString(subscriptionId))
  result = call_594400.call(path_594401, query_594402, nil, nil, nil)

var namespacesListNetworkRuleSets* = Call_NamespacesListNetworkRuleSets_594392(
    name: "namespacesListNetworkRuleSets", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/networkRuleSets",
    validator: validate_NamespacesListNetworkRuleSets_594393, base: "",
    url: url_NamespacesListNetworkRuleSets_594394, schemes: {Scheme.Https})
type
  Call_NamespacesCreateOrUpdateNetworkRuleSet_594414 = ref object of OpenApiRestCall_593437
proc url_NamespacesCreateOrUpdateNetworkRuleSet_594416(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceBus/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/networkRuleSets/default")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesCreateOrUpdateNetworkRuleSet_594415(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update NetworkRuleSet for a Namespace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_594417 = path.getOrDefault("namespaceName")
  valid_594417 = validateParameter(valid_594417, JString, required = true,
                                 default = nil)
  if valid_594417 != nil:
    section.add "namespaceName", valid_594417
  var valid_594418 = path.getOrDefault("resourceGroupName")
  valid_594418 = validateParameter(valid_594418, JString, required = true,
                                 default = nil)
  if valid_594418 != nil:
    section.add "resourceGroupName", valid_594418
  var valid_594419 = path.getOrDefault("subscriptionId")
  valid_594419 = validateParameter(valid_594419, JString, required = true,
                                 default = nil)
  if valid_594419 != nil:
    section.add "subscriptionId", valid_594419
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594420 = query.getOrDefault("api-version")
  valid_594420 = validateParameter(valid_594420, JString, required = true,
                                 default = nil)
  if valid_594420 != nil:
    section.add "api-version", valid_594420
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The Namespace IpFilterRule.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594422: Call_NamespacesCreateOrUpdateNetworkRuleSet_594414;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update NetworkRuleSet for a Namespace.
  ## 
  let valid = call_594422.validator(path, query, header, formData, body)
  let scheme = call_594422.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594422.url(scheme.get, call_594422.host, call_594422.base,
                         call_594422.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594422, url, valid)

proc call*(call_594423: Call_NamespacesCreateOrUpdateNetworkRuleSet_594414;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; parameters: JsonNode): Recallable =
  ## namespacesCreateOrUpdateNetworkRuleSet
  ## Create or update NetworkRuleSet for a Namespace.
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : The Namespace IpFilterRule.
  var path_594424 = newJObject()
  var query_594425 = newJObject()
  var body_594426 = newJObject()
  add(path_594424, "namespaceName", newJString(namespaceName))
  add(path_594424, "resourceGroupName", newJString(resourceGroupName))
  add(query_594425, "api-version", newJString(apiVersion))
  add(path_594424, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594426 = parameters
  result = call_594423.call(path_594424, query_594425, nil, nil, body_594426)

var namespacesCreateOrUpdateNetworkRuleSet* = Call_NamespacesCreateOrUpdateNetworkRuleSet_594414(
    name: "namespacesCreateOrUpdateNetworkRuleSet", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/networkRuleSets/default",
    validator: validate_NamespacesCreateOrUpdateNetworkRuleSet_594415, base: "",
    url: url_NamespacesCreateOrUpdateNetworkRuleSet_594416,
    schemes: {Scheme.Https})
type
  Call_NamespacesGetNetworkRuleSet_594403 = ref object of OpenApiRestCall_593437
proc url_NamespacesGetNetworkRuleSet_594405(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceBus/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/networkRuleSets/default")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesGetNetworkRuleSet_594404(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets NetworkRuleSet for a Namespace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_594406 = path.getOrDefault("namespaceName")
  valid_594406 = validateParameter(valid_594406, JString, required = true,
                                 default = nil)
  if valid_594406 != nil:
    section.add "namespaceName", valid_594406
  var valid_594407 = path.getOrDefault("resourceGroupName")
  valid_594407 = validateParameter(valid_594407, JString, required = true,
                                 default = nil)
  if valid_594407 != nil:
    section.add "resourceGroupName", valid_594407
  var valid_594408 = path.getOrDefault("subscriptionId")
  valid_594408 = validateParameter(valid_594408, JString, required = true,
                                 default = nil)
  if valid_594408 != nil:
    section.add "subscriptionId", valid_594408
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594409 = query.getOrDefault("api-version")
  valid_594409 = validateParameter(valid_594409, JString, required = true,
                                 default = nil)
  if valid_594409 != nil:
    section.add "api-version", valid_594409
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594410: Call_NamespacesGetNetworkRuleSet_594403; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets NetworkRuleSet for a Namespace.
  ## 
  let valid = call_594410.validator(path, query, header, formData, body)
  let scheme = call_594410.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594410.url(scheme.get, call_594410.host, call_594410.base,
                         call_594410.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594410, url, valid)

proc call*(call_594411: Call_NamespacesGetNetworkRuleSet_594403;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## namespacesGetNetworkRuleSet
  ## Gets NetworkRuleSet for a Namespace.
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594412 = newJObject()
  var query_594413 = newJObject()
  add(path_594412, "namespaceName", newJString(namespaceName))
  add(path_594412, "resourceGroupName", newJString(resourceGroupName))
  add(query_594413, "api-version", newJString(apiVersion))
  add(path_594412, "subscriptionId", newJString(subscriptionId))
  result = call_594411.call(path_594412, query_594413, nil, nil, nil)

var namespacesGetNetworkRuleSet* = Call_NamespacesGetNetworkRuleSet_594403(
    name: "namespacesGetNetworkRuleSet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/networkRuleSets/default",
    validator: validate_NamespacesGetNetworkRuleSet_594404, base: "",
    url: url_NamespacesGetNetworkRuleSet_594405, schemes: {Scheme.Https})
type
  Call_QueuesListByNamespace_594427 = ref object of OpenApiRestCall_593437
proc url_QueuesListByNamespace_594429(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceBus/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/queues")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_QueuesListByNamespace_594428(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the queues within a namespace.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639415.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_594431 = path.getOrDefault("namespaceName")
  valid_594431 = validateParameter(valid_594431, JString, required = true,
                                 default = nil)
  if valid_594431 != nil:
    section.add "namespaceName", valid_594431
  var valid_594432 = path.getOrDefault("resourceGroupName")
  valid_594432 = validateParameter(valid_594432, JString, required = true,
                                 default = nil)
  if valid_594432 != nil:
    section.add "resourceGroupName", valid_594432
  var valid_594433 = path.getOrDefault("subscriptionId")
  valid_594433 = validateParameter(valid_594433, JString, required = true,
                                 default = nil)
  if valid_594433 != nil:
    section.add "subscriptionId", valid_594433
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##       : May be used to limit the number of results to the most recent N usageDetails.
  ##   $skip: JInt
  ##        : Skip is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skip parameter that specifies a starting point to use for subsequent calls.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594434 = query.getOrDefault("api-version")
  valid_594434 = validateParameter(valid_594434, JString, required = true,
                                 default = nil)
  if valid_594434 != nil:
    section.add "api-version", valid_594434
  var valid_594435 = query.getOrDefault("$top")
  valid_594435 = validateParameter(valid_594435, JInt, required = false, default = nil)
  if valid_594435 != nil:
    section.add "$top", valid_594435
  var valid_594436 = query.getOrDefault("$skip")
  valid_594436 = validateParameter(valid_594436, JInt, required = false, default = nil)
  if valid_594436 != nil:
    section.add "$skip", valid_594436
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594437: Call_QueuesListByNamespace_594427; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the queues within a namespace.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639415.aspx
  let valid = call_594437.validator(path, query, header, formData, body)
  let scheme = call_594437.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594437.url(scheme.get, call_594437.host, call_594437.base,
                         call_594437.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594437, url, valid)

proc call*(call_594438: Call_QueuesListByNamespace_594427; namespaceName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          Top: int = 0; Skip: int = 0): Recallable =
  ## queuesListByNamespace
  ## Gets the queues within a namespace.
  ## https://msdn.microsoft.com/en-us/library/azure/mt639415.aspx
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : May be used to limit the number of results to the most recent N usageDetails.
  ##   Skip: int
  ##       : Skip is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skip parameter that specifies a starting point to use for subsequent calls.
  var path_594439 = newJObject()
  var query_594440 = newJObject()
  add(path_594439, "namespaceName", newJString(namespaceName))
  add(path_594439, "resourceGroupName", newJString(resourceGroupName))
  add(query_594440, "api-version", newJString(apiVersion))
  add(path_594439, "subscriptionId", newJString(subscriptionId))
  add(query_594440, "$top", newJInt(Top))
  add(query_594440, "$skip", newJInt(Skip))
  result = call_594438.call(path_594439, query_594440, nil, nil, nil)

var queuesListByNamespace* = Call_QueuesListByNamespace_594427(
    name: "queuesListByNamespace", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/queues",
    validator: validate_QueuesListByNamespace_594428, base: "",
    url: url_QueuesListByNamespace_594429, schemes: {Scheme.Https})
type
  Call_QueuesCreateOrUpdate_594453 = ref object of OpenApiRestCall_593437
proc url_QueuesCreateOrUpdate_594455(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "queueName" in path, "`queueName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceBus/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/queues/"),
               (kind: VariableSegment, value: "queueName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_QueuesCreateOrUpdate_594454(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a Service Bus queue. This operation is idempotent.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639395.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   queueName: JString (required)
  ##            : The queue name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_594456 = path.getOrDefault("namespaceName")
  valid_594456 = validateParameter(valid_594456, JString, required = true,
                                 default = nil)
  if valid_594456 != nil:
    section.add "namespaceName", valid_594456
  var valid_594457 = path.getOrDefault("resourceGroupName")
  valid_594457 = validateParameter(valid_594457, JString, required = true,
                                 default = nil)
  if valid_594457 != nil:
    section.add "resourceGroupName", valid_594457
  var valid_594458 = path.getOrDefault("subscriptionId")
  valid_594458 = validateParameter(valid_594458, JString, required = true,
                                 default = nil)
  if valid_594458 != nil:
    section.add "subscriptionId", valid_594458
  var valid_594459 = path.getOrDefault("queueName")
  valid_594459 = validateParameter(valid_594459, JString, required = true,
                                 default = nil)
  if valid_594459 != nil:
    section.add "queueName", valid_594459
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594460 = query.getOrDefault("api-version")
  valid_594460 = validateParameter(valid_594460, JString, required = true,
                                 default = nil)
  if valid_594460 != nil:
    section.add "api-version", valid_594460
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to create or update a queue resource.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594462: Call_QueuesCreateOrUpdate_594453; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a Service Bus queue. This operation is idempotent.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639395.aspx
  let valid = call_594462.validator(path, query, header, formData, body)
  let scheme = call_594462.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594462.url(scheme.get, call_594462.host, call_594462.base,
                         call_594462.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594462, url, valid)

proc call*(call_594463: Call_QueuesCreateOrUpdate_594453; namespaceName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode; queueName: string): Recallable =
  ## queuesCreateOrUpdate
  ## Creates or updates a Service Bus queue. This operation is idempotent.
  ## https://msdn.microsoft.com/en-us/library/azure/mt639395.aspx
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to create or update a queue resource.
  ##   queueName: string (required)
  ##            : The queue name.
  var path_594464 = newJObject()
  var query_594465 = newJObject()
  var body_594466 = newJObject()
  add(path_594464, "namespaceName", newJString(namespaceName))
  add(path_594464, "resourceGroupName", newJString(resourceGroupName))
  add(query_594465, "api-version", newJString(apiVersion))
  add(path_594464, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594466 = parameters
  add(path_594464, "queueName", newJString(queueName))
  result = call_594463.call(path_594464, query_594465, nil, nil, body_594466)

var queuesCreateOrUpdate* = Call_QueuesCreateOrUpdate_594453(
    name: "queuesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/queues/{queueName}",
    validator: validate_QueuesCreateOrUpdate_594454, base: "",
    url: url_QueuesCreateOrUpdate_594455, schemes: {Scheme.Https})
type
  Call_QueuesGet_594441 = ref object of OpenApiRestCall_593437
proc url_QueuesGet_594443(protocol: Scheme; host: string; base: string; route: string;
                         path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "queueName" in path, "`queueName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceBus/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/queues/"),
               (kind: VariableSegment, value: "queueName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_QueuesGet_594442(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a description for the specified queue.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639380.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   queueName: JString (required)
  ##            : The queue name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_594444 = path.getOrDefault("namespaceName")
  valid_594444 = validateParameter(valid_594444, JString, required = true,
                                 default = nil)
  if valid_594444 != nil:
    section.add "namespaceName", valid_594444
  var valid_594445 = path.getOrDefault("resourceGroupName")
  valid_594445 = validateParameter(valid_594445, JString, required = true,
                                 default = nil)
  if valid_594445 != nil:
    section.add "resourceGroupName", valid_594445
  var valid_594446 = path.getOrDefault("subscriptionId")
  valid_594446 = validateParameter(valid_594446, JString, required = true,
                                 default = nil)
  if valid_594446 != nil:
    section.add "subscriptionId", valid_594446
  var valid_594447 = path.getOrDefault("queueName")
  valid_594447 = validateParameter(valid_594447, JString, required = true,
                                 default = nil)
  if valid_594447 != nil:
    section.add "queueName", valid_594447
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594448 = query.getOrDefault("api-version")
  valid_594448 = validateParameter(valid_594448, JString, required = true,
                                 default = nil)
  if valid_594448 != nil:
    section.add "api-version", valid_594448
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594449: Call_QueuesGet_594441; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a description for the specified queue.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639380.aspx
  let valid = call_594449.validator(path, query, header, formData, body)
  let scheme = call_594449.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594449.url(scheme.get, call_594449.host, call_594449.base,
                         call_594449.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594449, url, valid)

proc call*(call_594450: Call_QueuesGet_594441; namespaceName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          queueName: string): Recallable =
  ## queuesGet
  ## Returns a description for the specified queue.
  ## https://msdn.microsoft.com/en-us/library/azure/mt639380.aspx
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   queueName: string (required)
  ##            : The queue name.
  var path_594451 = newJObject()
  var query_594452 = newJObject()
  add(path_594451, "namespaceName", newJString(namespaceName))
  add(path_594451, "resourceGroupName", newJString(resourceGroupName))
  add(query_594452, "api-version", newJString(apiVersion))
  add(path_594451, "subscriptionId", newJString(subscriptionId))
  add(path_594451, "queueName", newJString(queueName))
  result = call_594450.call(path_594451, query_594452, nil, nil, nil)

var queuesGet* = Call_QueuesGet_594441(name: "queuesGet", meth: HttpMethod.HttpGet,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/queues/{queueName}",
                                    validator: validate_QueuesGet_594442,
                                    base: "", url: url_QueuesGet_594443,
                                    schemes: {Scheme.Https})
type
  Call_QueuesDelete_594467 = ref object of OpenApiRestCall_593437
proc url_QueuesDelete_594469(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "queueName" in path, "`queueName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceBus/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/queues/"),
               (kind: VariableSegment, value: "queueName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_QueuesDelete_594468(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a queue from the specified namespace in a resource group.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639411.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   queueName: JString (required)
  ##            : The queue name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_594470 = path.getOrDefault("namespaceName")
  valid_594470 = validateParameter(valid_594470, JString, required = true,
                                 default = nil)
  if valid_594470 != nil:
    section.add "namespaceName", valid_594470
  var valid_594471 = path.getOrDefault("resourceGroupName")
  valid_594471 = validateParameter(valid_594471, JString, required = true,
                                 default = nil)
  if valid_594471 != nil:
    section.add "resourceGroupName", valid_594471
  var valid_594472 = path.getOrDefault("subscriptionId")
  valid_594472 = validateParameter(valid_594472, JString, required = true,
                                 default = nil)
  if valid_594472 != nil:
    section.add "subscriptionId", valid_594472
  var valid_594473 = path.getOrDefault("queueName")
  valid_594473 = validateParameter(valid_594473, JString, required = true,
                                 default = nil)
  if valid_594473 != nil:
    section.add "queueName", valid_594473
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594474 = query.getOrDefault("api-version")
  valid_594474 = validateParameter(valid_594474, JString, required = true,
                                 default = nil)
  if valid_594474 != nil:
    section.add "api-version", valid_594474
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594475: Call_QueuesDelete_594467; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a queue from the specified namespace in a resource group.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639411.aspx
  let valid = call_594475.validator(path, query, header, formData, body)
  let scheme = call_594475.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594475.url(scheme.get, call_594475.host, call_594475.base,
                         call_594475.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594475, url, valid)

proc call*(call_594476: Call_QueuesDelete_594467; namespaceName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          queueName: string): Recallable =
  ## queuesDelete
  ## Deletes a queue from the specified namespace in a resource group.
  ## https://msdn.microsoft.com/en-us/library/azure/mt639411.aspx
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   queueName: string (required)
  ##            : The queue name.
  var path_594477 = newJObject()
  var query_594478 = newJObject()
  add(path_594477, "namespaceName", newJString(namespaceName))
  add(path_594477, "resourceGroupName", newJString(resourceGroupName))
  add(query_594478, "api-version", newJString(apiVersion))
  add(path_594477, "subscriptionId", newJString(subscriptionId))
  add(path_594477, "queueName", newJString(queueName))
  result = call_594476.call(path_594477, query_594478, nil, nil, nil)

var queuesDelete* = Call_QueuesDelete_594467(name: "queuesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/queues/{queueName}",
    validator: validate_QueuesDelete_594468, base: "", url: url_QueuesDelete_594469,
    schemes: {Scheme.Https})
type
  Call_QueuesListAuthorizationRules_594479 = ref object of OpenApiRestCall_593437
proc url_QueuesListAuthorizationRules_594481(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "queueName" in path, "`queueName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceBus/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/queues/"),
               (kind: VariableSegment, value: "queueName"),
               (kind: ConstantSegment, value: "/authorizationRules")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_QueuesListAuthorizationRules_594480(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all authorization rules for a queue.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt705607.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   queueName: JString (required)
  ##            : The queue name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_594482 = path.getOrDefault("namespaceName")
  valid_594482 = validateParameter(valid_594482, JString, required = true,
                                 default = nil)
  if valid_594482 != nil:
    section.add "namespaceName", valid_594482
  var valid_594483 = path.getOrDefault("resourceGroupName")
  valid_594483 = validateParameter(valid_594483, JString, required = true,
                                 default = nil)
  if valid_594483 != nil:
    section.add "resourceGroupName", valid_594483
  var valid_594484 = path.getOrDefault("subscriptionId")
  valid_594484 = validateParameter(valid_594484, JString, required = true,
                                 default = nil)
  if valid_594484 != nil:
    section.add "subscriptionId", valid_594484
  var valid_594485 = path.getOrDefault("queueName")
  valid_594485 = validateParameter(valid_594485, JString, required = true,
                                 default = nil)
  if valid_594485 != nil:
    section.add "queueName", valid_594485
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594486 = query.getOrDefault("api-version")
  valid_594486 = validateParameter(valid_594486, JString, required = true,
                                 default = nil)
  if valid_594486 != nil:
    section.add "api-version", valid_594486
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594487: Call_QueuesListAuthorizationRules_594479; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all authorization rules for a queue.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt705607.aspx
  let valid = call_594487.validator(path, query, header, formData, body)
  let scheme = call_594487.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594487.url(scheme.get, call_594487.host, call_594487.base,
                         call_594487.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594487, url, valid)

proc call*(call_594488: Call_QueuesListAuthorizationRules_594479;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; queueName: string): Recallable =
  ## queuesListAuthorizationRules
  ## Gets all authorization rules for a queue.
  ## https://msdn.microsoft.com/en-us/library/azure/mt705607.aspx
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   queueName: string (required)
  ##            : The queue name.
  var path_594489 = newJObject()
  var query_594490 = newJObject()
  add(path_594489, "namespaceName", newJString(namespaceName))
  add(path_594489, "resourceGroupName", newJString(resourceGroupName))
  add(query_594490, "api-version", newJString(apiVersion))
  add(path_594489, "subscriptionId", newJString(subscriptionId))
  add(path_594489, "queueName", newJString(queueName))
  result = call_594488.call(path_594489, query_594490, nil, nil, nil)

var queuesListAuthorizationRules* = Call_QueuesListAuthorizationRules_594479(
    name: "queuesListAuthorizationRules", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/queues/{queueName}/authorizationRules",
    validator: validate_QueuesListAuthorizationRules_594480, base: "",
    url: url_QueuesListAuthorizationRules_594481, schemes: {Scheme.Https})
type
  Call_QueuesCreateOrUpdateAuthorizationRule_594504 = ref object of OpenApiRestCall_593437
proc url_QueuesCreateOrUpdateAuthorizationRule_594506(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "queueName" in path, "`queueName` is a required path parameter"
  assert "authorizationRuleName" in path,
        "`authorizationRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceBus/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/queues/"),
               (kind: VariableSegment, value: "queueName"),
               (kind: ConstantSegment, value: "/authorizationRules/"),
               (kind: VariableSegment, value: "authorizationRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_QueuesCreateOrUpdateAuthorizationRule_594505(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates an authorization rule for a queue.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   authorizationRuleName: JString (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   queueName: JString (required)
  ##            : The queue name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_594507 = path.getOrDefault("namespaceName")
  valid_594507 = validateParameter(valid_594507, JString, required = true,
                                 default = nil)
  if valid_594507 != nil:
    section.add "namespaceName", valid_594507
  var valid_594508 = path.getOrDefault("resourceGroupName")
  valid_594508 = validateParameter(valid_594508, JString, required = true,
                                 default = nil)
  if valid_594508 != nil:
    section.add "resourceGroupName", valid_594508
  var valid_594509 = path.getOrDefault("authorizationRuleName")
  valid_594509 = validateParameter(valid_594509, JString, required = true,
                                 default = nil)
  if valid_594509 != nil:
    section.add "authorizationRuleName", valid_594509
  var valid_594510 = path.getOrDefault("subscriptionId")
  valid_594510 = validateParameter(valid_594510, JString, required = true,
                                 default = nil)
  if valid_594510 != nil:
    section.add "subscriptionId", valid_594510
  var valid_594511 = path.getOrDefault("queueName")
  valid_594511 = validateParameter(valid_594511, JString, required = true,
                                 default = nil)
  if valid_594511 != nil:
    section.add "queueName", valid_594511
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594512 = query.getOrDefault("api-version")
  valid_594512 = validateParameter(valid_594512, JString, required = true,
                                 default = nil)
  if valid_594512 != nil:
    section.add "api-version", valid_594512
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The shared access authorization rule.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594514: Call_QueuesCreateOrUpdateAuthorizationRule_594504;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates an authorization rule for a queue.
  ## 
  let valid = call_594514.validator(path, query, header, formData, body)
  let scheme = call_594514.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594514.url(scheme.get, call_594514.host, call_594514.base,
                         call_594514.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594514, url, valid)

proc call*(call_594515: Call_QueuesCreateOrUpdateAuthorizationRule_594504;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          authorizationRuleName: string; subscriptionId: string;
          parameters: JsonNode; queueName: string): Recallable =
  ## queuesCreateOrUpdateAuthorizationRule
  ## Creates an authorization rule for a queue.
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   authorizationRuleName: string (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : The shared access authorization rule.
  ##   queueName: string (required)
  ##            : The queue name.
  var path_594516 = newJObject()
  var query_594517 = newJObject()
  var body_594518 = newJObject()
  add(path_594516, "namespaceName", newJString(namespaceName))
  add(path_594516, "resourceGroupName", newJString(resourceGroupName))
  add(query_594517, "api-version", newJString(apiVersion))
  add(path_594516, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_594516, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594518 = parameters
  add(path_594516, "queueName", newJString(queueName))
  result = call_594515.call(path_594516, query_594517, nil, nil, body_594518)

var queuesCreateOrUpdateAuthorizationRule* = Call_QueuesCreateOrUpdateAuthorizationRule_594504(
    name: "queuesCreateOrUpdateAuthorizationRule", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/queues/{queueName}/authorizationRules/{authorizationRuleName}",
    validator: validate_QueuesCreateOrUpdateAuthorizationRule_594505, base: "",
    url: url_QueuesCreateOrUpdateAuthorizationRule_594506, schemes: {Scheme.Https})
type
  Call_QueuesGetAuthorizationRule_594491 = ref object of OpenApiRestCall_593437
proc url_QueuesGetAuthorizationRule_594493(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "queueName" in path, "`queueName` is a required path parameter"
  assert "authorizationRuleName" in path,
        "`authorizationRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceBus/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/queues/"),
               (kind: VariableSegment, value: "queueName"),
               (kind: ConstantSegment, value: "/authorizationRules/"),
               (kind: VariableSegment, value: "authorizationRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_QueuesGetAuthorizationRule_594492(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets an authorization rule for a queue by rule name.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt705611.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   authorizationRuleName: JString (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   queueName: JString (required)
  ##            : The queue name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_594494 = path.getOrDefault("namespaceName")
  valid_594494 = validateParameter(valid_594494, JString, required = true,
                                 default = nil)
  if valid_594494 != nil:
    section.add "namespaceName", valid_594494
  var valid_594495 = path.getOrDefault("resourceGroupName")
  valid_594495 = validateParameter(valid_594495, JString, required = true,
                                 default = nil)
  if valid_594495 != nil:
    section.add "resourceGroupName", valid_594495
  var valid_594496 = path.getOrDefault("authorizationRuleName")
  valid_594496 = validateParameter(valid_594496, JString, required = true,
                                 default = nil)
  if valid_594496 != nil:
    section.add "authorizationRuleName", valid_594496
  var valid_594497 = path.getOrDefault("subscriptionId")
  valid_594497 = validateParameter(valid_594497, JString, required = true,
                                 default = nil)
  if valid_594497 != nil:
    section.add "subscriptionId", valid_594497
  var valid_594498 = path.getOrDefault("queueName")
  valid_594498 = validateParameter(valid_594498, JString, required = true,
                                 default = nil)
  if valid_594498 != nil:
    section.add "queueName", valid_594498
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594499 = query.getOrDefault("api-version")
  valid_594499 = validateParameter(valid_594499, JString, required = true,
                                 default = nil)
  if valid_594499 != nil:
    section.add "api-version", valid_594499
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594500: Call_QueuesGetAuthorizationRule_594491; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an authorization rule for a queue by rule name.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt705611.aspx
  let valid = call_594500.validator(path, query, header, formData, body)
  let scheme = call_594500.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594500.url(scheme.get, call_594500.host, call_594500.base,
                         call_594500.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594500, url, valid)

proc call*(call_594501: Call_QueuesGetAuthorizationRule_594491;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          authorizationRuleName: string; subscriptionId: string; queueName: string): Recallable =
  ## queuesGetAuthorizationRule
  ## Gets an authorization rule for a queue by rule name.
  ## https://msdn.microsoft.com/en-us/library/azure/mt705611.aspx
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   authorizationRuleName: string (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   queueName: string (required)
  ##            : The queue name.
  var path_594502 = newJObject()
  var query_594503 = newJObject()
  add(path_594502, "namespaceName", newJString(namespaceName))
  add(path_594502, "resourceGroupName", newJString(resourceGroupName))
  add(query_594503, "api-version", newJString(apiVersion))
  add(path_594502, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_594502, "subscriptionId", newJString(subscriptionId))
  add(path_594502, "queueName", newJString(queueName))
  result = call_594501.call(path_594502, query_594503, nil, nil, nil)

var queuesGetAuthorizationRule* = Call_QueuesGetAuthorizationRule_594491(
    name: "queuesGetAuthorizationRule", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/queues/{queueName}/authorizationRules/{authorizationRuleName}",
    validator: validate_QueuesGetAuthorizationRule_594492, base: "",
    url: url_QueuesGetAuthorizationRule_594493, schemes: {Scheme.Https})
type
  Call_QueuesDeleteAuthorizationRule_594519 = ref object of OpenApiRestCall_593437
proc url_QueuesDeleteAuthorizationRule_594521(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "queueName" in path, "`queueName` is a required path parameter"
  assert "authorizationRuleName" in path,
        "`authorizationRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceBus/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/queues/"),
               (kind: VariableSegment, value: "queueName"),
               (kind: ConstantSegment, value: "/authorizationRules/"),
               (kind: VariableSegment, value: "authorizationRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_QueuesDeleteAuthorizationRule_594520(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a queue authorization rule.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt705609.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   authorizationRuleName: JString (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   queueName: JString (required)
  ##            : The queue name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_594522 = path.getOrDefault("namespaceName")
  valid_594522 = validateParameter(valid_594522, JString, required = true,
                                 default = nil)
  if valid_594522 != nil:
    section.add "namespaceName", valid_594522
  var valid_594523 = path.getOrDefault("resourceGroupName")
  valid_594523 = validateParameter(valid_594523, JString, required = true,
                                 default = nil)
  if valid_594523 != nil:
    section.add "resourceGroupName", valid_594523
  var valid_594524 = path.getOrDefault("authorizationRuleName")
  valid_594524 = validateParameter(valid_594524, JString, required = true,
                                 default = nil)
  if valid_594524 != nil:
    section.add "authorizationRuleName", valid_594524
  var valid_594525 = path.getOrDefault("subscriptionId")
  valid_594525 = validateParameter(valid_594525, JString, required = true,
                                 default = nil)
  if valid_594525 != nil:
    section.add "subscriptionId", valid_594525
  var valid_594526 = path.getOrDefault("queueName")
  valid_594526 = validateParameter(valid_594526, JString, required = true,
                                 default = nil)
  if valid_594526 != nil:
    section.add "queueName", valid_594526
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594527 = query.getOrDefault("api-version")
  valid_594527 = validateParameter(valid_594527, JString, required = true,
                                 default = nil)
  if valid_594527 != nil:
    section.add "api-version", valid_594527
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594528: Call_QueuesDeleteAuthorizationRule_594519; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a queue authorization rule.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt705609.aspx
  let valid = call_594528.validator(path, query, header, formData, body)
  let scheme = call_594528.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594528.url(scheme.get, call_594528.host, call_594528.base,
                         call_594528.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594528, url, valid)

proc call*(call_594529: Call_QueuesDeleteAuthorizationRule_594519;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          authorizationRuleName: string; subscriptionId: string; queueName: string): Recallable =
  ## queuesDeleteAuthorizationRule
  ## Deletes a queue authorization rule.
  ## https://msdn.microsoft.com/en-us/library/azure/mt705609.aspx
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   authorizationRuleName: string (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   queueName: string (required)
  ##            : The queue name.
  var path_594530 = newJObject()
  var query_594531 = newJObject()
  add(path_594530, "namespaceName", newJString(namespaceName))
  add(path_594530, "resourceGroupName", newJString(resourceGroupName))
  add(query_594531, "api-version", newJString(apiVersion))
  add(path_594530, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_594530, "subscriptionId", newJString(subscriptionId))
  add(path_594530, "queueName", newJString(queueName))
  result = call_594529.call(path_594530, query_594531, nil, nil, nil)

var queuesDeleteAuthorizationRule* = Call_QueuesDeleteAuthorizationRule_594519(
    name: "queuesDeleteAuthorizationRule", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/queues/{queueName}/authorizationRules/{authorizationRuleName}",
    validator: validate_QueuesDeleteAuthorizationRule_594520, base: "",
    url: url_QueuesDeleteAuthorizationRule_594521, schemes: {Scheme.Https})
type
  Call_QueuesListKeys_594532 = ref object of OpenApiRestCall_593437
proc url_QueuesListKeys_594534(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "queueName" in path, "`queueName` is a required path parameter"
  assert "authorizationRuleName" in path,
        "`authorizationRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceBus/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/queues/"),
               (kind: VariableSegment, value: "queueName"),
               (kind: ConstantSegment, value: "/authorizationRules/"),
               (kind: VariableSegment, value: "authorizationRuleName"),
               (kind: ConstantSegment, value: "/ListKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_QueuesListKeys_594533(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Primary and secondary connection strings to the queue.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt705608.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   authorizationRuleName: JString (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   queueName: JString (required)
  ##            : The queue name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_594535 = path.getOrDefault("namespaceName")
  valid_594535 = validateParameter(valid_594535, JString, required = true,
                                 default = nil)
  if valid_594535 != nil:
    section.add "namespaceName", valid_594535
  var valid_594536 = path.getOrDefault("resourceGroupName")
  valid_594536 = validateParameter(valid_594536, JString, required = true,
                                 default = nil)
  if valid_594536 != nil:
    section.add "resourceGroupName", valid_594536
  var valid_594537 = path.getOrDefault("authorizationRuleName")
  valid_594537 = validateParameter(valid_594537, JString, required = true,
                                 default = nil)
  if valid_594537 != nil:
    section.add "authorizationRuleName", valid_594537
  var valid_594538 = path.getOrDefault("subscriptionId")
  valid_594538 = validateParameter(valid_594538, JString, required = true,
                                 default = nil)
  if valid_594538 != nil:
    section.add "subscriptionId", valid_594538
  var valid_594539 = path.getOrDefault("queueName")
  valid_594539 = validateParameter(valid_594539, JString, required = true,
                                 default = nil)
  if valid_594539 != nil:
    section.add "queueName", valid_594539
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594540 = query.getOrDefault("api-version")
  valid_594540 = validateParameter(valid_594540, JString, required = true,
                                 default = nil)
  if valid_594540 != nil:
    section.add "api-version", valid_594540
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594541: Call_QueuesListKeys_594532; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Primary and secondary connection strings to the queue.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt705608.aspx
  let valid = call_594541.validator(path, query, header, formData, body)
  let scheme = call_594541.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594541.url(scheme.get, call_594541.host, call_594541.base,
                         call_594541.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594541, url, valid)

proc call*(call_594542: Call_QueuesListKeys_594532; namespaceName: string;
          resourceGroupName: string; apiVersion: string;
          authorizationRuleName: string; subscriptionId: string; queueName: string): Recallable =
  ## queuesListKeys
  ## Primary and secondary connection strings to the queue.
  ## https://msdn.microsoft.com/en-us/library/azure/mt705608.aspx
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   authorizationRuleName: string (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   queueName: string (required)
  ##            : The queue name.
  var path_594543 = newJObject()
  var query_594544 = newJObject()
  add(path_594543, "namespaceName", newJString(namespaceName))
  add(path_594543, "resourceGroupName", newJString(resourceGroupName))
  add(query_594544, "api-version", newJString(apiVersion))
  add(path_594543, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_594543, "subscriptionId", newJString(subscriptionId))
  add(path_594543, "queueName", newJString(queueName))
  result = call_594542.call(path_594543, query_594544, nil, nil, nil)

var queuesListKeys* = Call_QueuesListKeys_594532(name: "queuesListKeys",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/queues/{queueName}/authorizationRules/{authorizationRuleName}/ListKeys",
    validator: validate_QueuesListKeys_594533, base: "", url: url_QueuesListKeys_594534,
    schemes: {Scheme.Https})
type
  Call_QueuesRegenerateKeys_594545 = ref object of OpenApiRestCall_593437
proc url_QueuesRegenerateKeys_594547(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "queueName" in path, "`queueName` is a required path parameter"
  assert "authorizationRuleName" in path,
        "`authorizationRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceBus/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/queues/"),
               (kind: VariableSegment, value: "queueName"),
               (kind: ConstantSegment, value: "/authorizationRules/"),
               (kind: VariableSegment, value: "authorizationRuleName"),
               (kind: ConstantSegment, value: "/regenerateKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_QueuesRegenerateKeys_594546(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Regenerates the primary or secondary connection strings to the queue.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt705606.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   authorizationRuleName: JString (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   queueName: JString (required)
  ##            : The queue name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_594548 = path.getOrDefault("namespaceName")
  valid_594548 = validateParameter(valid_594548, JString, required = true,
                                 default = nil)
  if valid_594548 != nil:
    section.add "namespaceName", valid_594548
  var valid_594549 = path.getOrDefault("resourceGroupName")
  valid_594549 = validateParameter(valid_594549, JString, required = true,
                                 default = nil)
  if valid_594549 != nil:
    section.add "resourceGroupName", valid_594549
  var valid_594550 = path.getOrDefault("authorizationRuleName")
  valid_594550 = validateParameter(valid_594550, JString, required = true,
                                 default = nil)
  if valid_594550 != nil:
    section.add "authorizationRuleName", valid_594550
  var valid_594551 = path.getOrDefault("subscriptionId")
  valid_594551 = validateParameter(valid_594551, JString, required = true,
                                 default = nil)
  if valid_594551 != nil:
    section.add "subscriptionId", valid_594551
  var valid_594552 = path.getOrDefault("queueName")
  valid_594552 = validateParameter(valid_594552, JString, required = true,
                                 default = nil)
  if valid_594552 != nil:
    section.add "queueName", valid_594552
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594553 = query.getOrDefault("api-version")
  valid_594553 = validateParameter(valid_594553, JString, required = true,
                                 default = nil)
  if valid_594553 != nil:
    section.add "api-version", valid_594553
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to regenerate the authorization rule.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594555: Call_QueuesRegenerateKeys_594545; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Regenerates the primary or secondary connection strings to the queue.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt705606.aspx
  let valid = call_594555.validator(path, query, header, formData, body)
  let scheme = call_594555.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594555.url(scheme.get, call_594555.host, call_594555.base,
                         call_594555.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594555, url, valid)

proc call*(call_594556: Call_QueuesRegenerateKeys_594545; namespaceName: string;
          resourceGroupName: string; apiVersion: string;
          authorizationRuleName: string; subscriptionId: string;
          parameters: JsonNode; queueName: string): Recallable =
  ## queuesRegenerateKeys
  ## Regenerates the primary or secondary connection strings to the queue.
  ## https://msdn.microsoft.com/en-us/library/azure/mt705606.aspx
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   authorizationRuleName: string (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to regenerate the authorization rule.
  ##   queueName: string (required)
  ##            : The queue name.
  var path_594557 = newJObject()
  var query_594558 = newJObject()
  var body_594559 = newJObject()
  add(path_594557, "namespaceName", newJString(namespaceName))
  add(path_594557, "resourceGroupName", newJString(resourceGroupName))
  add(query_594558, "api-version", newJString(apiVersion))
  add(path_594557, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_594557, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594559 = parameters
  add(path_594557, "queueName", newJString(queueName))
  result = call_594556.call(path_594557, query_594558, nil, nil, body_594559)

var queuesRegenerateKeys* = Call_QueuesRegenerateKeys_594545(
    name: "queuesRegenerateKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/queues/{queueName}/authorizationRules/{authorizationRuleName}/regenerateKeys",
    validator: validate_QueuesRegenerateKeys_594546, base: "",
    url: url_QueuesRegenerateKeys_594547, schemes: {Scheme.Https})
type
  Call_TopicsListByNamespace_594560 = ref object of OpenApiRestCall_593437
proc url_TopicsListByNamespace_594562(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceBus/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/topics")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TopicsListByNamespace_594561(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the topics in a namespace.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639388.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_594563 = path.getOrDefault("namespaceName")
  valid_594563 = validateParameter(valid_594563, JString, required = true,
                                 default = nil)
  if valid_594563 != nil:
    section.add "namespaceName", valid_594563
  var valid_594564 = path.getOrDefault("resourceGroupName")
  valid_594564 = validateParameter(valid_594564, JString, required = true,
                                 default = nil)
  if valid_594564 != nil:
    section.add "resourceGroupName", valid_594564
  var valid_594565 = path.getOrDefault("subscriptionId")
  valid_594565 = validateParameter(valid_594565, JString, required = true,
                                 default = nil)
  if valid_594565 != nil:
    section.add "subscriptionId", valid_594565
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##       : May be used to limit the number of results to the most recent N usageDetails.
  ##   $skip: JInt
  ##        : Skip is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skip parameter that specifies a starting point to use for subsequent calls.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594566 = query.getOrDefault("api-version")
  valid_594566 = validateParameter(valid_594566, JString, required = true,
                                 default = nil)
  if valid_594566 != nil:
    section.add "api-version", valid_594566
  var valid_594567 = query.getOrDefault("$top")
  valid_594567 = validateParameter(valid_594567, JInt, required = false, default = nil)
  if valid_594567 != nil:
    section.add "$top", valid_594567
  var valid_594568 = query.getOrDefault("$skip")
  valid_594568 = validateParameter(valid_594568, JInt, required = false, default = nil)
  if valid_594568 != nil:
    section.add "$skip", valid_594568
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594569: Call_TopicsListByNamespace_594560; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the topics in a namespace.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639388.aspx
  let valid = call_594569.validator(path, query, header, formData, body)
  let scheme = call_594569.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594569.url(scheme.get, call_594569.host, call_594569.base,
                         call_594569.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594569, url, valid)

proc call*(call_594570: Call_TopicsListByNamespace_594560; namespaceName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          Top: int = 0; Skip: int = 0): Recallable =
  ## topicsListByNamespace
  ## Gets all the topics in a namespace.
  ## https://msdn.microsoft.com/en-us/library/azure/mt639388.aspx
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : May be used to limit the number of results to the most recent N usageDetails.
  ##   Skip: int
  ##       : Skip is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skip parameter that specifies a starting point to use for subsequent calls.
  var path_594571 = newJObject()
  var query_594572 = newJObject()
  add(path_594571, "namespaceName", newJString(namespaceName))
  add(path_594571, "resourceGroupName", newJString(resourceGroupName))
  add(query_594572, "api-version", newJString(apiVersion))
  add(path_594571, "subscriptionId", newJString(subscriptionId))
  add(query_594572, "$top", newJInt(Top))
  add(query_594572, "$skip", newJInt(Skip))
  result = call_594570.call(path_594571, query_594572, nil, nil, nil)

var topicsListByNamespace* = Call_TopicsListByNamespace_594560(
    name: "topicsListByNamespace", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/topics",
    validator: validate_TopicsListByNamespace_594561, base: "",
    url: url_TopicsListByNamespace_594562, schemes: {Scheme.Https})
type
  Call_TopicsCreateOrUpdate_594585 = ref object of OpenApiRestCall_593437
proc url_TopicsCreateOrUpdate_594587(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "topicName" in path, "`topicName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceBus/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/topics/"),
               (kind: VariableSegment, value: "topicName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TopicsCreateOrUpdate_594586(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a topic in the specified namespace.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639409.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   topicName: JString (required)
  ##            : The topic name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_594588 = path.getOrDefault("namespaceName")
  valid_594588 = validateParameter(valid_594588, JString, required = true,
                                 default = nil)
  if valid_594588 != nil:
    section.add "namespaceName", valid_594588
  var valid_594589 = path.getOrDefault("resourceGroupName")
  valid_594589 = validateParameter(valid_594589, JString, required = true,
                                 default = nil)
  if valid_594589 != nil:
    section.add "resourceGroupName", valid_594589
  var valid_594590 = path.getOrDefault("topicName")
  valid_594590 = validateParameter(valid_594590, JString, required = true,
                                 default = nil)
  if valid_594590 != nil:
    section.add "topicName", valid_594590
  var valid_594591 = path.getOrDefault("subscriptionId")
  valid_594591 = validateParameter(valid_594591, JString, required = true,
                                 default = nil)
  if valid_594591 != nil:
    section.add "subscriptionId", valid_594591
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594592 = query.getOrDefault("api-version")
  valid_594592 = validateParameter(valid_594592, JString, required = true,
                                 default = nil)
  if valid_594592 != nil:
    section.add "api-version", valid_594592
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to create a topic resource.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594594: Call_TopicsCreateOrUpdate_594585; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a topic in the specified namespace.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639409.aspx
  let valid = call_594594.validator(path, query, header, formData, body)
  let scheme = call_594594.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594594.url(scheme.get, call_594594.host, call_594594.base,
                         call_594594.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594594, url, valid)

proc call*(call_594595: Call_TopicsCreateOrUpdate_594585; namespaceName: string;
          resourceGroupName: string; apiVersion: string; topicName: string;
          subscriptionId: string; parameters: JsonNode): Recallable =
  ## topicsCreateOrUpdate
  ## Creates a topic in the specified namespace.
  ## https://msdn.microsoft.com/en-us/library/azure/mt639409.aspx
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   topicName: string (required)
  ##            : The topic name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to create a topic resource.
  var path_594596 = newJObject()
  var query_594597 = newJObject()
  var body_594598 = newJObject()
  add(path_594596, "namespaceName", newJString(namespaceName))
  add(path_594596, "resourceGroupName", newJString(resourceGroupName))
  add(query_594597, "api-version", newJString(apiVersion))
  add(path_594596, "topicName", newJString(topicName))
  add(path_594596, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594598 = parameters
  result = call_594595.call(path_594596, query_594597, nil, nil, body_594598)

var topicsCreateOrUpdate* = Call_TopicsCreateOrUpdate_594585(
    name: "topicsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/topics/{topicName}",
    validator: validate_TopicsCreateOrUpdate_594586, base: "",
    url: url_TopicsCreateOrUpdate_594587, schemes: {Scheme.Https})
type
  Call_TopicsGet_594573 = ref object of OpenApiRestCall_593437
proc url_TopicsGet_594575(protocol: Scheme; host: string; base: string; route: string;
                         path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "topicName" in path, "`topicName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceBus/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/topics/"),
               (kind: VariableSegment, value: "topicName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TopicsGet_594574(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a description for the specified topic.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639399.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   topicName: JString (required)
  ##            : The topic name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_594576 = path.getOrDefault("namespaceName")
  valid_594576 = validateParameter(valid_594576, JString, required = true,
                                 default = nil)
  if valid_594576 != nil:
    section.add "namespaceName", valid_594576
  var valid_594577 = path.getOrDefault("resourceGroupName")
  valid_594577 = validateParameter(valid_594577, JString, required = true,
                                 default = nil)
  if valid_594577 != nil:
    section.add "resourceGroupName", valid_594577
  var valid_594578 = path.getOrDefault("topicName")
  valid_594578 = validateParameter(valid_594578, JString, required = true,
                                 default = nil)
  if valid_594578 != nil:
    section.add "topicName", valid_594578
  var valid_594579 = path.getOrDefault("subscriptionId")
  valid_594579 = validateParameter(valid_594579, JString, required = true,
                                 default = nil)
  if valid_594579 != nil:
    section.add "subscriptionId", valid_594579
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594580 = query.getOrDefault("api-version")
  valid_594580 = validateParameter(valid_594580, JString, required = true,
                                 default = nil)
  if valid_594580 != nil:
    section.add "api-version", valid_594580
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594581: Call_TopicsGet_594573; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a description for the specified topic.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639399.aspx
  let valid = call_594581.validator(path, query, header, formData, body)
  let scheme = call_594581.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594581.url(scheme.get, call_594581.host, call_594581.base,
                         call_594581.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594581, url, valid)

proc call*(call_594582: Call_TopicsGet_594573; namespaceName: string;
          resourceGroupName: string; apiVersion: string; topicName: string;
          subscriptionId: string): Recallable =
  ## topicsGet
  ## Returns a description for the specified topic.
  ## https://msdn.microsoft.com/en-us/library/azure/mt639399.aspx
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   topicName: string (required)
  ##            : The topic name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594583 = newJObject()
  var query_594584 = newJObject()
  add(path_594583, "namespaceName", newJString(namespaceName))
  add(path_594583, "resourceGroupName", newJString(resourceGroupName))
  add(query_594584, "api-version", newJString(apiVersion))
  add(path_594583, "topicName", newJString(topicName))
  add(path_594583, "subscriptionId", newJString(subscriptionId))
  result = call_594582.call(path_594583, query_594584, nil, nil, nil)

var topicsGet* = Call_TopicsGet_594573(name: "topicsGet", meth: HttpMethod.HttpGet,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/topics/{topicName}",
                                    validator: validate_TopicsGet_594574,
                                    base: "", url: url_TopicsGet_594575,
                                    schemes: {Scheme.Https})
type
  Call_TopicsDelete_594599 = ref object of OpenApiRestCall_593437
proc url_TopicsDelete_594601(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "topicName" in path, "`topicName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceBus/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/topics/"),
               (kind: VariableSegment, value: "topicName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TopicsDelete_594600(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a topic from the specified namespace and resource group.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639404.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   topicName: JString (required)
  ##            : The topic name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_594602 = path.getOrDefault("namespaceName")
  valid_594602 = validateParameter(valid_594602, JString, required = true,
                                 default = nil)
  if valid_594602 != nil:
    section.add "namespaceName", valid_594602
  var valid_594603 = path.getOrDefault("resourceGroupName")
  valid_594603 = validateParameter(valid_594603, JString, required = true,
                                 default = nil)
  if valid_594603 != nil:
    section.add "resourceGroupName", valid_594603
  var valid_594604 = path.getOrDefault("topicName")
  valid_594604 = validateParameter(valid_594604, JString, required = true,
                                 default = nil)
  if valid_594604 != nil:
    section.add "topicName", valid_594604
  var valid_594605 = path.getOrDefault("subscriptionId")
  valid_594605 = validateParameter(valid_594605, JString, required = true,
                                 default = nil)
  if valid_594605 != nil:
    section.add "subscriptionId", valid_594605
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594606 = query.getOrDefault("api-version")
  valid_594606 = validateParameter(valid_594606, JString, required = true,
                                 default = nil)
  if valid_594606 != nil:
    section.add "api-version", valid_594606
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594607: Call_TopicsDelete_594599; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a topic from the specified namespace and resource group.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639404.aspx
  let valid = call_594607.validator(path, query, header, formData, body)
  let scheme = call_594607.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594607.url(scheme.get, call_594607.host, call_594607.base,
                         call_594607.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594607, url, valid)

proc call*(call_594608: Call_TopicsDelete_594599; namespaceName: string;
          resourceGroupName: string; apiVersion: string; topicName: string;
          subscriptionId: string): Recallable =
  ## topicsDelete
  ## Deletes a topic from the specified namespace and resource group.
  ## https://msdn.microsoft.com/en-us/library/azure/mt639404.aspx
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   topicName: string (required)
  ##            : The topic name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594609 = newJObject()
  var query_594610 = newJObject()
  add(path_594609, "namespaceName", newJString(namespaceName))
  add(path_594609, "resourceGroupName", newJString(resourceGroupName))
  add(query_594610, "api-version", newJString(apiVersion))
  add(path_594609, "topicName", newJString(topicName))
  add(path_594609, "subscriptionId", newJString(subscriptionId))
  result = call_594608.call(path_594609, query_594610, nil, nil, nil)

var topicsDelete* = Call_TopicsDelete_594599(name: "topicsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/topics/{topicName}",
    validator: validate_TopicsDelete_594600, base: "", url: url_TopicsDelete_594601,
    schemes: {Scheme.Https})
type
  Call_TopicsListAuthorizationRules_594611 = ref object of OpenApiRestCall_593437
proc url_TopicsListAuthorizationRules_594613(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "topicName" in path, "`topicName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceBus/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/topics/"),
               (kind: VariableSegment, value: "topicName"),
               (kind: ConstantSegment, value: "/authorizationRules")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TopicsListAuthorizationRules_594612(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets authorization rules for a topic.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt720681.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   topicName: JString (required)
  ##            : The topic name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_594614 = path.getOrDefault("namespaceName")
  valid_594614 = validateParameter(valid_594614, JString, required = true,
                                 default = nil)
  if valid_594614 != nil:
    section.add "namespaceName", valid_594614
  var valid_594615 = path.getOrDefault("resourceGroupName")
  valid_594615 = validateParameter(valid_594615, JString, required = true,
                                 default = nil)
  if valid_594615 != nil:
    section.add "resourceGroupName", valid_594615
  var valid_594616 = path.getOrDefault("topicName")
  valid_594616 = validateParameter(valid_594616, JString, required = true,
                                 default = nil)
  if valid_594616 != nil:
    section.add "topicName", valid_594616
  var valid_594617 = path.getOrDefault("subscriptionId")
  valid_594617 = validateParameter(valid_594617, JString, required = true,
                                 default = nil)
  if valid_594617 != nil:
    section.add "subscriptionId", valid_594617
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594618 = query.getOrDefault("api-version")
  valid_594618 = validateParameter(valid_594618, JString, required = true,
                                 default = nil)
  if valid_594618 != nil:
    section.add "api-version", valid_594618
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594619: Call_TopicsListAuthorizationRules_594611; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets authorization rules for a topic.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt720681.aspx
  let valid = call_594619.validator(path, query, header, formData, body)
  let scheme = call_594619.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594619.url(scheme.get, call_594619.host, call_594619.base,
                         call_594619.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594619, url, valid)

proc call*(call_594620: Call_TopicsListAuthorizationRules_594611;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          topicName: string; subscriptionId: string): Recallable =
  ## topicsListAuthorizationRules
  ## Gets authorization rules for a topic.
  ## https://msdn.microsoft.com/en-us/library/azure/mt720681.aspx
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   topicName: string (required)
  ##            : The topic name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594621 = newJObject()
  var query_594622 = newJObject()
  add(path_594621, "namespaceName", newJString(namespaceName))
  add(path_594621, "resourceGroupName", newJString(resourceGroupName))
  add(query_594622, "api-version", newJString(apiVersion))
  add(path_594621, "topicName", newJString(topicName))
  add(path_594621, "subscriptionId", newJString(subscriptionId))
  result = call_594620.call(path_594621, query_594622, nil, nil, nil)

var topicsListAuthorizationRules* = Call_TopicsListAuthorizationRules_594611(
    name: "topicsListAuthorizationRules", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/topics/{topicName}/authorizationRules",
    validator: validate_TopicsListAuthorizationRules_594612, base: "",
    url: url_TopicsListAuthorizationRules_594613, schemes: {Scheme.Https})
type
  Call_TopicsCreateOrUpdateAuthorizationRule_594636 = ref object of OpenApiRestCall_593437
proc url_TopicsCreateOrUpdateAuthorizationRule_594638(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "topicName" in path, "`topicName` is a required path parameter"
  assert "authorizationRuleName" in path,
        "`authorizationRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceBus/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/topics/"),
               (kind: VariableSegment, value: "topicName"),
               (kind: ConstantSegment, value: "/authorizationRules/"),
               (kind: VariableSegment, value: "authorizationRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TopicsCreateOrUpdateAuthorizationRule_594637(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates an authorization rule for the specified topic.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt720678.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   topicName: JString (required)
  ##            : The topic name.
  ##   authorizationRuleName: JString (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_594639 = path.getOrDefault("namespaceName")
  valid_594639 = validateParameter(valid_594639, JString, required = true,
                                 default = nil)
  if valid_594639 != nil:
    section.add "namespaceName", valid_594639
  var valid_594640 = path.getOrDefault("resourceGroupName")
  valid_594640 = validateParameter(valid_594640, JString, required = true,
                                 default = nil)
  if valid_594640 != nil:
    section.add "resourceGroupName", valid_594640
  var valid_594641 = path.getOrDefault("topicName")
  valid_594641 = validateParameter(valid_594641, JString, required = true,
                                 default = nil)
  if valid_594641 != nil:
    section.add "topicName", valid_594641
  var valid_594642 = path.getOrDefault("authorizationRuleName")
  valid_594642 = validateParameter(valid_594642, JString, required = true,
                                 default = nil)
  if valid_594642 != nil:
    section.add "authorizationRuleName", valid_594642
  var valid_594643 = path.getOrDefault("subscriptionId")
  valid_594643 = validateParameter(valid_594643, JString, required = true,
                                 default = nil)
  if valid_594643 != nil:
    section.add "subscriptionId", valid_594643
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594644 = query.getOrDefault("api-version")
  valid_594644 = validateParameter(valid_594644, JString, required = true,
                                 default = nil)
  if valid_594644 != nil:
    section.add "api-version", valid_594644
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The shared access authorization rule.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594646: Call_TopicsCreateOrUpdateAuthorizationRule_594636;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates an authorization rule for the specified topic.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt720678.aspx
  let valid = call_594646.validator(path, query, header, formData, body)
  let scheme = call_594646.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594646.url(scheme.get, call_594646.host, call_594646.base,
                         call_594646.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594646, url, valid)

proc call*(call_594647: Call_TopicsCreateOrUpdateAuthorizationRule_594636;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          topicName: string; authorizationRuleName: string; subscriptionId: string;
          parameters: JsonNode): Recallable =
  ## topicsCreateOrUpdateAuthorizationRule
  ## Creates an authorization rule for the specified topic.
  ## https://msdn.microsoft.com/en-us/library/azure/mt720678.aspx
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   topicName: string (required)
  ##            : The topic name.
  ##   authorizationRuleName: string (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : The shared access authorization rule.
  var path_594648 = newJObject()
  var query_594649 = newJObject()
  var body_594650 = newJObject()
  add(path_594648, "namespaceName", newJString(namespaceName))
  add(path_594648, "resourceGroupName", newJString(resourceGroupName))
  add(query_594649, "api-version", newJString(apiVersion))
  add(path_594648, "topicName", newJString(topicName))
  add(path_594648, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_594648, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594650 = parameters
  result = call_594647.call(path_594648, query_594649, nil, nil, body_594650)

var topicsCreateOrUpdateAuthorizationRule* = Call_TopicsCreateOrUpdateAuthorizationRule_594636(
    name: "topicsCreateOrUpdateAuthorizationRule", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/topics/{topicName}/authorizationRules/{authorizationRuleName}",
    validator: validate_TopicsCreateOrUpdateAuthorizationRule_594637, base: "",
    url: url_TopicsCreateOrUpdateAuthorizationRule_594638, schemes: {Scheme.Https})
type
  Call_TopicsGetAuthorizationRule_594623 = ref object of OpenApiRestCall_593437
proc url_TopicsGetAuthorizationRule_594625(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "topicName" in path, "`topicName` is a required path parameter"
  assert "authorizationRuleName" in path,
        "`authorizationRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceBus/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/topics/"),
               (kind: VariableSegment, value: "topicName"),
               (kind: ConstantSegment, value: "/authorizationRules/"),
               (kind: VariableSegment, value: "authorizationRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TopicsGetAuthorizationRule_594624(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the specified authorization rule.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt720676.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   topicName: JString (required)
  ##            : The topic name.
  ##   authorizationRuleName: JString (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_594626 = path.getOrDefault("namespaceName")
  valid_594626 = validateParameter(valid_594626, JString, required = true,
                                 default = nil)
  if valid_594626 != nil:
    section.add "namespaceName", valid_594626
  var valid_594627 = path.getOrDefault("resourceGroupName")
  valid_594627 = validateParameter(valid_594627, JString, required = true,
                                 default = nil)
  if valid_594627 != nil:
    section.add "resourceGroupName", valid_594627
  var valid_594628 = path.getOrDefault("topicName")
  valid_594628 = validateParameter(valid_594628, JString, required = true,
                                 default = nil)
  if valid_594628 != nil:
    section.add "topicName", valid_594628
  var valid_594629 = path.getOrDefault("authorizationRuleName")
  valid_594629 = validateParameter(valid_594629, JString, required = true,
                                 default = nil)
  if valid_594629 != nil:
    section.add "authorizationRuleName", valid_594629
  var valid_594630 = path.getOrDefault("subscriptionId")
  valid_594630 = validateParameter(valid_594630, JString, required = true,
                                 default = nil)
  if valid_594630 != nil:
    section.add "subscriptionId", valid_594630
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594631 = query.getOrDefault("api-version")
  valid_594631 = validateParameter(valid_594631, JString, required = true,
                                 default = nil)
  if valid_594631 != nil:
    section.add "api-version", valid_594631
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594632: Call_TopicsGetAuthorizationRule_594623; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the specified authorization rule.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt720676.aspx
  let valid = call_594632.validator(path, query, header, formData, body)
  let scheme = call_594632.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594632.url(scheme.get, call_594632.host, call_594632.base,
                         call_594632.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594632, url, valid)

proc call*(call_594633: Call_TopicsGetAuthorizationRule_594623;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          topicName: string; authorizationRuleName: string; subscriptionId: string): Recallable =
  ## topicsGetAuthorizationRule
  ## Returns the specified authorization rule.
  ## https://msdn.microsoft.com/en-us/library/azure/mt720676.aspx
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   topicName: string (required)
  ##            : The topic name.
  ##   authorizationRuleName: string (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594634 = newJObject()
  var query_594635 = newJObject()
  add(path_594634, "namespaceName", newJString(namespaceName))
  add(path_594634, "resourceGroupName", newJString(resourceGroupName))
  add(query_594635, "api-version", newJString(apiVersion))
  add(path_594634, "topicName", newJString(topicName))
  add(path_594634, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_594634, "subscriptionId", newJString(subscriptionId))
  result = call_594633.call(path_594634, query_594635, nil, nil, nil)

var topicsGetAuthorizationRule* = Call_TopicsGetAuthorizationRule_594623(
    name: "topicsGetAuthorizationRule", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/topics/{topicName}/authorizationRules/{authorizationRuleName}",
    validator: validate_TopicsGetAuthorizationRule_594624, base: "",
    url: url_TopicsGetAuthorizationRule_594625, schemes: {Scheme.Https})
type
  Call_TopicsDeleteAuthorizationRule_594651 = ref object of OpenApiRestCall_593437
proc url_TopicsDeleteAuthorizationRule_594653(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "topicName" in path, "`topicName` is a required path parameter"
  assert "authorizationRuleName" in path,
        "`authorizationRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceBus/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/topics/"),
               (kind: VariableSegment, value: "topicName"),
               (kind: ConstantSegment, value: "/authorizationRules/"),
               (kind: VariableSegment, value: "authorizationRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TopicsDeleteAuthorizationRule_594652(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a topic authorization rule.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt720681.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   topicName: JString (required)
  ##            : The topic name.
  ##   authorizationRuleName: JString (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_594654 = path.getOrDefault("namespaceName")
  valid_594654 = validateParameter(valid_594654, JString, required = true,
                                 default = nil)
  if valid_594654 != nil:
    section.add "namespaceName", valid_594654
  var valid_594655 = path.getOrDefault("resourceGroupName")
  valid_594655 = validateParameter(valid_594655, JString, required = true,
                                 default = nil)
  if valid_594655 != nil:
    section.add "resourceGroupName", valid_594655
  var valid_594656 = path.getOrDefault("topicName")
  valid_594656 = validateParameter(valid_594656, JString, required = true,
                                 default = nil)
  if valid_594656 != nil:
    section.add "topicName", valid_594656
  var valid_594657 = path.getOrDefault("authorizationRuleName")
  valid_594657 = validateParameter(valid_594657, JString, required = true,
                                 default = nil)
  if valid_594657 != nil:
    section.add "authorizationRuleName", valid_594657
  var valid_594658 = path.getOrDefault("subscriptionId")
  valid_594658 = validateParameter(valid_594658, JString, required = true,
                                 default = nil)
  if valid_594658 != nil:
    section.add "subscriptionId", valid_594658
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594659 = query.getOrDefault("api-version")
  valid_594659 = validateParameter(valid_594659, JString, required = true,
                                 default = nil)
  if valid_594659 != nil:
    section.add "api-version", valid_594659
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594660: Call_TopicsDeleteAuthorizationRule_594651; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a topic authorization rule.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt720681.aspx
  let valid = call_594660.validator(path, query, header, formData, body)
  let scheme = call_594660.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594660.url(scheme.get, call_594660.host, call_594660.base,
                         call_594660.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594660, url, valid)

proc call*(call_594661: Call_TopicsDeleteAuthorizationRule_594651;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          topicName: string; authorizationRuleName: string; subscriptionId: string): Recallable =
  ## topicsDeleteAuthorizationRule
  ## Deletes a topic authorization rule.
  ## https://msdn.microsoft.com/en-us/library/azure/mt720681.aspx
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   topicName: string (required)
  ##            : The topic name.
  ##   authorizationRuleName: string (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594662 = newJObject()
  var query_594663 = newJObject()
  add(path_594662, "namespaceName", newJString(namespaceName))
  add(path_594662, "resourceGroupName", newJString(resourceGroupName))
  add(query_594663, "api-version", newJString(apiVersion))
  add(path_594662, "topicName", newJString(topicName))
  add(path_594662, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_594662, "subscriptionId", newJString(subscriptionId))
  result = call_594661.call(path_594662, query_594663, nil, nil, nil)

var topicsDeleteAuthorizationRule* = Call_TopicsDeleteAuthorizationRule_594651(
    name: "topicsDeleteAuthorizationRule", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/topics/{topicName}/authorizationRules/{authorizationRuleName}",
    validator: validate_TopicsDeleteAuthorizationRule_594652, base: "",
    url: url_TopicsDeleteAuthorizationRule_594653, schemes: {Scheme.Https})
type
  Call_TopicsListKeys_594664 = ref object of OpenApiRestCall_593437
proc url_TopicsListKeys_594666(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "topicName" in path, "`topicName` is a required path parameter"
  assert "authorizationRuleName" in path,
        "`authorizationRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceBus/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/topics/"),
               (kind: VariableSegment, value: "topicName"),
               (kind: ConstantSegment, value: "/authorizationRules/"),
               (kind: VariableSegment, value: "authorizationRuleName"),
               (kind: ConstantSegment, value: "/ListKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TopicsListKeys_594665(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Gets the primary and secondary connection strings for the topic.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt720677.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   topicName: JString (required)
  ##            : The topic name.
  ##   authorizationRuleName: JString (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_594667 = path.getOrDefault("namespaceName")
  valid_594667 = validateParameter(valid_594667, JString, required = true,
                                 default = nil)
  if valid_594667 != nil:
    section.add "namespaceName", valid_594667
  var valid_594668 = path.getOrDefault("resourceGroupName")
  valid_594668 = validateParameter(valid_594668, JString, required = true,
                                 default = nil)
  if valid_594668 != nil:
    section.add "resourceGroupName", valid_594668
  var valid_594669 = path.getOrDefault("topicName")
  valid_594669 = validateParameter(valid_594669, JString, required = true,
                                 default = nil)
  if valid_594669 != nil:
    section.add "topicName", valid_594669
  var valid_594670 = path.getOrDefault("authorizationRuleName")
  valid_594670 = validateParameter(valid_594670, JString, required = true,
                                 default = nil)
  if valid_594670 != nil:
    section.add "authorizationRuleName", valid_594670
  var valid_594671 = path.getOrDefault("subscriptionId")
  valid_594671 = validateParameter(valid_594671, JString, required = true,
                                 default = nil)
  if valid_594671 != nil:
    section.add "subscriptionId", valid_594671
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594672 = query.getOrDefault("api-version")
  valid_594672 = validateParameter(valid_594672, JString, required = true,
                                 default = nil)
  if valid_594672 != nil:
    section.add "api-version", valid_594672
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594673: Call_TopicsListKeys_594664; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the primary and secondary connection strings for the topic.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt720677.aspx
  let valid = call_594673.validator(path, query, header, formData, body)
  let scheme = call_594673.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594673.url(scheme.get, call_594673.host, call_594673.base,
                         call_594673.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594673, url, valid)

proc call*(call_594674: Call_TopicsListKeys_594664; namespaceName: string;
          resourceGroupName: string; apiVersion: string; topicName: string;
          authorizationRuleName: string; subscriptionId: string): Recallable =
  ## topicsListKeys
  ## Gets the primary and secondary connection strings for the topic.
  ## https://msdn.microsoft.com/en-us/library/azure/mt720677.aspx
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   topicName: string (required)
  ##            : The topic name.
  ##   authorizationRuleName: string (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594675 = newJObject()
  var query_594676 = newJObject()
  add(path_594675, "namespaceName", newJString(namespaceName))
  add(path_594675, "resourceGroupName", newJString(resourceGroupName))
  add(query_594676, "api-version", newJString(apiVersion))
  add(path_594675, "topicName", newJString(topicName))
  add(path_594675, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_594675, "subscriptionId", newJString(subscriptionId))
  result = call_594674.call(path_594675, query_594676, nil, nil, nil)

var topicsListKeys* = Call_TopicsListKeys_594664(name: "topicsListKeys",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/topics/{topicName}/authorizationRules/{authorizationRuleName}/ListKeys",
    validator: validate_TopicsListKeys_594665, base: "", url: url_TopicsListKeys_594666,
    schemes: {Scheme.Https})
type
  Call_TopicsRegenerateKeys_594677 = ref object of OpenApiRestCall_593437
proc url_TopicsRegenerateKeys_594679(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "topicName" in path, "`topicName` is a required path parameter"
  assert "authorizationRuleName" in path,
        "`authorizationRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceBus/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/topics/"),
               (kind: VariableSegment, value: "topicName"),
               (kind: ConstantSegment, value: "/authorizationRules/"),
               (kind: VariableSegment, value: "authorizationRuleName"),
               (kind: ConstantSegment, value: "/regenerateKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TopicsRegenerateKeys_594678(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Regenerates primary or secondary connection strings for the topic.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt720679.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   topicName: JString (required)
  ##            : The topic name.
  ##   authorizationRuleName: JString (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_594680 = path.getOrDefault("namespaceName")
  valid_594680 = validateParameter(valid_594680, JString, required = true,
                                 default = nil)
  if valid_594680 != nil:
    section.add "namespaceName", valid_594680
  var valid_594681 = path.getOrDefault("resourceGroupName")
  valid_594681 = validateParameter(valid_594681, JString, required = true,
                                 default = nil)
  if valid_594681 != nil:
    section.add "resourceGroupName", valid_594681
  var valid_594682 = path.getOrDefault("topicName")
  valid_594682 = validateParameter(valid_594682, JString, required = true,
                                 default = nil)
  if valid_594682 != nil:
    section.add "topicName", valid_594682
  var valid_594683 = path.getOrDefault("authorizationRuleName")
  valid_594683 = validateParameter(valid_594683, JString, required = true,
                                 default = nil)
  if valid_594683 != nil:
    section.add "authorizationRuleName", valid_594683
  var valid_594684 = path.getOrDefault("subscriptionId")
  valid_594684 = validateParameter(valid_594684, JString, required = true,
                                 default = nil)
  if valid_594684 != nil:
    section.add "subscriptionId", valid_594684
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594685 = query.getOrDefault("api-version")
  valid_594685 = validateParameter(valid_594685, JString, required = true,
                                 default = nil)
  if valid_594685 != nil:
    section.add "api-version", valid_594685
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to regenerate the authorization rule.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594687: Call_TopicsRegenerateKeys_594677; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Regenerates primary or secondary connection strings for the topic.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt720679.aspx
  let valid = call_594687.validator(path, query, header, formData, body)
  let scheme = call_594687.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594687.url(scheme.get, call_594687.host, call_594687.base,
                         call_594687.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594687, url, valid)

proc call*(call_594688: Call_TopicsRegenerateKeys_594677; namespaceName: string;
          resourceGroupName: string; apiVersion: string; topicName: string;
          authorizationRuleName: string; subscriptionId: string;
          parameters: JsonNode): Recallable =
  ## topicsRegenerateKeys
  ## Regenerates primary or secondary connection strings for the topic.
  ## https://msdn.microsoft.com/en-us/library/azure/mt720679.aspx
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   topicName: string (required)
  ##            : The topic name.
  ##   authorizationRuleName: string (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to regenerate the authorization rule.
  var path_594689 = newJObject()
  var query_594690 = newJObject()
  var body_594691 = newJObject()
  add(path_594689, "namespaceName", newJString(namespaceName))
  add(path_594689, "resourceGroupName", newJString(resourceGroupName))
  add(query_594690, "api-version", newJString(apiVersion))
  add(path_594689, "topicName", newJString(topicName))
  add(path_594689, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_594689, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594691 = parameters
  result = call_594688.call(path_594689, query_594690, nil, nil, body_594691)

var topicsRegenerateKeys* = Call_TopicsRegenerateKeys_594677(
    name: "topicsRegenerateKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/topics/{topicName}/authorizationRules/{authorizationRuleName}/regenerateKeys",
    validator: validate_TopicsRegenerateKeys_594678, base: "",
    url: url_TopicsRegenerateKeys_594679, schemes: {Scheme.Https})
type
  Call_SubscriptionsListByTopic_594692 = ref object of OpenApiRestCall_593437
proc url_SubscriptionsListByTopic_594694(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "topicName" in path, "`topicName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceBus/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/topics/"),
               (kind: VariableSegment, value: "topicName"),
               (kind: ConstantSegment, value: "/subscriptions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SubscriptionsListByTopic_594693(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all the subscriptions under a specified topic.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639400.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   topicName: JString (required)
  ##            : The topic name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_594695 = path.getOrDefault("namespaceName")
  valid_594695 = validateParameter(valid_594695, JString, required = true,
                                 default = nil)
  if valid_594695 != nil:
    section.add "namespaceName", valid_594695
  var valid_594696 = path.getOrDefault("resourceGroupName")
  valid_594696 = validateParameter(valid_594696, JString, required = true,
                                 default = nil)
  if valid_594696 != nil:
    section.add "resourceGroupName", valid_594696
  var valid_594697 = path.getOrDefault("topicName")
  valid_594697 = validateParameter(valid_594697, JString, required = true,
                                 default = nil)
  if valid_594697 != nil:
    section.add "topicName", valid_594697
  var valid_594698 = path.getOrDefault("subscriptionId")
  valid_594698 = validateParameter(valid_594698, JString, required = true,
                                 default = nil)
  if valid_594698 != nil:
    section.add "subscriptionId", valid_594698
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##       : May be used to limit the number of results to the most recent N usageDetails.
  ##   $skip: JInt
  ##        : Skip is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skip parameter that specifies a starting point to use for subsequent calls.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594699 = query.getOrDefault("api-version")
  valid_594699 = validateParameter(valid_594699, JString, required = true,
                                 default = nil)
  if valid_594699 != nil:
    section.add "api-version", valid_594699
  var valid_594700 = query.getOrDefault("$top")
  valid_594700 = validateParameter(valid_594700, JInt, required = false, default = nil)
  if valid_594700 != nil:
    section.add "$top", valid_594700
  var valid_594701 = query.getOrDefault("$skip")
  valid_594701 = validateParameter(valid_594701, JInt, required = false, default = nil)
  if valid_594701 != nil:
    section.add "$skip", valid_594701
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594702: Call_SubscriptionsListByTopic_594692; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all the subscriptions under a specified topic.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639400.aspx
  let valid = call_594702.validator(path, query, header, formData, body)
  let scheme = call_594702.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594702.url(scheme.get, call_594702.host, call_594702.base,
                         call_594702.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594702, url, valid)

proc call*(call_594703: Call_SubscriptionsListByTopic_594692;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          topicName: string; subscriptionId: string; Top: int = 0; Skip: int = 0): Recallable =
  ## subscriptionsListByTopic
  ## List all the subscriptions under a specified topic.
  ## https://msdn.microsoft.com/en-us/library/azure/mt639400.aspx
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   topicName: string (required)
  ##            : The topic name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : May be used to limit the number of results to the most recent N usageDetails.
  ##   Skip: int
  ##       : Skip is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skip parameter that specifies a starting point to use for subsequent calls.
  var path_594704 = newJObject()
  var query_594705 = newJObject()
  add(path_594704, "namespaceName", newJString(namespaceName))
  add(path_594704, "resourceGroupName", newJString(resourceGroupName))
  add(query_594705, "api-version", newJString(apiVersion))
  add(path_594704, "topicName", newJString(topicName))
  add(path_594704, "subscriptionId", newJString(subscriptionId))
  add(query_594705, "$top", newJInt(Top))
  add(query_594705, "$skip", newJInt(Skip))
  result = call_594703.call(path_594704, query_594705, nil, nil, nil)

var subscriptionsListByTopic* = Call_SubscriptionsListByTopic_594692(
    name: "subscriptionsListByTopic", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/topics/{topicName}/subscriptions",
    validator: validate_SubscriptionsListByTopic_594693, base: "",
    url: url_SubscriptionsListByTopic_594694, schemes: {Scheme.Https})
type
  Call_SubscriptionsCreateOrUpdate_594719 = ref object of OpenApiRestCall_593437
proc url_SubscriptionsCreateOrUpdate_594721(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "topicName" in path, "`topicName` is a required path parameter"
  assert "subscriptionName" in path,
        "`subscriptionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceBus/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/topics/"),
               (kind: VariableSegment, value: "topicName"),
               (kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SubscriptionsCreateOrUpdate_594720(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a topic subscription.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639385.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   topicName: JString (required)
  ##            : The topic name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   subscriptionName: JString (required)
  ##                   : The subscription name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_594722 = path.getOrDefault("namespaceName")
  valid_594722 = validateParameter(valid_594722, JString, required = true,
                                 default = nil)
  if valid_594722 != nil:
    section.add "namespaceName", valid_594722
  var valid_594723 = path.getOrDefault("resourceGroupName")
  valid_594723 = validateParameter(valid_594723, JString, required = true,
                                 default = nil)
  if valid_594723 != nil:
    section.add "resourceGroupName", valid_594723
  var valid_594724 = path.getOrDefault("topicName")
  valid_594724 = validateParameter(valid_594724, JString, required = true,
                                 default = nil)
  if valid_594724 != nil:
    section.add "topicName", valid_594724
  var valid_594725 = path.getOrDefault("subscriptionId")
  valid_594725 = validateParameter(valid_594725, JString, required = true,
                                 default = nil)
  if valid_594725 != nil:
    section.add "subscriptionId", valid_594725
  var valid_594726 = path.getOrDefault("subscriptionName")
  valid_594726 = validateParameter(valid_594726, JString, required = true,
                                 default = nil)
  if valid_594726 != nil:
    section.add "subscriptionName", valid_594726
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594727 = query.getOrDefault("api-version")
  valid_594727 = validateParameter(valid_594727, JString, required = true,
                                 default = nil)
  if valid_594727 != nil:
    section.add "api-version", valid_594727
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to create a subscription resource.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594729: Call_SubscriptionsCreateOrUpdate_594719; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a topic subscription.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639385.aspx
  let valid = call_594729.validator(path, query, header, formData, body)
  let scheme = call_594729.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594729.url(scheme.get, call_594729.host, call_594729.base,
                         call_594729.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594729, url, valid)

proc call*(call_594730: Call_SubscriptionsCreateOrUpdate_594719;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          topicName: string; subscriptionId: string; subscriptionName: string;
          parameters: JsonNode): Recallable =
  ## subscriptionsCreateOrUpdate
  ## Creates a topic subscription.
  ## https://msdn.microsoft.com/en-us/library/azure/mt639385.aspx
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   topicName: string (required)
  ##            : The topic name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   subscriptionName: string (required)
  ##                   : The subscription name.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to create a subscription resource.
  var path_594731 = newJObject()
  var query_594732 = newJObject()
  var body_594733 = newJObject()
  add(path_594731, "namespaceName", newJString(namespaceName))
  add(path_594731, "resourceGroupName", newJString(resourceGroupName))
  add(query_594732, "api-version", newJString(apiVersion))
  add(path_594731, "topicName", newJString(topicName))
  add(path_594731, "subscriptionId", newJString(subscriptionId))
  add(path_594731, "subscriptionName", newJString(subscriptionName))
  if parameters != nil:
    body_594733 = parameters
  result = call_594730.call(path_594731, query_594732, nil, nil, body_594733)

var subscriptionsCreateOrUpdate* = Call_SubscriptionsCreateOrUpdate_594719(
    name: "subscriptionsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/topics/{topicName}/subscriptions/{subscriptionName}",
    validator: validate_SubscriptionsCreateOrUpdate_594720, base: "",
    url: url_SubscriptionsCreateOrUpdate_594721, schemes: {Scheme.Https})
type
  Call_SubscriptionsGet_594706 = ref object of OpenApiRestCall_593437
proc url_SubscriptionsGet_594708(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "topicName" in path, "`topicName` is a required path parameter"
  assert "subscriptionName" in path,
        "`subscriptionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceBus/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/topics/"),
               (kind: VariableSegment, value: "topicName"),
               (kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SubscriptionsGet_594707(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Returns a subscription description for the specified topic.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639402.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   topicName: JString (required)
  ##            : The topic name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   subscriptionName: JString (required)
  ##                   : The subscription name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_594709 = path.getOrDefault("namespaceName")
  valid_594709 = validateParameter(valid_594709, JString, required = true,
                                 default = nil)
  if valid_594709 != nil:
    section.add "namespaceName", valid_594709
  var valid_594710 = path.getOrDefault("resourceGroupName")
  valid_594710 = validateParameter(valid_594710, JString, required = true,
                                 default = nil)
  if valid_594710 != nil:
    section.add "resourceGroupName", valid_594710
  var valid_594711 = path.getOrDefault("topicName")
  valid_594711 = validateParameter(valid_594711, JString, required = true,
                                 default = nil)
  if valid_594711 != nil:
    section.add "topicName", valid_594711
  var valid_594712 = path.getOrDefault("subscriptionId")
  valid_594712 = validateParameter(valid_594712, JString, required = true,
                                 default = nil)
  if valid_594712 != nil:
    section.add "subscriptionId", valid_594712
  var valid_594713 = path.getOrDefault("subscriptionName")
  valid_594713 = validateParameter(valid_594713, JString, required = true,
                                 default = nil)
  if valid_594713 != nil:
    section.add "subscriptionName", valid_594713
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594714 = query.getOrDefault("api-version")
  valid_594714 = validateParameter(valid_594714, JString, required = true,
                                 default = nil)
  if valid_594714 != nil:
    section.add "api-version", valid_594714
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594715: Call_SubscriptionsGet_594706; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a subscription description for the specified topic.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639402.aspx
  let valid = call_594715.validator(path, query, header, formData, body)
  let scheme = call_594715.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594715.url(scheme.get, call_594715.host, call_594715.base,
                         call_594715.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594715, url, valid)

proc call*(call_594716: Call_SubscriptionsGet_594706; namespaceName: string;
          resourceGroupName: string; apiVersion: string; topicName: string;
          subscriptionId: string; subscriptionName: string): Recallable =
  ## subscriptionsGet
  ## Returns a subscription description for the specified topic.
  ## https://msdn.microsoft.com/en-us/library/azure/mt639402.aspx
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   topicName: string (required)
  ##            : The topic name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   subscriptionName: string (required)
  ##                   : The subscription name.
  var path_594717 = newJObject()
  var query_594718 = newJObject()
  add(path_594717, "namespaceName", newJString(namespaceName))
  add(path_594717, "resourceGroupName", newJString(resourceGroupName))
  add(query_594718, "api-version", newJString(apiVersion))
  add(path_594717, "topicName", newJString(topicName))
  add(path_594717, "subscriptionId", newJString(subscriptionId))
  add(path_594717, "subscriptionName", newJString(subscriptionName))
  result = call_594716.call(path_594717, query_594718, nil, nil, nil)

var subscriptionsGet* = Call_SubscriptionsGet_594706(name: "subscriptionsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/topics/{topicName}/subscriptions/{subscriptionName}",
    validator: validate_SubscriptionsGet_594707, base: "",
    url: url_SubscriptionsGet_594708, schemes: {Scheme.Https})
type
  Call_SubscriptionsDelete_594734 = ref object of OpenApiRestCall_593437
proc url_SubscriptionsDelete_594736(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "topicName" in path, "`topicName` is a required path parameter"
  assert "subscriptionName" in path,
        "`subscriptionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceBus/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/topics/"),
               (kind: VariableSegment, value: "topicName"),
               (kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SubscriptionsDelete_594735(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Deletes a subscription from the specified topic.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639381.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   topicName: JString (required)
  ##            : The topic name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   subscriptionName: JString (required)
  ##                   : The subscription name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_594737 = path.getOrDefault("namespaceName")
  valid_594737 = validateParameter(valid_594737, JString, required = true,
                                 default = nil)
  if valid_594737 != nil:
    section.add "namespaceName", valid_594737
  var valid_594738 = path.getOrDefault("resourceGroupName")
  valid_594738 = validateParameter(valid_594738, JString, required = true,
                                 default = nil)
  if valid_594738 != nil:
    section.add "resourceGroupName", valid_594738
  var valid_594739 = path.getOrDefault("topicName")
  valid_594739 = validateParameter(valid_594739, JString, required = true,
                                 default = nil)
  if valid_594739 != nil:
    section.add "topicName", valid_594739
  var valid_594740 = path.getOrDefault("subscriptionId")
  valid_594740 = validateParameter(valid_594740, JString, required = true,
                                 default = nil)
  if valid_594740 != nil:
    section.add "subscriptionId", valid_594740
  var valid_594741 = path.getOrDefault("subscriptionName")
  valid_594741 = validateParameter(valid_594741, JString, required = true,
                                 default = nil)
  if valid_594741 != nil:
    section.add "subscriptionName", valid_594741
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594742 = query.getOrDefault("api-version")
  valid_594742 = validateParameter(valid_594742, JString, required = true,
                                 default = nil)
  if valid_594742 != nil:
    section.add "api-version", valid_594742
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594743: Call_SubscriptionsDelete_594734; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a subscription from the specified topic.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639381.aspx
  let valid = call_594743.validator(path, query, header, formData, body)
  let scheme = call_594743.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594743.url(scheme.get, call_594743.host, call_594743.base,
                         call_594743.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594743, url, valid)

proc call*(call_594744: Call_SubscriptionsDelete_594734; namespaceName: string;
          resourceGroupName: string; apiVersion: string; topicName: string;
          subscriptionId: string; subscriptionName: string): Recallable =
  ## subscriptionsDelete
  ## Deletes a subscription from the specified topic.
  ## https://msdn.microsoft.com/en-us/library/azure/mt639381.aspx
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   topicName: string (required)
  ##            : The topic name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   subscriptionName: string (required)
  ##                   : The subscription name.
  var path_594745 = newJObject()
  var query_594746 = newJObject()
  add(path_594745, "namespaceName", newJString(namespaceName))
  add(path_594745, "resourceGroupName", newJString(resourceGroupName))
  add(query_594746, "api-version", newJString(apiVersion))
  add(path_594745, "topicName", newJString(topicName))
  add(path_594745, "subscriptionId", newJString(subscriptionId))
  add(path_594745, "subscriptionName", newJString(subscriptionName))
  result = call_594744.call(path_594745, query_594746, nil, nil, nil)

var subscriptionsDelete* = Call_SubscriptionsDelete_594734(
    name: "subscriptionsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/topics/{topicName}/subscriptions/{subscriptionName}",
    validator: validate_SubscriptionsDelete_594735, base: "",
    url: url_SubscriptionsDelete_594736, schemes: {Scheme.Https})
type
  Call_RulesListBySubscriptions_594747 = ref object of OpenApiRestCall_593437
proc url_RulesListBySubscriptions_594749(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "topicName" in path, "`topicName` is a required path parameter"
  assert "subscriptionName" in path,
        "`subscriptionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceBus/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/topics/"),
               (kind: VariableSegment, value: "topicName"),
               (kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionName"),
               (kind: ConstantSegment, value: "/rules")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RulesListBySubscriptions_594748(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all the rules within given topic-subscription
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   topicName: JString (required)
  ##            : The topic name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   subscriptionName: JString (required)
  ##                   : The subscription name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_594750 = path.getOrDefault("namespaceName")
  valid_594750 = validateParameter(valid_594750, JString, required = true,
                                 default = nil)
  if valid_594750 != nil:
    section.add "namespaceName", valid_594750
  var valid_594751 = path.getOrDefault("resourceGroupName")
  valid_594751 = validateParameter(valid_594751, JString, required = true,
                                 default = nil)
  if valid_594751 != nil:
    section.add "resourceGroupName", valid_594751
  var valid_594752 = path.getOrDefault("topicName")
  valid_594752 = validateParameter(valid_594752, JString, required = true,
                                 default = nil)
  if valid_594752 != nil:
    section.add "topicName", valid_594752
  var valid_594753 = path.getOrDefault("subscriptionId")
  valid_594753 = validateParameter(valid_594753, JString, required = true,
                                 default = nil)
  if valid_594753 != nil:
    section.add "subscriptionId", valid_594753
  var valid_594754 = path.getOrDefault("subscriptionName")
  valid_594754 = validateParameter(valid_594754, JString, required = true,
                                 default = nil)
  if valid_594754 != nil:
    section.add "subscriptionName", valid_594754
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $top: JInt
  ##       : May be used to limit the number of results to the most recent N usageDetails.
  ##   $skip: JInt
  ##        : Skip is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skip parameter that specifies a starting point to use for subsequent calls.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594755 = query.getOrDefault("api-version")
  valid_594755 = validateParameter(valid_594755, JString, required = true,
                                 default = nil)
  if valid_594755 != nil:
    section.add "api-version", valid_594755
  var valid_594756 = query.getOrDefault("$top")
  valid_594756 = validateParameter(valid_594756, JInt, required = false, default = nil)
  if valid_594756 != nil:
    section.add "$top", valid_594756
  var valid_594757 = query.getOrDefault("$skip")
  valid_594757 = validateParameter(valid_594757, JInt, required = false, default = nil)
  if valid_594757 != nil:
    section.add "$skip", valid_594757
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594758: Call_RulesListBySubscriptions_594747; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all the rules within given topic-subscription
  ## 
  let valid = call_594758.validator(path, query, header, formData, body)
  let scheme = call_594758.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594758.url(scheme.get, call_594758.host, call_594758.base,
                         call_594758.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594758, url, valid)

proc call*(call_594759: Call_RulesListBySubscriptions_594747;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          topicName: string; subscriptionId: string; subscriptionName: string;
          Top: int = 0; Skip: int = 0): Recallable =
  ## rulesListBySubscriptions
  ## List all the rules within given topic-subscription
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   topicName: string (required)
  ##            : The topic name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : May be used to limit the number of results to the most recent N usageDetails.
  ##   subscriptionName: string (required)
  ##                   : The subscription name.
  ##   Skip: int
  ##       : Skip is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skip parameter that specifies a starting point to use for subsequent calls.
  var path_594760 = newJObject()
  var query_594761 = newJObject()
  add(path_594760, "namespaceName", newJString(namespaceName))
  add(path_594760, "resourceGroupName", newJString(resourceGroupName))
  add(query_594761, "api-version", newJString(apiVersion))
  add(path_594760, "topicName", newJString(topicName))
  add(path_594760, "subscriptionId", newJString(subscriptionId))
  add(query_594761, "$top", newJInt(Top))
  add(path_594760, "subscriptionName", newJString(subscriptionName))
  add(query_594761, "$skip", newJInt(Skip))
  result = call_594759.call(path_594760, query_594761, nil, nil, nil)

var rulesListBySubscriptions* = Call_RulesListBySubscriptions_594747(
    name: "rulesListBySubscriptions", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/topics/{topicName}/subscriptions/{subscriptionName}/rules",
    validator: validate_RulesListBySubscriptions_594748, base: "",
    url: url_RulesListBySubscriptions_594749, schemes: {Scheme.Https})
type
  Call_RulesCreateOrUpdate_594776 = ref object of OpenApiRestCall_593437
proc url_RulesCreateOrUpdate_594778(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "topicName" in path, "`topicName` is a required path parameter"
  assert "subscriptionName" in path,
        "`subscriptionName` is a required path parameter"
  assert "ruleName" in path, "`ruleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceBus/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/topics/"),
               (kind: VariableSegment, value: "topicName"),
               (kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionName"),
               (kind: ConstantSegment, value: "/rules/"),
               (kind: VariableSegment, value: "ruleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RulesCreateOrUpdate_594777(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Creates a new rule and updates an existing rule
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   topicName: JString (required)
  ##            : The topic name.
  ##   ruleName: JString (required)
  ##           : The rule name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   subscriptionName: JString (required)
  ##                   : The subscription name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_594779 = path.getOrDefault("namespaceName")
  valid_594779 = validateParameter(valid_594779, JString, required = true,
                                 default = nil)
  if valid_594779 != nil:
    section.add "namespaceName", valid_594779
  var valid_594780 = path.getOrDefault("resourceGroupName")
  valid_594780 = validateParameter(valid_594780, JString, required = true,
                                 default = nil)
  if valid_594780 != nil:
    section.add "resourceGroupName", valid_594780
  var valid_594781 = path.getOrDefault("topicName")
  valid_594781 = validateParameter(valid_594781, JString, required = true,
                                 default = nil)
  if valid_594781 != nil:
    section.add "topicName", valid_594781
  var valid_594782 = path.getOrDefault("ruleName")
  valid_594782 = validateParameter(valid_594782, JString, required = true,
                                 default = nil)
  if valid_594782 != nil:
    section.add "ruleName", valid_594782
  var valid_594783 = path.getOrDefault("subscriptionId")
  valid_594783 = validateParameter(valid_594783, JString, required = true,
                                 default = nil)
  if valid_594783 != nil:
    section.add "subscriptionId", valid_594783
  var valid_594784 = path.getOrDefault("subscriptionName")
  valid_594784 = validateParameter(valid_594784, JString, required = true,
                                 default = nil)
  if valid_594784 != nil:
    section.add "subscriptionName", valid_594784
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594785 = query.getOrDefault("api-version")
  valid_594785 = validateParameter(valid_594785, JString, required = true,
                                 default = nil)
  if valid_594785 != nil:
    section.add "api-version", valid_594785
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to create a rule.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594787: Call_RulesCreateOrUpdate_594776; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new rule and updates an existing rule
  ## 
  let valid = call_594787.validator(path, query, header, formData, body)
  let scheme = call_594787.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594787.url(scheme.get, call_594787.host, call_594787.base,
                         call_594787.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594787, url, valid)

proc call*(call_594788: Call_RulesCreateOrUpdate_594776; namespaceName: string;
          resourceGroupName: string; apiVersion: string; topicName: string;
          ruleName: string; subscriptionId: string; subscriptionName: string;
          parameters: JsonNode): Recallable =
  ## rulesCreateOrUpdate
  ## Creates a new rule and updates an existing rule
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   topicName: string (required)
  ##            : The topic name.
  ##   ruleName: string (required)
  ##           : The rule name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   subscriptionName: string (required)
  ##                   : The subscription name.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to create a rule.
  var path_594789 = newJObject()
  var query_594790 = newJObject()
  var body_594791 = newJObject()
  add(path_594789, "namespaceName", newJString(namespaceName))
  add(path_594789, "resourceGroupName", newJString(resourceGroupName))
  add(query_594790, "api-version", newJString(apiVersion))
  add(path_594789, "topicName", newJString(topicName))
  add(path_594789, "ruleName", newJString(ruleName))
  add(path_594789, "subscriptionId", newJString(subscriptionId))
  add(path_594789, "subscriptionName", newJString(subscriptionName))
  if parameters != nil:
    body_594791 = parameters
  result = call_594788.call(path_594789, query_594790, nil, nil, body_594791)

var rulesCreateOrUpdate* = Call_RulesCreateOrUpdate_594776(
    name: "rulesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/topics/{topicName}/subscriptions/{subscriptionName}/rules/{ruleName}",
    validator: validate_RulesCreateOrUpdate_594777, base: "",
    url: url_RulesCreateOrUpdate_594778, schemes: {Scheme.Https})
type
  Call_RulesGet_594762 = ref object of OpenApiRestCall_593437
proc url_RulesGet_594764(protocol: Scheme; host: string; base: string; route: string;
                        path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "topicName" in path, "`topicName` is a required path parameter"
  assert "subscriptionName" in path,
        "`subscriptionName` is a required path parameter"
  assert "ruleName" in path, "`ruleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceBus/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/topics/"),
               (kind: VariableSegment, value: "topicName"),
               (kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionName"),
               (kind: ConstantSegment, value: "/rules/"),
               (kind: VariableSegment, value: "ruleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RulesGet_594763(path: JsonNode; query: JsonNode; header: JsonNode;
                             formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the description for the specified rule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   topicName: JString (required)
  ##            : The topic name.
  ##   ruleName: JString (required)
  ##           : The rule name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   subscriptionName: JString (required)
  ##                   : The subscription name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_594765 = path.getOrDefault("namespaceName")
  valid_594765 = validateParameter(valid_594765, JString, required = true,
                                 default = nil)
  if valid_594765 != nil:
    section.add "namespaceName", valid_594765
  var valid_594766 = path.getOrDefault("resourceGroupName")
  valid_594766 = validateParameter(valid_594766, JString, required = true,
                                 default = nil)
  if valid_594766 != nil:
    section.add "resourceGroupName", valid_594766
  var valid_594767 = path.getOrDefault("topicName")
  valid_594767 = validateParameter(valid_594767, JString, required = true,
                                 default = nil)
  if valid_594767 != nil:
    section.add "topicName", valid_594767
  var valid_594768 = path.getOrDefault("ruleName")
  valid_594768 = validateParameter(valid_594768, JString, required = true,
                                 default = nil)
  if valid_594768 != nil:
    section.add "ruleName", valid_594768
  var valid_594769 = path.getOrDefault("subscriptionId")
  valid_594769 = validateParameter(valid_594769, JString, required = true,
                                 default = nil)
  if valid_594769 != nil:
    section.add "subscriptionId", valid_594769
  var valid_594770 = path.getOrDefault("subscriptionName")
  valid_594770 = validateParameter(valid_594770, JString, required = true,
                                 default = nil)
  if valid_594770 != nil:
    section.add "subscriptionName", valid_594770
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594771 = query.getOrDefault("api-version")
  valid_594771 = validateParameter(valid_594771, JString, required = true,
                                 default = nil)
  if valid_594771 != nil:
    section.add "api-version", valid_594771
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594772: Call_RulesGet_594762; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the description for the specified rule.
  ## 
  let valid = call_594772.validator(path, query, header, formData, body)
  let scheme = call_594772.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594772.url(scheme.get, call_594772.host, call_594772.base,
                         call_594772.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594772, url, valid)

proc call*(call_594773: Call_RulesGet_594762; namespaceName: string;
          resourceGroupName: string; apiVersion: string; topicName: string;
          ruleName: string; subscriptionId: string; subscriptionName: string): Recallable =
  ## rulesGet
  ## Retrieves the description for the specified rule.
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   topicName: string (required)
  ##            : The topic name.
  ##   ruleName: string (required)
  ##           : The rule name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   subscriptionName: string (required)
  ##                   : The subscription name.
  var path_594774 = newJObject()
  var query_594775 = newJObject()
  add(path_594774, "namespaceName", newJString(namespaceName))
  add(path_594774, "resourceGroupName", newJString(resourceGroupName))
  add(query_594775, "api-version", newJString(apiVersion))
  add(path_594774, "topicName", newJString(topicName))
  add(path_594774, "ruleName", newJString(ruleName))
  add(path_594774, "subscriptionId", newJString(subscriptionId))
  add(path_594774, "subscriptionName", newJString(subscriptionName))
  result = call_594773.call(path_594774, query_594775, nil, nil, nil)

var rulesGet* = Call_RulesGet_594762(name: "rulesGet", meth: HttpMethod.HttpGet,
                                  host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/topics/{topicName}/subscriptions/{subscriptionName}/rules/{ruleName}",
                                  validator: validate_RulesGet_594763, base: "",
                                  url: url_RulesGet_594764,
                                  schemes: {Scheme.Https})
type
  Call_RulesDelete_594792 = ref object of OpenApiRestCall_593437
proc url_RulesDelete_594794(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "topicName" in path, "`topicName` is a required path parameter"
  assert "subscriptionName" in path,
        "`subscriptionName` is a required path parameter"
  assert "ruleName" in path, "`ruleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceBus/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/topics/"),
               (kind: VariableSegment, value: "topicName"),
               (kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionName"),
               (kind: ConstantSegment, value: "/rules/"),
               (kind: VariableSegment, value: "ruleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RulesDelete_594793(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an existing rule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   topicName: JString (required)
  ##            : The topic name.
  ##   ruleName: JString (required)
  ##           : The rule name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   subscriptionName: JString (required)
  ##                   : The subscription name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_594795 = path.getOrDefault("namespaceName")
  valid_594795 = validateParameter(valid_594795, JString, required = true,
                                 default = nil)
  if valid_594795 != nil:
    section.add "namespaceName", valid_594795
  var valid_594796 = path.getOrDefault("resourceGroupName")
  valid_594796 = validateParameter(valid_594796, JString, required = true,
                                 default = nil)
  if valid_594796 != nil:
    section.add "resourceGroupName", valid_594796
  var valid_594797 = path.getOrDefault("topicName")
  valid_594797 = validateParameter(valid_594797, JString, required = true,
                                 default = nil)
  if valid_594797 != nil:
    section.add "topicName", valid_594797
  var valid_594798 = path.getOrDefault("ruleName")
  valid_594798 = validateParameter(valid_594798, JString, required = true,
                                 default = nil)
  if valid_594798 != nil:
    section.add "ruleName", valid_594798
  var valid_594799 = path.getOrDefault("subscriptionId")
  valid_594799 = validateParameter(valid_594799, JString, required = true,
                                 default = nil)
  if valid_594799 != nil:
    section.add "subscriptionId", valid_594799
  var valid_594800 = path.getOrDefault("subscriptionName")
  valid_594800 = validateParameter(valid_594800, JString, required = true,
                                 default = nil)
  if valid_594800 != nil:
    section.add "subscriptionName", valid_594800
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594801 = query.getOrDefault("api-version")
  valid_594801 = validateParameter(valid_594801, JString, required = true,
                                 default = nil)
  if valid_594801 != nil:
    section.add "api-version", valid_594801
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594802: Call_RulesDelete_594792; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an existing rule.
  ## 
  let valid = call_594802.validator(path, query, header, formData, body)
  let scheme = call_594802.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594802.url(scheme.get, call_594802.host, call_594802.base,
                         call_594802.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594802, url, valid)

proc call*(call_594803: Call_RulesDelete_594792; namespaceName: string;
          resourceGroupName: string; apiVersion: string; topicName: string;
          ruleName: string; subscriptionId: string; subscriptionName: string): Recallable =
  ## rulesDelete
  ## Deletes an existing rule.
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   topicName: string (required)
  ##            : The topic name.
  ##   ruleName: string (required)
  ##           : The rule name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   subscriptionName: string (required)
  ##                   : The subscription name.
  var path_594804 = newJObject()
  var query_594805 = newJObject()
  add(path_594804, "namespaceName", newJString(namespaceName))
  add(path_594804, "resourceGroupName", newJString(resourceGroupName))
  add(query_594805, "api-version", newJString(apiVersion))
  add(path_594804, "topicName", newJString(topicName))
  add(path_594804, "ruleName", newJString(ruleName))
  add(path_594804, "subscriptionId", newJString(subscriptionId))
  add(path_594804, "subscriptionName", newJString(subscriptionName))
  result = call_594803.call(path_594804, query_594805, nil, nil, nil)

var rulesDelete* = Call_RulesDelete_594792(name: "rulesDelete",
                                        meth: HttpMethod.HttpDelete,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceBus/namespaces/{namespaceName}/topics/{topicName}/subscriptions/{subscriptionName}/rules/{ruleName}",
                                        validator: validate_RulesDelete_594793,
                                        base: "", url: url_RulesDelete_594794,
                                        schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
