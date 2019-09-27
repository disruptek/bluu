
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: NotificationHubsManagementClient
## version: 2017-04-01
## termsOfService: (not provided)
## license: (not provided)
## 
## Azure NotificationHub client
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
  macServiceName = "notificationhubs"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_593647 = ref object of OpenApiRestCall_593425
proc url_OperationsList_593649(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_593648(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists all of the available NotificationHubs REST API operations.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593808 = query.getOrDefault("api-version")
  valid_593808 = validateParameter(valid_593808, JString, required = true,
                                 default = nil)
  if valid_593808 != nil:
    section.add "api-version", valid_593808
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593831: Call_OperationsList_593647; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available NotificationHubs REST API operations.
  ## 
  let valid = call_593831.validator(path, query, header, formData, body)
  let scheme = call_593831.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593831.url(scheme.get, call_593831.host, call_593831.base,
                         call_593831.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593831, url, valid)

proc call*(call_593902: Call_OperationsList_593647; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available NotificationHubs REST API operations.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var query_593903 = newJObject()
  add(query_593903, "api-version", newJString(apiVersion))
  result = call_593902.call(nil, query_593903, nil, nil, nil)

var operationsList* = Call_OperationsList_593647(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.NotificationHubs/operations",
    validator: validate_OperationsList_593648, base: "", url: url_OperationsList_593649,
    schemes: {Scheme.Https})
type
  Call_NamespacesCheckAvailability_593943 = ref object of OpenApiRestCall_593425
proc url_NamespacesCheckAvailability_593945(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.NotificationHubs/checkNamespaceAvailability")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesCheckAvailability_593944(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Checks the availability of the given service namespace across all Azure subscriptions. This is useful because the domain name is created based on the service namespace name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_593977 = path.getOrDefault("subscriptionId")
  valid_593977 = validateParameter(valid_593977, JString, required = true,
                                 default = nil)
  if valid_593977 != nil:
    section.add "subscriptionId", valid_593977
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593978 = query.getOrDefault("api-version")
  valid_593978 = validateParameter(valid_593978, JString, required = true,
                                 default = nil)
  if valid_593978 != nil:
    section.add "api-version", valid_593978
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The namespace name.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_593980: Call_NamespacesCheckAvailability_593943; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks the availability of the given service namespace across all Azure subscriptions. This is useful because the domain name is created based on the service namespace name.
  ## 
  let valid = call_593980.validator(path, query, header, formData, body)
  let scheme = call_593980.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593980.url(scheme.get, call_593980.host, call_593980.base,
                         call_593980.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593980, url, valid)

proc call*(call_593981: Call_NamespacesCheckAvailability_593943;
          apiVersion: string; subscriptionId: string; parameters: JsonNode): Recallable =
  ## namespacesCheckAvailability
  ## Checks the availability of the given service namespace across all Azure subscriptions. This is useful because the domain name is created based on the service namespace name.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : The namespace name.
  var path_593982 = newJObject()
  var query_593983 = newJObject()
  var body_593984 = newJObject()
  add(query_593983, "api-version", newJString(apiVersion))
  add(path_593982, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_593984 = parameters
  result = call_593981.call(path_593982, query_593983, nil, nil, body_593984)

var namespacesCheckAvailability* = Call_NamespacesCheckAvailability_593943(
    name: "namespacesCheckAvailability", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.NotificationHubs/checkNamespaceAvailability",
    validator: validate_NamespacesCheckAvailability_593944, base: "",
    url: url_NamespacesCheckAvailability_593945, schemes: {Scheme.Https})
type
  Call_NamespacesListAll_593985 = ref object of OpenApiRestCall_593425
proc url_NamespacesListAll_593987(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.NotificationHubs/namespaces")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesListAll_593986(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Lists all the available namespaces within the subscription irrespective of the resourceGroups.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_593988 = path.getOrDefault("subscriptionId")
  valid_593988 = validateParameter(valid_593988, JString, required = true,
                                 default = nil)
  if valid_593988 != nil:
    section.add "subscriptionId", valid_593988
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593989 = query.getOrDefault("api-version")
  valid_593989 = validateParameter(valid_593989, JString, required = true,
                                 default = nil)
  if valid_593989 != nil:
    section.add "api-version", valid_593989
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593990: Call_NamespacesListAll_593985; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the available namespaces within the subscription irrespective of the resourceGroups.
  ## 
  let valid = call_593990.validator(path, query, header, formData, body)
  let scheme = call_593990.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593990.url(scheme.get, call_593990.host, call_593990.base,
                         call_593990.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593990, url, valid)

proc call*(call_593991: Call_NamespacesListAll_593985; apiVersion: string;
          subscriptionId: string): Recallable =
  ## namespacesListAll
  ## Lists all the available namespaces within the subscription irrespective of the resourceGroups.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_593992 = newJObject()
  var query_593993 = newJObject()
  add(query_593993, "api-version", newJString(apiVersion))
  add(path_593992, "subscriptionId", newJString(subscriptionId))
  result = call_593991.call(path_593992, query_593993, nil, nil, nil)

var namespacesListAll* = Call_NamespacesListAll_593985(name: "namespacesListAll",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.NotificationHubs/namespaces",
    validator: validate_NamespacesListAll_593986, base: "",
    url: url_NamespacesListAll_593987, schemes: {Scheme.Https})
type
  Call_NamespacesList_593994 = ref object of OpenApiRestCall_593425
proc url_NamespacesList_593996(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
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
        value: "/providers/Microsoft.NotificationHubs/namespaces")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesList_593995(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists the available namespaces within a resourceGroup.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. If resourceGroupName value is null the method lists all the namespaces within subscription
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_593997 = path.getOrDefault("resourceGroupName")
  valid_593997 = validateParameter(valid_593997, JString, required = true,
                                 default = nil)
  if valid_593997 != nil:
    section.add "resourceGroupName", valid_593997
  var valid_593998 = path.getOrDefault("subscriptionId")
  valid_593998 = validateParameter(valid_593998, JString, required = true,
                                 default = nil)
  if valid_593998 != nil:
    section.add "subscriptionId", valid_593998
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
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

proc call*(call_594000: Call_NamespacesList_593994; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the available namespaces within a resourceGroup.
  ## 
  let valid = call_594000.validator(path, query, header, formData, body)
  let scheme = call_594000.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594000.url(scheme.get, call_594000.host, call_594000.base,
                         call_594000.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594000, url, valid)

proc call*(call_594001: Call_NamespacesList_593994; resourceGroupName: string;
          apiVersion: string; subscriptionId: string): Recallable =
  ## namespacesList
  ## Lists the available namespaces within a resourceGroup.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. If resourceGroupName value is null the method lists all the namespaces within subscription
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594002 = newJObject()
  var query_594003 = newJObject()
  add(path_594002, "resourceGroupName", newJString(resourceGroupName))
  add(query_594003, "api-version", newJString(apiVersion))
  add(path_594002, "subscriptionId", newJString(subscriptionId))
  result = call_594001.call(path_594002, query_594003, nil, nil, nil)

var namespacesList* = Call_NamespacesList_593994(name: "namespacesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NotificationHubs/namespaces",
    validator: validate_NamespacesList_593995, base: "", url: url_NamespacesList_593996,
    schemes: {Scheme.Https})
type
  Call_NamespacesCreateOrUpdate_594015 = ref object of OpenApiRestCall_593425
proc url_NamespacesCreateOrUpdate_594017(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.NotificationHubs/namespaces/"),
               (kind: VariableSegment, value: "namespaceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesCreateOrUpdate_594016(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates/Updates a service namespace. Once created, this namespace's resource manifest is immutable. This operation is idempotent.
  ## 
  ## http://msdn.microsoft.com/en-us/library/windowsazure/jj856303.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_594018 = path.getOrDefault("namespaceName")
  valid_594018 = validateParameter(valid_594018, JString, required = true,
                                 default = nil)
  if valid_594018 != nil:
    section.add "namespaceName", valid_594018
  var valid_594019 = path.getOrDefault("resourceGroupName")
  valid_594019 = validateParameter(valid_594019, JString, required = true,
                                 default = nil)
  if valid_594019 != nil:
    section.add "resourceGroupName", valid_594019
  var valid_594020 = path.getOrDefault("subscriptionId")
  valid_594020 = validateParameter(valid_594020, JString, required = true,
                                 default = nil)
  if valid_594020 != nil:
    section.add "subscriptionId", valid_594020
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594021 = query.getOrDefault("api-version")
  valid_594021 = validateParameter(valid_594021, JString, required = true,
                                 default = nil)
  if valid_594021 != nil:
    section.add "api-version", valid_594021
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to create a Namespace Resource.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594023: Call_NamespacesCreateOrUpdate_594015; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates/Updates a service namespace. Once created, this namespace's resource manifest is immutable. This operation is idempotent.
  ## 
  ## http://msdn.microsoft.com/en-us/library/windowsazure/jj856303.aspx
  let valid = call_594023.validator(path, query, header, formData, body)
  let scheme = call_594023.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594023.url(scheme.get, call_594023.host, call_594023.base,
                         call_594023.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594023, url, valid)

proc call*(call_594024: Call_NamespacesCreateOrUpdate_594015;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; parameters: JsonNode): Recallable =
  ## namespacesCreateOrUpdate
  ## Creates/Updates a service namespace. Once created, this namespace's resource manifest is immutable. This operation is idempotent.
  ## http://msdn.microsoft.com/en-us/library/windowsazure/jj856303.aspx
  ##   namespaceName: string (required)
  ##                : The namespace name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to create a Namespace Resource.
  var path_594025 = newJObject()
  var query_594026 = newJObject()
  var body_594027 = newJObject()
  add(path_594025, "namespaceName", newJString(namespaceName))
  add(path_594025, "resourceGroupName", newJString(resourceGroupName))
  add(query_594026, "api-version", newJString(apiVersion))
  add(path_594025, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594027 = parameters
  result = call_594024.call(path_594025, query_594026, nil, nil, body_594027)

var namespacesCreateOrUpdate* = Call_NamespacesCreateOrUpdate_594015(
    name: "namespacesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NotificationHubs/namespaces/{namespaceName}",
    validator: validate_NamespacesCreateOrUpdate_594016, base: "",
    url: url_NamespacesCreateOrUpdate_594017, schemes: {Scheme.Https})
type
  Call_NamespacesGet_594004 = ref object of OpenApiRestCall_593425
proc url_NamespacesGet_594006(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.NotificationHubs/namespaces/"),
               (kind: VariableSegment, value: "namespaceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesGet_594005(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the description for the specified namespace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_594007 = path.getOrDefault("namespaceName")
  valid_594007 = validateParameter(valid_594007, JString, required = true,
                                 default = nil)
  if valid_594007 != nil:
    section.add "namespaceName", valid_594007
  var valid_594008 = path.getOrDefault("resourceGroupName")
  valid_594008 = validateParameter(valid_594008, JString, required = true,
                                 default = nil)
  if valid_594008 != nil:
    section.add "resourceGroupName", valid_594008
  var valid_594009 = path.getOrDefault("subscriptionId")
  valid_594009 = validateParameter(valid_594009, JString, required = true,
                                 default = nil)
  if valid_594009 != nil:
    section.add "subscriptionId", valid_594009
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
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

proc call*(call_594011: Call_NamespacesGet_594004; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the description for the specified namespace.
  ## 
  let valid = call_594011.validator(path, query, header, formData, body)
  let scheme = call_594011.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594011.url(scheme.get, call_594011.host, call_594011.base,
                         call_594011.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594011, url, valid)

proc call*(call_594012: Call_NamespacesGet_594004; namespaceName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## namespacesGet
  ## Returns the description for the specified namespace.
  ##   namespaceName: string (required)
  ##                : The namespace name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594013 = newJObject()
  var query_594014 = newJObject()
  add(path_594013, "namespaceName", newJString(namespaceName))
  add(path_594013, "resourceGroupName", newJString(resourceGroupName))
  add(query_594014, "api-version", newJString(apiVersion))
  add(path_594013, "subscriptionId", newJString(subscriptionId))
  result = call_594012.call(path_594013, query_594014, nil, nil, nil)

var namespacesGet* = Call_NamespacesGet_594004(name: "namespacesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NotificationHubs/namespaces/{namespaceName}",
    validator: validate_NamespacesGet_594005, base: "", url: url_NamespacesGet_594006,
    schemes: {Scheme.Https})
type
  Call_NamespacesPatch_594039 = ref object of OpenApiRestCall_593425
proc url_NamespacesPatch_594041(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.NotificationHubs/namespaces/"),
               (kind: VariableSegment, value: "namespaceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesPatch_594040(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Patches the existing namespace
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_594042 = path.getOrDefault("namespaceName")
  valid_594042 = validateParameter(valid_594042, JString, required = true,
                                 default = nil)
  if valid_594042 != nil:
    section.add "namespaceName", valid_594042
  var valid_594043 = path.getOrDefault("resourceGroupName")
  valid_594043 = validateParameter(valid_594043, JString, required = true,
                                 default = nil)
  if valid_594043 != nil:
    section.add "resourceGroupName", valid_594043
  var valid_594044 = path.getOrDefault("subscriptionId")
  valid_594044 = validateParameter(valid_594044, JString, required = true,
                                 default = nil)
  if valid_594044 != nil:
    section.add "subscriptionId", valid_594044
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594045 = query.getOrDefault("api-version")
  valid_594045 = validateParameter(valid_594045, JString, required = true,
                                 default = nil)
  if valid_594045 != nil:
    section.add "api-version", valid_594045
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to patch a Namespace Resource.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594047: Call_NamespacesPatch_594039; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Patches the existing namespace
  ## 
  let valid = call_594047.validator(path, query, header, formData, body)
  let scheme = call_594047.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594047.url(scheme.get, call_594047.host, call_594047.base,
                         call_594047.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594047, url, valid)

proc call*(call_594048: Call_NamespacesPatch_594039; namespaceName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode): Recallable =
  ## namespacesPatch
  ## Patches the existing namespace
  ##   namespaceName: string (required)
  ##                : The namespace name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to patch a Namespace Resource.
  var path_594049 = newJObject()
  var query_594050 = newJObject()
  var body_594051 = newJObject()
  add(path_594049, "namespaceName", newJString(namespaceName))
  add(path_594049, "resourceGroupName", newJString(resourceGroupName))
  add(query_594050, "api-version", newJString(apiVersion))
  add(path_594049, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594051 = parameters
  result = call_594048.call(path_594049, query_594050, nil, nil, body_594051)

var namespacesPatch* = Call_NamespacesPatch_594039(name: "namespacesPatch",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NotificationHubs/namespaces/{namespaceName}",
    validator: validate_NamespacesPatch_594040, base: "", url: url_NamespacesPatch_594041,
    schemes: {Scheme.Https})
type
  Call_NamespacesDelete_594028 = ref object of OpenApiRestCall_593425
proc url_NamespacesDelete_594030(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.NotificationHubs/namespaces/"),
               (kind: VariableSegment, value: "namespaceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesDelete_594029(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Deletes an existing namespace. This operation also removes all associated notificationHubs under the namespace.
  ## 
  ## http://msdn.microsoft.com/en-us/library/windowsazure/jj856296.aspx
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_594031 = path.getOrDefault("namespaceName")
  valid_594031 = validateParameter(valid_594031, JString, required = true,
                                 default = nil)
  if valid_594031 != nil:
    section.add "namespaceName", valid_594031
  var valid_594032 = path.getOrDefault("resourceGroupName")
  valid_594032 = validateParameter(valid_594032, JString, required = true,
                                 default = nil)
  if valid_594032 != nil:
    section.add "resourceGroupName", valid_594032
  var valid_594033 = path.getOrDefault("subscriptionId")
  valid_594033 = validateParameter(valid_594033, JString, required = true,
                                 default = nil)
  if valid_594033 != nil:
    section.add "subscriptionId", valid_594033
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594034 = query.getOrDefault("api-version")
  valid_594034 = validateParameter(valid_594034, JString, required = true,
                                 default = nil)
  if valid_594034 != nil:
    section.add "api-version", valid_594034
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594035: Call_NamespacesDelete_594028; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an existing namespace. This operation also removes all associated notificationHubs under the namespace.
  ## 
  ## http://msdn.microsoft.com/en-us/library/windowsazure/jj856296.aspx
  let valid = call_594035.validator(path, query, header, formData, body)
  let scheme = call_594035.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594035.url(scheme.get, call_594035.host, call_594035.base,
                         call_594035.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594035, url, valid)

proc call*(call_594036: Call_NamespacesDelete_594028; namespaceName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## namespacesDelete
  ## Deletes an existing namespace. This operation also removes all associated notificationHubs under the namespace.
  ## http://msdn.microsoft.com/en-us/library/windowsazure/jj856296.aspx
  ##   namespaceName: string (required)
  ##                : The namespace name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594037 = newJObject()
  var query_594038 = newJObject()
  add(path_594037, "namespaceName", newJString(namespaceName))
  add(path_594037, "resourceGroupName", newJString(resourceGroupName))
  add(query_594038, "api-version", newJString(apiVersion))
  add(path_594037, "subscriptionId", newJString(subscriptionId))
  result = call_594036.call(path_594037, query_594038, nil, nil, nil)

var namespacesDelete* = Call_NamespacesDelete_594028(name: "namespacesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NotificationHubs/namespaces/{namespaceName}",
    validator: validate_NamespacesDelete_594029, base: "",
    url: url_NamespacesDelete_594030, schemes: {Scheme.Https})
type
  Call_NamespacesListAuthorizationRules_594052 = ref object of OpenApiRestCall_593425
proc url_NamespacesListAuthorizationRules_594054(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.NotificationHubs/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/AuthorizationRules")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesListAuthorizationRules_594053(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the authorization rules for a namespace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_594055 = path.getOrDefault("namespaceName")
  valid_594055 = validateParameter(valid_594055, JString, required = true,
                                 default = nil)
  if valid_594055 != nil:
    section.add "namespaceName", valid_594055
  var valid_594056 = path.getOrDefault("resourceGroupName")
  valid_594056 = validateParameter(valid_594056, JString, required = true,
                                 default = nil)
  if valid_594056 != nil:
    section.add "resourceGroupName", valid_594056
  var valid_594057 = path.getOrDefault("subscriptionId")
  valid_594057 = validateParameter(valid_594057, JString, required = true,
                                 default = nil)
  if valid_594057 != nil:
    section.add "subscriptionId", valid_594057
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594058 = query.getOrDefault("api-version")
  valid_594058 = validateParameter(valid_594058, JString, required = true,
                                 default = nil)
  if valid_594058 != nil:
    section.add "api-version", valid_594058
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594059: Call_NamespacesListAuthorizationRules_594052;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the authorization rules for a namespace.
  ## 
  let valid = call_594059.validator(path, query, header, formData, body)
  let scheme = call_594059.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594059.url(scheme.get, call_594059.host, call_594059.base,
                         call_594059.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594059, url, valid)

proc call*(call_594060: Call_NamespacesListAuthorizationRules_594052;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## namespacesListAuthorizationRules
  ## Gets the authorization rules for a namespace.
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594061 = newJObject()
  var query_594062 = newJObject()
  add(path_594061, "namespaceName", newJString(namespaceName))
  add(path_594061, "resourceGroupName", newJString(resourceGroupName))
  add(query_594062, "api-version", newJString(apiVersion))
  add(path_594061, "subscriptionId", newJString(subscriptionId))
  result = call_594060.call(path_594061, query_594062, nil, nil, nil)

var namespacesListAuthorizationRules* = Call_NamespacesListAuthorizationRules_594052(
    name: "namespacesListAuthorizationRules", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NotificationHubs/namespaces/{namespaceName}/AuthorizationRules",
    validator: validate_NamespacesListAuthorizationRules_594053, base: "",
    url: url_NamespacesListAuthorizationRules_594054, schemes: {Scheme.Https})
type
  Call_NamespacesCreateOrUpdateAuthorizationRule_594075 = ref object of OpenApiRestCall_593425
proc url_NamespacesCreateOrUpdateAuthorizationRule_594077(protocol: Scheme;
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
        value: "/providers/Microsoft.NotificationHubs/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/AuthorizationRules/"),
               (kind: VariableSegment, value: "authorizationRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesCreateOrUpdateAuthorizationRule_594076(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates an authorization rule for a namespace
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   authorizationRuleName: JString (required)
  ##                        : Authorization Rule Name.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_594078 = path.getOrDefault("namespaceName")
  valid_594078 = validateParameter(valid_594078, JString, required = true,
                                 default = nil)
  if valid_594078 != nil:
    section.add "namespaceName", valid_594078
  var valid_594079 = path.getOrDefault("resourceGroupName")
  valid_594079 = validateParameter(valid_594079, JString, required = true,
                                 default = nil)
  if valid_594079 != nil:
    section.add "resourceGroupName", valid_594079
  var valid_594080 = path.getOrDefault("authorizationRuleName")
  valid_594080 = validateParameter(valid_594080, JString, required = true,
                                 default = nil)
  if valid_594080 != nil:
    section.add "authorizationRuleName", valid_594080
  var valid_594081 = path.getOrDefault("subscriptionId")
  valid_594081 = validateParameter(valid_594081, JString, required = true,
                                 default = nil)
  if valid_594081 != nil:
    section.add "subscriptionId", valid_594081
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594082 = query.getOrDefault("api-version")
  valid_594082 = validateParameter(valid_594082, JString, required = true,
                                 default = nil)
  if valid_594082 != nil:
    section.add "api-version", valid_594082
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

proc call*(call_594084: Call_NamespacesCreateOrUpdateAuthorizationRule_594075;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates an authorization rule for a namespace
  ## 
  let valid = call_594084.validator(path, query, header, formData, body)
  let scheme = call_594084.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594084.url(scheme.get, call_594084.host, call_594084.base,
                         call_594084.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594084, url, valid)

proc call*(call_594085: Call_NamespacesCreateOrUpdateAuthorizationRule_594075;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          authorizationRuleName: string; subscriptionId: string;
          parameters: JsonNode): Recallable =
  ## namespacesCreateOrUpdateAuthorizationRule
  ## Creates an authorization rule for a namespace
  ##   namespaceName: string (required)
  ##                : The namespace name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   authorizationRuleName: string (required)
  ##                        : Authorization Rule Name.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : The shared access authorization rule.
  var path_594086 = newJObject()
  var query_594087 = newJObject()
  var body_594088 = newJObject()
  add(path_594086, "namespaceName", newJString(namespaceName))
  add(path_594086, "resourceGroupName", newJString(resourceGroupName))
  add(query_594087, "api-version", newJString(apiVersion))
  add(path_594086, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_594086, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594088 = parameters
  result = call_594085.call(path_594086, query_594087, nil, nil, body_594088)

var namespacesCreateOrUpdateAuthorizationRule* = Call_NamespacesCreateOrUpdateAuthorizationRule_594075(
    name: "namespacesCreateOrUpdateAuthorizationRule", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NotificationHubs/namespaces/{namespaceName}/AuthorizationRules/{authorizationRuleName}",
    validator: validate_NamespacesCreateOrUpdateAuthorizationRule_594076,
    base: "", url: url_NamespacesCreateOrUpdateAuthorizationRule_594077,
    schemes: {Scheme.Https})
type
  Call_NamespacesGetAuthorizationRule_594063 = ref object of OpenApiRestCall_593425
proc url_NamespacesGetAuthorizationRule_594065(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.NotificationHubs/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/AuthorizationRules/"),
               (kind: VariableSegment, value: "authorizationRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesGetAuthorizationRule_594064(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets an authorization rule for a namespace by name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   authorizationRuleName: JString (required)
  ##                        : Authorization rule name.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_594066 = path.getOrDefault("namespaceName")
  valid_594066 = validateParameter(valid_594066, JString, required = true,
                                 default = nil)
  if valid_594066 != nil:
    section.add "namespaceName", valid_594066
  var valid_594067 = path.getOrDefault("resourceGroupName")
  valid_594067 = validateParameter(valid_594067, JString, required = true,
                                 default = nil)
  if valid_594067 != nil:
    section.add "resourceGroupName", valid_594067
  var valid_594068 = path.getOrDefault("authorizationRuleName")
  valid_594068 = validateParameter(valid_594068, JString, required = true,
                                 default = nil)
  if valid_594068 != nil:
    section.add "authorizationRuleName", valid_594068
  var valid_594069 = path.getOrDefault("subscriptionId")
  valid_594069 = validateParameter(valid_594069, JString, required = true,
                                 default = nil)
  if valid_594069 != nil:
    section.add "subscriptionId", valid_594069
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594070 = query.getOrDefault("api-version")
  valid_594070 = validateParameter(valid_594070, JString, required = true,
                                 default = nil)
  if valid_594070 != nil:
    section.add "api-version", valid_594070
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594071: Call_NamespacesGetAuthorizationRule_594063; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an authorization rule for a namespace by name.
  ## 
  let valid = call_594071.validator(path, query, header, formData, body)
  let scheme = call_594071.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594071.url(scheme.get, call_594071.host, call_594071.base,
                         call_594071.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594071, url, valid)

proc call*(call_594072: Call_NamespacesGetAuthorizationRule_594063;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          authorizationRuleName: string; subscriptionId: string): Recallable =
  ## namespacesGetAuthorizationRule
  ## Gets an authorization rule for a namespace by name.
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   authorizationRuleName: string (required)
  ##                        : Authorization rule name.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594073 = newJObject()
  var query_594074 = newJObject()
  add(path_594073, "namespaceName", newJString(namespaceName))
  add(path_594073, "resourceGroupName", newJString(resourceGroupName))
  add(query_594074, "api-version", newJString(apiVersion))
  add(path_594073, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_594073, "subscriptionId", newJString(subscriptionId))
  result = call_594072.call(path_594073, query_594074, nil, nil, nil)

var namespacesGetAuthorizationRule* = Call_NamespacesGetAuthorizationRule_594063(
    name: "namespacesGetAuthorizationRule", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NotificationHubs/namespaces/{namespaceName}/AuthorizationRules/{authorizationRuleName}",
    validator: validate_NamespacesGetAuthorizationRule_594064, base: "",
    url: url_NamespacesGetAuthorizationRule_594065, schemes: {Scheme.Https})
type
  Call_NamespacesDeleteAuthorizationRule_594089 = ref object of OpenApiRestCall_593425
proc url_NamespacesDeleteAuthorizationRule_594091(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.NotificationHubs/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/AuthorizationRules/"),
               (kind: VariableSegment, value: "authorizationRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesDeleteAuthorizationRule_594090(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a namespace authorization rule
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   authorizationRuleName: JString (required)
  ##                        : Authorization Rule Name.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_594092 = path.getOrDefault("namespaceName")
  valid_594092 = validateParameter(valid_594092, JString, required = true,
                                 default = nil)
  if valid_594092 != nil:
    section.add "namespaceName", valid_594092
  var valid_594093 = path.getOrDefault("resourceGroupName")
  valid_594093 = validateParameter(valid_594093, JString, required = true,
                                 default = nil)
  if valid_594093 != nil:
    section.add "resourceGroupName", valid_594093
  var valid_594094 = path.getOrDefault("authorizationRuleName")
  valid_594094 = validateParameter(valid_594094, JString, required = true,
                                 default = nil)
  if valid_594094 != nil:
    section.add "authorizationRuleName", valid_594094
  var valid_594095 = path.getOrDefault("subscriptionId")
  valid_594095 = validateParameter(valid_594095, JString, required = true,
                                 default = nil)
  if valid_594095 != nil:
    section.add "subscriptionId", valid_594095
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594096 = query.getOrDefault("api-version")
  valid_594096 = validateParameter(valid_594096, JString, required = true,
                                 default = nil)
  if valid_594096 != nil:
    section.add "api-version", valid_594096
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594097: Call_NamespacesDeleteAuthorizationRule_594089;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a namespace authorization rule
  ## 
  let valid = call_594097.validator(path, query, header, formData, body)
  let scheme = call_594097.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594097.url(scheme.get, call_594097.host, call_594097.base,
                         call_594097.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594097, url, valid)

proc call*(call_594098: Call_NamespacesDeleteAuthorizationRule_594089;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          authorizationRuleName: string; subscriptionId: string): Recallable =
  ## namespacesDeleteAuthorizationRule
  ## Deletes a namespace authorization rule
  ##   namespaceName: string (required)
  ##                : The namespace name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   authorizationRuleName: string (required)
  ##                        : Authorization Rule Name.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594099 = newJObject()
  var query_594100 = newJObject()
  add(path_594099, "namespaceName", newJString(namespaceName))
  add(path_594099, "resourceGroupName", newJString(resourceGroupName))
  add(query_594100, "api-version", newJString(apiVersion))
  add(path_594099, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_594099, "subscriptionId", newJString(subscriptionId))
  result = call_594098.call(path_594099, query_594100, nil, nil, nil)

var namespacesDeleteAuthorizationRule* = Call_NamespacesDeleteAuthorizationRule_594089(
    name: "namespacesDeleteAuthorizationRule", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NotificationHubs/namespaces/{namespaceName}/AuthorizationRules/{authorizationRuleName}",
    validator: validate_NamespacesDeleteAuthorizationRule_594090, base: "",
    url: url_NamespacesDeleteAuthorizationRule_594091, schemes: {Scheme.Https})
type
  Call_NamespacesListKeys_594101 = ref object of OpenApiRestCall_593425
proc url_NamespacesListKeys_594103(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.NotificationHubs/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/AuthorizationRules/"),
               (kind: VariableSegment, value: "authorizationRuleName"),
               (kind: ConstantSegment, value: "/listKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesListKeys_594102(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Gets the Primary and Secondary ConnectionStrings to the namespace 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   authorizationRuleName: JString (required)
  ##                        : The connection string of the namespace for the specified authorizationRule.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_594104 = path.getOrDefault("namespaceName")
  valid_594104 = validateParameter(valid_594104, JString, required = true,
                                 default = nil)
  if valid_594104 != nil:
    section.add "namespaceName", valid_594104
  var valid_594105 = path.getOrDefault("resourceGroupName")
  valid_594105 = validateParameter(valid_594105, JString, required = true,
                                 default = nil)
  if valid_594105 != nil:
    section.add "resourceGroupName", valid_594105
  var valid_594106 = path.getOrDefault("authorizationRuleName")
  valid_594106 = validateParameter(valid_594106, JString, required = true,
                                 default = nil)
  if valid_594106 != nil:
    section.add "authorizationRuleName", valid_594106
  var valid_594107 = path.getOrDefault("subscriptionId")
  valid_594107 = validateParameter(valid_594107, JString, required = true,
                                 default = nil)
  if valid_594107 != nil:
    section.add "subscriptionId", valid_594107
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594108 = query.getOrDefault("api-version")
  valid_594108 = validateParameter(valid_594108, JString, required = true,
                                 default = nil)
  if valid_594108 != nil:
    section.add "api-version", valid_594108
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594109: Call_NamespacesListKeys_594101; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the Primary and Secondary ConnectionStrings to the namespace 
  ## 
  let valid = call_594109.validator(path, query, header, formData, body)
  let scheme = call_594109.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594109.url(scheme.get, call_594109.host, call_594109.base,
                         call_594109.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594109, url, valid)

proc call*(call_594110: Call_NamespacesListKeys_594101; namespaceName: string;
          resourceGroupName: string; apiVersion: string;
          authorizationRuleName: string; subscriptionId: string): Recallable =
  ## namespacesListKeys
  ## Gets the Primary and Secondary ConnectionStrings to the namespace 
  ##   namespaceName: string (required)
  ##                : The namespace name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   authorizationRuleName: string (required)
  ##                        : The connection string of the namespace for the specified authorizationRule.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594111 = newJObject()
  var query_594112 = newJObject()
  add(path_594111, "namespaceName", newJString(namespaceName))
  add(path_594111, "resourceGroupName", newJString(resourceGroupName))
  add(query_594112, "api-version", newJString(apiVersion))
  add(path_594111, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_594111, "subscriptionId", newJString(subscriptionId))
  result = call_594110.call(path_594111, query_594112, nil, nil, nil)

var namespacesListKeys* = Call_NamespacesListKeys_594101(
    name: "namespacesListKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NotificationHubs/namespaces/{namespaceName}/AuthorizationRules/{authorizationRuleName}/listKeys",
    validator: validate_NamespacesListKeys_594102, base: "",
    url: url_NamespacesListKeys_594103, schemes: {Scheme.Https})
type
  Call_NamespacesRegenerateKeys_594113 = ref object of OpenApiRestCall_593425
proc url_NamespacesRegenerateKeys_594115(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.NotificationHubs/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/AuthorizationRules/"),
               (kind: VariableSegment, value: "authorizationRuleName"),
               (kind: ConstantSegment, value: "/regenerateKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NamespacesRegenerateKeys_594114(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Regenerates the Primary/Secondary Keys to the Namespace Authorization Rule
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   authorizationRuleName: JString (required)
  ##                        : The connection string of the namespace for the specified authorizationRule.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_594116 = path.getOrDefault("namespaceName")
  valid_594116 = validateParameter(valid_594116, JString, required = true,
                                 default = nil)
  if valid_594116 != nil:
    section.add "namespaceName", valid_594116
  var valid_594117 = path.getOrDefault("resourceGroupName")
  valid_594117 = validateParameter(valid_594117, JString, required = true,
                                 default = nil)
  if valid_594117 != nil:
    section.add "resourceGroupName", valid_594117
  var valid_594118 = path.getOrDefault("authorizationRuleName")
  valid_594118 = validateParameter(valid_594118, JString, required = true,
                                 default = nil)
  if valid_594118 != nil:
    section.add "authorizationRuleName", valid_594118
  var valid_594119 = path.getOrDefault("subscriptionId")
  valid_594119 = validateParameter(valid_594119, JString, required = true,
                                 default = nil)
  if valid_594119 != nil:
    section.add "subscriptionId", valid_594119
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594120 = query.getOrDefault("api-version")
  valid_594120 = validateParameter(valid_594120, JString, required = true,
                                 default = nil)
  if valid_594120 != nil:
    section.add "api-version", valid_594120
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to regenerate the Namespace Authorization Rule Key.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594122: Call_NamespacesRegenerateKeys_594113; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Regenerates the Primary/Secondary Keys to the Namespace Authorization Rule
  ## 
  let valid = call_594122.validator(path, query, header, formData, body)
  let scheme = call_594122.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594122.url(scheme.get, call_594122.host, call_594122.base,
                         call_594122.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594122, url, valid)

proc call*(call_594123: Call_NamespacesRegenerateKeys_594113;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          authorizationRuleName: string; subscriptionId: string;
          parameters: JsonNode): Recallable =
  ## namespacesRegenerateKeys
  ## Regenerates the Primary/Secondary Keys to the Namespace Authorization Rule
  ##   namespaceName: string (required)
  ##                : The namespace name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   authorizationRuleName: string (required)
  ##                        : The connection string of the namespace for the specified authorizationRule.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to regenerate the Namespace Authorization Rule Key.
  var path_594124 = newJObject()
  var query_594125 = newJObject()
  var body_594126 = newJObject()
  add(path_594124, "namespaceName", newJString(namespaceName))
  add(path_594124, "resourceGroupName", newJString(resourceGroupName))
  add(query_594125, "api-version", newJString(apiVersion))
  add(path_594124, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_594124, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594126 = parameters
  result = call_594123.call(path_594124, query_594125, nil, nil, body_594126)

var namespacesRegenerateKeys* = Call_NamespacesRegenerateKeys_594113(
    name: "namespacesRegenerateKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NotificationHubs/namespaces/{namespaceName}/AuthorizationRules/{authorizationRuleName}/regenerateKeys",
    validator: validate_NamespacesRegenerateKeys_594114, base: "",
    url: url_NamespacesRegenerateKeys_594115, schemes: {Scheme.Https})
type
  Call_NotificationHubsCheckNotificationHubAvailability_594127 = ref object of OpenApiRestCall_593425
proc url_NotificationHubsCheckNotificationHubAvailability_594129(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
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
        value: "/providers/Microsoft.NotificationHubs/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"), (
        kind: ConstantSegment, value: "/checkNotificationHubAvailability")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NotificationHubsCheckNotificationHubAvailability_594128(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Checks the availability of the given notificationHub in a namespace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_594130 = path.getOrDefault("namespaceName")
  valid_594130 = validateParameter(valid_594130, JString, required = true,
                                 default = nil)
  if valid_594130 != nil:
    section.add "namespaceName", valid_594130
  var valid_594131 = path.getOrDefault("resourceGroupName")
  valid_594131 = validateParameter(valid_594131, JString, required = true,
                                 default = nil)
  if valid_594131 != nil:
    section.add "resourceGroupName", valid_594131
  var valid_594132 = path.getOrDefault("subscriptionId")
  valid_594132 = validateParameter(valid_594132, JString, required = true,
                                 default = nil)
  if valid_594132 != nil:
    section.add "subscriptionId", valid_594132
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594133 = query.getOrDefault("api-version")
  valid_594133 = validateParameter(valid_594133, JString, required = true,
                                 default = nil)
  if valid_594133 != nil:
    section.add "api-version", valid_594133
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The notificationHub name.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594135: Call_NotificationHubsCheckNotificationHubAvailability_594127;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Checks the availability of the given notificationHub in a namespace.
  ## 
  let valid = call_594135.validator(path, query, header, formData, body)
  let scheme = call_594135.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594135.url(scheme.get, call_594135.host, call_594135.base,
                         call_594135.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594135, url, valid)

proc call*(call_594136: Call_NotificationHubsCheckNotificationHubAvailability_594127;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; parameters: JsonNode): Recallable =
  ## notificationHubsCheckNotificationHubAvailability
  ## Checks the availability of the given notificationHub in a namespace.
  ##   namespaceName: string (required)
  ##                : The namespace name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : The notificationHub name.
  var path_594137 = newJObject()
  var query_594138 = newJObject()
  var body_594139 = newJObject()
  add(path_594137, "namespaceName", newJString(namespaceName))
  add(path_594137, "resourceGroupName", newJString(resourceGroupName))
  add(query_594138, "api-version", newJString(apiVersion))
  add(path_594137, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594139 = parameters
  result = call_594136.call(path_594137, query_594138, nil, nil, body_594139)

var notificationHubsCheckNotificationHubAvailability* = Call_NotificationHubsCheckNotificationHubAvailability_594127(
    name: "notificationHubsCheckNotificationHubAvailability",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NotificationHubs/namespaces/{namespaceName}/checkNotificationHubAvailability",
    validator: validate_NotificationHubsCheckNotificationHubAvailability_594128,
    base: "", url: url_NotificationHubsCheckNotificationHubAvailability_594129,
    schemes: {Scheme.Https})
type
  Call_NotificationHubsList_594140 = ref object of OpenApiRestCall_593425
proc url_NotificationHubsList_594142(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.NotificationHubs/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/notificationHubs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NotificationHubsList_594141(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the notification hubs associated with a namespace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_594143 = path.getOrDefault("namespaceName")
  valid_594143 = validateParameter(valid_594143, JString, required = true,
                                 default = nil)
  if valid_594143 != nil:
    section.add "namespaceName", valid_594143
  var valid_594144 = path.getOrDefault("resourceGroupName")
  valid_594144 = validateParameter(valid_594144, JString, required = true,
                                 default = nil)
  if valid_594144 != nil:
    section.add "resourceGroupName", valid_594144
  var valid_594145 = path.getOrDefault("subscriptionId")
  valid_594145 = validateParameter(valid_594145, JString, required = true,
                                 default = nil)
  if valid_594145 != nil:
    section.add "subscriptionId", valid_594145
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
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
  if body != nil:
    result.add "body", body

proc call*(call_594147: Call_NotificationHubsList_594140; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the notification hubs associated with a namespace.
  ## 
  let valid = call_594147.validator(path, query, header, formData, body)
  let scheme = call_594147.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594147.url(scheme.get, call_594147.host, call_594147.base,
                         call_594147.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594147, url, valid)

proc call*(call_594148: Call_NotificationHubsList_594140; namespaceName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## notificationHubsList
  ## Lists the notification hubs associated with a namespace.
  ##   namespaceName: string (required)
  ##                : The namespace name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594149 = newJObject()
  var query_594150 = newJObject()
  add(path_594149, "namespaceName", newJString(namespaceName))
  add(path_594149, "resourceGroupName", newJString(resourceGroupName))
  add(query_594150, "api-version", newJString(apiVersion))
  add(path_594149, "subscriptionId", newJString(subscriptionId))
  result = call_594148.call(path_594149, query_594150, nil, nil, nil)

var notificationHubsList* = Call_NotificationHubsList_594140(
    name: "notificationHubsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NotificationHubs/namespaces/{namespaceName}/notificationHubs",
    validator: validate_NotificationHubsList_594141, base: "",
    url: url_NotificationHubsList_594142, schemes: {Scheme.Https})
type
  Call_NotificationHubsCreateOrUpdate_594163 = ref object of OpenApiRestCall_593425
proc url_NotificationHubsCreateOrUpdate_594165(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "notificationHubName" in path,
        "`notificationHubName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.NotificationHubs/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/notificationHubs/"),
               (kind: VariableSegment, value: "notificationHubName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NotificationHubsCreateOrUpdate_594164(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates/Update a NotificationHub in a namespace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   notificationHubName: JString (required)
  ##                      : The notification hub name.
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
  var valid_594168 = path.getOrDefault("subscriptionId")
  valid_594168 = validateParameter(valid_594168, JString, required = true,
                                 default = nil)
  if valid_594168 != nil:
    section.add "subscriptionId", valid_594168
  var valid_594169 = path.getOrDefault("notificationHubName")
  valid_594169 = validateParameter(valid_594169, JString, required = true,
                                 default = nil)
  if valid_594169 != nil:
    section.add "notificationHubName", valid_594169
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
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
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the create/update a NotificationHub Resource.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594172: Call_NotificationHubsCreateOrUpdate_594163; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates/Update a NotificationHub in a namespace.
  ## 
  let valid = call_594172.validator(path, query, header, formData, body)
  let scheme = call_594172.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594172.url(scheme.get, call_594172.host, call_594172.base,
                         call_594172.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594172, url, valid)

proc call*(call_594173: Call_NotificationHubsCreateOrUpdate_594163;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; notificationHubName: string; parameters: JsonNode): Recallable =
  ## notificationHubsCreateOrUpdate
  ## Creates/Update a NotificationHub in a namespace.
  ##   namespaceName: string (required)
  ##                : The namespace name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   notificationHubName: string (required)
  ##                      : The notification hub name.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the create/update a NotificationHub Resource.
  var path_594174 = newJObject()
  var query_594175 = newJObject()
  var body_594176 = newJObject()
  add(path_594174, "namespaceName", newJString(namespaceName))
  add(path_594174, "resourceGroupName", newJString(resourceGroupName))
  add(query_594175, "api-version", newJString(apiVersion))
  add(path_594174, "subscriptionId", newJString(subscriptionId))
  add(path_594174, "notificationHubName", newJString(notificationHubName))
  if parameters != nil:
    body_594176 = parameters
  result = call_594173.call(path_594174, query_594175, nil, nil, body_594176)

var notificationHubsCreateOrUpdate* = Call_NotificationHubsCreateOrUpdate_594163(
    name: "notificationHubsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NotificationHubs/namespaces/{namespaceName}/notificationHubs/{notificationHubName}",
    validator: validate_NotificationHubsCreateOrUpdate_594164, base: "",
    url: url_NotificationHubsCreateOrUpdate_594165, schemes: {Scheme.Https})
type
  Call_NotificationHubsGet_594151 = ref object of OpenApiRestCall_593425
proc url_NotificationHubsGet_594153(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "notificationHubName" in path,
        "`notificationHubName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.NotificationHubs/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/notificationHubs/"),
               (kind: VariableSegment, value: "notificationHubName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NotificationHubsGet_594152(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Lists the notification hubs associated with a namespace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   notificationHubName: JString (required)
  ##                      : The notification hub name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_594154 = path.getOrDefault("namespaceName")
  valid_594154 = validateParameter(valid_594154, JString, required = true,
                                 default = nil)
  if valid_594154 != nil:
    section.add "namespaceName", valid_594154
  var valid_594155 = path.getOrDefault("resourceGroupName")
  valid_594155 = validateParameter(valid_594155, JString, required = true,
                                 default = nil)
  if valid_594155 != nil:
    section.add "resourceGroupName", valid_594155
  var valid_594156 = path.getOrDefault("subscriptionId")
  valid_594156 = validateParameter(valid_594156, JString, required = true,
                                 default = nil)
  if valid_594156 != nil:
    section.add "subscriptionId", valid_594156
  var valid_594157 = path.getOrDefault("notificationHubName")
  valid_594157 = validateParameter(valid_594157, JString, required = true,
                                 default = nil)
  if valid_594157 != nil:
    section.add "notificationHubName", valid_594157
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594158 = query.getOrDefault("api-version")
  valid_594158 = validateParameter(valid_594158, JString, required = true,
                                 default = nil)
  if valid_594158 != nil:
    section.add "api-version", valid_594158
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594159: Call_NotificationHubsGet_594151; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the notification hubs associated with a namespace.
  ## 
  let valid = call_594159.validator(path, query, header, formData, body)
  let scheme = call_594159.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594159.url(scheme.get, call_594159.host, call_594159.base,
                         call_594159.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594159, url, valid)

proc call*(call_594160: Call_NotificationHubsGet_594151; namespaceName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          notificationHubName: string): Recallable =
  ## notificationHubsGet
  ## Lists the notification hubs associated with a namespace.
  ##   namespaceName: string (required)
  ##                : The namespace name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   notificationHubName: string (required)
  ##                      : The notification hub name.
  var path_594161 = newJObject()
  var query_594162 = newJObject()
  add(path_594161, "namespaceName", newJString(namespaceName))
  add(path_594161, "resourceGroupName", newJString(resourceGroupName))
  add(query_594162, "api-version", newJString(apiVersion))
  add(path_594161, "subscriptionId", newJString(subscriptionId))
  add(path_594161, "notificationHubName", newJString(notificationHubName))
  result = call_594160.call(path_594161, query_594162, nil, nil, nil)

var notificationHubsGet* = Call_NotificationHubsGet_594151(
    name: "notificationHubsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NotificationHubs/namespaces/{namespaceName}/notificationHubs/{notificationHubName}",
    validator: validate_NotificationHubsGet_594152, base: "",
    url: url_NotificationHubsGet_594153, schemes: {Scheme.Https})
type
  Call_NotificationHubsPatch_594189 = ref object of OpenApiRestCall_593425
proc url_NotificationHubsPatch_594191(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "notificationHubName" in path,
        "`notificationHubName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.NotificationHubs/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/notificationHubs/"),
               (kind: VariableSegment, value: "notificationHubName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NotificationHubsPatch_594190(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Patch a NotificationHub in a namespace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   notificationHubName: JString (required)
  ##                      : The notification hub name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_594192 = path.getOrDefault("namespaceName")
  valid_594192 = validateParameter(valid_594192, JString, required = true,
                                 default = nil)
  if valid_594192 != nil:
    section.add "namespaceName", valid_594192
  var valid_594193 = path.getOrDefault("resourceGroupName")
  valid_594193 = validateParameter(valid_594193, JString, required = true,
                                 default = nil)
  if valid_594193 != nil:
    section.add "resourceGroupName", valid_594193
  var valid_594194 = path.getOrDefault("subscriptionId")
  valid_594194 = validateParameter(valid_594194, JString, required = true,
                                 default = nil)
  if valid_594194 != nil:
    section.add "subscriptionId", valid_594194
  var valid_594195 = path.getOrDefault("notificationHubName")
  valid_594195 = validateParameter(valid_594195, JString, required = true,
                                 default = nil)
  if valid_594195 != nil:
    section.add "notificationHubName", valid_594195
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594196 = query.getOrDefault("api-version")
  valid_594196 = validateParameter(valid_594196, JString, required = true,
                                 default = nil)
  if valid_594196 != nil:
    section.add "api-version", valid_594196
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject
  ##             : Parameters supplied to patch a NotificationHub Resource.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594198: Call_NotificationHubsPatch_594189; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Patch a NotificationHub in a namespace.
  ## 
  let valid = call_594198.validator(path, query, header, formData, body)
  let scheme = call_594198.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594198.url(scheme.get, call_594198.host, call_594198.base,
                         call_594198.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594198, url, valid)

proc call*(call_594199: Call_NotificationHubsPatch_594189; namespaceName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          notificationHubName: string; parameters: JsonNode = nil): Recallable =
  ## notificationHubsPatch
  ## Patch a NotificationHub in a namespace.
  ##   namespaceName: string (required)
  ##                : The namespace name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   notificationHubName: string (required)
  ##                      : The notification hub name.
  ##   parameters: JObject
  ##             : Parameters supplied to patch a NotificationHub Resource.
  var path_594200 = newJObject()
  var query_594201 = newJObject()
  var body_594202 = newJObject()
  add(path_594200, "namespaceName", newJString(namespaceName))
  add(path_594200, "resourceGroupName", newJString(resourceGroupName))
  add(query_594201, "api-version", newJString(apiVersion))
  add(path_594200, "subscriptionId", newJString(subscriptionId))
  add(path_594200, "notificationHubName", newJString(notificationHubName))
  if parameters != nil:
    body_594202 = parameters
  result = call_594199.call(path_594200, query_594201, nil, nil, body_594202)

var notificationHubsPatch* = Call_NotificationHubsPatch_594189(
    name: "notificationHubsPatch", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NotificationHubs/namespaces/{namespaceName}/notificationHubs/{notificationHubName}",
    validator: validate_NotificationHubsPatch_594190, base: "",
    url: url_NotificationHubsPatch_594191, schemes: {Scheme.Https})
type
  Call_NotificationHubsDelete_594177 = ref object of OpenApiRestCall_593425
proc url_NotificationHubsDelete_594179(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "notificationHubName" in path,
        "`notificationHubName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.NotificationHubs/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/notificationHubs/"),
               (kind: VariableSegment, value: "notificationHubName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NotificationHubsDelete_594178(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a notification hub associated with a namespace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   notificationHubName: JString (required)
  ##                      : The notification hub name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_594180 = path.getOrDefault("namespaceName")
  valid_594180 = validateParameter(valid_594180, JString, required = true,
                                 default = nil)
  if valid_594180 != nil:
    section.add "namespaceName", valid_594180
  var valid_594181 = path.getOrDefault("resourceGroupName")
  valid_594181 = validateParameter(valid_594181, JString, required = true,
                                 default = nil)
  if valid_594181 != nil:
    section.add "resourceGroupName", valid_594181
  var valid_594182 = path.getOrDefault("subscriptionId")
  valid_594182 = validateParameter(valid_594182, JString, required = true,
                                 default = nil)
  if valid_594182 != nil:
    section.add "subscriptionId", valid_594182
  var valid_594183 = path.getOrDefault("notificationHubName")
  valid_594183 = validateParameter(valid_594183, JString, required = true,
                                 default = nil)
  if valid_594183 != nil:
    section.add "notificationHubName", valid_594183
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594184 = query.getOrDefault("api-version")
  valid_594184 = validateParameter(valid_594184, JString, required = true,
                                 default = nil)
  if valid_594184 != nil:
    section.add "api-version", valid_594184
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594185: Call_NotificationHubsDelete_594177; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a notification hub associated with a namespace.
  ## 
  let valid = call_594185.validator(path, query, header, formData, body)
  let scheme = call_594185.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594185.url(scheme.get, call_594185.host, call_594185.base,
                         call_594185.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594185, url, valid)

proc call*(call_594186: Call_NotificationHubsDelete_594177; namespaceName: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          notificationHubName: string): Recallable =
  ## notificationHubsDelete
  ## Deletes a notification hub associated with a namespace.
  ##   namespaceName: string (required)
  ##                : The namespace name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   notificationHubName: string (required)
  ##                      : The notification hub name.
  var path_594187 = newJObject()
  var query_594188 = newJObject()
  add(path_594187, "namespaceName", newJString(namespaceName))
  add(path_594187, "resourceGroupName", newJString(resourceGroupName))
  add(query_594188, "api-version", newJString(apiVersion))
  add(path_594187, "subscriptionId", newJString(subscriptionId))
  add(path_594187, "notificationHubName", newJString(notificationHubName))
  result = call_594186.call(path_594187, query_594188, nil, nil, nil)

var notificationHubsDelete* = Call_NotificationHubsDelete_594177(
    name: "notificationHubsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NotificationHubs/namespaces/{namespaceName}/notificationHubs/{notificationHubName}",
    validator: validate_NotificationHubsDelete_594178, base: "",
    url: url_NotificationHubsDelete_594179, schemes: {Scheme.Https})
type
  Call_NotificationHubsListAuthorizationRules_594203 = ref object of OpenApiRestCall_593425
proc url_NotificationHubsListAuthorizationRules_594205(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "notificationHubName" in path,
        "`notificationHubName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.NotificationHubs/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/notificationHubs/"),
               (kind: VariableSegment, value: "notificationHubName"),
               (kind: ConstantSegment, value: "/AuthorizationRules")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NotificationHubsListAuthorizationRules_594204(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the authorization rules for a NotificationHub.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   notificationHubName: JString (required)
  ##                      : The notification hub name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_594206 = path.getOrDefault("namespaceName")
  valid_594206 = validateParameter(valid_594206, JString, required = true,
                                 default = nil)
  if valid_594206 != nil:
    section.add "namespaceName", valid_594206
  var valid_594207 = path.getOrDefault("resourceGroupName")
  valid_594207 = validateParameter(valid_594207, JString, required = true,
                                 default = nil)
  if valid_594207 != nil:
    section.add "resourceGroupName", valid_594207
  var valid_594208 = path.getOrDefault("subscriptionId")
  valid_594208 = validateParameter(valid_594208, JString, required = true,
                                 default = nil)
  if valid_594208 != nil:
    section.add "subscriptionId", valid_594208
  var valid_594209 = path.getOrDefault("notificationHubName")
  valid_594209 = validateParameter(valid_594209, JString, required = true,
                                 default = nil)
  if valid_594209 != nil:
    section.add "notificationHubName", valid_594209
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594210 = query.getOrDefault("api-version")
  valid_594210 = validateParameter(valid_594210, JString, required = true,
                                 default = nil)
  if valid_594210 != nil:
    section.add "api-version", valid_594210
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594211: Call_NotificationHubsListAuthorizationRules_594203;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the authorization rules for a NotificationHub.
  ## 
  let valid = call_594211.validator(path, query, header, formData, body)
  let scheme = call_594211.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594211.url(scheme.get, call_594211.host, call_594211.base,
                         call_594211.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594211, url, valid)

proc call*(call_594212: Call_NotificationHubsListAuthorizationRules_594203;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; notificationHubName: string): Recallable =
  ## notificationHubsListAuthorizationRules
  ## Gets the authorization rules for a NotificationHub.
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   notificationHubName: string (required)
  ##                      : The notification hub name.
  var path_594213 = newJObject()
  var query_594214 = newJObject()
  add(path_594213, "namespaceName", newJString(namespaceName))
  add(path_594213, "resourceGroupName", newJString(resourceGroupName))
  add(query_594214, "api-version", newJString(apiVersion))
  add(path_594213, "subscriptionId", newJString(subscriptionId))
  add(path_594213, "notificationHubName", newJString(notificationHubName))
  result = call_594212.call(path_594213, query_594214, nil, nil, nil)

var notificationHubsListAuthorizationRules* = Call_NotificationHubsListAuthorizationRules_594203(
    name: "notificationHubsListAuthorizationRules", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NotificationHubs/namespaces/{namespaceName}/notificationHubs/{notificationHubName}/AuthorizationRules",
    validator: validate_NotificationHubsListAuthorizationRules_594204, base: "",
    url: url_NotificationHubsListAuthorizationRules_594205,
    schemes: {Scheme.Https})
type
  Call_NotificationHubsCreateOrUpdateAuthorizationRule_594228 = ref object of OpenApiRestCall_593425
proc url_NotificationHubsCreateOrUpdateAuthorizationRule_594230(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "notificationHubName" in path,
        "`notificationHubName` is a required path parameter"
  assert "authorizationRuleName" in path,
        "`authorizationRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.NotificationHubs/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/notificationHubs/"),
               (kind: VariableSegment, value: "notificationHubName"),
               (kind: ConstantSegment, value: "/AuthorizationRules/"),
               (kind: VariableSegment, value: "authorizationRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NotificationHubsCreateOrUpdateAuthorizationRule_594229(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates/Updates an authorization rule for a NotificationHub
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   authorizationRuleName: JString (required)
  ##                        : Authorization Rule Name.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   notificationHubName: JString (required)
  ##                      : The notification hub name.
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
  var valid_594233 = path.getOrDefault("authorizationRuleName")
  valid_594233 = validateParameter(valid_594233, JString, required = true,
                                 default = nil)
  if valid_594233 != nil:
    section.add "authorizationRuleName", valid_594233
  var valid_594234 = path.getOrDefault("subscriptionId")
  valid_594234 = validateParameter(valid_594234, JString, required = true,
                                 default = nil)
  if valid_594234 != nil:
    section.add "subscriptionId", valid_594234
  var valid_594235 = path.getOrDefault("notificationHubName")
  valid_594235 = validateParameter(valid_594235, JString, required = true,
                                 default = nil)
  if valid_594235 != nil:
    section.add "notificationHubName", valid_594235
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
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
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The shared access authorization rule.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594238: Call_NotificationHubsCreateOrUpdateAuthorizationRule_594228;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates/Updates an authorization rule for a NotificationHub
  ## 
  let valid = call_594238.validator(path, query, header, formData, body)
  let scheme = call_594238.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594238.url(scheme.get, call_594238.host, call_594238.base,
                         call_594238.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594238, url, valid)

proc call*(call_594239: Call_NotificationHubsCreateOrUpdateAuthorizationRule_594228;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          authorizationRuleName: string; subscriptionId: string;
          notificationHubName: string; parameters: JsonNode): Recallable =
  ## notificationHubsCreateOrUpdateAuthorizationRule
  ## Creates/Updates an authorization rule for a NotificationHub
  ##   namespaceName: string (required)
  ##                : The namespace name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   authorizationRuleName: string (required)
  ##                        : Authorization Rule Name.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   notificationHubName: string (required)
  ##                      : The notification hub name.
  ##   parameters: JObject (required)
  ##             : The shared access authorization rule.
  var path_594240 = newJObject()
  var query_594241 = newJObject()
  var body_594242 = newJObject()
  add(path_594240, "namespaceName", newJString(namespaceName))
  add(path_594240, "resourceGroupName", newJString(resourceGroupName))
  add(query_594241, "api-version", newJString(apiVersion))
  add(path_594240, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_594240, "subscriptionId", newJString(subscriptionId))
  add(path_594240, "notificationHubName", newJString(notificationHubName))
  if parameters != nil:
    body_594242 = parameters
  result = call_594239.call(path_594240, query_594241, nil, nil, body_594242)

var notificationHubsCreateOrUpdateAuthorizationRule* = Call_NotificationHubsCreateOrUpdateAuthorizationRule_594228(
    name: "notificationHubsCreateOrUpdateAuthorizationRule",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NotificationHubs/namespaces/{namespaceName}/notificationHubs/{notificationHubName}/AuthorizationRules/{authorizationRuleName}",
    validator: validate_NotificationHubsCreateOrUpdateAuthorizationRule_594229,
    base: "", url: url_NotificationHubsCreateOrUpdateAuthorizationRule_594230,
    schemes: {Scheme.Https})
type
  Call_NotificationHubsGetAuthorizationRule_594215 = ref object of OpenApiRestCall_593425
proc url_NotificationHubsGetAuthorizationRule_594217(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "notificationHubName" in path,
        "`notificationHubName` is a required path parameter"
  assert "authorizationRuleName" in path,
        "`authorizationRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.NotificationHubs/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/notificationHubs/"),
               (kind: VariableSegment, value: "notificationHubName"),
               (kind: ConstantSegment, value: "/AuthorizationRules/"),
               (kind: VariableSegment, value: "authorizationRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NotificationHubsGetAuthorizationRule_594216(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets an authorization rule for a NotificationHub by name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   authorizationRuleName: JString (required)
  ##                        : authorization rule name.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   notificationHubName: JString (required)
  ##                      : The notification hub name.
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
  var valid_594220 = path.getOrDefault("authorizationRuleName")
  valid_594220 = validateParameter(valid_594220, JString, required = true,
                                 default = nil)
  if valid_594220 != nil:
    section.add "authorizationRuleName", valid_594220
  var valid_594221 = path.getOrDefault("subscriptionId")
  valid_594221 = validateParameter(valid_594221, JString, required = true,
                                 default = nil)
  if valid_594221 != nil:
    section.add "subscriptionId", valid_594221
  var valid_594222 = path.getOrDefault("notificationHubName")
  valid_594222 = validateParameter(valid_594222, JString, required = true,
                                 default = nil)
  if valid_594222 != nil:
    section.add "notificationHubName", valid_594222
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
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

proc call*(call_594224: Call_NotificationHubsGetAuthorizationRule_594215;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets an authorization rule for a NotificationHub by name.
  ## 
  let valid = call_594224.validator(path, query, header, formData, body)
  let scheme = call_594224.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594224.url(scheme.get, call_594224.host, call_594224.base,
                         call_594224.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594224, url, valid)

proc call*(call_594225: Call_NotificationHubsGetAuthorizationRule_594215;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          authorizationRuleName: string; subscriptionId: string;
          notificationHubName: string): Recallable =
  ## notificationHubsGetAuthorizationRule
  ## Gets an authorization rule for a NotificationHub by name.
  ##   namespaceName: string (required)
  ##                : The namespace name
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   authorizationRuleName: string (required)
  ##                        : authorization rule name.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   notificationHubName: string (required)
  ##                      : The notification hub name.
  var path_594226 = newJObject()
  var query_594227 = newJObject()
  add(path_594226, "namespaceName", newJString(namespaceName))
  add(path_594226, "resourceGroupName", newJString(resourceGroupName))
  add(query_594227, "api-version", newJString(apiVersion))
  add(path_594226, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_594226, "subscriptionId", newJString(subscriptionId))
  add(path_594226, "notificationHubName", newJString(notificationHubName))
  result = call_594225.call(path_594226, query_594227, nil, nil, nil)

var notificationHubsGetAuthorizationRule* = Call_NotificationHubsGetAuthorizationRule_594215(
    name: "notificationHubsGetAuthorizationRule", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NotificationHubs/namespaces/{namespaceName}/notificationHubs/{notificationHubName}/AuthorizationRules/{authorizationRuleName}",
    validator: validate_NotificationHubsGetAuthorizationRule_594216, base: "",
    url: url_NotificationHubsGetAuthorizationRule_594217, schemes: {Scheme.Https})
type
  Call_NotificationHubsDeleteAuthorizationRule_594243 = ref object of OpenApiRestCall_593425
proc url_NotificationHubsDeleteAuthorizationRule_594245(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "notificationHubName" in path,
        "`notificationHubName` is a required path parameter"
  assert "authorizationRuleName" in path,
        "`authorizationRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.NotificationHubs/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/notificationHubs/"),
               (kind: VariableSegment, value: "notificationHubName"),
               (kind: ConstantSegment, value: "/AuthorizationRules/"),
               (kind: VariableSegment, value: "authorizationRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NotificationHubsDeleteAuthorizationRule_594244(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a notificationHub authorization rule
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   authorizationRuleName: JString (required)
  ##                        : Authorization Rule Name.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   notificationHubName: JString (required)
  ##                      : The notification hub name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_594246 = path.getOrDefault("namespaceName")
  valid_594246 = validateParameter(valid_594246, JString, required = true,
                                 default = nil)
  if valid_594246 != nil:
    section.add "namespaceName", valid_594246
  var valid_594247 = path.getOrDefault("resourceGroupName")
  valid_594247 = validateParameter(valid_594247, JString, required = true,
                                 default = nil)
  if valid_594247 != nil:
    section.add "resourceGroupName", valid_594247
  var valid_594248 = path.getOrDefault("authorizationRuleName")
  valid_594248 = validateParameter(valid_594248, JString, required = true,
                                 default = nil)
  if valid_594248 != nil:
    section.add "authorizationRuleName", valid_594248
  var valid_594249 = path.getOrDefault("subscriptionId")
  valid_594249 = validateParameter(valid_594249, JString, required = true,
                                 default = nil)
  if valid_594249 != nil:
    section.add "subscriptionId", valid_594249
  var valid_594250 = path.getOrDefault("notificationHubName")
  valid_594250 = validateParameter(valid_594250, JString, required = true,
                                 default = nil)
  if valid_594250 != nil:
    section.add "notificationHubName", valid_594250
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594251 = query.getOrDefault("api-version")
  valid_594251 = validateParameter(valid_594251, JString, required = true,
                                 default = nil)
  if valid_594251 != nil:
    section.add "api-version", valid_594251
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594252: Call_NotificationHubsDeleteAuthorizationRule_594243;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a notificationHub authorization rule
  ## 
  let valid = call_594252.validator(path, query, header, formData, body)
  let scheme = call_594252.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594252.url(scheme.get, call_594252.host, call_594252.base,
                         call_594252.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594252, url, valid)

proc call*(call_594253: Call_NotificationHubsDeleteAuthorizationRule_594243;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          authorizationRuleName: string; subscriptionId: string;
          notificationHubName: string): Recallable =
  ## notificationHubsDeleteAuthorizationRule
  ## Deletes a notificationHub authorization rule
  ##   namespaceName: string (required)
  ##                : The namespace name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   authorizationRuleName: string (required)
  ##                        : Authorization Rule Name.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   notificationHubName: string (required)
  ##                      : The notification hub name.
  var path_594254 = newJObject()
  var query_594255 = newJObject()
  add(path_594254, "namespaceName", newJString(namespaceName))
  add(path_594254, "resourceGroupName", newJString(resourceGroupName))
  add(query_594255, "api-version", newJString(apiVersion))
  add(path_594254, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_594254, "subscriptionId", newJString(subscriptionId))
  add(path_594254, "notificationHubName", newJString(notificationHubName))
  result = call_594253.call(path_594254, query_594255, nil, nil, nil)

var notificationHubsDeleteAuthorizationRule* = Call_NotificationHubsDeleteAuthorizationRule_594243(
    name: "notificationHubsDeleteAuthorizationRule", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NotificationHubs/namespaces/{namespaceName}/notificationHubs/{notificationHubName}/AuthorizationRules/{authorizationRuleName}",
    validator: validate_NotificationHubsDeleteAuthorizationRule_594244, base: "",
    url: url_NotificationHubsDeleteAuthorizationRule_594245,
    schemes: {Scheme.Https})
type
  Call_NotificationHubsListKeys_594256 = ref object of OpenApiRestCall_593425
proc url_NotificationHubsListKeys_594258(protocol: Scheme; host: string;
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
  assert "notificationHubName" in path,
        "`notificationHubName` is a required path parameter"
  assert "authorizationRuleName" in path,
        "`authorizationRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.NotificationHubs/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/notificationHubs/"),
               (kind: VariableSegment, value: "notificationHubName"),
               (kind: ConstantSegment, value: "/AuthorizationRules/"),
               (kind: VariableSegment, value: "authorizationRuleName"),
               (kind: ConstantSegment, value: "/listKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NotificationHubsListKeys_594257(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the Primary and Secondary ConnectionStrings to the NotificationHub 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   authorizationRuleName: JString (required)
  ##                        : The connection string of the NotificationHub for the specified authorizationRule.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   notificationHubName: JString (required)
  ##                      : The notification hub name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_594259 = path.getOrDefault("namespaceName")
  valid_594259 = validateParameter(valid_594259, JString, required = true,
                                 default = nil)
  if valid_594259 != nil:
    section.add "namespaceName", valid_594259
  var valid_594260 = path.getOrDefault("resourceGroupName")
  valid_594260 = validateParameter(valid_594260, JString, required = true,
                                 default = nil)
  if valid_594260 != nil:
    section.add "resourceGroupName", valid_594260
  var valid_594261 = path.getOrDefault("authorizationRuleName")
  valid_594261 = validateParameter(valid_594261, JString, required = true,
                                 default = nil)
  if valid_594261 != nil:
    section.add "authorizationRuleName", valid_594261
  var valid_594262 = path.getOrDefault("subscriptionId")
  valid_594262 = validateParameter(valid_594262, JString, required = true,
                                 default = nil)
  if valid_594262 != nil:
    section.add "subscriptionId", valid_594262
  var valid_594263 = path.getOrDefault("notificationHubName")
  valid_594263 = validateParameter(valid_594263, JString, required = true,
                                 default = nil)
  if valid_594263 != nil:
    section.add "notificationHubName", valid_594263
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594264 = query.getOrDefault("api-version")
  valid_594264 = validateParameter(valid_594264, JString, required = true,
                                 default = nil)
  if valid_594264 != nil:
    section.add "api-version", valid_594264
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594265: Call_NotificationHubsListKeys_594256; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the Primary and Secondary ConnectionStrings to the NotificationHub 
  ## 
  let valid = call_594265.validator(path, query, header, formData, body)
  let scheme = call_594265.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594265.url(scheme.get, call_594265.host, call_594265.base,
                         call_594265.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594265, url, valid)

proc call*(call_594266: Call_NotificationHubsListKeys_594256;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          authorizationRuleName: string; subscriptionId: string;
          notificationHubName: string): Recallable =
  ## notificationHubsListKeys
  ## Gets the Primary and Secondary ConnectionStrings to the NotificationHub 
  ##   namespaceName: string (required)
  ##                : The namespace name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   authorizationRuleName: string (required)
  ##                        : The connection string of the NotificationHub for the specified authorizationRule.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   notificationHubName: string (required)
  ##                      : The notification hub name.
  var path_594267 = newJObject()
  var query_594268 = newJObject()
  add(path_594267, "namespaceName", newJString(namespaceName))
  add(path_594267, "resourceGroupName", newJString(resourceGroupName))
  add(query_594268, "api-version", newJString(apiVersion))
  add(path_594267, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_594267, "subscriptionId", newJString(subscriptionId))
  add(path_594267, "notificationHubName", newJString(notificationHubName))
  result = call_594266.call(path_594267, query_594268, nil, nil, nil)

var notificationHubsListKeys* = Call_NotificationHubsListKeys_594256(
    name: "notificationHubsListKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NotificationHubs/namespaces/{namespaceName}/notificationHubs/{notificationHubName}/AuthorizationRules/{authorizationRuleName}/listKeys",
    validator: validate_NotificationHubsListKeys_594257, base: "",
    url: url_NotificationHubsListKeys_594258, schemes: {Scheme.Https})
type
  Call_NotificationHubsRegenerateKeys_594269 = ref object of OpenApiRestCall_593425
proc url_NotificationHubsRegenerateKeys_594271(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "notificationHubName" in path,
        "`notificationHubName` is a required path parameter"
  assert "authorizationRuleName" in path,
        "`authorizationRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.NotificationHubs/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/notificationHubs/"),
               (kind: VariableSegment, value: "notificationHubName"),
               (kind: ConstantSegment, value: "/AuthorizationRules/"),
               (kind: VariableSegment, value: "authorizationRuleName"),
               (kind: ConstantSegment, value: "/regenerateKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NotificationHubsRegenerateKeys_594270(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Regenerates the Primary/Secondary Keys to the NotificationHub Authorization Rule
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   authorizationRuleName: JString (required)
  ##                        : The connection string of the NotificationHub for the specified authorizationRule.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   notificationHubName: JString (required)
  ##                      : The notification hub name.
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
  var valid_594274 = path.getOrDefault("authorizationRuleName")
  valid_594274 = validateParameter(valid_594274, JString, required = true,
                                 default = nil)
  if valid_594274 != nil:
    section.add "authorizationRuleName", valid_594274
  var valid_594275 = path.getOrDefault("subscriptionId")
  valid_594275 = validateParameter(valid_594275, JString, required = true,
                                 default = nil)
  if valid_594275 != nil:
    section.add "subscriptionId", valid_594275
  var valid_594276 = path.getOrDefault("notificationHubName")
  valid_594276 = validateParameter(valid_594276, JString, required = true,
                                 default = nil)
  if valid_594276 != nil:
    section.add "notificationHubName", valid_594276
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
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
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to regenerate the NotificationHub Authorization Rule Key.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594279: Call_NotificationHubsRegenerateKeys_594269; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Regenerates the Primary/Secondary Keys to the NotificationHub Authorization Rule
  ## 
  let valid = call_594279.validator(path, query, header, formData, body)
  let scheme = call_594279.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594279.url(scheme.get, call_594279.host, call_594279.base,
                         call_594279.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594279, url, valid)

proc call*(call_594280: Call_NotificationHubsRegenerateKeys_594269;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          authorizationRuleName: string; subscriptionId: string;
          notificationHubName: string; parameters: JsonNode): Recallable =
  ## notificationHubsRegenerateKeys
  ## Regenerates the Primary/Secondary Keys to the NotificationHub Authorization Rule
  ##   namespaceName: string (required)
  ##                : The namespace name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   authorizationRuleName: string (required)
  ##                        : The connection string of the NotificationHub for the specified authorizationRule.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   notificationHubName: string (required)
  ##                      : The notification hub name.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to regenerate the NotificationHub Authorization Rule Key.
  var path_594281 = newJObject()
  var query_594282 = newJObject()
  var body_594283 = newJObject()
  add(path_594281, "namespaceName", newJString(namespaceName))
  add(path_594281, "resourceGroupName", newJString(resourceGroupName))
  add(query_594282, "api-version", newJString(apiVersion))
  add(path_594281, "authorizationRuleName", newJString(authorizationRuleName))
  add(path_594281, "subscriptionId", newJString(subscriptionId))
  add(path_594281, "notificationHubName", newJString(notificationHubName))
  if parameters != nil:
    body_594283 = parameters
  result = call_594280.call(path_594281, query_594282, nil, nil, body_594283)

var notificationHubsRegenerateKeys* = Call_NotificationHubsRegenerateKeys_594269(
    name: "notificationHubsRegenerateKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NotificationHubs/namespaces/{namespaceName}/notificationHubs/{notificationHubName}/AuthorizationRules/{authorizationRuleName}/regenerateKeys",
    validator: validate_NotificationHubsRegenerateKeys_594270, base: "",
    url: url_NotificationHubsRegenerateKeys_594271, schemes: {Scheme.Https})
type
  Call_NotificationHubsDebugSend_594284 = ref object of OpenApiRestCall_593425
proc url_NotificationHubsDebugSend_594286(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "notificationHubName" in path,
        "`notificationHubName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.NotificationHubs/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/notificationHubs/"),
               (kind: VariableSegment, value: "notificationHubName"),
               (kind: ConstantSegment, value: "/debugsend")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NotificationHubsDebugSend_594285(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## test send a push notification
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   notificationHubName: JString (required)
  ##                      : The notification hub name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_594287 = path.getOrDefault("namespaceName")
  valid_594287 = validateParameter(valid_594287, JString, required = true,
                                 default = nil)
  if valid_594287 != nil:
    section.add "namespaceName", valid_594287
  var valid_594288 = path.getOrDefault("resourceGroupName")
  valid_594288 = validateParameter(valid_594288, JString, required = true,
                                 default = nil)
  if valid_594288 != nil:
    section.add "resourceGroupName", valid_594288
  var valid_594289 = path.getOrDefault("subscriptionId")
  valid_594289 = validateParameter(valid_594289, JString, required = true,
                                 default = nil)
  if valid_594289 != nil:
    section.add "subscriptionId", valid_594289
  var valid_594290 = path.getOrDefault("notificationHubName")
  valid_594290 = validateParameter(valid_594290, JString, required = true,
                                 default = nil)
  if valid_594290 != nil:
    section.add "notificationHubName", valid_594290
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594291 = query.getOrDefault("api-version")
  valid_594291 = validateParameter(valid_594291, JString, required = true,
                                 default = nil)
  if valid_594291 != nil:
    section.add "api-version", valid_594291
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject
  ##             : Debug send parameters
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594293: Call_NotificationHubsDebugSend_594284; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## test send a push notification
  ## 
  let valid = call_594293.validator(path, query, header, formData, body)
  let scheme = call_594293.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594293.url(scheme.get, call_594293.host, call_594293.base,
                         call_594293.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594293, url, valid)

proc call*(call_594294: Call_NotificationHubsDebugSend_594284;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; notificationHubName: string;
          parameters: JsonNode = nil): Recallable =
  ## notificationHubsDebugSend
  ## test send a push notification
  ##   namespaceName: string (required)
  ##                : The namespace name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   notificationHubName: string (required)
  ##                      : The notification hub name.
  ##   parameters: JObject
  ##             : Debug send parameters
  var path_594295 = newJObject()
  var query_594296 = newJObject()
  var body_594297 = newJObject()
  add(path_594295, "namespaceName", newJString(namespaceName))
  add(path_594295, "resourceGroupName", newJString(resourceGroupName))
  add(query_594296, "api-version", newJString(apiVersion))
  add(path_594295, "subscriptionId", newJString(subscriptionId))
  add(path_594295, "notificationHubName", newJString(notificationHubName))
  if parameters != nil:
    body_594297 = parameters
  result = call_594294.call(path_594295, query_594296, nil, nil, body_594297)

var notificationHubsDebugSend* = Call_NotificationHubsDebugSend_594284(
    name: "notificationHubsDebugSend", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NotificationHubs/namespaces/{namespaceName}/notificationHubs/{notificationHubName}/debugsend",
    validator: validate_NotificationHubsDebugSend_594285, base: "",
    url: url_NotificationHubsDebugSend_594286, schemes: {Scheme.Https})
type
  Call_NotificationHubsGetPnsCredentials_594298 = ref object of OpenApiRestCall_593425
proc url_NotificationHubsGetPnsCredentials_594300(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "namespaceName" in path, "`namespaceName` is a required path parameter"
  assert "notificationHubName" in path,
        "`notificationHubName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.NotificationHubs/namespaces/"),
               (kind: VariableSegment, value: "namespaceName"),
               (kind: ConstantSegment, value: "/notificationHubs/"),
               (kind: VariableSegment, value: "notificationHubName"),
               (kind: ConstantSegment, value: "/pnsCredentials")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NotificationHubsGetPnsCredentials_594299(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the PNS Credentials associated with a notification hub .
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   namespaceName: JString (required)
  ##                : The namespace name.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   notificationHubName: JString (required)
  ##                      : The notification hub name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `namespaceName` field"
  var valid_594301 = path.getOrDefault("namespaceName")
  valid_594301 = validateParameter(valid_594301, JString, required = true,
                                 default = nil)
  if valid_594301 != nil:
    section.add "namespaceName", valid_594301
  var valid_594302 = path.getOrDefault("resourceGroupName")
  valid_594302 = validateParameter(valid_594302, JString, required = true,
                                 default = nil)
  if valid_594302 != nil:
    section.add "resourceGroupName", valid_594302
  var valid_594303 = path.getOrDefault("subscriptionId")
  valid_594303 = validateParameter(valid_594303, JString, required = true,
                                 default = nil)
  if valid_594303 != nil:
    section.add "subscriptionId", valid_594303
  var valid_594304 = path.getOrDefault("notificationHubName")
  valid_594304 = validateParameter(valid_594304, JString, required = true,
                                 default = nil)
  if valid_594304 != nil:
    section.add "notificationHubName", valid_594304
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594305 = query.getOrDefault("api-version")
  valid_594305 = validateParameter(valid_594305, JString, required = true,
                                 default = nil)
  if valid_594305 != nil:
    section.add "api-version", valid_594305
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594306: Call_NotificationHubsGetPnsCredentials_594298;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the PNS Credentials associated with a notification hub .
  ## 
  let valid = call_594306.validator(path, query, header, formData, body)
  let scheme = call_594306.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594306.url(scheme.get, call_594306.host, call_594306.base,
                         call_594306.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594306, url, valid)

proc call*(call_594307: Call_NotificationHubsGetPnsCredentials_594298;
          namespaceName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; notificationHubName: string): Recallable =
  ## notificationHubsGetPnsCredentials
  ## Lists the PNS Credentials associated with a notification hub .
  ##   namespaceName: string (required)
  ##                : The namespace name.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   notificationHubName: string (required)
  ##                      : The notification hub name.
  var path_594308 = newJObject()
  var query_594309 = newJObject()
  add(path_594308, "namespaceName", newJString(namespaceName))
  add(path_594308, "resourceGroupName", newJString(resourceGroupName))
  add(query_594309, "api-version", newJString(apiVersion))
  add(path_594308, "subscriptionId", newJString(subscriptionId))
  add(path_594308, "notificationHubName", newJString(notificationHubName))
  result = call_594307.call(path_594308, query_594309, nil, nil, nil)

var notificationHubsGetPnsCredentials* = Call_NotificationHubsGetPnsCredentials_594298(
    name: "notificationHubsGetPnsCredentials", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NotificationHubs/namespaces/{namespaceName}/notificationHubs/{notificationHubName}/pnsCredentials",
    validator: validate_NotificationHubsGetPnsCredentials_594299, base: "",
    url: url_NotificationHubsGetPnsCredentials_594300, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
