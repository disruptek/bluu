
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: EventHubManagementClient
## version: 2015-08-01
## termsOfService: (not provided)
## license: (not provided)
## 
## Azure Event Hubs client
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
  macServiceName = "eventhub-EventHub"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_593646 = ref object of OpenApiRestCall_593424
proc url_OperationsList_593648(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_593647(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists all of the available Event Hub REST API operations.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593807 = query.getOrDefault("api-version")
  valid_593807 = validateParameter(valid_593807, JString, required = true,
                                 default = nil)
  if valid_593807 != nil:
    section.add "api-version", valid_593807
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593830: Call_OperationsList_593646; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available Event Hub REST API operations.
  ## 
  let valid = call_593830.validator(path, query, header, formData, body)
  let scheme = call_593830.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593830.url(scheme.get, call_593830.host, call_593830.base,
                         call_593830.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593830, url, valid)

proc call*(call_593901: Call_OperationsList_593646; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available Event Hub REST API operations.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  var query_593902 = newJObject()
  add(query_593902, "api-version", newJString(apiVersion))
  result = call_593901.call(nil, query_593902, nil, nil, nil)

var operationsList* = Call_OperationsList_593646(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.EventHub/operations",
    validator: validate_OperationsList_593647, base: "", url: url_OperationsList_593648,
    schemes: {Scheme.Https})
type
  Call_NamespacesCheckNameAvailability_593942 = ref object of OpenApiRestCall_593424
proc url_NamespacesCheckNameAvailability_593944(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.EventHub/CheckNameAvailability")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesCheckNameAvailability_593943(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Check the give Namespace name availability.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_593976 = path.getOrDefault("subscriptionId")
  valid_593976 = validateParameter(valid_593976, JString, required = true,
                                 default = nil)
  if valid_593976 != nil:
    section.add "subscriptionId", valid_593976
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593977 = query.getOrDefault("api-version")
  valid_593977 = validateParameter(valid_593977, JString, required = true,
                                 default = nil)
  if valid_593977 != nil:
    section.add "api-version", valid_593977
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters to check availability of the given Namespace name
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_593979: Call_NamespacesCheckNameAvailability_593942;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Check the give Namespace name availability.
  ## 
  let valid = call_593979.validator(path, query, header, formData, body)
  let scheme = call_593979.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593979.url(scheme.get, call_593979.host, call_593979.base,
                         call_593979.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593979, url, valid)

proc call*(call_593980: Call_NamespacesCheckNameAvailability_593942;
          apiVersion: string; subscriptionId: string; parameters: JsonNode): Recallable =
  ## namespacesCheckNameAvailability
  ## Check the give Namespace name availability.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters to check availability of the given Namespace name
  var path_593981 = newJObject()
  var query_593982 = newJObject()
  var body_593983 = newJObject()
  add(query_593982, "api-version", newJString(apiVersion))
  add(path_593981, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_593983 = parameters
  result = call_593980.call(path_593981, query_593982, nil, nil, body_593983)

var namespacesCheckNameAvailability* = Call_NamespacesCheckNameAvailability_593942(
    name: "namespacesCheckNameAvailability", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.EventHub/CheckNameAvailability",
    validator: validate_NamespacesCheckNameAvailability_593943, base: "",
    url: url_NamespacesCheckNameAvailability_593944, schemes: {Scheme.Https})
type
  Call_NamespacesListBySubscription_593984 = ref object of OpenApiRestCall_593424
proc url_NamespacesListBySubscription_593986(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.EventHub/namespaces")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesListBySubscription_593985(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all the available Namespaces within a subscription, irrespective of the resource groups.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_593987 = path.getOrDefault("subscriptionId")
  valid_593987 = validateParameter(valid_593987, JString, required = true,
                                 default = nil)
  if valid_593987 != nil:
    section.add "subscriptionId", valid_593987
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593988 = query.getOrDefault("api-version")
  valid_593988 = validateParameter(valid_593988, JString, required = true,
                                 default = nil)
  if valid_593988 != nil:
    section.add "api-version", valid_593988
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593989: Call_NamespacesListBySubscription_593984; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the available Namespaces within a subscription, irrespective of the resource groups.
  ## 
  let valid = call_593989.validator(path, query, header, formData, body)
  let scheme = call_593989.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593989.url(scheme.get, call_593989.host, call_593989.base,
                         call_593989.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593989, url, valid)

proc call*(call_593990: Call_NamespacesListBySubscription_593984;
          apiVersion: string; subscriptionId: string): Recallable =
  ## namespacesListBySubscription
  ## Lists all the available Namespaces within a subscription, irrespective of the resource groups.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_593991 = newJObject()
  var query_593992 = newJObject()
  add(query_593992, "api-version", newJString(apiVersion))
  add(path_593991, "subscriptionId", newJString(subscriptionId))
  result = call_593990.call(path_593991, query_593992, nil, nil, nil)

var namespacesListBySubscription* = Call_NamespacesListBySubscription_593984(
    name: "namespacesListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.EventHub/namespaces",
    validator: validate_NamespacesListBySubscription_593985, base: "",
    url: url_NamespacesListBySubscription_593986, schemes: {Scheme.Https})
type
  Call_NamespacesListByResourceGroup_593993 = ref object of OpenApiRestCall_593424
proc url_NamespacesListByResourceGroup_593995(protocol: Scheme; host: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.EventHub/namespaces")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesListByResourceGroup_593994(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the available Namespaces within a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_593996 = path.getOrDefault("resourceGroupName")
  valid_593996 = validateParameter(valid_593996, JString, required = true,
                                 default = nil)
  if valid_593996 != nil:
    section.add "resourceGroupName", valid_593996
  var valid_593997 = path.getOrDefault("subscriptionId")
  valid_593997 = validateParameter(valid_593997, JString, required = true,
                                 default = nil)
  if valid_593997 != nil:
    section.add "subscriptionId", valid_593997
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593998 = query.getOrDefault("api-version")
  valid_593998 = validateParameter(valid_593998, JString, required = true,
                                 default = nil)
  if valid_593998 != nil:
    section.add "api-version", valid_593998
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593999: Call_NamespacesListByResourceGroup_593993; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the available Namespaces within a resource group.
  ## 
  let valid = call_593999.validator(path, query, header, formData, body)
  let scheme = call_593999.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593999.url(scheme.get, call_593999.host, call_593999.base,
                         call_593999.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593999, url, valid)

proc call*(call_594000: Call_NamespacesListByResourceGroup_593993;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## namespacesListByResourceGroup
  ## Lists the available Namespaces within a resource group.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594001 = newJObject()
  var query_594002 = newJObject()
  add(path_594001, "resourceGroupName", newJString(resourceGroupName))
  add(query_594002, "api-version", newJString(apiVersion))
  add(path_594001, "subscriptionId", newJString(subscriptionId))
  result = call_594000.call(path_594001, query_594002, nil, nil, nil)

var namespacesListByResourceGroup* = Call_NamespacesListByResourceGroup_593993(
    name: "namespacesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces",
    validator: validate_NamespacesListByResourceGroup_593994, base: "",
    url: url_NamespacesListByResourceGroup_593995, schemes: {Scheme.Https})
type
  Call_NamespacesCreateOrUpdate_594014 = ref object of OpenApiRestCall_593424
proc url_NamespacesCreateOrUpdate_594016(protocol: Scheme; host: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.EventHub/namespaces/"),
               (kind: VariableSegment, value: "namespaceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesCreateOrUpdate_594015(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a namespace. Once created, this namespace's resource manifest is immutable. This operation is idempotent.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_594017 = path.getOrDefault("namespaceName")
  valid_594017 = validateParameter(valid_594017, JString, required = true,
                                 default = nil)
  if valid_594017 != nil:
    section.add "namespaceName", valid_594017
  var valid_594018 = path.getOrDefault("resourceGroupName")
  valid_594018 = validateParameter(valid_594018, JString, required = true,
                                 default = nil)
  if valid_594018 != nil:
    section.add "resourceGroupName", valid_594018
  var valid_594019 = path.getOrDefault("subscriptionId")
  valid_594019 = validateParameter(valid_594019, JString, required = true,
                                 default = nil)
  if valid_594019 != nil:
    section.add "subscriptionId", valid_594019
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
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
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters for creating a namespace resource.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594022: Call_NamespacesCreateOrUpdate_594014; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a namespace. Once created, this namespace's resource manifest is immutable. This operation is idempotent.
  ## 
  let valid = call_594022.validator(path, query, header, formData, body)
  let scheme = call_594022.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594022.url(scheme.get, call_594022.host, call_594022.base,
                         call_594022.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594022, url, valid)

proc call*(call_594023: Call_NamespacesCreateOrUpdate_594014;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; parameters: JsonNode): Recallable =
  ## namespacesCreateOrUpdate
  ## Creates or updates a namespace. Once created, this namespace's resource manifest is immutable. This operation is idempotent.
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters for creating a namespace resource.
  var path_594024 = newJObject()
  var query_594025 = newJObject()
  var body_594026 = newJObject()
  add(path_594024, "namespaceName", newJString(namespaceName))
  add(path_594024, "resourceGroupName", newJString(resourceGroupName))
  add(query_594025, "api-version", newJString(apiVersion))
  add(path_594024, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594026 = parameters
  result = call_594023.call(path_594024, query_594025, nil, nil, body_594026)

var namespacesCreateOrUpdate* = Call_NamespacesCreateOrUpdate_594014(
    name: "namespacesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}",
    validator: validate_NamespacesCreateOrUpdate_594015, base: "",
    url: url_NamespacesCreateOrUpdate_594016, schemes: {Scheme.Https})
type
  Call_NamespacesGet_594003 = ref object of OpenApiRestCall_593424
proc url_NamespacesGet_594005(protocol: Scheme; host: string; base: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.EventHub/namespaces/"),
               (kind: VariableSegment, value: "namespaceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesGet_594004(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the description of the specified namespace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_594006 = path.getOrDefault("namespaceName")
  valid_594006 = validateParameter(valid_594006, JString, required = true,
                                 default = nil)
  if valid_594006 != nil:
    section.add "namespaceName", valid_594006
  var valid_594007 = path.getOrDefault("resourceGroupName")
  valid_594007 = validateParameter(valid_594007, JString, required = true,
                                 default = nil)
  if valid_594007 != nil:
    section.add "resourceGroupName", valid_594007
  var valid_594008 = path.getOrDefault("subscriptionId")
  valid_594008 = validateParameter(valid_594008, JString, required = true,
                                 default = nil)
  if valid_594008 != nil:
    section.add "subscriptionId", valid_594008
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594009 = query.getOrDefault("api-version")
  valid_594009 = validateParameter(valid_594009, JString, required = true,
                                 default = nil)
  if valid_594009 != nil:
    section.add "api-version", valid_594009
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594010: Call_NamespacesGet_594003; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the description of the specified namespace.
  ## 
  let valid = call_594010.validator(path, query, header, formData, body)
  let scheme = call_594010.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594010.url(scheme.get, call_594010.host, call_594010.base,
                         call_594010.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594010, url, valid)

proc call*(call_594011: Call_NamespacesGet_594003; namespaceName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## namespacesGet
  ## Gets the description of the specified namespace.
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594012 = newJObject()
  var query_594013 = newJObject()
  add(path_594012, "namespaceName", newJString(namespaceName))
  add(path_594012, "resourceGroupName", newJString(resourceGroupName))
  add(query_594013, "api-version", newJString(apiVersion))
  add(path_594012, "subscriptionId", newJString(subscriptionId))
  result = call_594011.call(path_594012, query_594013, nil, nil, nil)

var namespacesGet* = Call_NamespacesGet_594003(name: "namespacesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}",
    validator: validate_NamespacesGet_594004, base: "", url: url_NamespacesGet_594005,
    schemes: {Scheme.Https})
type
  Call_NamespacesUpdate_594038 = ref object of OpenApiRestCall_593424
proc url_NamespacesUpdate_594040(protocol: Scheme; host: string; base: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.EventHub/namespaces/"),
               (kind: VariableSegment, value: "namespaceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesUpdate_594039(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Creates or updates a namespace. Once created, this namespace's resource manifest is immutable. This operation is idempotent.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_594041 = path.getOrDefault("namespaceName")
  valid_594041 = validateParameter(valid_594041, JString, required = true,
                                 default = nil)
  if valid_594041 != nil:
    section.add "namespaceName", valid_594041
  var valid_594042 = path.getOrDefault("resourceGroupName")
  valid_594042 = validateParameter(valid_594042, JString, required = true,
                                 default = nil)
  if valid_594042 != nil:
    section.add "resourceGroupName", valid_594042
  var valid_594043 = path.getOrDefault("subscriptionId")
  valid_594043 = validateParameter(valid_594043, JString, required = true,
                                 default = nil)
  if valid_594043 != nil:
    section.add "subscriptionId", valid_594043
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594044 = query.getOrDefault("api-version")
  valid_594044 = validateParameter(valid_594044, JString, required = true,
                                 default = nil)
  if valid_594044 != nil:
    section.add "api-version", valid_594044
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters for updating a namespace resource.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594046: Call_NamespacesUpdate_594038; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a namespace. Once created, this namespace's resource manifest is immutable. This operation is idempotent.
  ## 
  let valid = call_594046.validator(path, query, header, formData, body)
  let scheme = call_594046.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594046.url(scheme.get, call_594046.host, call_594046.base,
                         call_594046.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594046, url, valid)

proc call*(call_594047: Call_NamespacesUpdate_594038; namespaceName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode): Recallable =
  ## namespacesUpdate
  ## Creates or updates a namespace. Once created, this namespace's resource manifest is immutable. This operation is idempotent.
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters for updating a namespace resource.
  var path_594048 = newJObject()
  var query_594049 = newJObject()
  var body_594050 = newJObject()
  add(path_594048, "namespaceName", newJString(namespaceName))
  add(path_594048, "resourceGroupName", newJString(resourceGroupName))
  add(query_594049, "api-version", newJString(apiVersion))
  add(path_594048, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594050 = parameters
  result = call_594047.call(path_594048, query_594049, nil, nil, body_594050)

var namespacesUpdate* = Call_NamespacesUpdate_594038(name: "namespacesUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}",
    validator: validate_NamespacesUpdate_594039, base: "",
    url: url_NamespacesUpdate_594040, schemes: {Scheme.Https})
type
  Call_NamespacesDelete_594027 = ref object of OpenApiRestCall_593424
proc url_NamespacesDelete_594029(protocol: Scheme; host: string; base: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.EventHub/namespaces/"),
               (kind: VariableSegment, value: "namespaceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesDelete_594028(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Deletes an existing namespace. This operation also removes all associated resources under the namespace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_594030 = path.getOrDefault("namespaceName")
  valid_594030 = validateParameter(valid_594030, JString, required = true,
                                 default = nil)
  if valid_594030 != nil:
    section.add "namespaceName", valid_594030
  var valid_594031 = path.getOrDefault("resourceGroupName")
  valid_594031 = validateParameter(valid_594031, JString, required = true,
                                 default = nil)
  if valid_594031 != nil:
    section.add "resourceGroupName", valid_594031
  var valid_594032 = path.getOrDefault("subscriptionId")
  valid_594032 = validateParameter(valid_594032, JString, required = true,
                                 default = nil)
  if valid_594032 != nil:
    section.add "subscriptionId", valid_594032
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594033 = query.getOrDefault("api-version")
  valid_594033 = validateParameter(valid_594033, JString, required = true,
                                 default = nil)
  if valid_594033 != nil:
    section.add "api-version", valid_594033
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594034: Call_NamespacesDelete_594027; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an existing namespace. This operation also removes all associated resources under the namespace.
  ## 
  let valid = call_594034.validator(path, query, header, formData, body)
  let scheme = call_594034.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594034.url(scheme.get, call_594034.host, call_594034.base,
                         call_594034.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594034, url, valid)

proc call*(call_594035: Call_NamespacesDelete_594027; namespaceName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## namespacesDelete
  ## Deletes an existing namespace. This operation also removes all associated resources under the namespace.
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594036 = newJObject()
  var query_594037 = newJObject()
  add(path_594036, "namespaceName", newJString(namespaceName))
  add(path_594036, "resourceGroupName", newJString(resourceGroupName))
  add(query_594037, "api-version", newJString(apiVersion))
  add(path_594036, "subscriptionId", newJString(subscriptionId))
  result = call_594035.call(path_594036, query_594037, nil, nil, nil)

var namespacesDelete* = Call_NamespacesDelete_594027(name: "namespacesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}",
    validator: validate_NamespacesDelete_594028, base: "",
    url: url_NamespacesDelete_594029, schemes: {Scheme.Https})
type
  Call_NamespacesListAuthorizationRules_594051 = ref object of OpenApiRestCall_593424
proc url_NamespacesListAuthorizationRules_594053(protocol: Scheme; host: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.EventHub/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/AuthorizationRules")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesListAuthorizationRules_594052(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of authorization rules for a Namespace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_594054 = path.getOrDefault("namespaceName")
  valid_594054 = validateParameter(valid_594054, JString, required = true,
                                 default = nil)
  if valid_594054 != nil:
    section.add "namespaceName", valid_594054
  var valid_594055 = path.getOrDefault("resourceGroupName")
  valid_594055 = validateParameter(valid_594055, JString, required = true,
                                 default = nil)
  if valid_594055 != nil:
    section.add "resourceGroupName", valid_594055
  var valid_594056 = path.getOrDefault("subscriptionId")
  valid_594056 = validateParameter(valid_594056, JString, required = true,
                                 default = nil)
  if valid_594056 != nil:
    section.add "subscriptionId", valid_594056
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594057 = query.getOrDefault("api-version")
  valid_594057 = validateParameter(valid_594057, JString, required = true,
                                 default = nil)
  if valid_594057 != nil:
    section.add "api-version", valid_594057
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594058: Call_NamespacesListAuthorizationRules_594051;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of authorization rules for a Namespace.
  ## 
  let valid = call_594058.validator(path, query, header, formData, body)
  let scheme = call_594058.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594058.url(scheme.get, call_594058.host, call_594058.base,
                         call_594058.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594058, url, valid)

proc call*(call_594059: Call_NamespacesListAuthorizationRules_594051;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## namespacesListAuthorizationRules
  ## Gets a list of authorization rules for a Namespace.
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594060 = newJObject()
  var query_594061 = newJObject()
  add(path_594060, "namespaceName", newJString(namespaceName))
  add(path_594060, "resourceGroupName", newJString(resourceGroupName))
  add(query_594061, "api-version", newJString(apiVersion))
  add(path_594060, "subscriptionId", newJString(subscriptionId))
  result = call_594059.call(path_594060, query_594061, nil, nil, nil)

var namespacesListAuthorizationRules* = Call_NamespacesListAuthorizationRules_594051(
    name: "namespacesListAuthorizationRules", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/AuthorizationRules",
    validator: validate_NamespacesListAuthorizationRules_594052, base: "",
    url: url_NamespacesListAuthorizationRules_594053, schemes: {Scheme.Https})
type
  Call_NamespacesCreateOrUpdateAuthorizationRule_594074 = ref object of OpenApiRestCall_593424
proc url_NamespacesCreateOrUpdateAuthorizationRule_594076(protocol: Scheme;
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
        kind: ConstantSegment, value: "/providers/Microsoft.EventHub/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/AuthorizationRules/"),
               (kind: VariableSegment, value: "authorizationRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesCreateOrUpdateAuthorizationRule_594075(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates an AuthorizationRule for a Namespace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   authorizationRuleName: JString (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_594077 = path.getOrDefault("namespaceName")
  valid_594077 = validateParameter(valid_594077, JString, required = true,
                                 default = nil)
  if valid_594077 != nil:
    section.add "namespaceName", valid_594077
  var valid_594078 = path.getOrDefault("resourceGroupName")
  valid_594078 = validateParameter(valid_594078, JString, required = true,
                                 default = nil)
  if valid_594078 != nil:
    section.add "resourceGroupName", valid_594078
  var valid_594079 = path.getOrDefault("authorizationRuleName")
  valid_594079 = validateParameter(valid_594079, JString, required = true,
                                 default = nil)
  if valid_594079 != nil:
    section.add "authorizationRuleName", valid_594079
  var valid_594080 = path.getOrDefault("subscriptionId")
  valid_594080 = validateParameter(valid_594080, JString, required = true,
                                 default = nil)
  if valid_594080 != nil:
    section.add "subscriptionId", valid_594080
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594081 = query.getOrDefault("api-version")
  valid_594081 = validateParameter(valid_594081, JString, required = true,
                                 default = nil)
  if valid_594081 != nil:
    section.add "api-version", valid_594081
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The shared access AuthorizationRule.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594083: Call_NamespacesCreateOrUpdateAuthorizationRule_594074;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates an AuthorizationRule for a Namespace.
  ## 
  let valid = call_594083.validator(path, query, header, formData, body)
  let scheme = call_594083.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594083.url(scheme.get, call_594083.host, call_594083.base,
                         call_594083.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594083, url, valid)

proc call*(call_594084: Call_NamespacesCreateOrUpdateAuthorizationRule_594074;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          authorizationRuleName: string; subscriptionId: string;
          parameters: JsonNode): Recallable =
  ## namespacesCreateOrUpdateAuthorizationRule
  ## Creates or updates an AuthorizationRule for a Namespace.
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   authorizationRuleName: string (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : The shared access AuthorizationRule.
  var path_594085 = newJObject()
  var query_594086 = newJObject()
  var body_594087 = newJObject()
  add(path_594085, "namespaceName", newJString(namespaceName))
  add(path_594085, "resourceGroupName", newJString(resourceGroupName))
  add(query_594086, "api-version", newJString(apiVersion))
  add(path_594085, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_594085, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594087 = parameters
  result = call_594084.call(path_594085, query_594086, nil, nil, body_594087)

var namespacesCreateOrUpdateAuthorizationRule* = Call_NamespacesCreateOrUpdateAuthorizationRule_594074(
    name: "namespacesCreateOrUpdateAuthorizationRule", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/AuthorizationRules/{authorizationRuleName}",
    validator: validate_NamespacesCreateOrUpdateAuthorizationRule_594075,
    base: "", url: url_NamespacesCreateOrUpdateAuthorizationRule_594076,
    schemes: {Scheme.Https})
type
  Call_NamespacesGetAuthorizationRule_594062 = ref object of OpenApiRestCall_593424
proc url_NamespacesGetAuthorizationRule_594064(protocol: Scheme; host: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.EventHub/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/AuthorizationRules/"),
               (kind: VariableSegment, value: "authorizationRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesGetAuthorizationRule_594063(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets an AuthorizationRule for a Namespace by rule name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   authorizationRuleName: JString (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_594065 = path.getOrDefault("namespaceName")
  valid_594065 = validateParameter(valid_594065, JString, required = true,
                                 default = nil)
  if valid_594065 != nil:
    section.add "namespaceName", valid_594065
  var valid_594066 = path.getOrDefault("resourceGroupName")
  valid_594066 = validateParameter(valid_594066, JString, required = true,
                                 default = nil)
  if valid_594066 != nil:
    section.add "resourceGroupName", valid_594066
  var valid_594067 = path.getOrDefault("authorizationRuleName")
  valid_594067 = validateParameter(valid_594067, JString, required = true,
                                 default = nil)
  if valid_594067 != nil:
    section.add "authorizationRuleName", valid_594067
  var valid_594068 = path.getOrDefault("subscriptionId")
  valid_594068 = validateParameter(valid_594068, JString, required = true,
                                 default = nil)
  if valid_594068 != nil:
    section.add "subscriptionId", valid_594068
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594069 = query.getOrDefault("api-version")
  valid_594069 = validateParameter(valid_594069, JString, required = true,
                                 default = nil)
  if valid_594069 != nil:
    section.add "api-version", valid_594069
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594070: Call_NamespacesGetAuthorizationRule_594062; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an AuthorizationRule for a Namespace by rule name.
  ## 
  let valid = call_594070.validator(path, query, header, formData, body)
  let scheme = call_594070.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594070.url(scheme.get, call_594070.host, call_594070.base,
                         call_594070.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594070, url, valid)

proc call*(call_594071: Call_NamespacesGetAuthorizationRule_594062;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          authorizationRuleName: string; subscriptionId: string): Recallable =
  ## namespacesGetAuthorizationRule
  ## Gets an AuthorizationRule for a Namespace by rule name.
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   authorizationRuleName: string (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594072 = newJObject()
  var query_594073 = newJObject()
  add(path_594072, "namespaceName", newJString(namespaceName))
  add(path_594072, "resourceGroupName", newJString(resourceGroupName))
  add(query_594073, "api-version", newJString(apiVersion))
  add(path_594072, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_594072, "subscriptionId", newJString(subscriptionId))
  result = call_594071.call(path_594072, query_594073, nil, nil, nil)

var namespacesGetAuthorizationRule* = Call_NamespacesGetAuthorizationRule_594062(
    name: "namespacesGetAuthorizationRule", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/AuthorizationRules/{authorizationRuleName}",
    validator: validate_NamespacesGetAuthorizationRule_594063, base: "",
    url: url_NamespacesGetAuthorizationRule_594064, schemes: {Scheme.Https})
type
  Call_NamespacesDeleteAuthorizationRule_594088 = ref object of OpenApiRestCall_593424
proc url_NamespacesDeleteAuthorizationRule_594090(protocol: Scheme; host: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.EventHub/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/AuthorizationRules/"),
               (kind: VariableSegment, value: "authorizationRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesDeleteAuthorizationRule_594089(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an AuthorizationRule for a Namespace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   authorizationRuleName: JString (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_594091 = path.getOrDefault("namespaceName")
  valid_594091 = validateParameter(valid_594091, JString, required = true,
                                 default = nil)
  if valid_594091 != nil:
    section.add "namespaceName", valid_594091
  var valid_594092 = path.getOrDefault("resourceGroupName")
  valid_594092 = validateParameter(valid_594092, JString, required = true,
                                 default = nil)
  if valid_594092 != nil:
    section.add "resourceGroupName", valid_594092
  var valid_594093 = path.getOrDefault("authorizationRuleName")
  valid_594093 = validateParameter(valid_594093, JString, required = true,
                                 default = nil)
  if valid_594093 != nil:
    section.add "authorizationRuleName", valid_594093
  var valid_594094 = path.getOrDefault("subscriptionId")
  valid_594094 = validateParameter(valid_594094, JString, required = true,
                                 default = nil)
  if valid_594094 != nil:
    section.add "subscriptionId", valid_594094
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594095 = query.getOrDefault("api-version")
  valid_594095 = validateParameter(valid_594095, JString, required = true,
                                 default = nil)
  if valid_594095 != nil:
    section.add "api-version", valid_594095
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594096: Call_NamespacesDeleteAuthorizationRule_594088;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an AuthorizationRule for a Namespace.
  ## 
  let valid = call_594096.validator(path, query, header, formData, body)
  let scheme = call_594096.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594096.url(scheme.get, call_594096.host, call_594096.base,
                         call_594096.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594096, url, valid)

proc call*(call_594097: Call_NamespacesDeleteAuthorizationRule_594088;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          authorizationRuleName: string; subscriptionId: string): Recallable =
  ## namespacesDeleteAuthorizationRule
  ## Deletes an AuthorizationRule for a Namespace.
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   authorizationRuleName: string (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594098 = newJObject()
  var query_594099 = newJObject()
  add(path_594098, "namespaceName", newJString(namespaceName))
  add(path_594098, "resourceGroupName", newJString(resourceGroupName))
  add(query_594099, "api-version", newJString(apiVersion))
  add(path_594098, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_594098, "subscriptionId", newJString(subscriptionId))
  result = call_594097.call(path_594098, query_594099, nil, nil, nil)

var namespacesDeleteAuthorizationRule* = Call_NamespacesDeleteAuthorizationRule_594088(
    name: "namespacesDeleteAuthorizationRule", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/AuthorizationRules/{authorizationRuleName}",
    validator: validate_NamespacesDeleteAuthorizationRule_594089, base: "",
    url: url_NamespacesDeleteAuthorizationRule_594090, schemes: {Scheme.Https})
type
  Call_NamespacesListKeys_594100 = ref object of OpenApiRestCall_593424
proc url_NamespacesListKeys_594102(protocol: Scheme; host: string; base: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.EventHub/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/AuthorizationRules/"),
               (kind: VariableSegment, value: "authorizationRuleName"),
               (kind: ConstantSegment, value: "/listKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesListKeys_594101(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Gets the primary and secondary connection strings for the Namespace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   authorizationRuleName: JString (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_594103 = path.getOrDefault("namespaceName")
  valid_594103 = validateParameter(valid_594103, JString, required = true,
                                 default = nil)
  if valid_594103 != nil:
    section.add "namespaceName", valid_594103
  var valid_594104 = path.getOrDefault("resourceGroupName")
  valid_594104 = validateParameter(valid_594104, JString, required = true,
                                 default = nil)
  if valid_594104 != nil:
    section.add "resourceGroupName", valid_594104
  var valid_594105 = path.getOrDefault("authorizationRuleName")
  valid_594105 = validateParameter(valid_594105, JString, required = true,
                                 default = nil)
  if valid_594105 != nil:
    section.add "authorizationRuleName", valid_594105
  var valid_594106 = path.getOrDefault("subscriptionId")
  valid_594106 = validateParameter(valid_594106, JString, required = true,
                                 default = nil)
  if valid_594106 != nil:
    section.add "subscriptionId", valid_594106
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594107 = query.getOrDefault("api-version")
  valid_594107 = validateParameter(valid_594107, JString, required = true,
                                 default = nil)
  if valid_594107 != nil:
    section.add "api-version", valid_594107
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594108: Call_NamespacesListKeys_594100; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the primary and secondary connection strings for the Namespace.
  ## 
  let valid = call_594108.validator(path, query, header, formData, body)
  let scheme = call_594108.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594108.url(scheme.get, call_594108.host, call_594108.base,
                         call_594108.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594108, url, valid)

proc call*(call_594109: Call_NamespacesListKeys_594100; namespaceName: string;
          resourceGroupName: string; apiVersion: string;
          authorizationRuleName: string; subscriptionId: string): Recallable =
  ## namespacesListKeys
  ## Gets the primary and secondary connection strings for the Namespace.
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   authorizationRuleName: string (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594110 = newJObject()
  var query_594111 = newJObject()
  add(path_594110, "namespaceName", newJString(namespaceName))
  add(path_594110, "resourceGroupName", newJString(resourceGroupName))
  add(query_594111, "api-version", newJString(apiVersion))
  add(path_594110, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_594110, "subscriptionId", newJString(subscriptionId))
  result = call_594109.call(path_594110, query_594111, nil, nil, nil)

var namespacesListKeys* = Call_NamespacesListKeys_594100(
    name: "namespacesListKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/AuthorizationRules/{authorizationRuleName}/listKeys",
    validator: validate_NamespacesListKeys_594101, base: "",
    url: url_NamespacesListKeys_594102, schemes: {Scheme.Https})
type
  Call_NamespacesRegenerateKeys_594112 = ref object of OpenApiRestCall_593424
proc url_NamespacesRegenerateKeys_594114(protocol: Scheme; host: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.EventHub/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/AuthorizationRules/"),
               (kind: VariableSegment, value: "authorizationRuleName"),
               (kind: ConstantSegment, value: "/regenerateKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesRegenerateKeys_594113(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Regenerates the primary or secondary connection strings for the specified Namespace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   authorizationRuleName: JString (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_594115 = path.getOrDefault("namespaceName")
  valid_594115 = validateParameter(valid_594115, JString, required = true,
                                 default = nil)
  if valid_594115 != nil:
    section.add "namespaceName", valid_594115
  var valid_594116 = path.getOrDefault("resourceGroupName")
  valid_594116 = validateParameter(valid_594116, JString, required = true,
                                 default = nil)
  if valid_594116 != nil:
    section.add "resourceGroupName", valid_594116
  var valid_594117 = path.getOrDefault("authorizationRuleName")
  valid_594117 = validateParameter(valid_594117, JString, required = true,
                                 default = nil)
  if valid_594117 != nil:
    section.add "authorizationRuleName", valid_594117
  var valid_594118 = path.getOrDefault("subscriptionId")
  valid_594118 = validateParameter(valid_594118, JString, required = true,
                                 default = nil)
  if valid_594118 != nil:
    section.add "subscriptionId", valid_594118
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594119 = query.getOrDefault("api-version")
  valid_594119 = validateParameter(valid_594119, JString, required = true,
                                 default = nil)
  if valid_594119 != nil:
    section.add "api-version", valid_594119
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters required to regenerate the connection string.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594121: Call_NamespacesRegenerateKeys_594112; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Regenerates the primary or secondary connection strings for the specified Namespace.
  ## 
  let valid = call_594121.validator(path, query, header, formData, body)
  let scheme = call_594121.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594121.url(scheme.get, call_594121.host, call_594121.base,
                         call_594121.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594121, url, valid)

proc call*(call_594122: Call_NamespacesRegenerateKeys_594112;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          authorizationRuleName: string; subscriptionId: string;
          parameters: JsonNode): Recallable =
  ## namespacesRegenerateKeys
  ## Regenerates the primary or secondary connection strings for the specified Namespace.
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   authorizationRuleName: string (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters required to regenerate the connection string.
  var path_594123 = newJObject()
  var query_594124 = newJObject()
  var body_594125 = newJObject()
  add(path_594123, "namespaceName", newJString(namespaceName))
  add(path_594123, "resourceGroupName", newJString(resourceGroupName))
  add(query_594124, "api-version", newJString(apiVersion))
  add(path_594123, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_594123, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594125 = parameters
  result = call_594122.call(path_594123, query_594124, nil, nil, body_594125)

var namespacesRegenerateKeys* = Call_NamespacesRegenerateKeys_594112(
    name: "namespacesRegenerateKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/AuthorizationRules/{authorizationRuleName}/regenerateKeys",
    validator: validate_NamespacesRegenerateKeys_594113, base: "",
    url: url_NamespacesRegenerateKeys_594114, schemes: {Scheme.Https})
type
  Call_EventHubsListAll_594126 = ref object of OpenApiRestCall_593424
proc url_EventHubsListAll_594128(protocol: Scheme; host: string; base: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.EventHub/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/eventhubs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EventHubsListAll_594127(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Gets all the Event Hubs in a Namespace.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639493.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_594129 = path.getOrDefault("namespaceName")
  valid_594129 = validateParameter(valid_594129, JString, required = true,
                                 default = nil)
  if valid_594129 != nil:
    section.add "namespaceName", valid_594129
  var valid_594130 = path.getOrDefault("resourceGroupName")
  valid_594130 = validateParameter(valid_594130, JString, required = true,
                                 default = nil)
  if valid_594130 != nil:
    section.add "resourceGroupName", valid_594130
  var valid_594131 = path.getOrDefault("subscriptionId")
  valid_594131 = validateParameter(valid_594131, JString, required = true,
                                 default = nil)
  if valid_594131 != nil:
    section.add "subscriptionId", valid_594131
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594132 = query.getOrDefault("api-version")
  valid_594132 = validateParameter(valid_594132, JString, required = true,
                                 default = nil)
  if valid_594132 != nil:
    section.add "api-version", valid_594132
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594133: Call_EventHubsListAll_594126; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the Event Hubs in a Namespace.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639493.aspx
  let valid = call_594133.validator(path, query, header, formData, body)
  let scheme = call_594133.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594133.url(scheme.get, call_594133.host, call_594133.base,
                         call_594133.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594133, url, valid)

proc call*(call_594134: Call_EventHubsListAll_594126; namespaceName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## eventHubsListAll
  ## Gets all the Event Hubs in a Namespace.
  ## https://msdn.microsoft.com/en-us/library/azure/mt639493.aspx
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594135 = newJObject()
  var query_594136 = newJObject()
  add(path_594135, "namespaceName", newJString(namespaceName))
  add(path_594135, "resourceGroupName", newJString(resourceGroupName))
  add(query_594136, "api-version", newJString(apiVersion))
  add(path_594135, "subscriptionId", newJString(subscriptionId))
  result = call_594134.call(path_594135, query_594136, nil, nil, nil)

var eventHubsListAll* = Call_EventHubsListAll_594126(name: "eventHubsListAll",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/eventhubs",
    validator: validate_EventHubsListAll_594127, base: "",
    url: url_EventHubsListAll_594128, schemes: {Scheme.Https})
type
  Call_EventHubsCreateOrUpdate_594149 = ref object of OpenApiRestCall_593424
proc url_EventHubsCreateOrUpdate_594151(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "eventHubName" in path, "`eventHubName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.EventHub/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/eventhubs/"),
               (kind: VariableSegment, value: "eventHubName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EventHubsCreateOrUpdate_594150(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a new Event Hub as a nested resource within a Namespace.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639497.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   eventHubName: JString (required)
  ##               : The Event Hub name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_594152 = path.getOrDefault("namespaceName")
  valid_594152 = validateParameter(valid_594152, JString, required = true,
                                 default = nil)
  if valid_594152 != nil:
    section.add "namespaceName", valid_594152
  var valid_594153 = path.getOrDefault("resourceGroupName")
  valid_594153 = validateParameter(valid_594153, JString, required = true,
                                 default = nil)
  if valid_594153 != nil:
    section.add "resourceGroupName", valid_594153
  var valid_594154 = path.getOrDefault("eventHubName")
  valid_594154 = validateParameter(valid_594154, JString, required = true,
                                 default = nil)
  if valid_594154 != nil:
    section.add "eventHubName", valid_594154
  var valid_594155 = path.getOrDefault("subscriptionId")
  valid_594155 = validateParameter(valid_594155, JString, required = true,
                                 default = nil)
  if valid_594155 != nil:
    section.add "subscriptionId", valid_594155
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594156 = query.getOrDefault("api-version")
  valid_594156 = validateParameter(valid_594156, JString, required = true,
                                 default = nil)
  if valid_594156 != nil:
    section.add "api-version", valid_594156
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to create an Event Hub resource.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594158: Call_EventHubsCreateOrUpdate_594149; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a new Event Hub as a nested resource within a Namespace.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639497.aspx
  let valid = call_594158.validator(path, query, header, formData, body)
  let scheme = call_594158.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594158.url(scheme.get, call_594158.host, call_594158.base,
                         call_594158.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594158, url, valid)

proc call*(call_594159: Call_EventHubsCreateOrUpdate_594149; namespaceName: string;
          resourceGroupName: string; apiVersion: string; eventHubName: string;
          subscriptionId: string; parameters: JsonNode): Recallable =
  ## eventHubsCreateOrUpdate
  ## Creates or updates a new Event Hub as a nested resource within a Namespace.
  ## https://msdn.microsoft.com/en-us/library/azure/mt639497.aspx
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   eventHubName: string (required)
  ##               : The Event Hub name
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to create an Event Hub resource.
  var path_594160 = newJObject()
  var query_594161 = newJObject()
  var body_594162 = newJObject()
  add(path_594160, "namespaceName", newJString(namespaceName))
  add(path_594160, "resourceGroupName", newJString(resourceGroupName))
  add(query_594161, "api-version", newJString(apiVersion))
  add(path_594160, "eventHubName", newJString(eventHubName))
  add(path_594160, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594162 = parameters
  result = call_594159.call(path_594160, query_594161, nil, nil, body_594162)

var eventHubsCreateOrUpdate* = Call_EventHubsCreateOrUpdate_594149(
    name: "eventHubsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/eventhubs/{eventHubName}",
    validator: validate_EventHubsCreateOrUpdate_594150, base: "",
    url: url_EventHubsCreateOrUpdate_594151, schemes: {Scheme.Https})
type
  Call_EventHubsGet_594137 = ref object of OpenApiRestCall_593424
proc url_EventHubsGet_594139(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "eventHubName" in path, "`eventHubName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.EventHub/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/eventhubs/"),
               (kind: VariableSegment, value: "eventHubName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EventHubsGet_594138(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets an Event Hubs description for the specified Event Hub.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639501.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   eventHubName: JString (required)
  ##               : The Event Hub name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_594140 = path.getOrDefault("namespaceName")
  valid_594140 = validateParameter(valid_594140, JString, required = true,
                                 default = nil)
  if valid_594140 != nil:
    section.add "namespaceName", valid_594140
  var valid_594141 = path.getOrDefault("resourceGroupName")
  valid_594141 = validateParameter(valid_594141, JString, required = true,
                                 default = nil)
  if valid_594141 != nil:
    section.add "resourceGroupName", valid_594141
  var valid_594142 = path.getOrDefault("eventHubName")
  valid_594142 = validateParameter(valid_594142, JString, required = true,
                                 default = nil)
  if valid_594142 != nil:
    section.add "eventHubName", valid_594142
  var valid_594143 = path.getOrDefault("subscriptionId")
  valid_594143 = validateParameter(valid_594143, JString, required = true,
                                 default = nil)
  if valid_594143 != nil:
    section.add "subscriptionId", valid_594143
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594144 = query.getOrDefault("api-version")
  valid_594144 = validateParameter(valid_594144, JString, required = true,
                                 default = nil)
  if valid_594144 != nil:
    section.add "api-version", valid_594144
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594145: Call_EventHubsGet_594137; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an Event Hubs description for the specified Event Hub.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639501.aspx
  let valid = call_594145.validator(path, query, header, formData, body)
  let scheme = call_594145.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594145.url(scheme.get, call_594145.host, call_594145.base,
                         call_594145.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594145, url, valid)

proc call*(call_594146: Call_EventHubsGet_594137; namespaceName: string;
          resourceGroupName: string; apiVersion: string; eventHubName: string;
          subscriptionId: string): Recallable =
  ## eventHubsGet
  ## Gets an Event Hubs description for the specified Event Hub.
  ## https://msdn.microsoft.com/en-us/library/azure/mt639501.aspx
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   eventHubName: string (required)
  ##               : The Event Hub name
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594147 = newJObject()
  var query_594148 = newJObject()
  add(path_594147, "namespaceName", newJString(namespaceName))
  add(path_594147, "resourceGroupName", newJString(resourceGroupName))
  add(query_594148, "api-version", newJString(apiVersion))
  add(path_594147, "eventHubName", newJString(eventHubName))
  add(path_594147, "subscriptionId", newJString(subscriptionId))
  result = call_594146.call(path_594147, query_594148, nil, nil, nil)

var eventHubsGet* = Call_EventHubsGet_594137(name: "eventHubsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/eventhubs/{eventHubName}",
    validator: validate_EventHubsGet_594138, base: "", url: url_EventHubsGet_594139,
    schemes: {Scheme.Https})
type
  Call_EventHubsDelete_594163 = ref object of OpenApiRestCall_593424
proc url_EventHubsDelete_594165(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "eventHubName" in path, "`eventHubName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.EventHub/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/eventhubs/"),
               (kind: VariableSegment, value: "eventHubName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EventHubsDelete_594164(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Deletes an Event Hub from the specified Namespace and resource group.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639496.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   eventHubName: JString (required)
  ##               : The Event Hub name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_594166 = path.getOrDefault("namespaceName")
  valid_594166 = validateParameter(valid_594166, JString, required = true,
                                 default = nil)
  if valid_594166 != nil:
    section.add "namespaceName", valid_594166
  var valid_594167 = path.getOrDefault("resourceGroupName")
  valid_594167 = validateParameter(valid_594167, JString, required = true,
                                 default = nil)
  if valid_594167 != nil:
    section.add "resourceGroupName", valid_594167
  var valid_594168 = path.getOrDefault("eventHubName")
  valid_594168 = validateParameter(valid_594168, JString, required = true,
                                 default = nil)
  if valid_594168 != nil:
    section.add "eventHubName", valid_594168
  var valid_594169 = path.getOrDefault("subscriptionId")
  valid_594169 = validateParameter(valid_594169, JString, required = true,
                                 default = nil)
  if valid_594169 != nil:
    section.add "subscriptionId", valid_594169
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594170 = query.getOrDefault("api-version")
  valid_594170 = validateParameter(valid_594170, JString, required = true,
                                 default = nil)
  if valid_594170 != nil:
    section.add "api-version", valid_594170
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594171: Call_EventHubsDelete_594163; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an Event Hub from the specified Namespace and resource group.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639496.aspx
  let valid = call_594171.validator(path, query, header, formData, body)
  let scheme = call_594171.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594171.url(scheme.get, call_594171.host, call_594171.base,
                         call_594171.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594171, url, valid)

proc call*(call_594172: Call_EventHubsDelete_594163; namespaceName: string;
          resourceGroupName: string; apiVersion: string; eventHubName: string;
          subscriptionId: string): Recallable =
  ## eventHubsDelete
  ## Deletes an Event Hub from the specified Namespace and resource group.
  ## https://msdn.microsoft.com/en-us/library/azure/mt639496.aspx
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   eventHubName: string (required)
  ##               : The Event Hub name
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594173 = newJObject()
  var query_594174 = newJObject()
  add(path_594173, "namespaceName", newJString(namespaceName))
  add(path_594173, "resourceGroupName", newJString(resourceGroupName))
  add(query_594174, "api-version", newJString(apiVersion))
  add(path_594173, "eventHubName", newJString(eventHubName))
  add(path_594173, "subscriptionId", newJString(subscriptionId))
  result = call_594172.call(path_594173, query_594174, nil, nil, nil)

var eventHubsDelete* = Call_EventHubsDelete_594163(name: "eventHubsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/eventhubs/{eventHubName}",
    validator: validate_EventHubsDelete_594164, base: "", url: url_EventHubsDelete_594165,
    schemes: {Scheme.Https})
type
  Call_EventHubsListAuthorizationRules_594175 = ref object of OpenApiRestCall_593424
proc url_EventHubsListAuthorizationRules_594177(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "eventHubName" in path, "`eventHubName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.EventHub/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/eventhubs/"),
               (kind: VariableSegment, value: "eventHubName"),
               (kind: ConstantSegment, value: "/authorizationRules")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EventHubsListAuthorizationRules_594176(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the authorization rules for an Event Hub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   eventHubName: JString (required)
  ##               : The Event Hub name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_594178 = path.getOrDefault("namespaceName")
  valid_594178 = validateParameter(valid_594178, JString, required = true,
                                 default = nil)
  if valid_594178 != nil:
    section.add "namespaceName", valid_594178
  var valid_594179 = path.getOrDefault("resourceGroupName")
  valid_594179 = validateParameter(valid_594179, JString, required = true,
                                 default = nil)
  if valid_594179 != nil:
    section.add "resourceGroupName", valid_594179
  var valid_594180 = path.getOrDefault("eventHubName")
  valid_594180 = validateParameter(valid_594180, JString, required = true,
                                 default = nil)
  if valid_594180 != nil:
    section.add "eventHubName", valid_594180
  var valid_594181 = path.getOrDefault("subscriptionId")
  valid_594181 = validateParameter(valid_594181, JString, required = true,
                                 default = nil)
  if valid_594181 != nil:
    section.add "subscriptionId", valid_594181
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594182 = query.getOrDefault("api-version")
  valid_594182 = validateParameter(valid_594182, JString, required = true,
                                 default = nil)
  if valid_594182 != nil:
    section.add "api-version", valid_594182
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594183: Call_EventHubsListAuthorizationRules_594175;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the authorization rules for an Event Hub.
  ## 
  let valid = call_594183.validator(path, query, header, formData, body)
  let scheme = call_594183.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594183.url(scheme.get, call_594183.host, call_594183.base,
                         call_594183.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594183, url, valid)

proc call*(call_594184: Call_EventHubsListAuthorizationRules_594175;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          eventHubName: string; subscriptionId: string): Recallable =
  ## eventHubsListAuthorizationRules
  ## Gets the authorization rules for an Event Hub.
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   eventHubName: string (required)
  ##               : The Event Hub name
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594185 = newJObject()
  var query_594186 = newJObject()
  add(path_594185, "namespaceName", newJString(namespaceName))
  add(path_594185, "resourceGroupName", newJString(resourceGroupName))
  add(query_594186, "api-version", newJString(apiVersion))
  add(path_594185, "eventHubName", newJString(eventHubName))
  add(path_594185, "subscriptionId", newJString(subscriptionId))
  result = call_594184.call(path_594185, query_594186, nil, nil, nil)

var eventHubsListAuthorizationRules* = Call_EventHubsListAuthorizationRules_594175(
    name: "eventHubsListAuthorizationRules", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/eventhubs/{eventHubName}/authorizationRules",
    validator: validate_EventHubsListAuthorizationRules_594176, base: "",
    url: url_EventHubsListAuthorizationRules_594177, schemes: {Scheme.Https})
type
  Call_EventHubsCreateOrUpdateAuthorizationRule_594200 = ref object of OpenApiRestCall_593424
proc url_EventHubsCreateOrUpdateAuthorizationRule_594202(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "eventHubName" in path, "`eventHubName` is a required path parameter"
  assert "authorizationRuleName" in path,
        "`authorizationRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.EventHub/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/eventhubs/"),
               (kind: VariableSegment, value: "eventHubName"),
               (kind: ConstantSegment, value: "/authorizationRules/"),
               (kind: VariableSegment, value: "authorizationRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EventHubsCreateOrUpdateAuthorizationRule_594201(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates an AuthorizationRule for the specified Event Hub.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt706096.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   eventHubName: JString (required)
  ##               : The Event Hub name
  ##   authorizationRuleName: JString (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_594203 = path.getOrDefault("namespaceName")
  valid_594203 = validateParameter(valid_594203, JString, required = true,
                                 default = nil)
  if valid_594203 != nil:
    section.add "namespaceName", valid_594203
  var valid_594204 = path.getOrDefault("resourceGroupName")
  valid_594204 = validateParameter(valid_594204, JString, required = true,
                                 default = nil)
  if valid_594204 != nil:
    section.add "resourceGroupName", valid_594204
  var valid_594205 = path.getOrDefault("eventHubName")
  valid_594205 = validateParameter(valid_594205, JString, required = true,
                                 default = nil)
  if valid_594205 != nil:
    section.add "eventHubName", valid_594205
  var valid_594206 = path.getOrDefault("authorizationRuleName")
  valid_594206 = validateParameter(valid_594206, JString, required = true,
                                 default = nil)
  if valid_594206 != nil:
    section.add "authorizationRuleName", valid_594206
  var valid_594207 = path.getOrDefault("subscriptionId")
  valid_594207 = validateParameter(valid_594207, JString, required = true,
                                 default = nil)
  if valid_594207 != nil:
    section.add "subscriptionId", valid_594207
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594208 = query.getOrDefault("api-version")
  valid_594208 = validateParameter(valid_594208, JString, required = true,
                                 default = nil)
  if valid_594208 != nil:
    section.add "api-version", valid_594208
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The shared access AuthorizationRule.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594210: Call_EventHubsCreateOrUpdateAuthorizationRule_594200;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates an AuthorizationRule for the specified Event Hub.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt706096.aspx
  let valid = call_594210.validator(path, query, header, formData, body)
  let scheme = call_594210.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594210.url(scheme.get, call_594210.host, call_594210.base,
                         call_594210.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594210, url, valid)

proc call*(call_594211: Call_EventHubsCreateOrUpdateAuthorizationRule_594200;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          eventHubName: string; authorizationRuleName: string;
          subscriptionId: string; parameters: JsonNode): Recallable =
  ## eventHubsCreateOrUpdateAuthorizationRule
  ## Creates or updates an AuthorizationRule for the specified Event Hub.
  ## https://msdn.microsoft.com/en-us/library/azure/mt706096.aspx
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   eventHubName: string (required)
  ##               : The Event Hub name
  ##   authorizationRuleName: string (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : The shared access AuthorizationRule.
  var path_594212 = newJObject()
  var query_594213 = newJObject()
  var body_594214 = newJObject()
  add(path_594212, "namespaceName", newJString(namespaceName))
  add(path_594212, "resourceGroupName", newJString(resourceGroupName))
  add(query_594213, "api-version", newJString(apiVersion))
  add(path_594212, "eventHubName", newJString(eventHubName))
  add(path_594212, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_594212, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594214 = parameters
  result = call_594211.call(path_594212, query_594213, nil, nil, body_594214)

var eventHubsCreateOrUpdateAuthorizationRule* = Call_EventHubsCreateOrUpdateAuthorizationRule_594200(
    name: "eventHubsCreateOrUpdateAuthorizationRule", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/eventhubs/{eventHubName}/authorizationRules/{authorizationRuleName}",
    validator: validate_EventHubsCreateOrUpdateAuthorizationRule_594201, base: "",
    url: url_EventHubsCreateOrUpdateAuthorizationRule_594202,
    schemes: {Scheme.Https})
type
  Call_EventHubsPostAuthorizationRule_594215 = ref object of OpenApiRestCall_593424
proc url_EventHubsPostAuthorizationRule_594217(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "eventHubName" in path, "`eventHubName` is a required path parameter"
  assert "authorizationRuleName" in path,
        "`authorizationRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.EventHub/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/eventhubs/"),
               (kind: VariableSegment, value: "eventHubName"),
               (kind: ConstantSegment, value: "/authorizationRules/"),
               (kind: VariableSegment, value: "authorizationRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EventHubsPostAuthorizationRule_594216(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets an AuthorizationRule for an Event Hub by rule name.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt706097.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   eventHubName: JString (required)
  ##               : The Event Hub name
  ##   authorizationRuleName: JString (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_594218 = path.getOrDefault("namespaceName")
  valid_594218 = validateParameter(valid_594218, JString, required = true,
                                 default = nil)
  if valid_594218 != nil:
    section.add "namespaceName", valid_594218
  var valid_594219 = path.getOrDefault("resourceGroupName")
  valid_594219 = validateParameter(valid_594219, JString, required = true,
                                 default = nil)
  if valid_594219 != nil:
    section.add "resourceGroupName", valid_594219
  var valid_594220 = path.getOrDefault("eventHubName")
  valid_594220 = validateParameter(valid_594220, JString, required = true,
                                 default = nil)
  if valid_594220 != nil:
    section.add "eventHubName", valid_594220
  var valid_594221 = path.getOrDefault("authorizationRuleName")
  valid_594221 = validateParameter(valid_594221, JString, required = true,
                                 default = nil)
  if valid_594221 != nil:
    section.add "authorizationRuleName", valid_594221
  var valid_594222 = path.getOrDefault("subscriptionId")
  valid_594222 = validateParameter(valid_594222, JString, required = true,
                                 default = nil)
  if valid_594222 != nil:
    section.add "subscriptionId", valid_594222
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594223 = query.getOrDefault("api-version")
  valid_594223 = validateParameter(valid_594223, JString, required = true,
                                 default = nil)
  if valid_594223 != nil:
    section.add "api-version", valid_594223
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594224: Call_EventHubsPostAuthorizationRule_594215; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an AuthorizationRule for an Event Hub by rule name.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt706097.aspx
  let valid = call_594224.validator(path, query, header, formData, body)
  let scheme = call_594224.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594224.url(scheme.get, call_594224.host, call_594224.base,
                         call_594224.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594224, url, valid)

proc call*(call_594225: Call_EventHubsPostAuthorizationRule_594215;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          eventHubName: string; authorizationRuleName: string;
          subscriptionId: string): Recallable =
  ## eventHubsPostAuthorizationRule
  ## Gets an AuthorizationRule for an Event Hub by rule name.
  ## https://msdn.microsoft.com/en-us/library/azure/mt706097.aspx
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   eventHubName: string (required)
  ##               : The Event Hub name
  ##   authorizationRuleName: string (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594226 = newJObject()
  var query_594227 = newJObject()
  add(path_594226, "namespaceName", newJString(namespaceName))
  add(path_594226, "resourceGroupName", newJString(resourceGroupName))
  add(query_594227, "api-version", newJString(apiVersion))
  add(path_594226, "eventHubName", newJString(eventHubName))
  add(path_594226, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_594226, "subscriptionId", newJString(subscriptionId))
  result = call_594225.call(path_594226, query_594227, nil, nil, nil)

var eventHubsPostAuthorizationRule* = Call_EventHubsPostAuthorizationRule_594215(
    name: "eventHubsPostAuthorizationRule", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/eventhubs/{eventHubName}/authorizationRules/{authorizationRuleName}",
    validator: validate_EventHubsPostAuthorizationRule_594216, base: "",
    url: url_EventHubsPostAuthorizationRule_594217, schemes: {Scheme.Https})
type
  Call_EventHubsGetAuthorizationRule_594187 = ref object of OpenApiRestCall_593424
proc url_EventHubsGetAuthorizationRule_594189(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "eventHubName" in path, "`eventHubName` is a required path parameter"
  assert "authorizationRuleName" in path,
        "`authorizationRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.EventHub/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/eventhubs/"),
               (kind: VariableSegment, value: "eventHubName"),
               (kind: ConstantSegment, value: "/authorizationRules/"),
               (kind: VariableSegment, value: "authorizationRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EventHubsGetAuthorizationRule_594188(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets an AuthorizationRule for an Event Hub by rule name.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt706097.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   eventHubName: JString (required)
  ##               : The Event Hub name
  ##   authorizationRuleName: JString (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_594190 = path.getOrDefault("namespaceName")
  valid_594190 = validateParameter(valid_594190, JString, required = true,
                                 default = nil)
  if valid_594190 != nil:
    section.add "namespaceName", valid_594190
  var valid_594191 = path.getOrDefault("resourceGroupName")
  valid_594191 = validateParameter(valid_594191, JString, required = true,
                                 default = nil)
  if valid_594191 != nil:
    section.add "resourceGroupName", valid_594191
  var valid_594192 = path.getOrDefault("eventHubName")
  valid_594192 = validateParameter(valid_594192, JString, required = true,
                                 default = nil)
  if valid_594192 != nil:
    section.add "eventHubName", valid_594192
  var valid_594193 = path.getOrDefault("authorizationRuleName")
  valid_594193 = validateParameter(valid_594193, JString, required = true,
                                 default = nil)
  if valid_594193 != nil:
    section.add "authorizationRuleName", valid_594193
  var valid_594194 = path.getOrDefault("subscriptionId")
  valid_594194 = validateParameter(valid_594194, JString, required = true,
                                 default = nil)
  if valid_594194 != nil:
    section.add "subscriptionId", valid_594194
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594195 = query.getOrDefault("api-version")
  valid_594195 = validateParameter(valid_594195, JString, required = true,
                                 default = nil)
  if valid_594195 != nil:
    section.add "api-version", valid_594195
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594196: Call_EventHubsGetAuthorizationRule_594187; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an AuthorizationRule for an Event Hub by rule name.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt706097.aspx
  let valid = call_594196.validator(path, query, header, formData, body)
  let scheme = call_594196.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594196.url(scheme.get, call_594196.host, call_594196.base,
                         call_594196.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594196, url, valid)

proc call*(call_594197: Call_EventHubsGetAuthorizationRule_594187;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          eventHubName: string; authorizationRuleName: string;
          subscriptionId: string): Recallable =
  ## eventHubsGetAuthorizationRule
  ## Gets an AuthorizationRule for an Event Hub by rule name.
  ## https://msdn.microsoft.com/en-us/library/azure/mt706097.aspx
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   eventHubName: string (required)
  ##               : The Event Hub name
  ##   authorizationRuleName: string (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594198 = newJObject()
  var query_594199 = newJObject()
  add(path_594198, "namespaceName", newJString(namespaceName))
  add(path_594198, "resourceGroupName", newJString(resourceGroupName))
  add(query_594199, "api-version", newJString(apiVersion))
  add(path_594198, "eventHubName", newJString(eventHubName))
  add(path_594198, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_594198, "subscriptionId", newJString(subscriptionId))
  result = call_594197.call(path_594198, query_594199, nil, nil, nil)

var eventHubsGetAuthorizationRule* = Call_EventHubsGetAuthorizationRule_594187(
    name: "eventHubsGetAuthorizationRule", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/eventhubs/{eventHubName}/authorizationRules/{authorizationRuleName}",
    validator: validate_EventHubsGetAuthorizationRule_594188, base: "",
    url: url_EventHubsGetAuthorizationRule_594189, schemes: {Scheme.Https})
type
  Call_EventHubsDeleteAuthorizationRule_594228 = ref object of OpenApiRestCall_593424
proc url_EventHubsDeleteAuthorizationRule_594230(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "eventHubName" in path, "`eventHubName` is a required path parameter"
  assert "authorizationRuleName" in path,
        "`authorizationRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.EventHub/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/eventhubs/"),
               (kind: VariableSegment, value: "eventHubName"),
               (kind: ConstantSegment, value: "/authorizationRules/"),
               (kind: VariableSegment, value: "authorizationRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EventHubsDeleteAuthorizationRule_594229(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an Event Hub AuthorizationRule.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt706100.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   eventHubName: JString (required)
  ##               : The Event Hub name
  ##   authorizationRuleName: JString (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_594231 = path.getOrDefault("namespaceName")
  valid_594231 = validateParameter(valid_594231, JString, required = true,
                                 default = nil)
  if valid_594231 != nil:
    section.add "namespaceName", valid_594231
  var valid_594232 = path.getOrDefault("resourceGroupName")
  valid_594232 = validateParameter(valid_594232, JString, required = true,
                                 default = nil)
  if valid_594232 != nil:
    section.add "resourceGroupName", valid_594232
  var valid_594233 = path.getOrDefault("eventHubName")
  valid_594233 = validateParameter(valid_594233, JString, required = true,
                                 default = nil)
  if valid_594233 != nil:
    section.add "eventHubName", valid_594233
  var valid_594234 = path.getOrDefault("authorizationRuleName")
  valid_594234 = validateParameter(valid_594234, JString, required = true,
                                 default = nil)
  if valid_594234 != nil:
    section.add "authorizationRuleName", valid_594234
  var valid_594235 = path.getOrDefault("subscriptionId")
  valid_594235 = validateParameter(valid_594235, JString, required = true,
                                 default = nil)
  if valid_594235 != nil:
    section.add "subscriptionId", valid_594235
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594236 = query.getOrDefault("api-version")
  valid_594236 = validateParameter(valid_594236, JString, required = true,
                                 default = nil)
  if valid_594236 != nil:
    section.add "api-version", valid_594236
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594237: Call_EventHubsDeleteAuthorizationRule_594228;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an Event Hub AuthorizationRule.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt706100.aspx
  let valid = call_594237.validator(path, query, header, formData, body)
  let scheme = call_594237.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594237.url(scheme.get, call_594237.host, call_594237.base,
                         call_594237.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594237, url, valid)

proc call*(call_594238: Call_EventHubsDeleteAuthorizationRule_594228;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          eventHubName: string; authorizationRuleName: string;
          subscriptionId: string): Recallable =
  ## eventHubsDeleteAuthorizationRule
  ## Deletes an Event Hub AuthorizationRule.
  ## https://msdn.microsoft.com/en-us/library/azure/mt706100.aspx
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   eventHubName: string (required)
  ##               : The Event Hub name
  ##   authorizationRuleName: string (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594239 = newJObject()
  var query_594240 = newJObject()
  add(path_594239, "namespaceName", newJString(namespaceName))
  add(path_594239, "resourceGroupName", newJString(resourceGroupName))
  add(query_594240, "api-version", newJString(apiVersion))
  add(path_594239, "eventHubName", newJString(eventHubName))
  add(path_594239, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_594239, "subscriptionId", newJString(subscriptionId))
  result = call_594238.call(path_594239, query_594240, nil, nil, nil)

var eventHubsDeleteAuthorizationRule* = Call_EventHubsDeleteAuthorizationRule_594228(
    name: "eventHubsDeleteAuthorizationRule", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/eventhubs/{eventHubName}/authorizationRules/{authorizationRuleName}",
    validator: validate_EventHubsDeleteAuthorizationRule_594229, base: "",
    url: url_EventHubsDeleteAuthorizationRule_594230, schemes: {Scheme.Https})
type
  Call_EventHubsListKeys_594241 = ref object of OpenApiRestCall_593424
proc url_EventHubsListKeys_594243(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "eventHubName" in path, "`eventHubName` is a required path parameter"
  assert "authorizationRuleName" in path,
        "`authorizationRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.EventHub/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/eventhubs/"),
               (kind: VariableSegment, value: "eventHubName"),
               (kind: ConstantSegment, value: "/authorizationRules/"),
               (kind: VariableSegment, value: "authorizationRuleName"),
               (kind: ConstantSegment, value: "/ListKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EventHubsListKeys_594242(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Gets the ACS and SAS connection strings for the Event Hub.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt706098.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   eventHubName: JString (required)
  ##               : The Event Hub name
  ##   authorizationRuleName: JString (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_594244 = path.getOrDefault("namespaceName")
  valid_594244 = validateParameter(valid_594244, JString, required = true,
                                 default = nil)
  if valid_594244 != nil:
    section.add "namespaceName", valid_594244
  var valid_594245 = path.getOrDefault("resourceGroupName")
  valid_594245 = validateParameter(valid_594245, JString, required = true,
                                 default = nil)
  if valid_594245 != nil:
    section.add "resourceGroupName", valid_594245
  var valid_594246 = path.getOrDefault("eventHubName")
  valid_594246 = validateParameter(valid_594246, JString, required = true,
                                 default = nil)
  if valid_594246 != nil:
    section.add "eventHubName", valid_594246
  var valid_594247 = path.getOrDefault("authorizationRuleName")
  valid_594247 = validateParameter(valid_594247, JString, required = true,
                                 default = nil)
  if valid_594247 != nil:
    section.add "authorizationRuleName", valid_594247
  var valid_594248 = path.getOrDefault("subscriptionId")
  valid_594248 = validateParameter(valid_594248, JString, required = true,
                                 default = nil)
  if valid_594248 != nil:
    section.add "subscriptionId", valid_594248
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594249 = query.getOrDefault("api-version")
  valid_594249 = validateParameter(valid_594249, JString, required = true,
                                 default = nil)
  if valid_594249 != nil:
    section.add "api-version", valid_594249
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594250: Call_EventHubsListKeys_594241; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the ACS and SAS connection strings for the Event Hub.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt706098.aspx
  let valid = call_594250.validator(path, query, header, formData, body)
  let scheme = call_594250.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594250.url(scheme.get, call_594250.host, call_594250.base,
                         call_594250.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594250, url, valid)

proc call*(call_594251: Call_EventHubsListKeys_594241; namespaceName: string;
          resourceGroupName: string; apiVersion: string; eventHubName: string;
          authorizationRuleName: string; subscriptionId: string): Recallable =
  ## eventHubsListKeys
  ## Gets the ACS and SAS connection strings for the Event Hub.
  ## https://msdn.microsoft.com/en-us/library/azure/mt706098.aspx
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   eventHubName: string (required)
  ##               : The Event Hub name
  ##   authorizationRuleName: string (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594252 = newJObject()
  var query_594253 = newJObject()
  add(path_594252, "namespaceName", newJString(namespaceName))
  add(path_594252, "resourceGroupName", newJString(resourceGroupName))
  add(query_594253, "api-version", newJString(apiVersion))
  add(path_594252, "eventHubName", newJString(eventHubName))
  add(path_594252, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_594252, "subscriptionId", newJString(subscriptionId))
  result = call_594251.call(path_594252, query_594253, nil, nil, nil)

var eventHubsListKeys* = Call_EventHubsListKeys_594241(name: "eventHubsListKeys",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/eventhubs/{eventHubName}/authorizationRules/{authorizationRuleName}/ListKeys",
    validator: validate_EventHubsListKeys_594242, base: "",
    url: url_EventHubsListKeys_594243, schemes: {Scheme.Https})
type
  Call_EventHubsRegenerateKeys_594254 = ref object of OpenApiRestCall_593424
proc url_EventHubsRegenerateKeys_594256(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "eventHubName" in path, "`eventHubName` is a required path parameter"
  assert "authorizationRuleName" in path,
        "`authorizationRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.EventHub/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/eventhubs/"),
               (kind: VariableSegment, value: "eventHubName"),
               (kind: ConstantSegment, value: "/authorizationRules/"),
               (kind: VariableSegment, value: "authorizationRuleName"),
               (kind: ConstantSegment, value: "/regenerateKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EventHubsRegenerateKeys_594255(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Regenerates the ACS and SAS connection strings for the Event Hub.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt706099.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   eventHubName: JString (required)
  ##               : The Event Hub name
  ##   authorizationRuleName: JString (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_594257 = path.getOrDefault("namespaceName")
  valid_594257 = validateParameter(valid_594257, JString, required = true,
                                 default = nil)
  if valid_594257 != nil:
    section.add "namespaceName", valid_594257
  var valid_594258 = path.getOrDefault("resourceGroupName")
  valid_594258 = validateParameter(valid_594258, JString, required = true,
                                 default = nil)
  if valid_594258 != nil:
    section.add "resourceGroupName", valid_594258
  var valid_594259 = path.getOrDefault("eventHubName")
  valid_594259 = validateParameter(valid_594259, JString, required = true,
                                 default = nil)
  if valid_594259 != nil:
    section.add "eventHubName", valid_594259
  var valid_594260 = path.getOrDefault("authorizationRuleName")
  valid_594260 = validateParameter(valid_594260, JString, required = true,
                                 default = nil)
  if valid_594260 != nil:
    section.add "authorizationRuleName", valid_594260
  var valid_594261 = path.getOrDefault("subscriptionId")
  valid_594261 = validateParameter(valid_594261, JString, required = true,
                                 default = nil)
  if valid_594261 != nil:
    section.add "subscriptionId", valid_594261
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594262 = query.getOrDefault("api-version")
  valid_594262 = validateParameter(valid_594262, JString, required = true,
                                 default = nil)
  if valid_594262 != nil:
    section.add "api-version", valid_594262
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to regenerate the AuthorizationRule Keys (PrimaryKey/SecondaryKey).
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594264: Call_EventHubsRegenerateKeys_594254; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Regenerates the ACS and SAS connection strings for the Event Hub.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt706099.aspx
  let valid = call_594264.validator(path, query, header, formData, body)
  let scheme = call_594264.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594264.url(scheme.get, call_594264.host, call_594264.base,
                         call_594264.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594264, url, valid)

proc call*(call_594265: Call_EventHubsRegenerateKeys_594254; namespaceName: string;
          resourceGroupName: string; apiVersion: string; eventHubName: string;
          authorizationRuleName: string; subscriptionId: string;
          parameters: JsonNode): Recallable =
  ## eventHubsRegenerateKeys
  ## Regenerates the ACS and SAS connection strings for the Event Hub.
  ## https://msdn.microsoft.com/en-us/library/azure/mt706099.aspx
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   eventHubName: string (required)
  ##               : The Event Hub name
  ##   authorizationRuleName: string (required)
  ##                        : The authorization rule name.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to regenerate the AuthorizationRule Keys (PrimaryKey/SecondaryKey).
  var path_594266 = newJObject()
  var query_594267 = newJObject()
  var body_594268 = newJObject()
  add(path_594266, "namespaceName", newJString(namespaceName))
  add(path_594266, "resourceGroupName", newJString(resourceGroupName))
  add(query_594267, "api-version", newJString(apiVersion))
  add(path_594266, "eventHubName", newJString(eventHubName))
  add(path_594266, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_594266, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594268 = parameters
  result = call_594265.call(path_594266, query_594267, nil, nil, body_594268)

var eventHubsRegenerateKeys* = Call_EventHubsRegenerateKeys_594254(
    name: "eventHubsRegenerateKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/eventhubs/{eventHubName}/authorizationRules/{authorizationRuleName}/regenerateKeys",
    validator: validate_EventHubsRegenerateKeys_594255, base: "",
    url: url_EventHubsRegenerateKeys_594256, schemes: {Scheme.Https})
type
  Call_ConsumerGroupsListAll_594269 = ref object of OpenApiRestCall_593424
proc url_ConsumerGroupsListAll_594271(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "eventHubName" in path, "`eventHubName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.EventHub/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/eventhubs/"),
               (kind: VariableSegment, value: "eventHubName"),
               (kind: ConstantSegment, value: "/consumergroups")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ConsumerGroupsListAll_594270(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the consumer groups in a Namespace. An empty feed is returned if no consumer group exists in the Namespace.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639503.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   eventHubName: JString (required)
  ##               : The Event Hub name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_594272 = path.getOrDefault("namespaceName")
  valid_594272 = validateParameter(valid_594272, JString, required = true,
                                 default = nil)
  if valid_594272 != nil:
    section.add "namespaceName", valid_594272
  var valid_594273 = path.getOrDefault("resourceGroupName")
  valid_594273 = validateParameter(valid_594273, JString, required = true,
                                 default = nil)
  if valid_594273 != nil:
    section.add "resourceGroupName", valid_594273
  var valid_594274 = path.getOrDefault("eventHubName")
  valid_594274 = validateParameter(valid_594274, JString, required = true,
                                 default = nil)
  if valid_594274 != nil:
    section.add "eventHubName", valid_594274
  var valid_594275 = path.getOrDefault("subscriptionId")
  valid_594275 = validateParameter(valid_594275, JString, required = true,
                                 default = nil)
  if valid_594275 != nil:
    section.add "subscriptionId", valid_594275
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594276 = query.getOrDefault("api-version")
  valid_594276 = validateParameter(valid_594276, JString, required = true,
                                 default = nil)
  if valid_594276 != nil:
    section.add "api-version", valid_594276
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594277: Call_ConsumerGroupsListAll_594269; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the consumer groups in a Namespace. An empty feed is returned if no consumer group exists in the Namespace.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639503.aspx
  let valid = call_594277.validator(path, query, header, formData, body)
  let scheme = call_594277.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594277.url(scheme.get, call_594277.host, call_594277.base,
                         call_594277.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594277, url, valid)

proc call*(call_594278: Call_ConsumerGroupsListAll_594269; namespaceName: string;
          resourceGroupName: string; apiVersion: string; eventHubName: string;
          subscriptionId: string): Recallable =
  ## consumerGroupsListAll
  ## Gets all the consumer groups in a Namespace. An empty feed is returned if no consumer group exists in the Namespace.
  ## https://msdn.microsoft.com/en-us/library/azure/mt639503.aspx
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   eventHubName: string (required)
  ##               : The Event Hub name
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594279 = newJObject()
  var query_594280 = newJObject()
  add(path_594279, "namespaceName", newJString(namespaceName))
  add(path_594279, "resourceGroupName", newJString(resourceGroupName))
  add(query_594280, "api-version", newJString(apiVersion))
  add(path_594279, "eventHubName", newJString(eventHubName))
  add(path_594279, "subscriptionId", newJString(subscriptionId))
  result = call_594278.call(path_594279, query_594280, nil, nil, nil)

var consumerGroupsListAll* = Call_ConsumerGroupsListAll_594269(
    name: "consumerGroupsListAll", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/eventhubs/{eventHubName}/consumergroups",
    validator: validate_ConsumerGroupsListAll_594270, base: "",
    url: url_ConsumerGroupsListAll_594271, schemes: {Scheme.Https})
type
  Call_ConsumerGroupsCreateOrUpdate_594294 = ref object of OpenApiRestCall_593424
proc url_ConsumerGroupsCreateOrUpdate_594296(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "eventHubName" in path, "`eventHubName` is a required path parameter"
  assert "consumerGroupName" in path,
        "`consumerGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.EventHub/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/eventhubs/"),
               (kind: VariableSegment, value: "eventHubName"),
               (kind: ConstantSegment, value: "/consumergroups/"),
               (kind: VariableSegment, value: "consumerGroupName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ConsumerGroupsCreateOrUpdate_594295(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates an Event Hubs consumer group as a nested resource within a Namespace.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639498.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   eventHubName: JString (required)
  ##               : The Event Hub name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   consumerGroupName: JString (required)
  ##                    : The consumer group name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_594297 = path.getOrDefault("namespaceName")
  valid_594297 = validateParameter(valid_594297, JString, required = true,
                                 default = nil)
  if valid_594297 != nil:
    section.add "namespaceName", valid_594297
  var valid_594298 = path.getOrDefault("resourceGroupName")
  valid_594298 = validateParameter(valid_594298, JString, required = true,
                                 default = nil)
  if valid_594298 != nil:
    section.add "resourceGroupName", valid_594298
  var valid_594299 = path.getOrDefault("eventHubName")
  valid_594299 = validateParameter(valid_594299, JString, required = true,
                                 default = nil)
  if valid_594299 != nil:
    section.add "eventHubName", valid_594299
  var valid_594300 = path.getOrDefault("subscriptionId")
  valid_594300 = validateParameter(valid_594300, JString, required = true,
                                 default = nil)
  if valid_594300 != nil:
    section.add "subscriptionId", valid_594300
  var valid_594301 = path.getOrDefault("consumerGroupName")
  valid_594301 = validateParameter(valid_594301, JString, required = true,
                                 default = nil)
  if valid_594301 != nil:
    section.add "consumerGroupName", valid_594301
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594302 = query.getOrDefault("api-version")
  valid_594302 = validateParameter(valid_594302, JString, required = true,
                                 default = nil)
  if valid_594302 != nil:
    section.add "api-version", valid_594302
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to create or update a consumer group resource.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594304: Call_ConsumerGroupsCreateOrUpdate_594294; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates an Event Hubs consumer group as a nested resource within a Namespace.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639498.aspx
  let valid = call_594304.validator(path, query, header, formData, body)
  let scheme = call_594304.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594304.url(scheme.get, call_594304.host, call_594304.base,
                         call_594304.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594304, url, valid)

proc call*(call_594305: Call_ConsumerGroupsCreateOrUpdate_594294;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          eventHubName: string; subscriptionId: string; consumerGroupName: string;
          parameters: JsonNode): Recallable =
  ## consumerGroupsCreateOrUpdate
  ## Creates or updates an Event Hubs consumer group as a nested resource within a Namespace.
  ## https://msdn.microsoft.com/en-us/library/azure/mt639498.aspx
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   eventHubName: string (required)
  ##               : The Event Hub name
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   consumerGroupName: string (required)
  ##                    : The consumer group name
  ##   parameters: JObject (required)
  ##             : Parameters supplied to create or update a consumer group resource.
  var path_594306 = newJObject()
  var query_594307 = newJObject()
  var body_594308 = newJObject()
  add(path_594306, "namespaceName", newJString(namespaceName))
  add(path_594306, "resourceGroupName", newJString(resourceGroupName))
  add(query_594307, "api-version", newJString(apiVersion))
  add(path_594306, "eventHubName", newJString(eventHubName))
  add(path_594306, "subscriptionId", newJString(subscriptionId))
  add(path_594306, "consumerGroupName", newJString(consumerGroupName))
  if parameters != nil:
    body_594308 = parameters
  result = call_594305.call(path_594306, query_594307, nil, nil, body_594308)

var consumerGroupsCreateOrUpdate* = Call_ConsumerGroupsCreateOrUpdate_594294(
    name: "consumerGroupsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/eventhubs/{eventHubName}/consumergroups/{consumerGroupName}",
    validator: validate_ConsumerGroupsCreateOrUpdate_594295, base: "",
    url: url_ConsumerGroupsCreateOrUpdate_594296, schemes: {Scheme.Https})
type
  Call_ConsumerGroupsGet_594281 = ref object of OpenApiRestCall_593424
proc url_ConsumerGroupsGet_594283(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "eventHubName" in path, "`eventHubName` is a required path parameter"
  assert "consumerGroupName" in path,
        "`consumerGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.EventHub/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/eventhubs/"),
               (kind: VariableSegment, value: "eventHubName"),
               (kind: ConstantSegment, value: "/consumergroups/"),
               (kind: VariableSegment, value: "consumerGroupName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ConsumerGroupsGet_594282(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Gets a description for the specified consumer group.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639488.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   eventHubName: JString (required)
  ##               : The Event Hub name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   consumerGroupName: JString (required)
  ##                    : The consumer group name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_594284 = path.getOrDefault("namespaceName")
  valid_594284 = validateParameter(valid_594284, JString, required = true,
                                 default = nil)
  if valid_594284 != nil:
    section.add "namespaceName", valid_594284
  var valid_594285 = path.getOrDefault("resourceGroupName")
  valid_594285 = validateParameter(valid_594285, JString, required = true,
                                 default = nil)
  if valid_594285 != nil:
    section.add "resourceGroupName", valid_594285
  var valid_594286 = path.getOrDefault("eventHubName")
  valid_594286 = validateParameter(valid_594286, JString, required = true,
                                 default = nil)
  if valid_594286 != nil:
    section.add "eventHubName", valid_594286
  var valid_594287 = path.getOrDefault("subscriptionId")
  valid_594287 = validateParameter(valid_594287, JString, required = true,
                                 default = nil)
  if valid_594287 != nil:
    section.add "subscriptionId", valid_594287
  var valid_594288 = path.getOrDefault("consumerGroupName")
  valid_594288 = validateParameter(valid_594288, JString, required = true,
                                 default = nil)
  if valid_594288 != nil:
    section.add "consumerGroupName", valid_594288
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594289 = query.getOrDefault("api-version")
  valid_594289 = validateParameter(valid_594289, JString, required = true,
                                 default = nil)
  if valid_594289 != nil:
    section.add "api-version", valid_594289
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594290: Call_ConsumerGroupsGet_594281; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a description for the specified consumer group.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639488.aspx
  let valid = call_594290.validator(path, query, header, formData, body)
  let scheme = call_594290.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594290.url(scheme.get, call_594290.host, call_594290.base,
                         call_594290.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594290, url, valid)

proc call*(call_594291: Call_ConsumerGroupsGet_594281; namespaceName: string;
          resourceGroupName: string; apiVersion: string; eventHubName: string;
          subscriptionId: string; consumerGroupName: string): Recallable =
  ## consumerGroupsGet
  ## Gets a description for the specified consumer group.
  ## https://msdn.microsoft.com/en-us/library/azure/mt639488.aspx
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   eventHubName: string (required)
  ##               : The Event Hub name
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   consumerGroupName: string (required)
  ##                    : The consumer group name
  var path_594292 = newJObject()
  var query_594293 = newJObject()
  add(path_594292, "namespaceName", newJString(namespaceName))
  add(path_594292, "resourceGroupName", newJString(resourceGroupName))
  add(query_594293, "api-version", newJString(apiVersion))
  add(path_594292, "eventHubName", newJString(eventHubName))
  add(path_594292, "subscriptionId", newJString(subscriptionId))
  add(path_594292, "consumerGroupName", newJString(consumerGroupName))
  result = call_594291.call(path_594292, query_594293, nil, nil, nil)

var consumerGroupsGet* = Call_ConsumerGroupsGet_594281(name: "consumerGroupsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/eventhubs/{eventHubName}/consumergroups/{consumerGroupName}",
    validator: validate_ConsumerGroupsGet_594282, base: "",
    url: url_ConsumerGroupsGet_594283, schemes: {Scheme.Https})
type
  Call_ConsumerGroupsDelete_594309 = ref object of OpenApiRestCall_593424
proc url_ConsumerGroupsDelete_594311(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "eventHubName" in path, "`eventHubName` is a required path parameter"
  assert "consumerGroupName" in path,
        "`consumerGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.EventHub/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/eventhubs/"),
               (kind: VariableSegment, value: "eventHubName"),
               (kind: ConstantSegment, value: "/consumergroups/"),
               (kind: VariableSegment, value: "consumerGroupName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ConsumerGroupsDelete_594310(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a consumer group from the specified Event Hub and resource group.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639491.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The Namespace name
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   eventHubName: JString (required)
  ##               : The Event Hub name
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   consumerGroupName: JString (required)
  ##                    : The consumer group name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_594312 = path.getOrDefault("namespaceName")
  valid_594312 = validateParameter(valid_594312, JString, required = true,
                                 default = nil)
  if valid_594312 != nil:
    section.add "namespaceName", valid_594312
  var valid_594313 = path.getOrDefault("resourceGroupName")
  valid_594313 = validateParameter(valid_594313, JString, required = true,
                                 default = nil)
  if valid_594313 != nil:
    section.add "resourceGroupName", valid_594313
  var valid_594314 = path.getOrDefault("eventHubName")
  valid_594314 = validateParameter(valid_594314, JString, required = true,
                                 default = nil)
  if valid_594314 != nil:
    section.add "eventHubName", valid_594314
  var valid_594315 = path.getOrDefault("subscriptionId")
  valid_594315 = validateParameter(valid_594315, JString, required = true,
                                 default = nil)
  if valid_594315 != nil:
    section.add "subscriptionId", valid_594315
  var valid_594316 = path.getOrDefault("consumerGroupName")
  valid_594316 = validateParameter(valid_594316, JString, required = true,
                                 default = nil)
  if valid_594316 != nil:
    section.add "consumerGroupName", valid_594316
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594317 = query.getOrDefault("api-version")
  valid_594317 = validateParameter(valid_594317, JString, required = true,
                                 default = nil)
  if valid_594317 != nil:
    section.add "api-version", valid_594317
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594318: Call_ConsumerGroupsDelete_594309; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a consumer group from the specified Event Hub and resource group.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639491.aspx
  let valid = call_594318.validator(path, query, header, formData, body)
  let scheme = call_594318.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594318.url(scheme.get, call_594318.host, call_594318.base,
                         call_594318.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594318, url, valid)

proc call*(call_594319: Call_ConsumerGroupsDelete_594309; namespaceName: string;
          resourceGroupName: string; apiVersion: string; eventHubName: string;
          subscriptionId: string; consumerGroupName: string): Recallable =
  ## consumerGroupsDelete
  ## Deletes a consumer group from the specified Event Hub and resource group.
  ## https://msdn.microsoft.com/en-us/library/azure/mt639491.aspx
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   eventHubName: string (required)
  ##               : The Event Hub name
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   consumerGroupName: string (required)
  ##                    : The consumer group name
  var path_594320 = newJObject()
  var query_594321 = newJObject()
  add(path_594320, "namespaceName", newJString(namespaceName))
  add(path_594320, "resourceGroupName", newJString(resourceGroupName))
  add(query_594321, "api-version", newJString(apiVersion))
  add(path_594320, "eventHubName", newJString(eventHubName))
  add(path_594320, "subscriptionId", newJString(subscriptionId))
  add(path_594320, "consumerGroupName", newJString(consumerGroupName))
  result = call_594319.call(path_594320, query_594321, nil, nil, nil)

var consumerGroupsDelete* = Call_ConsumerGroupsDelete_594309(
    name: "consumerGroupsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/eventhubs/{eventHubName}/consumergroups/{consumerGroupName}",
    validator: validate_ConsumerGroupsDelete_594310, base: "",
    url: url_ConsumerGroupsDelete_594311, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
