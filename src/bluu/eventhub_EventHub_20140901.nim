
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: EventHubManagementClient
## version: 2014-09-01
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
  Call_NamespacesCheckNameSpaceAvailability_593984 = ref object of OpenApiRestCall_593424
proc url_NamespacesCheckNameSpaceAvailability_593986(protocol: Scheme;
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
        value: "/providers/Microsoft.EventHub/CheckNamespaceAvailability")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesCheckNameSpaceAvailability_593985(path: JsonNode;
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
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters to check availability of the given Namespace name
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_593990: Call_NamespacesCheckNameSpaceAvailability_593984;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Check the give Namespace name availability.
  ## 
  let valid = call_593990.validator(path, query, header, formData, body)
  let scheme = call_593990.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593990.url(scheme.get, call_593990.host, call_593990.base,
                         call_593990.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593990, url, valid)

proc call*(call_593991: Call_NamespacesCheckNameSpaceAvailability_593984;
          apiVersion: string; subscriptionId: string; parameters: JsonNode): Recallable =
  ## namespacesCheckNameSpaceAvailability
  ## Check the give Namespace name availability.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters to check availability of the given Namespace name
  var path_593992 = newJObject()
  var query_593993 = newJObject()
  var body_593994 = newJObject()
  add(query_593993, "api-version", newJString(apiVersion))
  add(path_593992, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_593994 = parameters
  result = call_593991.call(path_593992, query_593993, nil, nil, body_593994)

var namespacesCheckNameSpaceAvailability* = Call_NamespacesCheckNameSpaceAvailability_593984(
    name: "namespacesCheckNameSpaceAvailability", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.EventHub/CheckNamespaceAvailability",
    validator: validate_NamespacesCheckNameSpaceAvailability_593985, base: "",
    url: url_NamespacesCheckNameSpaceAvailability_593986, schemes: {Scheme.Https})
type
  Call_NamespacesListBySubscription_593995 = ref object of OpenApiRestCall_593424
proc url_NamespacesListBySubscription_593997(protocol: Scheme; host: string;
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

proc validate_NamespacesListBySubscription_593996(path: JsonNode; query: JsonNode;
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
  var valid_593998 = path.getOrDefault("subscriptionId")
  valid_593998 = validateParameter(valid_593998, JString, required = true,
                                 default = nil)
  if valid_593998 != nil:
    section.add "subscriptionId", valid_593998
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593999 = query.getOrDefault("api-version")
  valid_593999 = validateParameter(valid_593999, JString, required = true,
                                 default = nil)
  if valid_593999 != nil:
    section.add "api-version", valid_593999
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594000: Call_NamespacesListBySubscription_593995; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the available Namespaces within a subscription, irrespective of the resource groups.
  ## 
  let valid = call_594000.validator(path, query, header, formData, body)
  let scheme = call_594000.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594000.url(scheme.get, call_594000.host, call_594000.base,
                         call_594000.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594000, url, valid)

proc call*(call_594001: Call_NamespacesListBySubscription_593995;
          apiVersion: string; subscriptionId: string): Recallable =
  ## namespacesListBySubscription
  ## Lists all the available Namespaces within a subscription, irrespective of the resource groups.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594002 = newJObject()
  var query_594003 = newJObject()
  add(query_594003, "api-version", newJString(apiVersion))
  add(path_594002, "subscriptionId", newJString(subscriptionId))
  result = call_594001.call(path_594002, query_594003, nil, nil, nil)

var namespacesListBySubscription* = Call_NamespacesListBySubscription_593995(
    name: "namespacesListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.EventHub/namespaces",
    validator: validate_NamespacesListBySubscription_593996, base: "",
    url: url_NamespacesListBySubscription_593997, schemes: {Scheme.Https})
type
  Call_NamespacesListByResourceGroup_594004 = ref object of OpenApiRestCall_593424
proc url_NamespacesListByResourceGroup_594006(protocol: Scheme; host: string;
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

proc validate_NamespacesListByResourceGroup_594005(path: JsonNode; query: JsonNode;
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

proc call*(call_594010: Call_NamespacesListByResourceGroup_594004; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the available Namespaces within a resource group.
  ## 
  let valid = call_594010.validator(path, query, header, formData, body)
  let scheme = call_594010.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594010.url(scheme.get, call_594010.host, call_594010.base,
                         call_594010.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594010, url, valid)

proc call*(call_594011: Call_NamespacesListByResourceGroup_594004;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## namespacesListByResourceGroup
  ## Lists the available Namespaces within a resource group.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594012 = newJObject()
  var query_594013 = newJObject()
  add(path_594012, "resourceGroupName", newJString(resourceGroupName))
  add(query_594013, "api-version", newJString(apiVersion))
  add(path_594012, "subscriptionId", newJString(subscriptionId))
  result = call_594011.call(path_594012, query_594013, nil, nil, nil)

var namespacesListByResourceGroup* = Call_NamespacesListByResourceGroup_594004(
    name: "namespacesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces",
    validator: validate_NamespacesListByResourceGroup_594005, base: "",
    url: url_NamespacesListByResourceGroup_594006, schemes: {Scheme.Https})
type
  Call_NamespacesCreateOrUpdate_594025 = ref object of OpenApiRestCall_593424
proc url_NamespacesCreateOrUpdate_594027(protocol: Scheme; host: string;
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

proc validate_NamespacesCreateOrUpdate_594026(path: JsonNode; query: JsonNode;
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
  var valid_594028 = path.getOrDefault("namespaceName")
  valid_594028 = validateParameter(valid_594028, JString, required = true,
                                 default = nil)
  if valid_594028 != nil:
    section.add "namespaceName", valid_594028
  var valid_594029 = path.getOrDefault("resourceGroupName")
  valid_594029 = validateParameter(valid_594029, JString, required = true,
                                 default = nil)
  if valid_594029 != nil:
    section.add "resourceGroupName", valid_594029
  var valid_594030 = path.getOrDefault("subscriptionId")
  valid_594030 = validateParameter(valid_594030, JString, required = true,
                                 default = nil)
  if valid_594030 != nil:
    section.add "subscriptionId", valid_594030
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594031 = query.getOrDefault("api-version")
  valid_594031 = validateParameter(valid_594031, JString, required = true,
                                 default = nil)
  if valid_594031 != nil:
    section.add "api-version", valid_594031
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

proc call*(call_594033: Call_NamespacesCreateOrUpdate_594025; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a namespace. Once created, this namespace's resource manifest is immutable. This operation is idempotent.
  ## 
  let valid = call_594033.validator(path, query, header, formData, body)
  let scheme = call_594033.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594033.url(scheme.get, call_594033.host, call_594033.base,
                         call_594033.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594033, url, valid)

proc call*(call_594034: Call_NamespacesCreateOrUpdate_594025;
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
  var path_594035 = newJObject()
  var query_594036 = newJObject()
  var body_594037 = newJObject()
  add(path_594035, "namespaceName", newJString(namespaceName))
  add(path_594035, "resourceGroupName", newJString(resourceGroupName))
  add(query_594036, "api-version", newJString(apiVersion))
  add(path_594035, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594037 = parameters
  result = call_594034.call(path_594035, query_594036, nil, nil, body_594037)

var namespacesCreateOrUpdate* = Call_NamespacesCreateOrUpdate_594025(
    name: "namespacesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}",
    validator: validate_NamespacesCreateOrUpdate_594026, base: "",
    url: url_NamespacesCreateOrUpdate_594027, schemes: {Scheme.Https})
type
  Call_NamespacesGet_594014 = ref object of OpenApiRestCall_593424
proc url_NamespacesGet_594016(protocol: Scheme; host: string; base: string;
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

proc validate_NamespacesGet_594015(path: JsonNode; query: JsonNode; header: JsonNode;
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
  if body != nil:
    result.add "body", body

proc call*(call_594021: Call_NamespacesGet_594014; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the description of the specified namespace.
  ## 
  let valid = call_594021.validator(path, query, header, formData, body)
  let scheme = call_594021.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594021.url(scheme.get, call_594021.host, call_594021.base,
                         call_594021.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594021, url, valid)

proc call*(call_594022: Call_NamespacesGet_594014; namespaceName: string;
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
  var path_594023 = newJObject()
  var query_594024 = newJObject()
  add(path_594023, "namespaceName", newJString(namespaceName))
  add(path_594023, "resourceGroupName", newJString(resourceGroupName))
  add(query_594024, "api-version", newJString(apiVersion))
  add(path_594023, "subscriptionId", newJString(subscriptionId))
  result = call_594022.call(path_594023, query_594024, nil, nil, nil)

var namespacesGet* = Call_NamespacesGet_594014(name: "namespacesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}",
    validator: validate_NamespacesGet_594015, base: "", url: url_NamespacesGet_594016,
    schemes: {Scheme.Https})
type
  Call_NamespacesUpdate_594049 = ref object of OpenApiRestCall_593424
proc url_NamespacesUpdate_594051(protocol: Scheme; host: string; base: string;
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

proc validate_NamespacesUpdate_594050(path: JsonNode; query: JsonNode;
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
  var valid_594052 = path.getOrDefault("namespaceName")
  valid_594052 = validateParameter(valid_594052, JString, required = true,
                                 default = nil)
  if valid_594052 != nil:
    section.add "namespaceName", valid_594052
  var valid_594053 = path.getOrDefault("resourceGroupName")
  valid_594053 = validateParameter(valid_594053, JString, required = true,
                                 default = nil)
  if valid_594053 != nil:
    section.add "resourceGroupName", valid_594053
  var valid_594054 = path.getOrDefault("subscriptionId")
  valid_594054 = validateParameter(valid_594054, JString, required = true,
                                 default = nil)
  if valid_594054 != nil:
    section.add "subscriptionId", valid_594054
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594055 = query.getOrDefault("api-version")
  valid_594055 = validateParameter(valid_594055, JString, required = true,
                                 default = nil)
  if valid_594055 != nil:
    section.add "api-version", valid_594055
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

proc call*(call_594057: Call_NamespacesUpdate_594049; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a namespace. Once created, this namespace's resource manifest is immutable. This operation is idempotent.
  ## 
  let valid = call_594057.validator(path, query, header, formData, body)
  let scheme = call_594057.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594057.url(scheme.get, call_594057.host, call_594057.base,
                         call_594057.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594057, url, valid)

proc call*(call_594058: Call_NamespacesUpdate_594049; namespaceName: string;
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
  var path_594059 = newJObject()
  var query_594060 = newJObject()
  var body_594061 = newJObject()
  add(path_594059, "namespaceName", newJString(namespaceName))
  add(path_594059, "resourceGroupName", newJString(resourceGroupName))
  add(query_594060, "api-version", newJString(apiVersion))
  add(path_594059, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594061 = parameters
  result = call_594058.call(path_594059, query_594060, nil, nil, body_594061)

var namespacesUpdate* = Call_NamespacesUpdate_594049(name: "namespacesUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}",
    validator: validate_NamespacesUpdate_594050, base: "",
    url: url_NamespacesUpdate_594051, schemes: {Scheme.Https})
type
  Call_NamespacesDelete_594038 = ref object of OpenApiRestCall_593424
proc url_NamespacesDelete_594040(protocol: Scheme; host: string; base: string;
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

proc validate_NamespacesDelete_594039(path: JsonNode; query: JsonNode;
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
  if body != nil:
    result.add "body", body

proc call*(call_594045: Call_NamespacesDelete_594038; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an existing namespace. This operation also removes all associated resources under the namespace.
  ## 
  let valid = call_594045.validator(path, query, header, formData, body)
  let scheme = call_594045.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594045.url(scheme.get, call_594045.host, call_594045.base,
                         call_594045.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594045, url, valid)

proc call*(call_594046: Call_NamespacesDelete_594038; namespaceName: string;
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
  var path_594047 = newJObject()
  var query_594048 = newJObject()
  add(path_594047, "namespaceName", newJString(namespaceName))
  add(path_594047, "resourceGroupName", newJString(resourceGroupName))
  add(query_594048, "api-version", newJString(apiVersion))
  add(path_594047, "subscriptionId", newJString(subscriptionId))
  result = call_594046.call(path_594047, query_594048, nil, nil, nil)

var namespacesDelete* = Call_NamespacesDelete_594038(name: "namespacesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}",
    validator: validate_NamespacesDelete_594039, base: "",
    url: url_NamespacesDelete_594040, schemes: {Scheme.Https})
type
  Call_NamespacesListPostAuthorizationRules_594073 = ref object of OpenApiRestCall_593424
proc url_NamespacesListPostAuthorizationRules_594075(protocol: Scheme;
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
        kind: ConstantSegment, value: "/providers/Microsoft.EventHub/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/AuthorizationRules")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesListPostAuthorizationRules_594074(path: JsonNode;
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
  var valid_594076 = path.getOrDefault("namespaceName")
  valid_594076 = validateParameter(valid_594076, JString, required = true,
                                 default = nil)
  if valid_594076 != nil:
    section.add "namespaceName", valid_594076
  var valid_594077 = path.getOrDefault("resourceGroupName")
  valid_594077 = validateParameter(valid_594077, JString, required = true,
                                 default = nil)
  if valid_594077 != nil:
    section.add "resourceGroupName", valid_594077
  var valid_594078 = path.getOrDefault("subscriptionId")
  valid_594078 = validateParameter(valid_594078, JString, required = true,
                                 default = nil)
  if valid_594078 != nil:
    section.add "subscriptionId", valid_594078
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594079 = query.getOrDefault("api-version")
  valid_594079 = validateParameter(valid_594079, JString, required = true,
                                 default = nil)
  if valid_594079 != nil:
    section.add "api-version", valid_594079
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594080: Call_NamespacesListPostAuthorizationRules_594073;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of authorization rules for a Namespace.
  ## 
  let valid = call_594080.validator(path, query, header, formData, body)
  let scheme = call_594080.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594080.url(scheme.get, call_594080.host, call_594080.base,
                         call_594080.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594080, url, valid)

proc call*(call_594081: Call_NamespacesListPostAuthorizationRules_594073;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## namespacesListPostAuthorizationRules
  ## Gets a list of authorization rules for a Namespace.
  ##   namespaceName: string (required)
  ##                : The Namespace name
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group within the azure subscription.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594082 = newJObject()
  var query_594083 = newJObject()
  add(path_594082, "namespaceName", newJString(namespaceName))
  add(path_594082, "resourceGroupName", newJString(resourceGroupName))
  add(query_594083, "api-version", newJString(apiVersion))
  add(path_594082, "subscriptionId", newJString(subscriptionId))
  result = call_594081.call(path_594082, query_594083, nil, nil, nil)

var namespacesListPostAuthorizationRules* = Call_NamespacesListPostAuthorizationRules_594073(
    name: "namespacesListPostAuthorizationRules", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/AuthorizationRules",
    validator: validate_NamespacesListPostAuthorizationRules_594074, base: "",
    url: url_NamespacesListPostAuthorizationRules_594075, schemes: {Scheme.Https})
type
  Call_NamespacesListAuthorizationRules_594062 = ref object of OpenApiRestCall_593424
proc url_NamespacesListAuthorizationRules_594064(protocol: Scheme; host: string;
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

proc validate_NamespacesListAuthorizationRules_594063(path: JsonNode;
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
  var valid_594067 = path.getOrDefault("subscriptionId")
  valid_594067 = validateParameter(valid_594067, JString, required = true,
                                 default = nil)
  if valid_594067 != nil:
    section.add "subscriptionId", valid_594067
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594068 = query.getOrDefault("api-version")
  valid_594068 = validateParameter(valid_594068, JString, required = true,
                                 default = nil)
  if valid_594068 != nil:
    section.add "api-version", valid_594068
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594069: Call_NamespacesListAuthorizationRules_594062;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of authorization rules for a Namespace.
  ## 
  let valid = call_594069.validator(path, query, header, formData, body)
  let scheme = call_594069.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594069.url(scheme.get, call_594069.host, call_594069.base,
                         call_594069.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594069, url, valid)

proc call*(call_594070: Call_NamespacesListAuthorizationRules_594062;
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
  var path_594071 = newJObject()
  var query_594072 = newJObject()
  add(path_594071, "namespaceName", newJString(namespaceName))
  add(path_594071, "resourceGroupName", newJString(resourceGroupName))
  add(query_594072, "api-version", newJString(apiVersion))
  add(path_594071, "subscriptionId", newJString(subscriptionId))
  result = call_594070.call(path_594071, query_594072, nil, nil, nil)

var namespacesListAuthorizationRules* = Call_NamespacesListAuthorizationRules_594062(
    name: "namespacesListAuthorizationRules", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/AuthorizationRules",
    validator: validate_NamespacesListAuthorizationRules_594063, base: "",
    url: url_NamespacesListAuthorizationRules_594064, schemes: {Scheme.Https})
type
  Call_NamespacesCreateOrUpdateAuthorizationRule_594096 = ref object of OpenApiRestCall_593424
proc url_NamespacesCreateOrUpdateAuthorizationRule_594098(protocol: Scheme;
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

proc validate_NamespacesCreateOrUpdateAuthorizationRule_594097(path: JsonNode;
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
  var valid_594099 = path.getOrDefault("namespaceName")
  valid_594099 = validateParameter(valid_594099, JString, required = true,
                                 default = nil)
  if valid_594099 != nil:
    section.add "namespaceName", valid_594099
  var valid_594100 = path.getOrDefault("resourceGroupName")
  valid_594100 = validateParameter(valid_594100, JString, required = true,
                                 default = nil)
  if valid_594100 != nil:
    section.add "resourceGroupName", valid_594100
  var valid_594101 = path.getOrDefault("authorizationRuleName")
  valid_594101 = validateParameter(valid_594101, JString, required = true,
                                 default = nil)
  if valid_594101 != nil:
    section.add "authorizationRuleName", valid_594101
  var valid_594102 = path.getOrDefault("subscriptionId")
  valid_594102 = validateParameter(valid_594102, JString, required = true,
                                 default = nil)
  if valid_594102 != nil:
    section.add "subscriptionId", valid_594102
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594103 = query.getOrDefault("api-version")
  valid_594103 = validateParameter(valid_594103, JString, required = true,
                                 default = nil)
  if valid_594103 != nil:
    section.add "api-version", valid_594103
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

proc call*(call_594105: Call_NamespacesCreateOrUpdateAuthorizationRule_594096;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates an AuthorizationRule for a Namespace.
  ## 
  let valid = call_594105.validator(path, query, header, formData, body)
  let scheme = call_594105.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594105.url(scheme.get, call_594105.host, call_594105.base,
                         call_594105.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594105, url, valid)

proc call*(call_594106: Call_NamespacesCreateOrUpdateAuthorizationRule_594096;
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
  var path_594107 = newJObject()
  var query_594108 = newJObject()
  var body_594109 = newJObject()
  add(path_594107, "namespaceName", newJString(namespaceName))
  add(path_594107, "resourceGroupName", newJString(resourceGroupName))
  add(query_594108, "api-version", newJString(apiVersion))
  add(path_594107, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_594107, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594109 = parameters
  result = call_594106.call(path_594107, query_594108, nil, nil, body_594109)

var namespacesCreateOrUpdateAuthorizationRule* = Call_NamespacesCreateOrUpdateAuthorizationRule_594096(
    name: "namespacesCreateOrUpdateAuthorizationRule", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/AuthorizationRules/{authorizationRuleName}",
    validator: validate_NamespacesCreateOrUpdateAuthorizationRule_594097,
    base: "", url: url_NamespacesCreateOrUpdateAuthorizationRule_594098,
    schemes: {Scheme.Https})
type
  Call_NamespacesPostAuthorizationRule_594110 = ref object of OpenApiRestCall_593424
proc url_NamespacesPostAuthorizationRule_594112(protocol: Scheme; host: string;
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

proc validate_NamespacesPostAuthorizationRule_594111(path: JsonNode;
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
  var valid_594113 = path.getOrDefault("namespaceName")
  valid_594113 = validateParameter(valid_594113, JString, required = true,
                                 default = nil)
  if valid_594113 != nil:
    section.add "namespaceName", valid_594113
  var valid_594114 = path.getOrDefault("resourceGroupName")
  valid_594114 = validateParameter(valid_594114, JString, required = true,
                                 default = nil)
  if valid_594114 != nil:
    section.add "resourceGroupName", valid_594114
  var valid_594115 = path.getOrDefault("authorizationRuleName")
  valid_594115 = validateParameter(valid_594115, JString, required = true,
                                 default = nil)
  if valid_594115 != nil:
    section.add "authorizationRuleName", valid_594115
  var valid_594116 = path.getOrDefault("subscriptionId")
  valid_594116 = validateParameter(valid_594116, JString, required = true,
                                 default = nil)
  if valid_594116 != nil:
    section.add "subscriptionId", valid_594116
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594117 = query.getOrDefault("api-version")
  valid_594117 = validateParameter(valid_594117, JString, required = true,
                                 default = nil)
  if valid_594117 != nil:
    section.add "api-version", valid_594117
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594118: Call_NamespacesPostAuthorizationRule_594110;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets an AuthorizationRule for a Namespace by rule name.
  ## 
  let valid = call_594118.validator(path, query, header, formData, body)
  let scheme = call_594118.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594118.url(scheme.get, call_594118.host, call_594118.base,
                         call_594118.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594118, url, valid)

proc call*(call_594119: Call_NamespacesPostAuthorizationRule_594110;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          authorizationRuleName: string; subscriptionId: string): Recallable =
  ## namespacesPostAuthorizationRule
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
  var path_594120 = newJObject()
  var query_594121 = newJObject()
  add(path_594120, "namespaceName", newJString(namespaceName))
  add(path_594120, "resourceGroupName", newJString(resourceGroupName))
  add(query_594121, "api-version", newJString(apiVersion))
  add(path_594120, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_594120, "subscriptionId", newJString(subscriptionId))
  result = call_594119.call(path_594120, query_594121, nil, nil, nil)

var namespacesPostAuthorizationRule* = Call_NamespacesPostAuthorizationRule_594110(
    name: "namespacesPostAuthorizationRule", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/AuthorizationRules/{authorizationRuleName}",
    validator: validate_NamespacesPostAuthorizationRule_594111, base: "",
    url: url_NamespacesPostAuthorizationRule_594112, schemes: {Scheme.Https})
type
  Call_NamespacesGetAuthorizationRule_594084 = ref object of OpenApiRestCall_593424
proc url_NamespacesGetAuthorizationRule_594086(protocol: Scheme; host: string;
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

proc validate_NamespacesGetAuthorizationRule_594085(path: JsonNode;
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
  var valid_594087 = path.getOrDefault("namespaceName")
  valid_594087 = validateParameter(valid_594087, JString, required = true,
                                 default = nil)
  if valid_594087 != nil:
    section.add "namespaceName", valid_594087
  var valid_594088 = path.getOrDefault("resourceGroupName")
  valid_594088 = validateParameter(valid_594088, JString, required = true,
                                 default = nil)
  if valid_594088 != nil:
    section.add "resourceGroupName", valid_594088
  var valid_594089 = path.getOrDefault("authorizationRuleName")
  valid_594089 = validateParameter(valid_594089, JString, required = true,
                                 default = nil)
  if valid_594089 != nil:
    section.add "authorizationRuleName", valid_594089
  var valid_594090 = path.getOrDefault("subscriptionId")
  valid_594090 = validateParameter(valid_594090, JString, required = true,
                                 default = nil)
  if valid_594090 != nil:
    section.add "subscriptionId", valid_594090
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594091 = query.getOrDefault("api-version")
  valid_594091 = validateParameter(valid_594091, JString, required = true,
                                 default = nil)
  if valid_594091 != nil:
    section.add "api-version", valid_594091
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594092: Call_NamespacesGetAuthorizationRule_594084; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an AuthorizationRule for a Namespace by rule name.
  ## 
  let valid = call_594092.validator(path, query, header, formData, body)
  let scheme = call_594092.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594092.url(scheme.get, call_594092.host, call_594092.base,
                         call_594092.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594092, url, valid)

proc call*(call_594093: Call_NamespacesGetAuthorizationRule_594084;
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
  var path_594094 = newJObject()
  var query_594095 = newJObject()
  add(path_594094, "namespaceName", newJString(namespaceName))
  add(path_594094, "resourceGroupName", newJString(resourceGroupName))
  add(query_594095, "api-version", newJString(apiVersion))
  add(path_594094, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_594094, "subscriptionId", newJString(subscriptionId))
  result = call_594093.call(path_594094, query_594095, nil, nil, nil)

var namespacesGetAuthorizationRule* = Call_NamespacesGetAuthorizationRule_594084(
    name: "namespacesGetAuthorizationRule", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/AuthorizationRules/{authorizationRuleName}",
    validator: validate_NamespacesGetAuthorizationRule_594085, base: "",
    url: url_NamespacesGetAuthorizationRule_594086, schemes: {Scheme.Https})
type
  Call_NamespacesDeleteAuthorizationRule_594122 = ref object of OpenApiRestCall_593424
proc url_NamespacesDeleteAuthorizationRule_594124(protocol: Scheme; host: string;
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

proc validate_NamespacesDeleteAuthorizationRule_594123(path: JsonNode;
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
  var valid_594125 = path.getOrDefault("namespaceName")
  valid_594125 = validateParameter(valid_594125, JString, required = true,
                                 default = nil)
  if valid_594125 != nil:
    section.add "namespaceName", valid_594125
  var valid_594126 = path.getOrDefault("resourceGroupName")
  valid_594126 = validateParameter(valid_594126, JString, required = true,
                                 default = nil)
  if valid_594126 != nil:
    section.add "resourceGroupName", valid_594126
  var valid_594127 = path.getOrDefault("authorizationRuleName")
  valid_594127 = validateParameter(valid_594127, JString, required = true,
                                 default = nil)
  if valid_594127 != nil:
    section.add "authorizationRuleName", valid_594127
  var valid_594128 = path.getOrDefault("subscriptionId")
  valid_594128 = validateParameter(valid_594128, JString, required = true,
                                 default = nil)
  if valid_594128 != nil:
    section.add "subscriptionId", valid_594128
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594129 = query.getOrDefault("api-version")
  valid_594129 = validateParameter(valid_594129, JString, required = true,
                                 default = nil)
  if valid_594129 != nil:
    section.add "api-version", valid_594129
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594130: Call_NamespacesDeleteAuthorizationRule_594122;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an AuthorizationRule for a Namespace.
  ## 
  let valid = call_594130.validator(path, query, header, formData, body)
  let scheme = call_594130.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594130.url(scheme.get, call_594130.host, call_594130.base,
                         call_594130.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594130, url, valid)

proc call*(call_594131: Call_NamespacesDeleteAuthorizationRule_594122;
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
  var path_594132 = newJObject()
  var query_594133 = newJObject()
  add(path_594132, "namespaceName", newJString(namespaceName))
  add(path_594132, "resourceGroupName", newJString(resourceGroupName))
  add(query_594133, "api-version", newJString(apiVersion))
  add(path_594132, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_594132, "subscriptionId", newJString(subscriptionId))
  result = call_594131.call(path_594132, query_594133, nil, nil, nil)

var namespacesDeleteAuthorizationRule* = Call_NamespacesDeleteAuthorizationRule_594122(
    name: "namespacesDeleteAuthorizationRule", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/AuthorizationRules/{authorizationRuleName}",
    validator: validate_NamespacesDeleteAuthorizationRule_594123, base: "",
    url: url_NamespacesDeleteAuthorizationRule_594124, schemes: {Scheme.Https})
type
  Call_EventHubsListAll_594134 = ref object of OpenApiRestCall_593424
proc url_EventHubsListAll_594136(protocol: Scheme; host: string; base: string;
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

proc validate_EventHubsListAll_594135(path: JsonNode; query: JsonNode;
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
  var valid_594137 = path.getOrDefault("namespaceName")
  valid_594137 = validateParameter(valid_594137, JString, required = true,
                                 default = nil)
  if valid_594137 != nil:
    section.add "namespaceName", valid_594137
  var valid_594138 = path.getOrDefault("resourceGroupName")
  valid_594138 = validateParameter(valid_594138, JString, required = true,
                                 default = nil)
  if valid_594138 != nil:
    section.add "resourceGroupName", valid_594138
  var valid_594139 = path.getOrDefault("subscriptionId")
  valid_594139 = validateParameter(valid_594139, JString, required = true,
                                 default = nil)
  if valid_594139 != nil:
    section.add "subscriptionId", valid_594139
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594140 = query.getOrDefault("api-version")
  valid_594140 = validateParameter(valid_594140, JString, required = true,
                                 default = nil)
  if valid_594140 != nil:
    section.add "api-version", valid_594140
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594141: Call_EventHubsListAll_594134; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the Event Hubs in a Namespace.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639493.aspx
  let valid = call_594141.validator(path, query, header, formData, body)
  let scheme = call_594141.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594141.url(scheme.get, call_594141.host, call_594141.base,
                         call_594141.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594141, url, valid)

proc call*(call_594142: Call_EventHubsListAll_594134; namespaceName: string;
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
  var path_594143 = newJObject()
  var query_594144 = newJObject()
  add(path_594143, "namespaceName", newJString(namespaceName))
  add(path_594143, "resourceGroupName", newJString(resourceGroupName))
  add(query_594144, "api-version", newJString(apiVersion))
  add(path_594143, "subscriptionId", newJString(subscriptionId))
  result = call_594142.call(path_594143, query_594144, nil, nil, nil)

var eventHubsListAll* = Call_EventHubsListAll_594134(name: "eventHubsListAll",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/eventhubs",
    validator: validate_EventHubsListAll_594135, base: "",
    url: url_EventHubsListAll_594136, schemes: {Scheme.Https})
type
  Call_EventHubsCreateOrUpdate_594157 = ref object of OpenApiRestCall_593424
proc url_EventHubsCreateOrUpdate_594159(protocol: Scheme; host: string; base: string;
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

proc validate_EventHubsCreateOrUpdate_594158(path: JsonNode; query: JsonNode;
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
  var valid_594160 = path.getOrDefault("namespaceName")
  valid_594160 = validateParameter(valid_594160, JString, required = true,
                                 default = nil)
  if valid_594160 != nil:
    section.add "namespaceName", valid_594160
  var valid_594161 = path.getOrDefault("resourceGroupName")
  valid_594161 = validateParameter(valid_594161, JString, required = true,
                                 default = nil)
  if valid_594161 != nil:
    section.add "resourceGroupName", valid_594161
  var valid_594162 = path.getOrDefault("eventHubName")
  valid_594162 = validateParameter(valid_594162, JString, required = true,
                                 default = nil)
  if valid_594162 != nil:
    section.add "eventHubName", valid_594162
  var valid_594163 = path.getOrDefault("subscriptionId")
  valid_594163 = validateParameter(valid_594163, JString, required = true,
                                 default = nil)
  if valid_594163 != nil:
    section.add "subscriptionId", valid_594163
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
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
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to create an Event Hub resource.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594166: Call_EventHubsCreateOrUpdate_594157; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a new Event Hub as a nested resource within a Namespace.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639497.aspx
  let valid = call_594166.validator(path, query, header, formData, body)
  let scheme = call_594166.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594166.url(scheme.get, call_594166.host, call_594166.base,
                         call_594166.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594166, url, valid)

proc call*(call_594167: Call_EventHubsCreateOrUpdate_594157; namespaceName: string;
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
  var path_594168 = newJObject()
  var query_594169 = newJObject()
  var body_594170 = newJObject()
  add(path_594168, "namespaceName", newJString(namespaceName))
  add(path_594168, "resourceGroupName", newJString(resourceGroupName))
  add(query_594169, "api-version", newJString(apiVersion))
  add(path_594168, "eventHubName", newJString(eventHubName))
  add(path_594168, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594170 = parameters
  result = call_594167.call(path_594168, query_594169, nil, nil, body_594170)

var eventHubsCreateOrUpdate* = Call_EventHubsCreateOrUpdate_594157(
    name: "eventHubsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/eventhubs/{eventHubName}",
    validator: validate_EventHubsCreateOrUpdate_594158, base: "",
    url: url_EventHubsCreateOrUpdate_594159, schemes: {Scheme.Https})
type
  Call_EventHubsGet_594145 = ref object of OpenApiRestCall_593424
proc url_EventHubsGet_594147(protocol: Scheme; host: string; base: string;
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

proc validate_EventHubsGet_594146(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594148 = path.getOrDefault("namespaceName")
  valid_594148 = validateParameter(valid_594148, JString, required = true,
                                 default = nil)
  if valid_594148 != nil:
    section.add "namespaceName", valid_594148
  var valid_594149 = path.getOrDefault("resourceGroupName")
  valid_594149 = validateParameter(valid_594149, JString, required = true,
                                 default = nil)
  if valid_594149 != nil:
    section.add "resourceGroupName", valid_594149
  var valid_594150 = path.getOrDefault("eventHubName")
  valid_594150 = validateParameter(valid_594150, JString, required = true,
                                 default = nil)
  if valid_594150 != nil:
    section.add "eventHubName", valid_594150
  var valid_594151 = path.getOrDefault("subscriptionId")
  valid_594151 = validateParameter(valid_594151, JString, required = true,
                                 default = nil)
  if valid_594151 != nil:
    section.add "subscriptionId", valid_594151
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594152 = query.getOrDefault("api-version")
  valid_594152 = validateParameter(valid_594152, JString, required = true,
                                 default = nil)
  if valid_594152 != nil:
    section.add "api-version", valid_594152
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594153: Call_EventHubsGet_594145; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an Event Hubs description for the specified Event Hub.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639501.aspx
  let valid = call_594153.validator(path, query, header, formData, body)
  let scheme = call_594153.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594153.url(scheme.get, call_594153.host, call_594153.base,
                         call_594153.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594153, url, valid)

proc call*(call_594154: Call_EventHubsGet_594145; namespaceName: string;
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
  var path_594155 = newJObject()
  var query_594156 = newJObject()
  add(path_594155, "namespaceName", newJString(namespaceName))
  add(path_594155, "resourceGroupName", newJString(resourceGroupName))
  add(query_594156, "api-version", newJString(apiVersion))
  add(path_594155, "eventHubName", newJString(eventHubName))
  add(path_594155, "subscriptionId", newJString(subscriptionId))
  result = call_594154.call(path_594155, query_594156, nil, nil, nil)

var eventHubsGet* = Call_EventHubsGet_594145(name: "eventHubsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/eventhubs/{eventHubName}",
    validator: validate_EventHubsGet_594146, base: "", url: url_EventHubsGet_594147,
    schemes: {Scheme.Https})
type
  Call_EventHubsDelete_594171 = ref object of OpenApiRestCall_593424
proc url_EventHubsDelete_594173(protocol: Scheme; host: string; base: string;
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

proc validate_EventHubsDelete_594172(path: JsonNode; query: JsonNode;
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
  var valid_594174 = path.getOrDefault("namespaceName")
  valid_594174 = validateParameter(valid_594174, JString, required = true,
                                 default = nil)
  if valid_594174 != nil:
    section.add "namespaceName", valid_594174
  var valid_594175 = path.getOrDefault("resourceGroupName")
  valid_594175 = validateParameter(valid_594175, JString, required = true,
                                 default = nil)
  if valid_594175 != nil:
    section.add "resourceGroupName", valid_594175
  var valid_594176 = path.getOrDefault("eventHubName")
  valid_594176 = validateParameter(valid_594176, JString, required = true,
                                 default = nil)
  if valid_594176 != nil:
    section.add "eventHubName", valid_594176
  var valid_594177 = path.getOrDefault("subscriptionId")
  valid_594177 = validateParameter(valid_594177, JString, required = true,
                                 default = nil)
  if valid_594177 != nil:
    section.add "subscriptionId", valid_594177
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594178 = query.getOrDefault("api-version")
  valid_594178 = validateParameter(valid_594178, JString, required = true,
                                 default = nil)
  if valid_594178 != nil:
    section.add "api-version", valid_594178
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594179: Call_EventHubsDelete_594171; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an Event Hub from the specified Namespace and resource group.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639496.aspx
  let valid = call_594179.validator(path, query, header, formData, body)
  let scheme = call_594179.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594179.url(scheme.get, call_594179.host, call_594179.base,
                         call_594179.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594179, url, valid)

proc call*(call_594180: Call_EventHubsDelete_594171; namespaceName: string;
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
  var path_594181 = newJObject()
  var query_594182 = newJObject()
  add(path_594181, "namespaceName", newJString(namespaceName))
  add(path_594181, "resourceGroupName", newJString(resourceGroupName))
  add(query_594182, "api-version", newJString(apiVersion))
  add(path_594181, "eventHubName", newJString(eventHubName))
  add(path_594181, "subscriptionId", newJString(subscriptionId))
  result = call_594180.call(path_594181, query_594182, nil, nil, nil)

var eventHubsDelete* = Call_EventHubsDelete_594171(name: "eventHubsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/eventhubs/{eventHubName}",
    validator: validate_EventHubsDelete_594172, base: "", url: url_EventHubsDelete_594173,
    schemes: {Scheme.Https})
type
  Call_EventHubsListAuthorizationRules_594183 = ref object of OpenApiRestCall_593424
proc url_EventHubsListAuthorizationRules_594185(protocol: Scheme; host: string;
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

proc validate_EventHubsListAuthorizationRules_594184(path: JsonNode;
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
  var valid_594186 = path.getOrDefault("namespaceName")
  valid_594186 = validateParameter(valid_594186, JString, required = true,
                                 default = nil)
  if valid_594186 != nil:
    section.add "namespaceName", valid_594186
  var valid_594187 = path.getOrDefault("resourceGroupName")
  valid_594187 = validateParameter(valid_594187, JString, required = true,
                                 default = nil)
  if valid_594187 != nil:
    section.add "resourceGroupName", valid_594187
  var valid_594188 = path.getOrDefault("eventHubName")
  valid_594188 = validateParameter(valid_594188, JString, required = true,
                                 default = nil)
  if valid_594188 != nil:
    section.add "eventHubName", valid_594188
  var valid_594189 = path.getOrDefault("subscriptionId")
  valid_594189 = validateParameter(valid_594189, JString, required = true,
                                 default = nil)
  if valid_594189 != nil:
    section.add "subscriptionId", valid_594189
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594190 = query.getOrDefault("api-version")
  valid_594190 = validateParameter(valid_594190, JString, required = true,
                                 default = nil)
  if valid_594190 != nil:
    section.add "api-version", valid_594190
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594191: Call_EventHubsListAuthorizationRules_594183;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the authorization rules for an Event Hub.
  ## 
  let valid = call_594191.validator(path, query, header, formData, body)
  let scheme = call_594191.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594191.url(scheme.get, call_594191.host, call_594191.base,
                         call_594191.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594191, url, valid)

proc call*(call_594192: Call_EventHubsListAuthorizationRules_594183;
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
  var path_594193 = newJObject()
  var query_594194 = newJObject()
  add(path_594193, "namespaceName", newJString(namespaceName))
  add(path_594193, "resourceGroupName", newJString(resourceGroupName))
  add(query_594194, "api-version", newJString(apiVersion))
  add(path_594193, "eventHubName", newJString(eventHubName))
  add(path_594193, "subscriptionId", newJString(subscriptionId))
  result = call_594192.call(path_594193, query_594194, nil, nil, nil)

var eventHubsListAuthorizationRules* = Call_EventHubsListAuthorizationRules_594183(
    name: "eventHubsListAuthorizationRules", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/eventhubs/{eventHubName}/authorizationRules",
    validator: validate_EventHubsListAuthorizationRules_594184, base: "",
    url: url_EventHubsListAuthorizationRules_594185, schemes: {Scheme.Https})
type
  Call_EventHubsCreateOrUpdateAuthorizationRule_594208 = ref object of OpenApiRestCall_593424
proc url_EventHubsCreateOrUpdateAuthorizationRule_594210(protocol: Scheme;
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

proc validate_EventHubsCreateOrUpdateAuthorizationRule_594209(path: JsonNode;
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
  var valid_594213 = path.getOrDefault("eventHubName")
  valid_594213 = validateParameter(valid_594213, JString, required = true,
                                 default = nil)
  if valid_594213 != nil:
    section.add "eventHubName", valid_594213
  var valid_594214 = path.getOrDefault("authorizationRuleName")
  valid_594214 = validateParameter(valid_594214, JString, required = true,
                                 default = nil)
  if valid_594214 != nil:
    section.add "authorizationRuleName", valid_594214
  var valid_594215 = path.getOrDefault("subscriptionId")
  valid_594215 = validateParameter(valid_594215, JString, required = true,
                                 default = nil)
  if valid_594215 != nil:
    section.add "subscriptionId", valid_594215
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594216 = query.getOrDefault("api-version")
  valid_594216 = validateParameter(valid_594216, JString, required = true,
                                 default = nil)
  if valid_594216 != nil:
    section.add "api-version", valid_594216
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

proc call*(call_594218: Call_EventHubsCreateOrUpdateAuthorizationRule_594208;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates an AuthorizationRule for the specified Event Hub.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt706096.aspx
  let valid = call_594218.validator(path, query, header, formData, body)
  let scheme = call_594218.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594218.url(scheme.get, call_594218.host, call_594218.base,
                         call_594218.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594218, url, valid)

proc call*(call_594219: Call_EventHubsCreateOrUpdateAuthorizationRule_594208;
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
  var path_594220 = newJObject()
  var query_594221 = newJObject()
  var body_594222 = newJObject()
  add(path_594220, "namespaceName", newJString(namespaceName))
  add(path_594220, "resourceGroupName", newJString(resourceGroupName))
  add(query_594221, "api-version", newJString(apiVersion))
  add(path_594220, "eventHubName", newJString(eventHubName))
  add(path_594220, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_594220, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594222 = parameters
  result = call_594219.call(path_594220, query_594221, nil, nil, body_594222)

var eventHubsCreateOrUpdateAuthorizationRule* = Call_EventHubsCreateOrUpdateAuthorizationRule_594208(
    name: "eventHubsCreateOrUpdateAuthorizationRule", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/eventhubs/{eventHubName}/authorizationRules/{authorizationRuleName}",
    validator: validate_EventHubsCreateOrUpdateAuthorizationRule_594209, base: "",
    url: url_EventHubsCreateOrUpdateAuthorizationRule_594210,
    schemes: {Scheme.Https})
type
  Call_EventHubsPostAuthorizationRule_594223 = ref object of OpenApiRestCall_593424
proc url_EventHubsPostAuthorizationRule_594225(protocol: Scheme; host: string;
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

proc validate_EventHubsPostAuthorizationRule_594224(path: JsonNode;
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
  var valid_594226 = path.getOrDefault("namespaceName")
  valid_594226 = validateParameter(valid_594226, JString, required = true,
                                 default = nil)
  if valid_594226 != nil:
    section.add "namespaceName", valid_594226
  var valid_594227 = path.getOrDefault("resourceGroupName")
  valid_594227 = validateParameter(valid_594227, JString, required = true,
                                 default = nil)
  if valid_594227 != nil:
    section.add "resourceGroupName", valid_594227
  var valid_594228 = path.getOrDefault("eventHubName")
  valid_594228 = validateParameter(valid_594228, JString, required = true,
                                 default = nil)
  if valid_594228 != nil:
    section.add "eventHubName", valid_594228
  var valid_594229 = path.getOrDefault("authorizationRuleName")
  valid_594229 = validateParameter(valid_594229, JString, required = true,
                                 default = nil)
  if valid_594229 != nil:
    section.add "authorizationRuleName", valid_594229
  var valid_594230 = path.getOrDefault("subscriptionId")
  valid_594230 = validateParameter(valid_594230, JString, required = true,
                                 default = nil)
  if valid_594230 != nil:
    section.add "subscriptionId", valid_594230
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594231 = query.getOrDefault("api-version")
  valid_594231 = validateParameter(valid_594231, JString, required = true,
                                 default = nil)
  if valid_594231 != nil:
    section.add "api-version", valid_594231
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594232: Call_EventHubsPostAuthorizationRule_594223; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an AuthorizationRule for an Event Hub by rule name.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt706097.aspx
  let valid = call_594232.validator(path, query, header, formData, body)
  let scheme = call_594232.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594232.url(scheme.get, call_594232.host, call_594232.base,
                         call_594232.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594232, url, valid)

proc call*(call_594233: Call_EventHubsPostAuthorizationRule_594223;
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
  var path_594234 = newJObject()
  var query_594235 = newJObject()
  add(path_594234, "namespaceName", newJString(namespaceName))
  add(path_594234, "resourceGroupName", newJString(resourceGroupName))
  add(query_594235, "api-version", newJString(apiVersion))
  add(path_594234, "eventHubName", newJString(eventHubName))
  add(path_594234, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_594234, "subscriptionId", newJString(subscriptionId))
  result = call_594233.call(path_594234, query_594235, nil, nil, nil)

var eventHubsPostAuthorizationRule* = Call_EventHubsPostAuthorizationRule_594223(
    name: "eventHubsPostAuthorizationRule", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/eventhubs/{eventHubName}/authorizationRules/{authorizationRuleName}",
    validator: validate_EventHubsPostAuthorizationRule_594224, base: "",
    url: url_EventHubsPostAuthorizationRule_594225, schemes: {Scheme.Https})
type
  Call_EventHubsGetAuthorizationRule_594195 = ref object of OpenApiRestCall_593424
proc url_EventHubsGetAuthorizationRule_594197(protocol: Scheme; host: string;
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

proc validate_EventHubsGetAuthorizationRule_594196(path: JsonNode; query: JsonNode;
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
  var valid_594198 = path.getOrDefault("namespaceName")
  valid_594198 = validateParameter(valid_594198, JString, required = true,
                                 default = nil)
  if valid_594198 != nil:
    section.add "namespaceName", valid_594198
  var valid_594199 = path.getOrDefault("resourceGroupName")
  valid_594199 = validateParameter(valid_594199, JString, required = true,
                                 default = nil)
  if valid_594199 != nil:
    section.add "resourceGroupName", valid_594199
  var valid_594200 = path.getOrDefault("eventHubName")
  valid_594200 = validateParameter(valid_594200, JString, required = true,
                                 default = nil)
  if valid_594200 != nil:
    section.add "eventHubName", valid_594200
  var valid_594201 = path.getOrDefault("authorizationRuleName")
  valid_594201 = validateParameter(valid_594201, JString, required = true,
                                 default = nil)
  if valid_594201 != nil:
    section.add "authorizationRuleName", valid_594201
  var valid_594202 = path.getOrDefault("subscriptionId")
  valid_594202 = validateParameter(valid_594202, JString, required = true,
                                 default = nil)
  if valid_594202 != nil:
    section.add "subscriptionId", valid_594202
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594203 = query.getOrDefault("api-version")
  valid_594203 = validateParameter(valid_594203, JString, required = true,
                                 default = nil)
  if valid_594203 != nil:
    section.add "api-version", valid_594203
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594204: Call_EventHubsGetAuthorizationRule_594195; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an AuthorizationRule for an Event Hub by rule name.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt706097.aspx
  let valid = call_594204.validator(path, query, header, formData, body)
  let scheme = call_594204.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594204.url(scheme.get, call_594204.host, call_594204.base,
                         call_594204.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594204, url, valid)

proc call*(call_594205: Call_EventHubsGetAuthorizationRule_594195;
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
  var path_594206 = newJObject()
  var query_594207 = newJObject()
  add(path_594206, "namespaceName", newJString(namespaceName))
  add(path_594206, "resourceGroupName", newJString(resourceGroupName))
  add(query_594207, "api-version", newJString(apiVersion))
  add(path_594206, "eventHubName", newJString(eventHubName))
  add(path_594206, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_594206, "subscriptionId", newJString(subscriptionId))
  result = call_594205.call(path_594206, query_594207, nil, nil, nil)

var eventHubsGetAuthorizationRule* = Call_EventHubsGetAuthorizationRule_594195(
    name: "eventHubsGetAuthorizationRule", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/eventhubs/{eventHubName}/authorizationRules/{authorizationRuleName}",
    validator: validate_EventHubsGetAuthorizationRule_594196, base: "",
    url: url_EventHubsGetAuthorizationRule_594197, schemes: {Scheme.Https})
type
  Call_EventHubsDeleteAuthorizationRule_594236 = ref object of OpenApiRestCall_593424
proc url_EventHubsDeleteAuthorizationRule_594238(protocol: Scheme; host: string;
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

proc validate_EventHubsDeleteAuthorizationRule_594237(path: JsonNode;
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
  var valid_594239 = path.getOrDefault("namespaceName")
  valid_594239 = validateParameter(valid_594239, JString, required = true,
                                 default = nil)
  if valid_594239 != nil:
    section.add "namespaceName", valid_594239
  var valid_594240 = path.getOrDefault("resourceGroupName")
  valid_594240 = validateParameter(valid_594240, JString, required = true,
                                 default = nil)
  if valid_594240 != nil:
    section.add "resourceGroupName", valid_594240
  var valid_594241 = path.getOrDefault("eventHubName")
  valid_594241 = validateParameter(valid_594241, JString, required = true,
                                 default = nil)
  if valid_594241 != nil:
    section.add "eventHubName", valid_594241
  var valid_594242 = path.getOrDefault("authorizationRuleName")
  valid_594242 = validateParameter(valid_594242, JString, required = true,
                                 default = nil)
  if valid_594242 != nil:
    section.add "authorizationRuleName", valid_594242
  var valid_594243 = path.getOrDefault("subscriptionId")
  valid_594243 = validateParameter(valid_594243, JString, required = true,
                                 default = nil)
  if valid_594243 != nil:
    section.add "subscriptionId", valid_594243
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594244 = query.getOrDefault("api-version")
  valid_594244 = validateParameter(valid_594244, JString, required = true,
                                 default = nil)
  if valid_594244 != nil:
    section.add "api-version", valid_594244
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594245: Call_EventHubsDeleteAuthorizationRule_594236;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an Event Hub AuthorizationRule.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt706100.aspx
  let valid = call_594245.validator(path, query, header, formData, body)
  let scheme = call_594245.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594245.url(scheme.get, call_594245.host, call_594245.base,
                         call_594245.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594245, url, valid)

proc call*(call_594246: Call_EventHubsDeleteAuthorizationRule_594236;
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
  var path_594247 = newJObject()
  var query_594248 = newJObject()
  add(path_594247, "namespaceName", newJString(namespaceName))
  add(path_594247, "resourceGroupName", newJString(resourceGroupName))
  add(query_594248, "api-version", newJString(apiVersion))
  add(path_594247, "eventHubName", newJString(eventHubName))
  add(path_594247, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_594247, "subscriptionId", newJString(subscriptionId))
  result = call_594246.call(path_594247, query_594248, nil, nil, nil)

var eventHubsDeleteAuthorizationRule* = Call_EventHubsDeleteAuthorizationRule_594236(
    name: "eventHubsDeleteAuthorizationRule", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/eventhubs/{eventHubName}/authorizationRules/{authorizationRuleName}",
    validator: validate_EventHubsDeleteAuthorizationRule_594237, base: "",
    url: url_EventHubsDeleteAuthorizationRule_594238, schemes: {Scheme.Https})
type
  Call_ConsumerGroupsListAll_594249 = ref object of OpenApiRestCall_593424
proc url_ConsumerGroupsListAll_594251(protocol: Scheme; host: string; base: string;
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

proc validate_ConsumerGroupsListAll_594250(path: JsonNode; query: JsonNode;
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
  var valid_594252 = path.getOrDefault("namespaceName")
  valid_594252 = validateParameter(valid_594252, JString, required = true,
                                 default = nil)
  if valid_594252 != nil:
    section.add "namespaceName", valid_594252
  var valid_594253 = path.getOrDefault("resourceGroupName")
  valid_594253 = validateParameter(valid_594253, JString, required = true,
                                 default = nil)
  if valid_594253 != nil:
    section.add "resourceGroupName", valid_594253
  var valid_594254 = path.getOrDefault("eventHubName")
  valid_594254 = validateParameter(valid_594254, JString, required = true,
                                 default = nil)
  if valid_594254 != nil:
    section.add "eventHubName", valid_594254
  var valid_594255 = path.getOrDefault("subscriptionId")
  valid_594255 = validateParameter(valid_594255, JString, required = true,
                                 default = nil)
  if valid_594255 != nil:
    section.add "subscriptionId", valid_594255
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594256 = query.getOrDefault("api-version")
  valid_594256 = validateParameter(valid_594256, JString, required = true,
                                 default = nil)
  if valid_594256 != nil:
    section.add "api-version", valid_594256
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594257: Call_ConsumerGroupsListAll_594249; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the consumer groups in a Namespace. An empty feed is returned if no consumer group exists in the Namespace.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639503.aspx
  let valid = call_594257.validator(path, query, header, formData, body)
  let scheme = call_594257.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594257.url(scheme.get, call_594257.host, call_594257.base,
                         call_594257.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594257, url, valid)

proc call*(call_594258: Call_ConsumerGroupsListAll_594249; namespaceName: string;
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
  var path_594259 = newJObject()
  var query_594260 = newJObject()
  add(path_594259, "namespaceName", newJString(namespaceName))
  add(path_594259, "resourceGroupName", newJString(resourceGroupName))
  add(query_594260, "api-version", newJString(apiVersion))
  add(path_594259, "eventHubName", newJString(eventHubName))
  add(path_594259, "subscriptionId", newJString(subscriptionId))
  result = call_594258.call(path_594259, query_594260, nil, nil, nil)

var consumerGroupsListAll* = Call_ConsumerGroupsListAll_594249(
    name: "consumerGroupsListAll", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/eventhubs/{eventHubName}/consumergroups",
    validator: validate_ConsumerGroupsListAll_594250, base: "",
    url: url_ConsumerGroupsListAll_594251, schemes: {Scheme.Https})
type
  Call_ConsumerGroupsCreateOrUpdate_594274 = ref object of OpenApiRestCall_593424
proc url_ConsumerGroupsCreateOrUpdate_594276(protocol: Scheme; host: string;
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

proc validate_ConsumerGroupsCreateOrUpdate_594275(path: JsonNode; query: JsonNode;
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
  var valid_594277 = path.getOrDefault("namespaceName")
  valid_594277 = validateParameter(valid_594277, JString, required = true,
                                 default = nil)
  if valid_594277 != nil:
    section.add "namespaceName", valid_594277
  var valid_594278 = path.getOrDefault("resourceGroupName")
  valid_594278 = validateParameter(valid_594278, JString, required = true,
                                 default = nil)
  if valid_594278 != nil:
    section.add "resourceGroupName", valid_594278
  var valid_594279 = path.getOrDefault("eventHubName")
  valid_594279 = validateParameter(valid_594279, JString, required = true,
                                 default = nil)
  if valid_594279 != nil:
    section.add "eventHubName", valid_594279
  var valid_594280 = path.getOrDefault("subscriptionId")
  valid_594280 = validateParameter(valid_594280, JString, required = true,
                                 default = nil)
  if valid_594280 != nil:
    section.add "subscriptionId", valid_594280
  var valid_594281 = path.getOrDefault("consumerGroupName")
  valid_594281 = validateParameter(valid_594281, JString, required = true,
                                 default = nil)
  if valid_594281 != nil:
    section.add "consumerGroupName", valid_594281
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594282 = query.getOrDefault("api-version")
  valid_594282 = validateParameter(valid_594282, JString, required = true,
                                 default = nil)
  if valid_594282 != nil:
    section.add "api-version", valid_594282
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

proc call*(call_594284: Call_ConsumerGroupsCreateOrUpdate_594274; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates an Event Hubs consumer group as a nested resource within a Namespace.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639498.aspx
  let valid = call_594284.validator(path, query, header, formData, body)
  let scheme = call_594284.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594284.url(scheme.get, call_594284.host, call_594284.base,
                         call_594284.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594284, url, valid)

proc call*(call_594285: Call_ConsumerGroupsCreateOrUpdate_594274;
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
  var path_594286 = newJObject()
  var query_594287 = newJObject()
  var body_594288 = newJObject()
  add(path_594286, "namespaceName", newJString(namespaceName))
  add(path_594286, "resourceGroupName", newJString(resourceGroupName))
  add(query_594287, "api-version", newJString(apiVersion))
  add(path_594286, "eventHubName", newJString(eventHubName))
  add(path_594286, "subscriptionId", newJString(subscriptionId))
  add(path_594286, "consumerGroupName", newJString(consumerGroupName))
  if parameters != nil:
    body_594288 = parameters
  result = call_594285.call(path_594286, query_594287, nil, nil, body_594288)

var consumerGroupsCreateOrUpdate* = Call_ConsumerGroupsCreateOrUpdate_594274(
    name: "consumerGroupsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/eventhubs/{eventHubName}/consumergroups/{consumerGroupName}",
    validator: validate_ConsumerGroupsCreateOrUpdate_594275, base: "",
    url: url_ConsumerGroupsCreateOrUpdate_594276, schemes: {Scheme.Https})
type
  Call_ConsumerGroupsGet_594261 = ref object of OpenApiRestCall_593424
proc url_ConsumerGroupsGet_594263(protocol: Scheme; host: string; base: string;
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

proc validate_ConsumerGroupsGet_594262(path: JsonNode; query: JsonNode;
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
  var valid_594264 = path.getOrDefault("namespaceName")
  valid_594264 = validateParameter(valid_594264, JString, required = true,
                                 default = nil)
  if valid_594264 != nil:
    section.add "namespaceName", valid_594264
  var valid_594265 = path.getOrDefault("resourceGroupName")
  valid_594265 = validateParameter(valid_594265, JString, required = true,
                                 default = nil)
  if valid_594265 != nil:
    section.add "resourceGroupName", valid_594265
  var valid_594266 = path.getOrDefault("eventHubName")
  valid_594266 = validateParameter(valid_594266, JString, required = true,
                                 default = nil)
  if valid_594266 != nil:
    section.add "eventHubName", valid_594266
  var valid_594267 = path.getOrDefault("subscriptionId")
  valid_594267 = validateParameter(valid_594267, JString, required = true,
                                 default = nil)
  if valid_594267 != nil:
    section.add "subscriptionId", valid_594267
  var valid_594268 = path.getOrDefault("consumerGroupName")
  valid_594268 = validateParameter(valid_594268, JString, required = true,
                                 default = nil)
  if valid_594268 != nil:
    section.add "consumerGroupName", valid_594268
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594269 = query.getOrDefault("api-version")
  valid_594269 = validateParameter(valid_594269, JString, required = true,
                                 default = nil)
  if valid_594269 != nil:
    section.add "api-version", valid_594269
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594270: Call_ConsumerGroupsGet_594261; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a description for the specified consumer group.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639488.aspx
  let valid = call_594270.validator(path, query, header, formData, body)
  let scheme = call_594270.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594270.url(scheme.get, call_594270.host, call_594270.base,
                         call_594270.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594270, url, valid)

proc call*(call_594271: Call_ConsumerGroupsGet_594261; namespaceName: string;
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
  var path_594272 = newJObject()
  var query_594273 = newJObject()
  add(path_594272, "namespaceName", newJString(namespaceName))
  add(path_594272, "resourceGroupName", newJString(resourceGroupName))
  add(query_594273, "api-version", newJString(apiVersion))
  add(path_594272, "eventHubName", newJString(eventHubName))
  add(path_594272, "subscriptionId", newJString(subscriptionId))
  add(path_594272, "consumerGroupName", newJString(consumerGroupName))
  result = call_594271.call(path_594272, query_594273, nil, nil, nil)

var consumerGroupsGet* = Call_ConsumerGroupsGet_594261(name: "consumerGroupsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/eventhubs/{eventHubName}/consumergroups/{consumerGroupName}",
    validator: validate_ConsumerGroupsGet_594262, base: "",
    url: url_ConsumerGroupsGet_594263, schemes: {Scheme.Https})
type
  Call_ConsumerGroupsDelete_594289 = ref object of OpenApiRestCall_593424
proc url_ConsumerGroupsDelete_594291(protocol: Scheme; host: string; base: string;
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

proc validate_ConsumerGroupsDelete_594290(path: JsonNode; query: JsonNode;
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
  var valid_594292 = path.getOrDefault("namespaceName")
  valid_594292 = validateParameter(valid_594292, JString, required = true,
                                 default = nil)
  if valid_594292 != nil:
    section.add "namespaceName", valid_594292
  var valid_594293 = path.getOrDefault("resourceGroupName")
  valid_594293 = validateParameter(valid_594293, JString, required = true,
                                 default = nil)
  if valid_594293 != nil:
    section.add "resourceGroupName", valid_594293
  var valid_594294 = path.getOrDefault("eventHubName")
  valid_594294 = validateParameter(valid_594294, JString, required = true,
                                 default = nil)
  if valid_594294 != nil:
    section.add "eventHubName", valid_594294
  var valid_594295 = path.getOrDefault("subscriptionId")
  valid_594295 = validateParameter(valid_594295, JString, required = true,
                                 default = nil)
  if valid_594295 != nil:
    section.add "subscriptionId", valid_594295
  var valid_594296 = path.getOrDefault("consumerGroupName")
  valid_594296 = validateParameter(valid_594296, JString, required = true,
                                 default = nil)
  if valid_594296 != nil:
    section.add "consumerGroupName", valid_594296
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594297 = query.getOrDefault("api-version")
  valid_594297 = validateParameter(valid_594297, JString, required = true,
                                 default = nil)
  if valid_594297 != nil:
    section.add "api-version", valid_594297
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594298: Call_ConsumerGroupsDelete_594289; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a consumer group from the specified Event Hub and resource group.
  ## 
  ## https://msdn.microsoft.com/en-us/library/azure/mt639491.aspx
  let valid = call_594298.validator(path, query, header, formData, body)
  let scheme = call_594298.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594298.url(scheme.get, call_594298.host, call_594298.base,
                         call_594298.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594298, url, valid)

proc call*(call_594299: Call_ConsumerGroupsDelete_594289; namespaceName: string;
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
  var path_594300 = newJObject()
  var query_594301 = newJObject()
  add(path_594300, "namespaceName", newJString(namespaceName))
  add(path_594300, "resourceGroupName", newJString(resourceGroupName))
  add(query_594301, "api-version", newJString(apiVersion))
  add(path_594300, "eventHubName", newJString(eventHubName))
  add(path_594300, "subscriptionId", newJString(subscriptionId))
  add(path_594300, "consumerGroupName", newJString(consumerGroupName))
  result = call_594299.call(path_594300, query_594301, nil, nil, nil)

var consumerGroupsDelete* = Call_ConsumerGroupsDelete_594289(
    name: "consumerGroupsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.EventHub/namespaces/{namespaceName}/eventhubs/{eventHubName}/consumergroups/{consumerGroupName}",
    validator: validate_ConsumerGroupsDelete_594290, base: "",
    url: url_ConsumerGroupsDelete_594291, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
