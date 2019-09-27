
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Update Management
## version: 2017-05-15-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## APIs for managing software update configurations.
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
  macServiceName = "automation-softwareUpdateConfiguration"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_SoftwareUpdateConfigurationsList_593647 = ref object of OpenApiRestCall_593425
proc url_SoftwareUpdateConfigurationsList_593649(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "automationAccountName" in path,
        "`automationAccountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Automation/automationAccounts/"),
               (kind: VariableSegment, value: "automationAccountName"),
               (kind: ConstantSegment, value: "/softwareUpdateConfigurations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SoftwareUpdateConfigurationsList_593648(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get all software update configurations for the account.
  ## 
  ## http://aka.ms/azureautomationsdk/softwareupdateconfigurationoperations
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   automationAccountName: JString (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `automationAccountName` field"
  var valid_593810 = path.getOrDefault("automationAccountName")
  valid_593810 = validateParameter(valid_593810, JString, required = true,
                                 default = nil)
  if valid_593810 != nil:
    section.add "automationAccountName", valid_593810
  var valid_593811 = path.getOrDefault("resourceGroupName")
  valid_593811 = validateParameter(valid_593811, JString, required = true,
                                 default = nil)
  if valid_593811 != nil:
    section.add "resourceGroupName", valid_593811
  var valid_593812 = path.getOrDefault("subscriptionId")
  valid_593812 = validateParameter(valid_593812, JString, required = true,
                                 default = nil)
  if valid_593812 != nil:
    section.add "subscriptionId", valid_593812
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593813 = query.getOrDefault("api-version")
  valid_593813 = validateParameter(valid_593813, JString, required = true,
                                 default = nil)
  if valid_593813 != nil:
    section.add "api-version", valid_593813
  var valid_593814 = query.getOrDefault("$filter")
  valid_593814 = validateParameter(valid_593814, JString, required = false,
                                 default = nil)
  if valid_593814 != nil:
    section.add "$filter", valid_593814
  result.add "query", section
  ## parameters in `header` object:
  ##   clientRequestId: JString
  ##                  : Identifies this specific client request.
  section = newJObject()
  var valid_593815 = header.getOrDefault("clientRequestId")
  valid_593815 = validateParameter(valid_593815, JString, required = false,
                                 default = nil)
  if valid_593815 != nil:
    section.add "clientRequestId", valid_593815
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593842: Call_SoftwareUpdateConfigurationsList_593647;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get all software update configurations for the account.
  ## 
  ## http://aka.ms/azureautomationsdk/softwareupdateconfigurationoperations
  let valid = call_593842.validator(path, query, header, formData, body)
  let scheme = call_593842.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593842.url(scheme.get, call_593842.host, call_593842.base,
                         call_593842.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593842, url, valid)

proc call*(call_593913: Call_SoftwareUpdateConfigurationsList_593647;
          automationAccountName: string; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; Filter: string = ""): Recallable =
  ## softwareUpdateConfigurationsList
  ## Get all software update configurations for the account.
  ## http://aka.ms/azureautomationsdk/softwareupdateconfigurationoperations
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  var path_593914 = newJObject()
  var query_593916 = newJObject()
  add(path_593914, "automationAccountName", newJString(automationAccountName))
  add(path_593914, "resourceGroupName", newJString(resourceGroupName))
  add(query_593916, "api-version", newJString(apiVersion))
  add(path_593914, "subscriptionId", newJString(subscriptionId))
  add(query_593916, "$filter", newJString(Filter))
  result = call_593913.call(path_593914, query_593916, nil, nil, nil)

var softwareUpdateConfigurationsList* = Call_SoftwareUpdateConfigurationsList_593647(
    name: "softwareUpdateConfigurationsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/softwareUpdateConfigurations",
    validator: validate_SoftwareUpdateConfigurationsList_593648, base: "/",
    url: url_SoftwareUpdateConfigurationsList_593649, schemes: {Scheme.Https})
type
  Call_SoftwareUpdateConfigurationsCreate_593968 = ref object of OpenApiRestCall_593425
proc url_SoftwareUpdateConfigurationsCreate_593970(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "automationAccountName" in path,
        "`automationAccountName` is a required path parameter"
  assert "softwareUpdateConfigurationName" in path,
        "`softwareUpdateConfigurationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Automation/automationAccounts/"),
               (kind: VariableSegment, value: "automationAccountName"), (
        kind: ConstantSegment, value: "/softwareUpdateConfigurations/"), (
        kind: VariableSegment, value: "softwareUpdateConfigurationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SoftwareUpdateConfigurationsCreate_593969(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a new software update configuration with the name given in the URI.
  ## 
  ## http://aka.ms/azureautomationsdk/softwareupdateconfigurationoperations
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   automationAccountName: JString (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   softwareUpdateConfigurationName: JString (required)
  ##                                  : The name of the software update configuration to be created.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `automationAccountName` field"
  var valid_593980 = path.getOrDefault("automationAccountName")
  valid_593980 = validateParameter(valid_593980, JString, required = true,
                                 default = nil)
  if valid_593980 != nil:
    section.add "automationAccountName", valid_593980
  var valid_593981 = path.getOrDefault("resourceGroupName")
  valid_593981 = validateParameter(valid_593981, JString, required = true,
                                 default = nil)
  if valid_593981 != nil:
    section.add "resourceGroupName", valid_593981
  var valid_593982 = path.getOrDefault("softwareUpdateConfigurationName")
  valid_593982 = validateParameter(valid_593982, JString, required = true,
                                 default = nil)
  if valid_593982 != nil:
    section.add "softwareUpdateConfigurationName", valid_593982
  var valid_593983 = path.getOrDefault("subscriptionId")
  valid_593983 = validateParameter(valid_593983, JString, required = true,
                                 default = nil)
  if valid_593983 != nil:
    section.add "subscriptionId", valid_593983
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593984 = query.getOrDefault("api-version")
  valid_593984 = validateParameter(valid_593984, JString, required = true,
                                 default = nil)
  if valid_593984 != nil:
    section.add "api-version", valid_593984
  result.add "query", section
  ## parameters in `header` object:
  ##   clientRequestId: JString
  ##                  : Identifies this specific client request.
  section = newJObject()
  var valid_593985 = header.getOrDefault("clientRequestId")
  valid_593985 = validateParameter(valid_593985, JString, required = false,
                                 default = nil)
  if valid_593985 != nil:
    section.add "clientRequestId", valid_593985
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Request body.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_593987: Call_SoftwareUpdateConfigurationsCreate_593968;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create a new software update configuration with the name given in the URI.
  ## 
  ## http://aka.ms/azureautomationsdk/softwareupdateconfigurationoperations
  let valid = call_593987.validator(path, query, header, formData, body)
  let scheme = call_593987.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593987.url(scheme.get, call_593987.host, call_593987.base,
                         call_593987.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593987, url, valid)

proc call*(call_593988: Call_SoftwareUpdateConfigurationsCreate_593968;
          automationAccountName: string; resourceGroupName: string;
          apiVersion: string; softwareUpdateConfigurationName: string;
          subscriptionId: string; parameters: JsonNode): Recallable =
  ## softwareUpdateConfigurationsCreate
  ## Create a new software update configuration with the name given in the URI.
  ## http://aka.ms/azureautomationsdk/softwareupdateconfigurationoperations
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   softwareUpdateConfigurationName: string (required)
  ##                                  : The name of the software update configuration to be created.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Request body.
  var path_593989 = newJObject()
  var query_593990 = newJObject()
  var body_593991 = newJObject()
  add(path_593989, "automationAccountName", newJString(automationAccountName))
  add(path_593989, "resourceGroupName", newJString(resourceGroupName))
  add(query_593990, "api-version", newJString(apiVersion))
  add(path_593989, "softwareUpdateConfigurationName",
      newJString(softwareUpdateConfigurationName))
  add(path_593989, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_593991 = parameters
  result = call_593988.call(path_593989, query_593990, nil, nil, body_593991)

var softwareUpdateConfigurationsCreate* = Call_SoftwareUpdateConfigurationsCreate_593968(
    name: "softwareUpdateConfigurationsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/softwareUpdateConfigurations/{softwareUpdateConfigurationName}",
    validator: validate_SoftwareUpdateConfigurationsCreate_593969, base: "/",
    url: url_SoftwareUpdateConfigurationsCreate_593970, schemes: {Scheme.Https})
type
  Call_SoftwareUpdateConfigurationsGetByName_593955 = ref object of OpenApiRestCall_593425
proc url_SoftwareUpdateConfigurationsGetByName_593957(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "automationAccountName" in path,
        "`automationAccountName` is a required path parameter"
  assert "softwareUpdateConfigurationName" in path,
        "`softwareUpdateConfigurationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Automation/automationAccounts/"),
               (kind: VariableSegment, value: "automationAccountName"), (
        kind: ConstantSegment, value: "/softwareUpdateConfigurations/"), (
        kind: VariableSegment, value: "softwareUpdateConfigurationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SoftwareUpdateConfigurationsGetByName_593956(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a single software update configuration by name.
  ## 
  ## http://aka.ms/azureautomationsdk/softwareupdateconfigurationoperations
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   automationAccountName: JString (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   softwareUpdateConfigurationName: JString (required)
  ##                                  : The name of the software update configuration to be created.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `automationAccountName` field"
  var valid_593958 = path.getOrDefault("automationAccountName")
  valid_593958 = validateParameter(valid_593958, JString, required = true,
                                 default = nil)
  if valid_593958 != nil:
    section.add "automationAccountName", valid_593958
  var valid_593959 = path.getOrDefault("resourceGroupName")
  valid_593959 = validateParameter(valid_593959, JString, required = true,
                                 default = nil)
  if valid_593959 != nil:
    section.add "resourceGroupName", valid_593959
  var valid_593960 = path.getOrDefault("softwareUpdateConfigurationName")
  valid_593960 = validateParameter(valid_593960, JString, required = true,
                                 default = nil)
  if valid_593960 != nil:
    section.add "softwareUpdateConfigurationName", valid_593960
  var valid_593961 = path.getOrDefault("subscriptionId")
  valid_593961 = validateParameter(valid_593961, JString, required = true,
                                 default = nil)
  if valid_593961 != nil:
    section.add "subscriptionId", valid_593961
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593962 = query.getOrDefault("api-version")
  valid_593962 = validateParameter(valid_593962, JString, required = true,
                                 default = nil)
  if valid_593962 != nil:
    section.add "api-version", valid_593962
  result.add "query", section
  ## parameters in `header` object:
  ##   clientRequestId: JString
  ##                  : Identifies this specific client request.
  section = newJObject()
  var valid_593963 = header.getOrDefault("clientRequestId")
  valid_593963 = validateParameter(valid_593963, JString, required = false,
                                 default = nil)
  if valid_593963 != nil:
    section.add "clientRequestId", valid_593963
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593964: Call_SoftwareUpdateConfigurationsGetByName_593955;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get a single software update configuration by name.
  ## 
  ## http://aka.ms/azureautomationsdk/softwareupdateconfigurationoperations
  let valid = call_593964.validator(path, query, header, formData, body)
  let scheme = call_593964.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593964.url(scheme.get, call_593964.host, call_593964.base,
                         call_593964.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593964, url, valid)

proc call*(call_593965: Call_SoftwareUpdateConfigurationsGetByName_593955;
          automationAccountName: string; resourceGroupName: string;
          apiVersion: string; softwareUpdateConfigurationName: string;
          subscriptionId: string): Recallable =
  ## softwareUpdateConfigurationsGetByName
  ## Get a single software update configuration by name.
  ## http://aka.ms/azureautomationsdk/softwareupdateconfigurationoperations
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   softwareUpdateConfigurationName: string (required)
  ##                                  : The name of the software update configuration to be created.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_593966 = newJObject()
  var query_593967 = newJObject()
  add(path_593966, "automationAccountName", newJString(automationAccountName))
  add(path_593966, "resourceGroupName", newJString(resourceGroupName))
  add(query_593967, "api-version", newJString(apiVersion))
  add(path_593966, "softwareUpdateConfigurationName",
      newJString(softwareUpdateConfigurationName))
  add(path_593966, "subscriptionId", newJString(subscriptionId))
  result = call_593965.call(path_593966, query_593967, nil, nil, nil)

var softwareUpdateConfigurationsGetByName* = Call_SoftwareUpdateConfigurationsGetByName_593955(
    name: "softwareUpdateConfigurationsGetByName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/softwareUpdateConfigurations/{softwareUpdateConfigurationName}",
    validator: validate_SoftwareUpdateConfigurationsGetByName_593956, base: "/",
    url: url_SoftwareUpdateConfigurationsGetByName_593957, schemes: {Scheme.Https})
type
  Call_SoftwareUpdateConfigurationsDelete_593992 = ref object of OpenApiRestCall_593425
proc url_SoftwareUpdateConfigurationsDelete_593994(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "automationAccountName" in path,
        "`automationAccountName` is a required path parameter"
  assert "softwareUpdateConfigurationName" in path,
        "`softwareUpdateConfigurationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Automation/automationAccounts/"),
               (kind: VariableSegment, value: "automationAccountName"), (
        kind: ConstantSegment, value: "/softwareUpdateConfigurations/"), (
        kind: VariableSegment, value: "softwareUpdateConfigurationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SoftwareUpdateConfigurationsDelete_593993(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## delete a specific software update configuration.
  ## 
  ## http://aka.ms/azureautomationsdk/softwareupdateconfigurationoperations
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   automationAccountName: JString (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: JString (required)
  ##                    : Name of an Azure Resource group.
  ##   softwareUpdateConfigurationName: JString (required)
  ##                                  : The name of the software update configuration to be created.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `automationAccountName` field"
  var valid_593995 = path.getOrDefault("automationAccountName")
  valid_593995 = validateParameter(valid_593995, JString, required = true,
                                 default = nil)
  if valid_593995 != nil:
    section.add "automationAccountName", valid_593995
  var valid_593996 = path.getOrDefault("resourceGroupName")
  valid_593996 = validateParameter(valid_593996, JString, required = true,
                                 default = nil)
  if valid_593996 != nil:
    section.add "resourceGroupName", valid_593996
  var valid_593997 = path.getOrDefault("softwareUpdateConfigurationName")
  valid_593997 = validateParameter(valid_593997, JString, required = true,
                                 default = nil)
  if valid_593997 != nil:
    section.add "softwareUpdateConfigurationName", valid_593997
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
  ## parameters in `header` object:
  ##   clientRequestId: JString
  ##                  : Identifies this specific client request.
  section = newJObject()
  var valid_594000 = header.getOrDefault("clientRequestId")
  valid_594000 = validateParameter(valid_594000, JString, required = false,
                                 default = nil)
  if valid_594000 != nil:
    section.add "clientRequestId", valid_594000
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594001: Call_SoftwareUpdateConfigurationsDelete_593992;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## delete a specific software update configuration.
  ## 
  ## http://aka.ms/azureautomationsdk/softwareupdateconfigurationoperations
  let valid = call_594001.validator(path, query, header, formData, body)
  let scheme = call_594001.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594001.url(scheme.get, call_594001.host, call_594001.base,
                         call_594001.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594001, url, valid)

proc call*(call_594002: Call_SoftwareUpdateConfigurationsDelete_593992;
          automationAccountName: string; resourceGroupName: string;
          apiVersion: string; softwareUpdateConfigurationName: string;
          subscriptionId: string): Recallable =
  ## softwareUpdateConfigurationsDelete
  ## delete a specific software update configuration.
  ## http://aka.ms/azureautomationsdk/softwareupdateconfigurationoperations
  ##   automationAccountName: string (required)
  ##                        : The name of the automation account.
  ##   resourceGroupName: string (required)
  ##                    : Name of an Azure Resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   softwareUpdateConfigurationName: string (required)
  ##                                  : The name of the software update configuration to be created.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594003 = newJObject()
  var query_594004 = newJObject()
  add(path_594003, "automationAccountName", newJString(automationAccountName))
  add(path_594003, "resourceGroupName", newJString(resourceGroupName))
  add(query_594004, "api-version", newJString(apiVersion))
  add(path_594003, "softwareUpdateConfigurationName",
      newJString(softwareUpdateConfigurationName))
  add(path_594003, "subscriptionId", newJString(subscriptionId))
  result = call_594002.call(path_594003, query_594004, nil, nil, nil)

var softwareUpdateConfigurationsDelete* = Call_SoftwareUpdateConfigurationsDelete_593992(
    name: "softwareUpdateConfigurationsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Automation/automationAccounts/{automationAccountName}/softwareUpdateConfigurations/{softwareUpdateConfigurationName}",
    validator: validate_SoftwareUpdateConfigurationsDelete_593993, base: "/",
    url: url_SoftwareUpdateConfigurationsDelete_593994, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
