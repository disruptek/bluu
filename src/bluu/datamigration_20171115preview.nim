
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Azure Data Migration Service Resource Provider
## version: 2017-11-15-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## The Data Migration Service helps people migrate their data from on-premise database servers to Azure, or from older database software to newer software. The service manages one or more workers that are joined to a customer's virtual network, which is assumed to provide connectivity to their databases. To avoid frequent updates to the resource provider, data migration tasks are implemented by the resource provider in a generic way as task resources, each of which has a task type (which identifies the type of work to run), input, and output. The client is responsible for providing appropriate task type and inputs, which will be passed through unexamined to the machines that implement the functionality, and for understanding the output, which is passed back unexamined to the client.
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
  macServiceName = "datamigration"
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
  ## Lists all available actions exposed by the Data Migration Service resource provider.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API
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
  ## Lists all available actions exposed by the Data Migration Service resource provider.
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
  ## Lists all available actions exposed by the Data Migration Service resource provider.
  ##   apiVersion: string (required)
  ##             : Version of the API
  var query_593902 = newJObject()
  add(query_593902, "api-version", newJString(apiVersion))
  result = call_593901.call(nil, query_593902, nil, nil, nil)

var operationsList* = Call_OperationsList_593646(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.DataMigration/operations",
    validator: validate_OperationsList_593647, base: "", url: url_OperationsList_593648,
    schemes: {Scheme.Https})
type
  Call_ServicesCheckNameAvailability_593942 = ref object of OpenApiRestCall_593424
proc url_ServicesCheckNameAvailability_593944(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataMigration/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/checkNameAvailability")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicesCheckNameAvailability_593943(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This method checks whether a proposed top-level resource name is valid and available.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Identifier of the subscription
  ##   location: JString (required)
  ##           : The Azure region of the operation
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_593959 = path.getOrDefault("subscriptionId")
  valid_593959 = validateParameter(valid_593959, JString, required = true,
                                 default = nil)
  if valid_593959 != nil:
    section.add "subscriptionId", valid_593959
  var valid_593960 = path.getOrDefault("location")
  valid_593960 = validateParameter(valid_593960, JString, required = true,
                                 default = nil)
  if valid_593960 != nil:
    section.add "location", valid_593960
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593961 = query.getOrDefault("api-version")
  valid_593961 = validateParameter(valid_593961, JString, required = true,
                                 default = nil)
  if valid_593961 != nil:
    section.add "api-version", valid_593961
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Requested name to validate
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_593963: Call_ServicesCheckNameAvailability_593942; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This method checks whether a proposed top-level resource name is valid and available.
  ## 
  let valid = call_593963.validator(path, query, header, formData, body)
  let scheme = call_593963.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593963.url(scheme.get, call_593963.host, call_593963.base,
                         call_593963.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593963, url, valid)

proc call*(call_593964: Call_ServicesCheckNameAvailability_593942;
          apiVersion: string; subscriptionId: string; parameters: JsonNode;
          location: string): Recallable =
  ## servicesCheckNameAvailability
  ## This method checks whether a proposed top-level resource name is valid and available.
  ##   apiVersion: string (required)
  ##             : Version of the API
  ##   subscriptionId: string (required)
  ##                 : Identifier of the subscription
  ##   parameters: JObject (required)
  ##             : Requested name to validate
  ##   location: string (required)
  ##           : The Azure region of the operation
  var path_593965 = newJObject()
  var query_593966 = newJObject()
  var body_593967 = newJObject()
  add(query_593966, "api-version", newJString(apiVersion))
  add(path_593965, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_593967 = parameters
  add(path_593965, "location", newJString(location))
  result = call_593964.call(path_593965, query_593966, nil, nil, body_593967)

var servicesCheckNameAvailability* = Call_ServicesCheckNameAvailability_593942(
    name: "servicesCheckNameAvailability", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.DataMigration/locations/{location}/checkNameAvailability",
    validator: validate_ServicesCheckNameAvailability_593943, base: "",
    url: url_ServicesCheckNameAvailability_593944, schemes: {Scheme.Https})
type
  Call_UsagesList_593968 = ref object of OpenApiRestCall_593424
proc url_UsagesList_593970(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataMigration/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/usages")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UsagesList_593969(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## This method returns region-specific quotas and resource usage information for the Data Migration Service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Identifier of the subscription
  ##   location: JString (required)
  ##           : The Azure region of the operation
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_593971 = path.getOrDefault("subscriptionId")
  valid_593971 = validateParameter(valid_593971, JString, required = true,
                                 default = nil)
  if valid_593971 != nil:
    section.add "subscriptionId", valid_593971
  var valid_593972 = path.getOrDefault("location")
  valid_593972 = validateParameter(valid_593972, JString, required = true,
                                 default = nil)
  if valid_593972 != nil:
    section.add "location", valid_593972
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593973 = query.getOrDefault("api-version")
  valid_593973 = validateParameter(valid_593973, JString, required = true,
                                 default = nil)
  if valid_593973 != nil:
    section.add "api-version", valid_593973
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593974: Call_UsagesList_593968; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This method returns region-specific quotas and resource usage information for the Data Migration Service.
  ## 
  let valid = call_593974.validator(path, query, header, formData, body)
  let scheme = call_593974.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593974.url(scheme.get, call_593974.host, call_593974.base,
                         call_593974.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593974, url, valid)

proc call*(call_593975: Call_UsagesList_593968; apiVersion: string;
          subscriptionId: string; location: string): Recallable =
  ## usagesList
  ## This method returns region-specific quotas and resource usage information for the Data Migration Service.
  ##   apiVersion: string (required)
  ##             : Version of the API
  ##   subscriptionId: string (required)
  ##                 : Identifier of the subscription
  ##   location: string (required)
  ##           : The Azure region of the operation
  var path_593976 = newJObject()
  var query_593977 = newJObject()
  add(query_593977, "api-version", newJString(apiVersion))
  add(path_593976, "subscriptionId", newJString(subscriptionId))
  add(path_593976, "location", newJString(location))
  result = call_593975.call(path_593976, query_593977, nil, nil, nil)

var usagesList* = Call_UsagesList_593968(name: "usagesList",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.DataMigration/locations/{location}/usages",
                                      validator: validate_UsagesList_593969,
                                      base: "", url: url_UsagesList_593970,
                                      schemes: {Scheme.Https})
type
  Call_ServicesList_593978 = ref object of OpenApiRestCall_593424
proc url_ServicesList_593980(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.DataMigration/services")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicesList_593979(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## The services resource is the top-level resource that represents the Data Migration Service. This method returns a list of service resources in a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Identifier of the subscription
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_593981 = path.getOrDefault("subscriptionId")
  valid_593981 = validateParameter(valid_593981, JString, required = true,
                                 default = nil)
  if valid_593981 != nil:
    section.add "subscriptionId", valid_593981
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593982 = query.getOrDefault("api-version")
  valid_593982 = validateParameter(valid_593982, JString, required = true,
                                 default = nil)
  if valid_593982 != nil:
    section.add "api-version", valid_593982
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593983: Call_ServicesList_593978; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The services resource is the top-level resource that represents the Data Migration Service. This method returns a list of service resources in a subscription.
  ## 
  let valid = call_593983.validator(path, query, header, formData, body)
  let scheme = call_593983.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593983.url(scheme.get, call_593983.host, call_593983.base,
                         call_593983.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593983, url, valid)

proc call*(call_593984: Call_ServicesList_593978; apiVersion: string;
          subscriptionId: string): Recallable =
  ## servicesList
  ## The services resource is the top-level resource that represents the Data Migration Service. This method returns a list of service resources in a subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API
  ##   subscriptionId: string (required)
  ##                 : Identifier of the subscription
  var path_593985 = newJObject()
  var query_593986 = newJObject()
  add(query_593986, "api-version", newJString(apiVersion))
  add(path_593985, "subscriptionId", newJString(subscriptionId))
  result = call_593984.call(path_593985, query_593986, nil, nil, nil)

var servicesList* = Call_ServicesList_593978(name: "servicesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.DataMigration/services",
    validator: validate_ServicesList_593979, base: "", url: url_ServicesList_593980,
    schemes: {Scheme.Https})
type
  Call_ResourceSkusListSkus_593987 = ref object of OpenApiRestCall_593424
proc url_ResourceSkusListSkus_593989(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DataMigration/skus")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourceSkusListSkus_593988(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The skus action returns the list of SKUs that DMS supports.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Identifier of the subscription
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_593990 = path.getOrDefault("subscriptionId")
  valid_593990 = validateParameter(valid_593990, JString, required = true,
                                 default = nil)
  if valid_593990 != nil:
    section.add "subscriptionId", valid_593990
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593991 = query.getOrDefault("api-version")
  valid_593991 = validateParameter(valid_593991, JString, required = true,
                                 default = nil)
  if valid_593991 != nil:
    section.add "api-version", valid_593991
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593992: Call_ResourceSkusListSkus_593987; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The skus action returns the list of SKUs that DMS supports.
  ## 
  let valid = call_593992.validator(path, query, header, formData, body)
  let scheme = call_593992.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593992.url(scheme.get, call_593992.host, call_593992.base,
                         call_593992.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593992, url, valid)

proc call*(call_593993: Call_ResourceSkusListSkus_593987; apiVersion: string;
          subscriptionId: string): Recallable =
  ## resourceSkusListSkus
  ## The skus action returns the list of SKUs that DMS supports.
  ##   apiVersion: string (required)
  ##             : Version of the API
  ##   subscriptionId: string (required)
  ##                 : Identifier of the subscription
  var path_593994 = newJObject()
  var query_593995 = newJObject()
  add(query_593995, "api-version", newJString(apiVersion))
  add(path_593994, "subscriptionId", newJString(subscriptionId))
  result = call_593993.call(path_593994, query_593995, nil, nil, nil)

var resourceSkusListSkus* = Call_ResourceSkusListSkus_593987(
    name: "resourceSkusListSkus", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.DataMigration/skus",
    validator: validate_ResourceSkusListSkus_593988, base: "",
    url: url_ResourceSkusListSkus_593989, schemes: {Scheme.Https})
type
  Call_ServicesListByResourceGroup_593996 = ref object of OpenApiRestCall_593424
proc url_ServicesListByResourceGroup_593998(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "groupName" in path, "`groupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "groupName"), (kind: ConstantSegment,
        value: "/providers/Microsoft.DataMigration/services")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicesListByResourceGroup_593997(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The Services resource is the top-level resource that represents the Data Migration Service. This method returns a list of service resources in a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Identifier of the subscription
  ##   groupName: JString (required)
  ##            : Name of the resource group
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_593999 = path.getOrDefault("subscriptionId")
  valid_593999 = validateParameter(valid_593999, JString, required = true,
                                 default = nil)
  if valid_593999 != nil:
    section.add "subscriptionId", valid_593999
  var valid_594000 = path.getOrDefault("groupName")
  valid_594000 = validateParameter(valid_594000, JString, required = true,
                                 default = nil)
  if valid_594000 != nil:
    section.add "groupName", valid_594000
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API
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

proc call*(call_594002: Call_ServicesListByResourceGroup_593996; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Services resource is the top-level resource that represents the Data Migration Service. This method returns a list of service resources in a resource group.
  ## 
  let valid = call_594002.validator(path, query, header, formData, body)
  let scheme = call_594002.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594002.url(scheme.get, call_594002.host, call_594002.base,
                         call_594002.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594002, url, valid)

proc call*(call_594003: Call_ServicesListByResourceGroup_593996;
          apiVersion: string; subscriptionId: string; groupName: string): Recallable =
  ## servicesListByResourceGroup
  ## The Services resource is the top-level resource that represents the Data Migration Service. This method returns a list of service resources in a resource group.
  ##   apiVersion: string (required)
  ##             : Version of the API
  ##   subscriptionId: string (required)
  ##                 : Identifier of the subscription
  ##   groupName: string (required)
  ##            : Name of the resource group
  var path_594004 = newJObject()
  var query_594005 = newJObject()
  add(query_594005, "api-version", newJString(apiVersion))
  add(path_594004, "subscriptionId", newJString(subscriptionId))
  add(path_594004, "groupName", newJString(groupName))
  result = call_594003.call(path_594004, query_594005, nil, nil, nil)

var servicesListByResourceGroup* = Call_ServicesListByResourceGroup_593996(
    name: "servicesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{groupName}/providers/Microsoft.DataMigration/services",
    validator: validate_ServicesListByResourceGroup_593997, base: "",
    url: url_ServicesListByResourceGroup_593998, schemes: {Scheme.Https})
type
  Call_ServicesCreateOrUpdate_594017 = ref object of OpenApiRestCall_593424
proc url_ServicesCreateOrUpdate_594019(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "groupName" in path, "`groupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "groupName"), (kind: ConstantSegment,
        value: "/providers/Microsoft.DataMigration/services/"),
               (kind: VariableSegment, value: "serviceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicesCreateOrUpdate_594018(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The services resource is the top-level resource that represents the Data Migration Service. The PUT method creates a new service or updates an existing one. When a service is updated, existing child resources (i.e. tasks) are unaffected. Services currently support a single kind, "vm", which refers to a VM-based service, although other kinds may be added in the future. This method can change the kind, SKU, and network of the service, but if tasks are currently running (i.e. the service is busy), this will fail with 400 Bad Request ("ServiceIsBusy"). The provider will reply when successful with 200 OK or 201 Created. Long-running operations use the provisioningState property.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Identifier of the subscription
  ##   groupName: JString (required)
  ##            : Name of the resource group
  ##   serviceName: JString (required)
  ##              : Name of the service
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_594020 = path.getOrDefault("subscriptionId")
  valid_594020 = validateParameter(valid_594020, JString, required = true,
                                 default = nil)
  if valid_594020 != nil:
    section.add "subscriptionId", valid_594020
  var valid_594021 = path.getOrDefault("groupName")
  valid_594021 = validateParameter(valid_594021, JString, required = true,
                                 default = nil)
  if valid_594021 != nil:
    section.add "groupName", valid_594021
  var valid_594022 = path.getOrDefault("serviceName")
  valid_594022 = validateParameter(valid_594022, JString, required = true,
                                 default = nil)
  if valid_594022 != nil:
    section.add "serviceName", valid_594022
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API
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
  ##   parameters: JObject (required)
  ##             : Information about the service
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594025: Call_ServicesCreateOrUpdate_594017; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The services resource is the top-level resource that represents the Data Migration Service. The PUT method creates a new service or updates an existing one. When a service is updated, existing child resources (i.e. tasks) are unaffected. Services currently support a single kind, "vm", which refers to a VM-based service, although other kinds may be added in the future. This method can change the kind, SKU, and network of the service, but if tasks are currently running (i.e. the service is busy), this will fail with 400 Bad Request ("ServiceIsBusy"). The provider will reply when successful with 200 OK or 201 Created. Long-running operations use the provisioningState property.
  ## 
  let valid = call_594025.validator(path, query, header, formData, body)
  let scheme = call_594025.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594025.url(scheme.get, call_594025.host, call_594025.base,
                         call_594025.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594025, url, valid)

proc call*(call_594026: Call_ServicesCreateOrUpdate_594017; apiVersion: string;
          subscriptionId: string; groupName: string; parameters: JsonNode;
          serviceName: string): Recallable =
  ## servicesCreateOrUpdate
  ## The services resource is the top-level resource that represents the Data Migration Service. The PUT method creates a new service or updates an existing one. When a service is updated, existing child resources (i.e. tasks) are unaffected. Services currently support a single kind, "vm", which refers to a VM-based service, although other kinds may be added in the future. This method can change the kind, SKU, and network of the service, but if tasks are currently running (i.e. the service is busy), this will fail with 400 Bad Request ("ServiceIsBusy"). The provider will reply when successful with 200 OK or 201 Created. Long-running operations use the provisioningState property.
  ##   apiVersion: string (required)
  ##             : Version of the API
  ##   subscriptionId: string (required)
  ##                 : Identifier of the subscription
  ##   groupName: string (required)
  ##            : Name of the resource group
  ##   parameters: JObject (required)
  ##             : Information about the service
  ##   serviceName: string (required)
  ##              : Name of the service
  var path_594027 = newJObject()
  var query_594028 = newJObject()
  var body_594029 = newJObject()
  add(query_594028, "api-version", newJString(apiVersion))
  add(path_594027, "subscriptionId", newJString(subscriptionId))
  add(path_594027, "groupName", newJString(groupName))
  if parameters != nil:
    body_594029 = parameters
  add(path_594027, "serviceName", newJString(serviceName))
  result = call_594026.call(path_594027, query_594028, nil, nil, body_594029)

var servicesCreateOrUpdate* = Call_ServicesCreateOrUpdate_594017(
    name: "servicesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{groupName}/providers/Microsoft.DataMigration/services/{serviceName}",
    validator: validate_ServicesCreateOrUpdate_594018, base: "",
    url: url_ServicesCreateOrUpdate_594019, schemes: {Scheme.Https})
type
  Call_ServicesGet_594006 = ref object of OpenApiRestCall_593424
proc url_ServicesGet_594008(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "groupName" in path, "`groupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "groupName"), (kind: ConstantSegment,
        value: "/providers/Microsoft.DataMigration/services/"),
               (kind: VariableSegment, value: "serviceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicesGet_594007(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## The services resource is the top-level resource that represents the Data Migration Service. The GET method retrieves information about a service instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Identifier of the subscription
  ##   groupName: JString (required)
  ##            : Name of the resource group
  ##   serviceName: JString (required)
  ##              : Name of the service
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_594009 = path.getOrDefault("subscriptionId")
  valid_594009 = validateParameter(valid_594009, JString, required = true,
                                 default = nil)
  if valid_594009 != nil:
    section.add "subscriptionId", valid_594009
  var valid_594010 = path.getOrDefault("groupName")
  valid_594010 = validateParameter(valid_594010, JString, required = true,
                                 default = nil)
  if valid_594010 != nil:
    section.add "groupName", valid_594010
  var valid_594011 = path.getOrDefault("serviceName")
  valid_594011 = validateParameter(valid_594011, JString, required = true,
                                 default = nil)
  if valid_594011 != nil:
    section.add "serviceName", valid_594011
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594012 = query.getOrDefault("api-version")
  valid_594012 = validateParameter(valid_594012, JString, required = true,
                                 default = nil)
  if valid_594012 != nil:
    section.add "api-version", valid_594012
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594013: Call_ServicesGet_594006; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The services resource is the top-level resource that represents the Data Migration Service. The GET method retrieves information about a service instance.
  ## 
  let valid = call_594013.validator(path, query, header, formData, body)
  let scheme = call_594013.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594013.url(scheme.get, call_594013.host, call_594013.base,
                         call_594013.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594013, url, valid)

proc call*(call_594014: Call_ServicesGet_594006; apiVersion: string;
          subscriptionId: string; groupName: string; serviceName: string): Recallable =
  ## servicesGet
  ## The services resource is the top-level resource that represents the Data Migration Service. The GET method retrieves information about a service instance.
  ##   apiVersion: string (required)
  ##             : Version of the API
  ##   subscriptionId: string (required)
  ##                 : Identifier of the subscription
  ##   groupName: string (required)
  ##            : Name of the resource group
  ##   serviceName: string (required)
  ##              : Name of the service
  var path_594015 = newJObject()
  var query_594016 = newJObject()
  add(query_594016, "api-version", newJString(apiVersion))
  add(path_594015, "subscriptionId", newJString(subscriptionId))
  add(path_594015, "groupName", newJString(groupName))
  add(path_594015, "serviceName", newJString(serviceName))
  result = call_594014.call(path_594015, query_594016, nil, nil, nil)

var servicesGet* = Call_ServicesGet_594006(name: "servicesGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{groupName}/providers/Microsoft.DataMigration/services/{serviceName}",
                                        validator: validate_ServicesGet_594007,
                                        base: "", url: url_ServicesGet_594008,
                                        schemes: {Scheme.Https})
type
  Call_ServicesUpdate_594042 = ref object of OpenApiRestCall_593424
proc url_ServicesUpdate_594044(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "groupName" in path, "`groupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "groupName"), (kind: ConstantSegment,
        value: "/providers/Microsoft.DataMigration/services/"),
               (kind: VariableSegment, value: "serviceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicesUpdate_594043(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## The services resource is the top-level resource that represents the Data Migration Service. The PATCH method updates an existing service. This method can change the kind, SKU, and network of the service, but if tasks are currently running (i.e. the service is busy), this will fail with 400 Bad Request ("ServiceIsBusy").
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Identifier of the subscription
  ##   groupName: JString (required)
  ##            : Name of the resource group
  ##   serviceName: JString (required)
  ##              : Name of the service
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_594045 = path.getOrDefault("subscriptionId")
  valid_594045 = validateParameter(valid_594045, JString, required = true,
                                 default = nil)
  if valid_594045 != nil:
    section.add "subscriptionId", valid_594045
  var valid_594046 = path.getOrDefault("groupName")
  valid_594046 = validateParameter(valid_594046, JString, required = true,
                                 default = nil)
  if valid_594046 != nil:
    section.add "groupName", valid_594046
  var valid_594047 = path.getOrDefault("serviceName")
  valid_594047 = validateParameter(valid_594047, JString, required = true,
                                 default = nil)
  if valid_594047 != nil:
    section.add "serviceName", valid_594047
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594048 = query.getOrDefault("api-version")
  valid_594048 = validateParameter(valid_594048, JString, required = true,
                                 default = nil)
  if valid_594048 != nil:
    section.add "api-version", valid_594048
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Information about the service
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594050: Call_ServicesUpdate_594042; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The services resource is the top-level resource that represents the Data Migration Service. The PATCH method updates an existing service. This method can change the kind, SKU, and network of the service, but if tasks are currently running (i.e. the service is busy), this will fail with 400 Bad Request ("ServiceIsBusy").
  ## 
  let valid = call_594050.validator(path, query, header, formData, body)
  let scheme = call_594050.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594050.url(scheme.get, call_594050.host, call_594050.base,
                         call_594050.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594050, url, valid)

proc call*(call_594051: Call_ServicesUpdate_594042; apiVersion: string;
          subscriptionId: string; groupName: string; parameters: JsonNode;
          serviceName: string): Recallable =
  ## servicesUpdate
  ## The services resource is the top-level resource that represents the Data Migration Service. The PATCH method updates an existing service. This method can change the kind, SKU, and network of the service, but if tasks are currently running (i.e. the service is busy), this will fail with 400 Bad Request ("ServiceIsBusy").
  ##   apiVersion: string (required)
  ##             : Version of the API
  ##   subscriptionId: string (required)
  ##                 : Identifier of the subscription
  ##   groupName: string (required)
  ##            : Name of the resource group
  ##   parameters: JObject (required)
  ##             : Information about the service
  ##   serviceName: string (required)
  ##              : Name of the service
  var path_594052 = newJObject()
  var query_594053 = newJObject()
  var body_594054 = newJObject()
  add(query_594053, "api-version", newJString(apiVersion))
  add(path_594052, "subscriptionId", newJString(subscriptionId))
  add(path_594052, "groupName", newJString(groupName))
  if parameters != nil:
    body_594054 = parameters
  add(path_594052, "serviceName", newJString(serviceName))
  result = call_594051.call(path_594052, query_594053, nil, nil, body_594054)

var servicesUpdate* = Call_ServicesUpdate_594042(name: "servicesUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{groupName}/providers/Microsoft.DataMigration/services/{serviceName}",
    validator: validate_ServicesUpdate_594043, base: "", url: url_ServicesUpdate_594044,
    schemes: {Scheme.Https})
type
  Call_ServicesDelete_594030 = ref object of OpenApiRestCall_593424
proc url_ServicesDelete_594032(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "groupName" in path, "`groupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "groupName"), (kind: ConstantSegment,
        value: "/providers/Microsoft.DataMigration/services/"),
               (kind: VariableSegment, value: "serviceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicesDelete_594031(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## The services resource is the top-level resource that represents the Data Migration Service. The DELETE method deletes a service. Any running tasks will be canceled.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Identifier of the subscription
  ##   groupName: JString (required)
  ##            : Name of the resource group
  ##   serviceName: JString (required)
  ##              : Name of the service
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_594033 = path.getOrDefault("subscriptionId")
  valid_594033 = validateParameter(valid_594033, JString, required = true,
                                 default = nil)
  if valid_594033 != nil:
    section.add "subscriptionId", valid_594033
  var valid_594034 = path.getOrDefault("groupName")
  valid_594034 = validateParameter(valid_594034, JString, required = true,
                                 default = nil)
  if valid_594034 != nil:
    section.add "groupName", valid_594034
  var valid_594035 = path.getOrDefault("serviceName")
  valid_594035 = validateParameter(valid_594035, JString, required = true,
                                 default = nil)
  if valid_594035 != nil:
    section.add "serviceName", valid_594035
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API
  ##   deleteRunningTasks: JBool
  ##                     : Delete the resource even if it contains running tasks
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594036 = query.getOrDefault("api-version")
  valid_594036 = validateParameter(valid_594036, JString, required = true,
                                 default = nil)
  if valid_594036 != nil:
    section.add "api-version", valid_594036
  var valid_594037 = query.getOrDefault("deleteRunningTasks")
  valid_594037 = validateParameter(valid_594037, JBool, required = false, default = nil)
  if valid_594037 != nil:
    section.add "deleteRunningTasks", valid_594037
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594038: Call_ServicesDelete_594030; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The services resource is the top-level resource that represents the Data Migration Service. The DELETE method deletes a service. Any running tasks will be canceled.
  ## 
  let valid = call_594038.validator(path, query, header, formData, body)
  let scheme = call_594038.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594038.url(scheme.get, call_594038.host, call_594038.base,
                         call_594038.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594038, url, valid)

proc call*(call_594039: Call_ServicesDelete_594030; apiVersion: string;
          subscriptionId: string; groupName: string; serviceName: string;
          deleteRunningTasks: bool = false): Recallable =
  ## servicesDelete
  ## The services resource is the top-level resource that represents the Data Migration Service. The DELETE method deletes a service. Any running tasks will be canceled.
  ##   apiVersion: string (required)
  ##             : Version of the API
  ##   subscriptionId: string (required)
  ##                 : Identifier of the subscription
  ##   groupName: string (required)
  ##            : Name of the resource group
  ##   deleteRunningTasks: bool
  ##                     : Delete the resource even if it contains running tasks
  ##   serviceName: string (required)
  ##              : Name of the service
  var path_594040 = newJObject()
  var query_594041 = newJObject()
  add(query_594041, "api-version", newJString(apiVersion))
  add(path_594040, "subscriptionId", newJString(subscriptionId))
  add(path_594040, "groupName", newJString(groupName))
  add(query_594041, "deleteRunningTasks", newJBool(deleteRunningTasks))
  add(path_594040, "serviceName", newJString(serviceName))
  result = call_594039.call(path_594040, query_594041, nil, nil, nil)

var servicesDelete* = Call_ServicesDelete_594030(name: "servicesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{groupName}/providers/Microsoft.DataMigration/services/{serviceName}",
    validator: validate_ServicesDelete_594031, base: "", url: url_ServicesDelete_594032,
    schemes: {Scheme.Https})
type
  Call_ServicesCheckChildrenNameAvailability_594055 = ref object of OpenApiRestCall_593424
proc url_ServicesCheckChildrenNameAvailability_594057(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "groupName" in path, "`groupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "groupName"), (kind: ConstantSegment,
        value: "/providers/Microsoft.DataMigration/services/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/checkNameAvailability")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicesCheckChildrenNameAvailability_594056(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This method checks whether a proposed nested resource name is valid and available.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Identifier of the subscription
  ##   groupName: JString (required)
  ##            : Name of the resource group
  ##   serviceName: JString (required)
  ##              : Name of the service
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_594058 = path.getOrDefault("subscriptionId")
  valid_594058 = validateParameter(valid_594058, JString, required = true,
                                 default = nil)
  if valid_594058 != nil:
    section.add "subscriptionId", valid_594058
  var valid_594059 = path.getOrDefault("groupName")
  valid_594059 = validateParameter(valid_594059, JString, required = true,
                                 default = nil)
  if valid_594059 != nil:
    section.add "groupName", valid_594059
  var valid_594060 = path.getOrDefault("serviceName")
  valid_594060 = validateParameter(valid_594060, JString, required = true,
                                 default = nil)
  if valid_594060 != nil:
    section.add "serviceName", valid_594060
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594061 = query.getOrDefault("api-version")
  valid_594061 = validateParameter(valid_594061, JString, required = true,
                                 default = nil)
  if valid_594061 != nil:
    section.add "api-version", valid_594061
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Requested name to validate
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594063: Call_ServicesCheckChildrenNameAvailability_594055;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## This method checks whether a proposed nested resource name is valid and available.
  ## 
  let valid = call_594063.validator(path, query, header, formData, body)
  let scheme = call_594063.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594063.url(scheme.get, call_594063.host, call_594063.base,
                         call_594063.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594063, url, valid)

proc call*(call_594064: Call_ServicesCheckChildrenNameAvailability_594055;
          apiVersion: string; subscriptionId: string; groupName: string;
          parameters: JsonNode; serviceName: string): Recallable =
  ## servicesCheckChildrenNameAvailability
  ## This method checks whether a proposed nested resource name is valid and available.
  ##   apiVersion: string (required)
  ##             : Version of the API
  ##   subscriptionId: string (required)
  ##                 : Identifier of the subscription
  ##   groupName: string (required)
  ##            : Name of the resource group
  ##   parameters: JObject (required)
  ##             : Requested name to validate
  ##   serviceName: string (required)
  ##              : Name of the service
  var path_594065 = newJObject()
  var query_594066 = newJObject()
  var body_594067 = newJObject()
  add(query_594066, "api-version", newJString(apiVersion))
  add(path_594065, "subscriptionId", newJString(subscriptionId))
  add(path_594065, "groupName", newJString(groupName))
  if parameters != nil:
    body_594067 = parameters
  add(path_594065, "serviceName", newJString(serviceName))
  result = call_594064.call(path_594065, query_594066, nil, nil, body_594067)

var servicesCheckChildrenNameAvailability* = Call_ServicesCheckChildrenNameAvailability_594055(
    name: "servicesCheckChildrenNameAvailability", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{groupName}/providers/Microsoft.DataMigration/services/{serviceName}/checkNameAvailability",
    validator: validate_ServicesCheckChildrenNameAvailability_594056, base: "",
    url: url_ServicesCheckChildrenNameAvailability_594057, schemes: {Scheme.Https})
type
  Call_ServicesCheckStatus_594068 = ref object of OpenApiRestCall_593424
proc url_ServicesCheckStatus_594070(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "groupName" in path, "`groupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "groupName"), (kind: ConstantSegment,
        value: "/providers/Microsoft.DataMigration/services/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/checkStatus")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicesCheckStatus_594069(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## The services resource is the top-level resource that represents the Data Migration Service. This action performs a health check and returns the status of the service and virtual machine size.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Identifier of the subscription
  ##   groupName: JString (required)
  ##            : Name of the resource group
  ##   serviceName: JString (required)
  ##              : Name of the service
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_594071 = path.getOrDefault("subscriptionId")
  valid_594071 = validateParameter(valid_594071, JString, required = true,
                                 default = nil)
  if valid_594071 != nil:
    section.add "subscriptionId", valid_594071
  var valid_594072 = path.getOrDefault("groupName")
  valid_594072 = validateParameter(valid_594072, JString, required = true,
                                 default = nil)
  if valid_594072 != nil:
    section.add "groupName", valid_594072
  var valid_594073 = path.getOrDefault("serviceName")
  valid_594073 = validateParameter(valid_594073, JString, required = true,
                                 default = nil)
  if valid_594073 != nil:
    section.add "serviceName", valid_594073
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594074 = query.getOrDefault("api-version")
  valid_594074 = validateParameter(valid_594074, JString, required = true,
                                 default = nil)
  if valid_594074 != nil:
    section.add "api-version", valid_594074
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594075: Call_ServicesCheckStatus_594068; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The services resource is the top-level resource that represents the Data Migration Service. This action performs a health check and returns the status of the service and virtual machine size.
  ## 
  let valid = call_594075.validator(path, query, header, formData, body)
  let scheme = call_594075.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594075.url(scheme.get, call_594075.host, call_594075.base,
                         call_594075.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594075, url, valid)

proc call*(call_594076: Call_ServicesCheckStatus_594068; apiVersion: string;
          subscriptionId: string; groupName: string; serviceName: string): Recallable =
  ## servicesCheckStatus
  ## The services resource is the top-level resource that represents the Data Migration Service. This action performs a health check and returns the status of the service and virtual machine size.
  ##   apiVersion: string (required)
  ##             : Version of the API
  ##   subscriptionId: string (required)
  ##                 : Identifier of the subscription
  ##   groupName: string (required)
  ##            : Name of the resource group
  ##   serviceName: string (required)
  ##              : Name of the service
  var path_594077 = newJObject()
  var query_594078 = newJObject()
  add(query_594078, "api-version", newJString(apiVersion))
  add(path_594077, "subscriptionId", newJString(subscriptionId))
  add(path_594077, "groupName", newJString(groupName))
  add(path_594077, "serviceName", newJString(serviceName))
  result = call_594076.call(path_594077, query_594078, nil, nil, nil)

var servicesCheckStatus* = Call_ServicesCheckStatus_594068(
    name: "servicesCheckStatus", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{groupName}/providers/Microsoft.DataMigration/services/{serviceName}/checkStatus",
    validator: validate_ServicesCheckStatus_594069, base: "",
    url: url_ServicesCheckStatus_594070, schemes: {Scheme.Https})
type
  Call_ProjectsList_594079 = ref object of OpenApiRestCall_593424
proc url_ProjectsList_594081(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "groupName" in path, "`groupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "groupName"), (kind: ConstantSegment,
        value: "/providers/Microsoft.DataMigration/services/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/projects")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProjectsList_594080(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## The project resource is a nested resource representing a stored migration project. This method returns a list of projects owned by a service resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Identifier of the subscription
  ##   groupName: JString (required)
  ##            : Name of the resource group
  ##   serviceName: JString (required)
  ##              : Name of the service
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_594082 = path.getOrDefault("subscriptionId")
  valid_594082 = validateParameter(valid_594082, JString, required = true,
                                 default = nil)
  if valid_594082 != nil:
    section.add "subscriptionId", valid_594082
  var valid_594083 = path.getOrDefault("groupName")
  valid_594083 = validateParameter(valid_594083, JString, required = true,
                                 default = nil)
  if valid_594083 != nil:
    section.add "groupName", valid_594083
  var valid_594084 = path.getOrDefault("serviceName")
  valid_594084 = validateParameter(valid_594084, JString, required = true,
                                 default = nil)
  if valid_594084 != nil:
    section.add "serviceName", valid_594084
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594085 = query.getOrDefault("api-version")
  valid_594085 = validateParameter(valid_594085, JString, required = true,
                                 default = nil)
  if valid_594085 != nil:
    section.add "api-version", valid_594085
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594086: Call_ProjectsList_594079; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The project resource is a nested resource representing a stored migration project. This method returns a list of projects owned by a service resource.
  ## 
  let valid = call_594086.validator(path, query, header, formData, body)
  let scheme = call_594086.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594086.url(scheme.get, call_594086.host, call_594086.base,
                         call_594086.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594086, url, valid)

proc call*(call_594087: Call_ProjectsList_594079; apiVersion: string;
          subscriptionId: string; groupName: string; serviceName: string): Recallable =
  ## projectsList
  ## The project resource is a nested resource representing a stored migration project. This method returns a list of projects owned by a service resource.
  ##   apiVersion: string (required)
  ##             : Version of the API
  ##   subscriptionId: string (required)
  ##                 : Identifier of the subscription
  ##   groupName: string (required)
  ##            : Name of the resource group
  ##   serviceName: string (required)
  ##              : Name of the service
  var path_594088 = newJObject()
  var query_594089 = newJObject()
  add(query_594089, "api-version", newJString(apiVersion))
  add(path_594088, "subscriptionId", newJString(subscriptionId))
  add(path_594088, "groupName", newJString(groupName))
  add(path_594088, "serviceName", newJString(serviceName))
  result = call_594087.call(path_594088, query_594089, nil, nil, nil)

var projectsList* = Call_ProjectsList_594079(name: "projectsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{groupName}/providers/Microsoft.DataMigration/services/{serviceName}/projects",
    validator: validate_ProjectsList_594080, base: "", url: url_ProjectsList_594081,
    schemes: {Scheme.Https})
type
  Call_ProjectsCreateOrUpdate_594102 = ref object of OpenApiRestCall_593424
proc url_ProjectsCreateOrUpdate_594104(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "groupName" in path, "`groupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "projectName" in path, "`projectName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "groupName"), (kind: ConstantSegment,
        value: "/providers/Microsoft.DataMigration/services/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "projectName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProjectsCreateOrUpdate_594103(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The project resource is a nested resource representing a stored migration project. The PUT method creates a new project or updates an existing one.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Identifier of the subscription
  ##   groupName: JString (required)
  ##            : Name of the resource group
  ##   projectName: JString (required)
  ##              : Name of the project
  ##   serviceName: JString (required)
  ##              : Name of the service
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_594105 = path.getOrDefault("subscriptionId")
  valid_594105 = validateParameter(valid_594105, JString, required = true,
                                 default = nil)
  if valid_594105 != nil:
    section.add "subscriptionId", valid_594105
  var valid_594106 = path.getOrDefault("groupName")
  valid_594106 = validateParameter(valid_594106, JString, required = true,
                                 default = nil)
  if valid_594106 != nil:
    section.add "groupName", valid_594106
  var valid_594107 = path.getOrDefault("projectName")
  valid_594107 = validateParameter(valid_594107, JString, required = true,
                                 default = nil)
  if valid_594107 != nil:
    section.add "projectName", valid_594107
  var valid_594108 = path.getOrDefault("serviceName")
  valid_594108 = validateParameter(valid_594108, JString, required = true,
                                 default = nil)
  if valid_594108 != nil:
    section.add "serviceName", valid_594108
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594109 = query.getOrDefault("api-version")
  valid_594109 = validateParameter(valid_594109, JString, required = true,
                                 default = nil)
  if valid_594109 != nil:
    section.add "api-version", valid_594109
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Information about the project
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594111: Call_ProjectsCreateOrUpdate_594102; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The project resource is a nested resource representing a stored migration project. The PUT method creates a new project or updates an existing one.
  ## 
  let valid = call_594111.validator(path, query, header, formData, body)
  let scheme = call_594111.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594111.url(scheme.get, call_594111.host, call_594111.base,
                         call_594111.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594111, url, valid)

proc call*(call_594112: Call_ProjectsCreateOrUpdate_594102; apiVersion: string;
          subscriptionId: string; groupName: string; projectName: string;
          parameters: JsonNode; serviceName: string): Recallable =
  ## projectsCreateOrUpdate
  ## The project resource is a nested resource representing a stored migration project. The PUT method creates a new project or updates an existing one.
  ##   apiVersion: string (required)
  ##             : Version of the API
  ##   subscriptionId: string (required)
  ##                 : Identifier of the subscription
  ##   groupName: string (required)
  ##            : Name of the resource group
  ##   projectName: string (required)
  ##              : Name of the project
  ##   parameters: JObject (required)
  ##             : Information about the project
  ##   serviceName: string (required)
  ##              : Name of the service
  var path_594113 = newJObject()
  var query_594114 = newJObject()
  var body_594115 = newJObject()
  add(query_594114, "api-version", newJString(apiVersion))
  add(path_594113, "subscriptionId", newJString(subscriptionId))
  add(path_594113, "groupName", newJString(groupName))
  add(path_594113, "projectName", newJString(projectName))
  if parameters != nil:
    body_594115 = parameters
  add(path_594113, "serviceName", newJString(serviceName))
  result = call_594112.call(path_594113, query_594114, nil, nil, body_594115)

var projectsCreateOrUpdate* = Call_ProjectsCreateOrUpdate_594102(
    name: "projectsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{groupName}/providers/Microsoft.DataMigration/services/{serviceName}/projects/{projectName}",
    validator: validate_ProjectsCreateOrUpdate_594103, base: "",
    url: url_ProjectsCreateOrUpdate_594104, schemes: {Scheme.Https})
type
  Call_ProjectsGet_594090 = ref object of OpenApiRestCall_593424
proc url_ProjectsGet_594092(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "groupName" in path, "`groupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "projectName" in path, "`projectName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "groupName"), (kind: ConstantSegment,
        value: "/providers/Microsoft.DataMigration/services/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "projectName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProjectsGet_594091(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## The project resource is a nested resource representing a stored migration project. The GET method retrieves information about a project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Identifier of the subscription
  ##   groupName: JString (required)
  ##            : Name of the resource group
  ##   projectName: JString (required)
  ##              : Name of the project
  ##   serviceName: JString (required)
  ##              : Name of the service
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_594093 = path.getOrDefault("subscriptionId")
  valid_594093 = validateParameter(valid_594093, JString, required = true,
                                 default = nil)
  if valid_594093 != nil:
    section.add "subscriptionId", valid_594093
  var valid_594094 = path.getOrDefault("groupName")
  valid_594094 = validateParameter(valid_594094, JString, required = true,
                                 default = nil)
  if valid_594094 != nil:
    section.add "groupName", valid_594094
  var valid_594095 = path.getOrDefault("projectName")
  valid_594095 = validateParameter(valid_594095, JString, required = true,
                                 default = nil)
  if valid_594095 != nil:
    section.add "projectName", valid_594095
  var valid_594096 = path.getOrDefault("serviceName")
  valid_594096 = validateParameter(valid_594096, JString, required = true,
                                 default = nil)
  if valid_594096 != nil:
    section.add "serviceName", valid_594096
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594097 = query.getOrDefault("api-version")
  valid_594097 = validateParameter(valid_594097, JString, required = true,
                                 default = nil)
  if valid_594097 != nil:
    section.add "api-version", valid_594097
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594098: Call_ProjectsGet_594090; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The project resource is a nested resource representing a stored migration project. The GET method retrieves information about a project.
  ## 
  let valid = call_594098.validator(path, query, header, formData, body)
  let scheme = call_594098.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594098.url(scheme.get, call_594098.host, call_594098.base,
                         call_594098.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594098, url, valid)

proc call*(call_594099: Call_ProjectsGet_594090; apiVersion: string;
          subscriptionId: string; groupName: string; projectName: string;
          serviceName: string): Recallable =
  ## projectsGet
  ## The project resource is a nested resource representing a stored migration project. The GET method retrieves information about a project.
  ##   apiVersion: string (required)
  ##             : Version of the API
  ##   subscriptionId: string (required)
  ##                 : Identifier of the subscription
  ##   groupName: string (required)
  ##            : Name of the resource group
  ##   projectName: string (required)
  ##              : Name of the project
  ##   serviceName: string (required)
  ##              : Name of the service
  var path_594100 = newJObject()
  var query_594101 = newJObject()
  add(query_594101, "api-version", newJString(apiVersion))
  add(path_594100, "subscriptionId", newJString(subscriptionId))
  add(path_594100, "groupName", newJString(groupName))
  add(path_594100, "projectName", newJString(projectName))
  add(path_594100, "serviceName", newJString(serviceName))
  result = call_594099.call(path_594100, query_594101, nil, nil, nil)

var projectsGet* = Call_ProjectsGet_594090(name: "projectsGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{groupName}/providers/Microsoft.DataMigration/services/{serviceName}/projects/{projectName}",
                                        validator: validate_ProjectsGet_594091,
                                        base: "", url: url_ProjectsGet_594092,
                                        schemes: {Scheme.Https})
type
  Call_ProjectsUpdate_594129 = ref object of OpenApiRestCall_593424
proc url_ProjectsUpdate_594131(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "groupName" in path, "`groupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "projectName" in path, "`projectName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "groupName"), (kind: ConstantSegment,
        value: "/providers/Microsoft.DataMigration/services/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "projectName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProjectsUpdate_594130(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## The project resource is a nested resource representing a stored migration project. The PATCH method updates an existing project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Identifier of the subscription
  ##   groupName: JString (required)
  ##            : Name of the resource group
  ##   projectName: JString (required)
  ##              : Name of the project
  ##   serviceName: JString (required)
  ##              : Name of the service
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_594132 = path.getOrDefault("subscriptionId")
  valid_594132 = validateParameter(valid_594132, JString, required = true,
                                 default = nil)
  if valid_594132 != nil:
    section.add "subscriptionId", valid_594132
  var valid_594133 = path.getOrDefault("groupName")
  valid_594133 = validateParameter(valid_594133, JString, required = true,
                                 default = nil)
  if valid_594133 != nil:
    section.add "groupName", valid_594133
  var valid_594134 = path.getOrDefault("projectName")
  valid_594134 = validateParameter(valid_594134, JString, required = true,
                                 default = nil)
  if valid_594134 != nil:
    section.add "projectName", valid_594134
  var valid_594135 = path.getOrDefault("serviceName")
  valid_594135 = validateParameter(valid_594135, JString, required = true,
                                 default = nil)
  if valid_594135 != nil:
    section.add "serviceName", valid_594135
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594136 = query.getOrDefault("api-version")
  valid_594136 = validateParameter(valid_594136, JString, required = true,
                                 default = nil)
  if valid_594136 != nil:
    section.add "api-version", valid_594136
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Information about the project
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594138: Call_ProjectsUpdate_594129; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The project resource is a nested resource representing a stored migration project. The PATCH method updates an existing project.
  ## 
  let valid = call_594138.validator(path, query, header, formData, body)
  let scheme = call_594138.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594138.url(scheme.get, call_594138.host, call_594138.base,
                         call_594138.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594138, url, valid)

proc call*(call_594139: Call_ProjectsUpdate_594129; apiVersion: string;
          subscriptionId: string; groupName: string; projectName: string;
          parameters: JsonNode; serviceName: string): Recallable =
  ## projectsUpdate
  ## The project resource is a nested resource representing a stored migration project. The PATCH method updates an existing project.
  ##   apiVersion: string (required)
  ##             : Version of the API
  ##   subscriptionId: string (required)
  ##                 : Identifier of the subscription
  ##   groupName: string (required)
  ##            : Name of the resource group
  ##   projectName: string (required)
  ##              : Name of the project
  ##   parameters: JObject (required)
  ##             : Information about the project
  ##   serviceName: string (required)
  ##              : Name of the service
  var path_594140 = newJObject()
  var query_594141 = newJObject()
  var body_594142 = newJObject()
  add(query_594141, "api-version", newJString(apiVersion))
  add(path_594140, "subscriptionId", newJString(subscriptionId))
  add(path_594140, "groupName", newJString(groupName))
  add(path_594140, "projectName", newJString(projectName))
  if parameters != nil:
    body_594142 = parameters
  add(path_594140, "serviceName", newJString(serviceName))
  result = call_594139.call(path_594140, query_594141, nil, nil, body_594142)

var projectsUpdate* = Call_ProjectsUpdate_594129(name: "projectsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{groupName}/providers/Microsoft.DataMigration/services/{serviceName}/projects/{projectName}",
    validator: validate_ProjectsUpdate_594130, base: "", url: url_ProjectsUpdate_594131,
    schemes: {Scheme.Https})
type
  Call_ProjectsDelete_594116 = ref object of OpenApiRestCall_593424
proc url_ProjectsDelete_594118(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "groupName" in path, "`groupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "projectName" in path, "`projectName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "groupName"), (kind: ConstantSegment,
        value: "/providers/Microsoft.DataMigration/services/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "projectName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProjectsDelete_594117(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## The project resource is a nested resource representing a stored migration project. The DELETE method deletes a project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Identifier of the subscription
  ##   groupName: JString (required)
  ##            : Name of the resource group
  ##   projectName: JString (required)
  ##              : Name of the project
  ##   serviceName: JString (required)
  ##              : Name of the service
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_594119 = path.getOrDefault("subscriptionId")
  valid_594119 = validateParameter(valid_594119, JString, required = true,
                                 default = nil)
  if valid_594119 != nil:
    section.add "subscriptionId", valid_594119
  var valid_594120 = path.getOrDefault("groupName")
  valid_594120 = validateParameter(valid_594120, JString, required = true,
                                 default = nil)
  if valid_594120 != nil:
    section.add "groupName", valid_594120
  var valid_594121 = path.getOrDefault("projectName")
  valid_594121 = validateParameter(valid_594121, JString, required = true,
                                 default = nil)
  if valid_594121 != nil:
    section.add "projectName", valid_594121
  var valid_594122 = path.getOrDefault("serviceName")
  valid_594122 = validateParameter(valid_594122, JString, required = true,
                                 default = nil)
  if valid_594122 != nil:
    section.add "serviceName", valid_594122
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API
  ##   deleteRunningTasks: JBool
  ##                     : Delete the resource even if it contains running tasks
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594123 = query.getOrDefault("api-version")
  valid_594123 = validateParameter(valid_594123, JString, required = true,
                                 default = nil)
  if valid_594123 != nil:
    section.add "api-version", valid_594123
  var valid_594124 = query.getOrDefault("deleteRunningTasks")
  valid_594124 = validateParameter(valid_594124, JBool, required = false, default = nil)
  if valid_594124 != nil:
    section.add "deleteRunningTasks", valid_594124
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594125: Call_ProjectsDelete_594116; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The project resource is a nested resource representing a stored migration project. The DELETE method deletes a project.
  ## 
  let valid = call_594125.validator(path, query, header, formData, body)
  let scheme = call_594125.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594125.url(scheme.get, call_594125.host, call_594125.base,
                         call_594125.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594125, url, valid)

proc call*(call_594126: Call_ProjectsDelete_594116; apiVersion: string;
          subscriptionId: string; groupName: string; projectName: string;
          serviceName: string; deleteRunningTasks: bool = false): Recallable =
  ## projectsDelete
  ## The project resource is a nested resource representing a stored migration project. The DELETE method deletes a project.
  ##   apiVersion: string (required)
  ##             : Version of the API
  ##   subscriptionId: string (required)
  ##                 : Identifier of the subscription
  ##   groupName: string (required)
  ##            : Name of the resource group
  ##   deleteRunningTasks: bool
  ##                     : Delete the resource even if it contains running tasks
  ##   projectName: string (required)
  ##              : Name of the project
  ##   serviceName: string (required)
  ##              : Name of the service
  var path_594127 = newJObject()
  var query_594128 = newJObject()
  add(query_594128, "api-version", newJString(apiVersion))
  add(path_594127, "subscriptionId", newJString(subscriptionId))
  add(path_594127, "groupName", newJString(groupName))
  add(query_594128, "deleteRunningTasks", newJBool(deleteRunningTasks))
  add(path_594127, "projectName", newJString(projectName))
  add(path_594127, "serviceName", newJString(serviceName))
  result = call_594126.call(path_594127, query_594128, nil, nil, nil)

var projectsDelete* = Call_ProjectsDelete_594116(name: "projectsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{groupName}/providers/Microsoft.DataMigration/services/{serviceName}/projects/{projectName}",
    validator: validate_ProjectsDelete_594117, base: "", url: url_ProjectsDelete_594118,
    schemes: {Scheme.Https})
type
  Call_TasksList_594143 = ref object of OpenApiRestCall_593424
proc url_TasksList_594145(protocol: Scheme; host: string; base: string; route: string;
                         path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "groupName" in path, "`groupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "projectName" in path, "`projectName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "groupName"), (kind: ConstantSegment,
        value: "/providers/Microsoft.DataMigration/services/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "projectName"),
               (kind: ConstantSegment, value: "/tasks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TasksList_594144(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## The services resource is the top-level resource that represents the Data Migration Service. This method returns a list of tasks owned by a service resource. Some tasks may have a status of Unknown, which indicates that an error occurred while querying the status of that task.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Identifier of the subscription
  ##   groupName: JString (required)
  ##            : Name of the resource group
  ##   projectName: JString (required)
  ##              : Name of the project
  ##   serviceName: JString (required)
  ##              : Name of the service
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_594146 = path.getOrDefault("subscriptionId")
  valid_594146 = validateParameter(valid_594146, JString, required = true,
                                 default = nil)
  if valid_594146 != nil:
    section.add "subscriptionId", valid_594146
  var valid_594147 = path.getOrDefault("groupName")
  valid_594147 = validateParameter(valid_594147, JString, required = true,
                                 default = nil)
  if valid_594147 != nil:
    section.add "groupName", valid_594147
  var valid_594148 = path.getOrDefault("projectName")
  valid_594148 = validateParameter(valid_594148, JString, required = true,
                                 default = nil)
  if valid_594148 != nil:
    section.add "projectName", valid_594148
  var valid_594149 = path.getOrDefault("serviceName")
  valid_594149 = validateParameter(valid_594149, JString, required = true,
                                 default = nil)
  if valid_594149 != nil:
    section.add "serviceName", valid_594149
  result.add "path", section
  ## parameters in `query` object:
  ##   taskType: JString
  ##           : Filter tasks by task type
  ##   api-version: JString (required)
  ##              : Version of the API
  section = newJObject()
  var valid_594150 = query.getOrDefault("taskType")
  valid_594150 = validateParameter(valid_594150, JString, required = false,
                                 default = nil)
  if valid_594150 != nil:
    section.add "taskType", valid_594150
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
  if body != nil:
    result.add "body", body

proc call*(call_594152: Call_TasksList_594143; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The services resource is the top-level resource that represents the Data Migration Service. This method returns a list of tasks owned by a service resource. Some tasks may have a status of Unknown, which indicates that an error occurred while querying the status of that task.
  ## 
  let valid = call_594152.validator(path, query, header, formData, body)
  let scheme = call_594152.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594152.url(scheme.get, call_594152.host, call_594152.base,
                         call_594152.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594152, url, valid)

proc call*(call_594153: Call_TasksList_594143; apiVersion: string;
          subscriptionId: string; groupName: string; projectName: string;
          serviceName: string; taskType: string = ""): Recallable =
  ## tasksList
  ## The services resource is the top-level resource that represents the Data Migration Service. This method returns a list of tasks owned by a service resource. Some tasks may have a status of Unknown, which indicates that an error occurred while querying the status of that task.
  ##   taskType: string
  ##           : Filter tasks by task type
  ##   apiVersion: string (required)
  ##             : Version of the API
  ##   subscriptionId: string (required)
  ##                 : Identifier of the subscription
  ##   groupName: string (required)
  ##            : Name of the resource group
  ##   projectName: string (required)
  ##              : Name of the project
  ##   serviceName: string (required)
  ##              : Name of the service
  var path_594154 = newJObject()
  var query_594155 = newJObject()
  add(query_594155, "taskType", newJString(taskType))
  add(query_594155, "api-version", newJString(apiVersion))
  add(path_594154, "subscriptionId", newJString(subscriptionId))
  add(path_594154, "groupName", newJString(groupName))
  add(path_594154, "projectName", newJString(projectName))
  add(path_594154, "serviceName", newJString(serviceName))
  result = call_594153.call(path_594154, query_594155, nil, nil, nil)

var tasksList* = Call_TasksList_594143(name: "tasksList", meth: HttpMethod.HttpGet,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{groupName}/providers/Microsoft.DataMigration/services/{serviceName}/projects/{projectName}/tasks",
                                    validator: validate_TasksList_594144,
                                    base: "", url: url_TasksList_594145,
                                    schemes: {Scheme.Https})
type
  Call_TasksCreateOrUpdate_594171 = ref object of OpenApiRestCall_593424
proc url_TasksCreateOrUpdate_594173(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "groupName" in path, "`groupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "projectName" in path, "`projectName` is a required path parameter"
  assert "taskName" in path, "`taskName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "groupName"), (kind: ConstantSegment,
        value: "/providers/Microsoft.DataMigration/services/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "projectName"),
               (kind: ConstantSegment, value: "/tasks/"),
               (kind: VariableSegment, value: "taskName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TasksCreateOrUpdate_594172(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## The tasks resource is a nested, proxy-only resource representing work performed by a DMS instance. The PUT method creates a new task or updates an existing one, although since tasks have no mutable custom properties, there is little reason to update an exising one.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Identifier of the subscription
  ##   groupName: JString (required)
  ##            : Name of the resource group
  ##   taskName: JString (required)
  ##           : Name of the Task
  ##   projectName: JString (required)
  ##              : Name of the project
  ##   serviceName: JString (required)
  ##              : Name of the service
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_594174 = path.getOrDefault("subscriptionId")
  valid_594174 = validateParameter(valid_594174, JString, required = true,
                                 default = nil)
  if valid_594174 != nil:
    section.add "subscriptionId", valid_594174
  var valid_594175 = path.getOrDefault("groupName")
  valid_594175 = validateParameter(valid_594175, JString, required = true,
                                 default = nil)
  if valid_594175 != nil:
    section.add "groupName", valid_594175
  var valid_594176 = path.getOrDefault("taskName")
  valid_594176 = validateParameter(valid_594176, JString, required = true,
                                 default = nil)
  if valid_594176 != nil:
    section.add "taskName", valid_594176
  var valid_594177 = path.getOrDefault("projectName")
  valid_594177 = validateParameter(valid_594177, JString, required = true,
                                 default = nil)
  if valid_594177 != nil:
    section.add "projectName", valid_594177
  var valid_594178 = path.getOrDefault("serviceName")
  valid_594178 = validateParameter(valid_594178, JString, required = true,
                                 default = nil)
  if valid_594178 != nil:
    section.add "serviceName", valid_594178
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594179 = query.getOrDefault("api-version")
  valid_594179 = validateParameter(valid_594179, JString, required = true,
                                 default = nil)
  if valid_594179 != nil:
    section.add "api-version", valid_594179
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Information about the task
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594181: Call_TasksCreateOrUpdate_594171; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The tasks resource is a nested, proxy-only resource representing work performed by a DMS instance. The PUT method creates a new task or updates an existing one, although since tasks have no mutable custom properties, there is little reason to update an exising one.
  ## 
  let valid = call_594181.validator(path, query, header, formData, body)
  let scheme = call_594181.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594181.url(scheme.get, call_594181.host, call_594181.base,
                         call_594181.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594181, url, valid)

proc call*(call_594182: Call_TasksCreateOrUpdate_594171; apiVersion: string;
          subscriptionId: string; groupName: string; taskName: string;
          projectName: string; parameters: JsonNode; serviceName: string): Recallable =
  ## tasksCreateOrUpdate
  ## The tasks resource is a nested, proxy-only resource representing work performed by a DMS instance. The PUT method creates a new task or updates an existing one, although since tasks have no mutable custom properties, there is little reason to update an exising one.
  ##   apiVersion: string (required)
  ##             : Version of the API
  ##   subscriptionId: string (required)
  ##                 : Identifier of the subscription
  ##   groupName: string (required)
  ##            : Name of the resource group
  ##   taskName: string (required)
  ##           : Name of the Task
  ##   projectName: string (required)
  ##              : Name of the project
  ##   parameters: JObject (required)
  ##             : Information about the task
  ##   serviceName: string (required)
  ##              : Name of the service
  var path_594183 = newJObject()
  var query_594184 = newJObject()
  var body_594185 = newJObject()
  add(query_594184, "api-version", newJString(apiVersion))
  add(path_594183, "subscriptionId", newJString(subscriptionId))
  add(path_594183, "groupName", newJString(groupName))
  add(path_594183, "taskName", newJString(taskName))
  add(path_594183, "projectName", newJString(projectName))
  if parameters != nil:
    body_594185 = parameters
  add(path_594183, "serviceName", newJString(serviceName))
  result = call_594182.call(path_594183, query_594184, nil, nil, body_594185)

var tasksCreateOrUpdate* = Call_TasksCreateOrUpdate_594171(
    name: "tasksCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{groupName}/providers/Microsoft.DataMigration/services/{serviceName}/projects/{projectName}/tasks/{taskName}",
    validator: validate_TasksCreateOrUpdate_594172, base: "",
    url: url_TasksCreateOrUpdate_594173, schemes: {Scheme.Https})
type
  Call_TasksGet_594156 = ref object of OpenApiRestCall_593424
proc url_TasksGet_594158(protocol: Scheme; host: string; base: string; route: string;
                        path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "groupName" in path, "`groupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "projectName" in path, "`projectName` is a required path parameter"
  assert "taskName" in path, "`taskName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "groupName"), (kind: ConstantSegment,
        value: "/providers/Microsoft.DataMigration/services/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "projectName"),
               (kind: ConstantSegment, value: "/tasks/"),
               (kind: VariableSegment, value: "taskName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TasksGet_594157(path: JsonNode; query: JsonNode; header: JsonNode;
                             formData: JsonNode; body: JsonNode): JsonNode =
  ## The tasks resource is a nested, proxy-only resource representing work performed by a DMS instance. The GET method retrieves information about a task.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Identifier of the subscription
  ##   groupName: JString (required)
  ##            : Name of the resource group
  ##   taskName: JString (required)
  ##           : Name of the Task
  ##   projectName: JString (required)
  ##              : Name of the project
  ##   serviceName: JString (required)
  ##              : Name of the service
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_594160 = path.getOrDefault("subscriptionId")
  valid_594160 = validateParameter(valid_594160, JString, required = true,
                                 default = nil)
  if valid_594160 != nil:
    section.add "subscriptionId", valid_594160
  var valid_594161 = path.getOrDefault("groupName")
  valid_594161 = validateParameter(valid_594161, JString, required = true,
                                 default = nil)
  if valid_594161 != nil:
    section.add "groupName", valid_594161
  var valid_594162 = path.getOrDefault("taskName")
  valid_594162 = validateParameter(valid_594162, JString, required = true,
                                 default = nil)
  if valid_594162 != nil:
    section.add "taskName", valid_594162
  var valid_594163 = path.getOrDefault("projectName")
  valid_594163 = validateParameter(valid_594163, JString, required = true,
                                 default = nil)
  if valid_594163 != nil:
    section.add "projectName", valid_594163
  var valid_594164 = path.getOrDefault("serviceName")
  valid_594164 = validateParameter(valid_594164, JString, required = true,
                                 default = nil)
  if valid_594164 != nil:
    section.add "serviceName", valid_594164
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API
  ##   $expand: JString
  ##          : Expand the response
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594165 = query.getOrDefault("api-version")
  valid_594165 = validateParameter(valid_594165, JString, required = true,
                                 default = nil)
  if valid_594165 != nil:
    section.add "api-version", valid_594165
  var valid_594166 = query.getOrDefault("$expand")
  valid_594166 = validateParameter(valid_594166, JString, required = false,
                                 default = nil)
  if valid_594166 != nil:
    section.add "$expand", valid_594166
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594167: Call_TasksGet_594156; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The tasks resource is a nested, proxy-only resource representing work performed by a DMS instance. The GET method retrieves information about a task.
  ## 
  let valid = call_594167.validator(path, query, header, formData, body)
  let scheme = call_594167.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594167.url(scheme.get, call_594167.host, call_594167.base,
                         call_594167.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594167, url, valid)

proc call*(call_594168: Call_TasksGet_594156; apiVersion: string;
          subscriptionId: string; groupName: string; taskName: string;
          projectName: string; serviceName: string; Expand: string = ""): Recallable =
  ## tasksGet
  ## The tasks resource is a nested, proxy-only resource representing work performed by a DMS instance. The GET method retrieves information about a task.
  ##   apiVersion: string (required)
  ##             : Version of the API
  ##   Expand: string
  ##         : Expand the response
  ##   subscriptionId: string (required)
  ##                 : Identifier of the subscription
  ##   groupName: string (required)
  ##            : Name of the resource group
  ##   taskName: string (required)
  ##           : Name of the Task
  ##   projectName: string (required)
  ##              : Name of the project
  ##   serviceName: string (required)
  ##              : Name of the service
  var path_594169 = newJObject()
  var query_594170 = newJObject()
  add(query_594170, "api-version", newJString(apiVersion))
  add(query_594170, "$expand", newJString(Expand))
  add(path_594169, "subscriptionId", newJString(subscriptionId))
  add(path_594169, "groupName", newJString(groupName))
  add(path_594169, "taskName", newJString(taskName))
  add(path_594169, "projectName", newJString(projectName))
  add(path_594169, "serviceName", newJString(serviceName))
  result = call_594168.call(path_594169, query_594170, nil, nil, nil)

var tasksGet* = Call_TasksGet_594156(name: "tasksGet", meth: HttpMethod.HttpGet,
                                  host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{groupName}/providers/Microsoft.DataMigration/services/{serviceName}/projects/{projectName}/tasks/{taskName}",
                                  validator: validate_TasksGet_594157, base: "",
                                  url: url_TasksGet_594158,
                                  schemes: {Scheme.Https})
type
  Call_TasksUpdate_594200 = ref object of OpenApiRestCall_593424
proc url_TasksUpdate_594202(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "groupName" in path, "`groupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "projectName" in path, "`projectName` is a required path parameter"
  assert "taskName" in path, "`taskName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "groupName"), (kind: ConstantSegment,
        value: "/providers/Microsoft.DataMigration/services/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "projectName"),
               (kind: ConstantSegment, value: "/tasks/"),
               (kind: VariableSegment, value: "taskName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TasksUpdate_594201(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## The tasks resource is a nested, proxy-only resource representing work performed by a DMS instance. The PATCH method updates an existing task, but since tasks have no mutable custom properties, there is little reason to do so.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Identifier of the subscription
  ##   groupName: JString (required)
  ##            : Name of the resource group
  ##   taskName: JString (required)
  ##           : Name of the Task
  ##   projectName: JString (required)
  ##              : Name of the project
  ##   serviceName: JString (required)
  ##              : Name of the service
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_594203 = path.getOrDefault("subscriptionId")
  valid_594203 = validateParameter(valid_594203, JString, required = true,
                                 default = nil)
  if valid_594203 != nil:
    section.add "subscriptionId", valid_594203
  var valid_594204 = path.getOrDefault("groupName")
  valid_594204 = validateParameter(valid_594204, JString, required = true,
                                 default = nil)
  if valid_594204 != nil:
    section.add "groupName", valid_594204
  var valid_594205 = path.getOrDefault("taskName")
  valid_594205 = validateParameter(valid_594205, JString, required = true,
                                 default = nil)
  if valid_594205 != nil:
    section.add "taskName", valid_594205
  var valid_594206 = path.getOrDefault("projectName")
  valid_594206 = validateParameter(valid_594206, JString, required = true,
                                 default = nil)
  if valid_594206 != nil:
    section.add "projectName", valid_594206
  var valid_594207 = path.getOrDefault("serviceName")
  valid_594207 = validateParameter(valid_594207, JString, required = true,
                                 default = nil)
  if valid_594207 != nil:
    section.add "serviceName", valid_594207
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API
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
  ##             : Information about the task
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594210: Call_TasksUpdate_594200; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The tasks resource is a nested, proxy-only resource representing work performed by a DMS instance. The PATCH method updates an existing task, but since tasks have no mutable custom properties, there is little reason to do so.
  ## 
  let valid = call_594210.validator(path, query, header, formData, body)
  let scheme = call_594210.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594210.url(scheme.get, call_594210.host, call_594210.base,
                         call_594210.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594210, url, valid)

proc call*(call_594211: Call_TasksUpdate_594200; apiVersion: string;
          subscriptionId: string; groupName: string; taskName: string;
          projectName: string; parameters: JsonNode; serviceName: string): Recallable =
  ## tasksUpdate
  ## The tasks resource is a nested, proxy-only resource representing work performed by a DMS instance. The PATCH method updates an existing task, but since tasks have no mutable custom properties, there is little reason to do so.
  ##   apiVersion: string (required)
  ##             : Version of the API
  ##   subscriptionId: string (required)
  ##                 : Identifier of the subscription
  ##   groupName: string (required)
  ##            : Name of the resource group
  ##   taskName: string (required)
  ##           : Name of the Task
  ##   projectName: string (required)
  ##              : Name of the project
  ##   parameters: JObject (required)
  ##             : Information about the task
  ##   serviceName: string (required)
  ##              : Name of the service
  var path_594212 = newJObject()
  var query_594213 = newJObject()
  var body_594214 = newJObject()
  add(query_594213, "api-version", newJString(apiVersion))
  add(path_594212, "subscriptionId", newJString(subscriptionId))
  add(path_594212, "groupName", newJString(groupName))
  add(path_594212, "taskName", newJString(taskName))
  add(path_594212, "projectName", newJString(projectName))
  if parameters != nil:
    body_594214 = parameters
  add(path_594212, "serviceName", newJString(serviceName))
  result = call_594211.call(path_594212, query_594213, nil, nil, body_594214)

var tasksUpdate* = Call_TasksUpdate_594200(name: "tasksUpdate",
                                        meth: HttpMethod.HttpPatch,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{groupName}/providers/Microsoft.DataMigration/services/{serviceName}/projects/{projectName}/tasks/{taskName}",
                                        validator: validate_TasksUpdate_594201,
                                        base: "", url: url_TasksUpdate_594202,
                                        schemes: {Scheme.Https})
type
  Call_TasksDelete_594186 = ref object of OpenApiRestCall_593424
proc url_TasksDelete_594188(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "groupName" in path, "`groupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "projectName" in path, "`projectName` is a required path parameter"
  assert "taskName" in path, "`taskName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "groupName"), (kind: ConstantSegment,
        value: "/providers/Microsoft.DataMigration/services/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "projectName"),
               (kind: ConstantSegment, value: "/tasks/"),
               (kind: VariableSegment, value: "taskName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TasksDelete_594187(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## The tasks resource is a nested, proxy-only resource representing work performed by a DMS instance. The DELETE method deletes a task, canceling it first if it's running.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Identifier of the subscription
  ##   groupName: JString (required)
  ##            : Name of the resource group
  ##   taskName: JString (required)
  ##           : Name of the Task
  ##   projectName: JString (required)
  ##              : Name of the project
  ##   serviceName: JString (required)
  ##              : Name of the service
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_594189 = path.getOrDefault("subscriptionId")
  valid_594189 = validateParameter(valid_594189, JString, required = true,
                                 default = nil)
  if valid_594189 != nil:
    section.add "subscriptionId", valid_594189
  var valid_594190 = path.getOrDefault("groupName")
  valid_594190 = validateParameter(valid_594190, JString, required = true,
                                 default = nil)
  if valid_594190 != nil:
    section.add "groupName", valid_594190
  var valid_594191 = path.getOrDefault("taskName")
  valid_594191 = validateParameter(valid_594191, JString, required = true,
                                 default = nil)
  if valid_594191 != nil:
    section.add "taskName", valid_594191
  var valid_594192 = path.getOrDefault("projectName")
  valid_594192 = validateParameter(valid_594192, JString, required = true,
                                 default = nil)
  if valid_594192 != nil:
    section.add "projectName", valid_594192
  var valid_594193 = path.getOrDefault("serviceName")
  valid_594193 = validateParameter(valid_594193, JString, required = true,
                                 default = nil)
  if valid_594193 != nil:
    section.add "serviceName", valid_594193
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API
  ##   deleteRunningTasks: JBool
  ##                     : Delete the resource even if it contains running tasks
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594194 = query.getOrDefault("api-version")
  valid_594194 = validateParameter(valid_594194, JString, required = true,
                                 default = nil)
  if valid_594194 != nil:
    section.add "api-version", valid_594194
  var valid_594195 = query.getOrDefault("deleteRunningTasks")
  valid_594195 = validateParameter(valid_594195, JBool, required = false, default = nil)
  if valid_594195 != nil:
    section.add "deleteRunningTasks", valid_594195
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594196: Call_TasksDelete_594186; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The tasks resource is a nested, proxy-only resource representing work performed by a DMS instance. The DELETE method deletes a task, canceling it first if it's running.
  ## 
  let valid = call_594196.validator(path, query, header, formData, body)
  let scheme = call_594196.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594196.url(scheme.get, call_594196.host, call_594196.base,
                         call_594196.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594196, url, valid)

proc call*(call_594197: Call_TasksDelete_594186; apiVersion: string;
          subscriptionId: string; groupName: string; taskName: string;
          projectName: string; serviceName: string; deleteRunningTasks: bool = false): Recallable =
  ## tasksDelete
  ## The tasks resource is a nested, proxy-only resource representing work performed by a DMS instance. The DELETE method deletes a task, canceling it first if it's running.
  ##   apiVersion: string (required)
  ##             : Version of the API
  ##   subscriptionId: string (required)
  ##                 : Identifier of the subscription
  ##   groupName: string (required)
  ##            : Name of the resource group
  ##   taskName: string (required)
  ##           : Name of the Task
  ##   deleteRunningTasks: bool
  ##                     : Delete the resource even if it contains running tasks
  ##   projectName: string (required)
  ##              : Name of the project
  ##   serviceName: string (required)
  ##              : Name of the service
  var path_594198 = newJObject()
  var query_594199 = newJObject()
  add(query_594199, "api-version", newJString(apiVersion))
  add(path_594198, "subscriptionId", newJString(subscriptionId))
  add(path_594198, "groupName", newJString(groupName))
  add(path_594198, "taskName", newJString(taskName))
  add(query_594199, "deleteRunningTasks", newJBool(deleteRunningTasks))
  add(path_594198, "projectName", newJString(projectName))
  add(path_594198, "serviceName", newJString(serviceName))
  result = call_594197.call(path_594198, query_594199, nil, nil, nil)

var tasksDelete* = Call_TasksDelete_594186(name: "tasksDelete",
                                        meth: HttpMethod.HttpDelete,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{groupName}/providers/Microsoft.DataMigration/services/{serviceName}/projects/{projectName}/tasks/{taskName}",
                                        validator: validate_TasksDelete_594187,
                                        base: "", url: url_TasksDelete_594188,
                                        schemes: {Scheme.Https})
type
  Call_TasksCancel_594215 = ref object of OpenApiRestCall_593424
proc url_TasksCancel_594217(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "groupName" in path, "`groupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "projectName" in path, "`projectName` is a required path parameter"
  assert "taskName" in path, "`taskName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "groupName"), (kind: ConstantSegment,
        value: "/providers/Microsoft.DataMigration/services/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "projectName"),
               (kind: ConstantSegment, value: "/tasks/"),
               (kind: VariableSegment, value: "taskName"),
               (kind: ConstantSegment, value: "/cancel")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TasksCancel_594216(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## The tasks resource is a nested, proxy-only resource representing work performed by a DMS instance. This method cancels a task if it's currently queued or running.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Identifier of the subscription
  ##   groupName: JString (required)
  ##            : Name of the resource group
  ##   taskName: JString (required)
  ##           : Name of the Task
  ##   projectName: JString (required)
  ##              : Name of the project
  ##   serviceName: JString (required)
  ##              : Name of the service
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_594218 = path.getOrDefault("subscriptionId")
  valid_594218 = validateParameter(valid_594218, JString, required = true,
                                 default = nil)
  if valid_594218 != nil:
    section.add "subscriptionId", valid_594218
  var valid_594219 = path.getOrDefault("groupName")
  valid_594219 = validateParameter(valid_594219, JString, required = true,
                                 default = nil)
  if valid_594219 != nil:
    section.add "groupName", valid_594219
  var valid_594220 = path.getOrDefault("taskName")
  valid_594220 = validateParameter(valid_594220, JString, required = true,
                                 default = nil)
  if valid_594220 != nil:
    section.add "taskName", valid_594220
  var valid_594221 = path.getOrDefault("projectName")
  valid_594221 = validateParameter(valid_594221, JString, required = true,
                                 default = nil)
  if valid_594221 != nil:
    section.add "projectName", valid_594221
  var valid_594222 = path.getOrDefault("serviceName")
  valid_594222 = validateParameter(valid_594222, JString, required = true,
                                 default = nil)
  if valid_594222 != nil:
    section.add "serviceName", valid_594222
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API
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

proc call*(call_594224: Call_TasksCancel_594215; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The tasks resource is a nested, proxy-only resource representing work performed by a DMS instance. This method cancels a task if it's currently queued or running.
  ## 
  let valid = call_594224.validator(path, query, header, formData, body)
  let scheme = call_594224.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594224.url(scheme.get, call_594224.host, call_594224.base,
                         call_594224.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594224, url, valid)

proc call*(call_594225: Call_TasksCancel_594215; apiVersion: string;
          subscriptionId: string; groupName: string; taskName: string;
          projectName: string; serviceName: string): Recallable =
  ## tasksCancel
  ## The tasks resource is a nested, proxy-only resource representing work performed by a DMS instance. This method cancels a task if it's currently queued or running.
  ##   apiVersion: string (required)
  ##             : Version of the API
  ##   subscriptionId: string (required)
  ##                 : Identifier of the subscription
  ##   groupName: string (required)
  ##            : Name of the resource group
  ##   taskName: string (required)
  ##           : Name of the Task
  ##   projectName: string (required)
  ##              : Name of the project
  ##   serviceName: string (required)
  ##              : Name of the service
  var path_594226 = newJObject()
  var query_594227 = newJObject()
  add(query_594227, "api-version", newJString(apiVersion))
  add(path_594226, "subscriptionId", newJString(subscriptionId))
  add(path_594226, "groupName", newJString(groupName))
  add(path_594226, "taskName", newJString(taskName))
  add(path_594226, "projectName", newJString(projectName))
  add(path_594226, "serviceName", newJString(serviceName))
  result = call_594225.call(path_594226, query_594227, nil, nil, nil)

var tasksCancel* = Call_TasksCancel_594215(name: "tasksCancel",
                                        meth: HttpMethod.HttpPost,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{groupName}/providers/Microsoft.DataMigration/services/{serviceName}/projects/{projectName}/tasks/{taskName}/cancel",
                                        validator: validate_TasksCancel_594216,
                                        base: "", url: url_TasksCancel_594217,
                                        schemes: {Scheme.Https})
type
  Call_ServicesListSkus_594228 = ref object of OpenApiRestCall_593424
proc url_ServicesListSkus_594230(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "groupName" in path, "`groupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "groupName"), (kind: ConstantSegment,
        value: "/providers/Microsoft.DataMigration/services/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/skus")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicesListSkus_594229(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## The services resource is the top-level resource that represents the Data Migration Service. The skus action returns the list of SKUs that a service resource can be updated to.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Identifier of the subscription
  ##   groupName: JString (required)
  ##            : Name of the resource group
  ##   serviceName: JString (required)
  ##              : Name of the service
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_594231 = path.getOrDefault("subscriptionId")
  valid_594231 = validateParameter(valid_594231, JString, required = true,
                                 default = nil)
  if valid_594231 != nil:
    section.add "subscriptionId", valid_594231
  var valid_594232 = path.getOrDefault("groupName")
  valid_594232 = validateParameter(valid_594232, JString, required = true,
                                 default = nil)
  if valid_594232 != nil:
    section.add "groupName", valid_594232
  var valid_594233 = path.getOrDefault("serviceName")
  valid_594233 = validateParameter(valid_594233, JString, required = true,
                                 default = nil)
  if valid_594233 != nil:
    section.add "serviceName", valid_594233
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594234 = query.getOrDefault("api-version")
  valid_594234 = validateParameter(valid_594234, JString, required = true,
                                 default = nil)
  if valid_594234 != nil:
    section.add "api-version", valid_594234
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594235: Call_ServicesListSkus_594228; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The services resource is the top-level resource that represents the Data Migration Service. The skus action returns the list of SKUs that a service resource can be updated to.
  ## 
  let valid = call_594235.validator(path, query, header, formData, body)
  let scheme = call_594235.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594235.url(scheme.get, call_594235.host, call_594235.base,
                         call_594235.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594235, url, valid)

proc call*(call_594236: Call_ServicesListSkus_594228; apiVersion: string;
          subscriptionId: string; groupName: string; serviceName: string): Recallable =
  ## servicesListSkus
  ## The services resource is the top-level resource that represents the Data Migration Service. The skus action returns the list of SKUs that a service resource can be updated to.
  ##   apiVersion: string (required)
  ##             : Version of the API
  ##   subscriptionId: string (required)
  ##                 : Identifier of the subscription
  ##   groupName: string (required)
  ##            : Name of the resource group
  ##   serviceName: string (required)
  ##              : Name of the service
  var path_594237 = newJObject()
  var query_594238 = newJObject()
  add(query_594238, "api-version", newJString(apiVersion))
  add(path_594237, "subscriptionId", newJString(subscriptionId))
  add(path_594237, "groupName", newJString(groupName))
  add(path_594237, "serviceName", newJString(serviceName))
  result = call_594236.call(path_594237, query_594238, nil, nil, nil)

var servicesListSkus* = Call_ServicesListSkus_594228(name: "servicesListSkus",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{groupName}/providers/Microsoft.DataMigration/services/{serviceName}/skus",
    validator: validate_ServicesListSkus_594229, base: "",
    url: url_ServicesListSkus_594230, schemes: {Scheme.Https})
type
  Call_ServicesStart_594239 = ref object of OpenApiRestCall_593424
proc url_ServicesStart_594241(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "groupName" in path, "`groupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "groupName"), (kind: ConstantSegment,
        value: "/providers/Microsoft.DataMigration/services/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/start")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicesStart_594240(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## The services resource is the top-level resource that represents the Data Migration Service. This action starts the service and the service can be used for data migration.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Identifier of the subscription
  ##   groupName: JString (required)
  ##            : Name of the resource group
  ##   serviceName: JString (required)
  ##              : Name of the service
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_594242 = path.getOrDefault("subscriptionId")
  valid_594242 = validateParameter(valid_594242, JString, required = true,
                                 default = nil)
  if valid_594242 != nil:
    section.add "subscriptionId", valid_594242
  var valid_594243 = path.getOrDefault("groupName")
  valid_594243 = validateParameter(valid_594243, JString, required = true,
                                 default = nil)
  if valid_594243 != nil:
    section.add "groupName", valid_594243
  var valid_594244 = path.getOrDefault("serviceName")
  valid_594244 = validateParameter(valid_594244, JString, required = true,
                                 default = nil)
  if valid_594244 != nil:
    section.add "serviceName", valid_594244
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594245 = query.getOrDefault("api-version")
  valid_594245 = validateParameter(valid_594245, JString, required = true,
                                 default = nil)
  if valid_594245 != nil:
    section.add "api-version", valid_594245
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594246: Call_ServicesStart_594239; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The services resource is the top-level resource that represents the Data Migration Service. This action starts the service and the service can be used for data migration.
  ## 
  let valid = call_594246.validator(path, query, header, formData, body)
  let scheme = call_594246.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594246.url(scheme.get, call_594246.host, call_594246.base,
                         call_594246.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594246, url, valid)

proc call*(call_594247: Call_ServicesStart_594239; apiVersion: string;
          subscriptionId: string; groupName: string; serviceName: string): Recallable =
  ## servicesStart
  ## The services resource is the top-level resource that represents the Data Migration Service. This action starts the service and the service can be used for data migration.
  ##   apiVersion: string (required)
  ##             : Version of the API
  ##   subscriptionId: string (required)
  ##                 : Identifier of the subscription
  ##   groupName: string (required)
  ##            : Name of the resource group
  ##   serviceName: string (required)
  ##              : Name of the service
  var path_594248 = newJObject()
  var query_594249 = newJObject()
  add(query_594249, "api-version", newJString(apiVersion))
  add(path_594248, "subscriptionId", newJString(subscriptionId))
  add(path_594248, "groupName", newJString(groupName))
  add(path_594248, "serviceName", newJString(serviceName))
  result = call_594247.call(path_594248, query_594249, nil, nil, nil)

var servicesStart* = Call_ServicesStart_594239(name: "servicesStart",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{groupName}/providers/Microsoft.DataMigration/services/{serviceName}/start",
    validator: validate_ServicesStart_594240, base: "", url: url_ServicesStart_594241,
    schemes: {Scheme.Https})
type
  Call_ServicesStop_594250 = ref object of OpenApiRestCall_593424
proc url_ServicesStop_594252(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "groupName" in path, "`groupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "groupName"), (kind: ConstantSegment,
        value: "/providers/Microsoft.DataMigration/services/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/stop")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicesStop_594251(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## The services resource is the top-level resource that represents the Data Migration Service. This action stops the service and the service cannot be used for data migration. The service owner won't be billed when the service is stopped.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Identifier of the subscription
  ##   groupName: JString (required)
  ##            : Name of the resource group
  ##   serviceName: JString (required)
  ##              : Name of the service
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_594253 = path.getOrDefault("subscriptionId")
  valid_594253 = validateParameter(valid_594253, JString, required = true,
                                 default = nil)
  if valid_594253 != nil:
    section.add "subscriptionId", valid_594253
  var valid_594254 = path.getOrDefault("groupName")
  valid_594254 = validateParameter(valid_594254, JString, required = true,
                                 default = nil)
  if valid_594254 != nil:
    section.add "groupName", valid_594254
  var valid_594255 = path.getOrDefault("serviceName")
  valid_594255 = validateParameter(valid_594255, JString, required = true,
                                 default = nil)
  if valid_594255 != nil:
    section.add "serviceName", valid_594255
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API
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

proc call*(call_594257: Call_ServicesStop_594250; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The services resource is the top-level resource that represents the Data Migration Service. This action stops the service and the service cannot be used for data migration. The service owner won't be billed when the service is stopped.
  ## 
  let valid = call_594257.validator(path, query, header, formData, body)
  let scheme = call_594257.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594257.url(scheme.get, call_594257.host, call_594257.base,
                         call_594257.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594257, url, valid)

proc call*(call_594258: Call_ServicesStop_594250; apiVersion: string;
          subscriptionId: string; groupName: string; serviceName: string): Recallable =
  ## servicesStop
  ## The services resource is the top-level resource that represents the Data Migration Service. This action stops the service and the service cannot be used for data migration. The service owner won't be billed when the service is stopped.
  ##   apiVersion: string (required)
  ##             : Version of the API
  ##   subscriptionId: string (required)
  ##                 : Identifier of the subscription
  ##   groupName: string (required)
  ##            : Name of the resource group
  ##   serviceName: string (required)
  ##              : Name of the service
  var path_594259 = newJObject()
  var query_594260 = newJObject()
  add(query_594260, "api-version", newJString(apiVersion))
  add(path_594259, "subscriptionId", newJString(subscriptionId))
  add(path_594259, "groupName", newJString(groupName))
  add(path_594259, "serviceName", newJString(serviceName))
  result = call_594258.call(path_594259, query_594260, nil, nil, nil)

var servicesStop* = Call_ServicesStop_594250(name: "servicesStop",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{groupName}/providers/Microsoft.DataMigration/services/{serviceName}/stop",
    validator: validate_ServicesStop_594251, base: "", url: url_ServicesStop_594252,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
